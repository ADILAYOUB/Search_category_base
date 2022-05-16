import 'package:flutter/material.dart';


//Type of object
enum typeEnum {
  legal,
  insurance,
  personal,
}
//
// Object reference
class ObjectData {
  String? _name;
  String? get name => _name;
  typeEnum? _type;
  typeEnum? get type => _type;

  ObjectData(this._name, this._type);
}
//

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Objects List reference
  //I think this list comes in a API
  List<ObjectData> list = [
    ObjectData("ABCDE1", typeEnum.insurance),
    ObjectData("ABCDE2", typeEnum.legal),
    ObjectData("ABCDE3", typeEnum.personal),
    ObjectData("ABCDE4", typeEnum.personal),
    ObjectData("ABCDE5", typeEnum.legal),
    ObjectData("ABCDE6", typeEnum.legal),
    ObjectData("ABCDE7", typeEnum.insurance),
    ObjectData("ABCDE8", typeEnum.insurance),
    ObjectData("ZZZZ", typeEnum.insurance),
  ];

  typeEnum? typeSelected;
  List<ObjectData> renderingList = []; ///Objects List to render

  String text = ""; ///Text that the user is going to write
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
                padding: const EdgeInsets.only(
                    left: 18.0, top: 6.0, right: 18.0, bottom: 6.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (String value) {
                    text = value;
                    filterText(text); ///Method to filter the object list
                  },
                  onTap: () {
                    index = renderingList.length;
                  },
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                    icon: Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                    //contentPadding: EdgeInsets.all(12.0)
                  ),
                ),
              ),
              Row(
                children: [
                  button("all", 0),
                  button(typeEnum.insurance.name, 1),
                  button(typeEnum.personal.name, 2),
                  button(typeEnum.legal.name, 3)
                ],
              )
            ],
          ),
          index == 0
              ? const SizedBox()
              : Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: index,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.transparent,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    renderingList[index].name!,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 22.0,
                                      //fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    renderingList[index].type!.name,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 22.0,
                                      //fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: Card(
                                  elevation: 4.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(renderingList[index].name!,
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget button(String name, int id) {
    return GestureDetector(
      onTap: () {
        setState(() {
          try {
            typeSelected =
                typeEnum.values.where((element) => element.name == name).first;
          } catch (e) {
            typeSelected = null;
          }
        });
        filterText(text); ///When the user tap one of the buttons they call the Method filterText to change the object List rendering
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 30,
          width: 70,
          decoration: BoxDecoration(
              color: name == "all" && typeSelected == null
                  ? Colors.blueGrey
                  : typeSelected != null && typeSelected!.name == name
                      ? Colors.blueGrey
                      : Colors.blue,
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          child: Center(child: Text(name)),
        ),
      ),
    );
  }


  ///All the magic
  void filterText(String text) {
    if (text == '') {
      setState(() {
        renderingList = [];
        index = renderingList.length;
      });
    } else {
      List<ObjectData> intermediaData = [];
      list.forEach((txt) {
        if ((txt.name!.toLowerCase()).contains(text.toLowerCase())) {
          if (typeSelected == null) {
            intermediaData.add(txt);
          } else {
            if (typeSelected == txt.type) {
              intermediaData.add(txt);
            }
          }
        }
      });
      setState(() {
        index = intermediaData.length;
        renderingList = intermediaData;
      });
    }
  }
}
