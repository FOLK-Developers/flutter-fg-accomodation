import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:folkguideapp/mainpage.dart';
// import 'package:folkguideapp/room.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: myapp(),
    );
  }
}

// ignore: camel_case_types
class myapp extends StatefulWidget {
  @override
  authentication createState() => authentication();
}


// ignore: camel_case_types
class authentication extends State<myapp> {
  List<String> centers = [];
  String selectedcenter='Center1';

  Future<void> getcenters() async{
    var db = await Firestore.instance.collection('centers').getDocuments();
    db.documents.forEach((element){
      setState(() {
        centers.add(element.documentID.toString());
      });
    });
  }


  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String center in centers) {
      var newItem = DropdownMenuItem(
        child: Text(center),
        value: center,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedcenter,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedcenter = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> centerlist = [];
    for (String centers in centers) {
      centerlist.add(Text(centers));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedcenter = centers[selectedIndex];
        });
      },
      children: centerlist,
    );
  }
  
  @override
  void initState() {
  
    super.initState();
    getcenters();

  }
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child:Padding(
                padding: EdgeInsets.all(60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30,),
                    Text('folk guide',
                      style: TextStyle(
                        color: Colors.green[900],
                        fontSize: 30,
                      ),),
                    SizedBox(height:80,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child:SizedBox(width: 3,) ,),
                              Text('Select your center  ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16
                                  ),),
                              Container(
                                width:80,
                                height:30,
                                color: Colors.white,
                                child: Platform.isIOS ? iOSPicker() : androidDropdown(),
                              ),
                              Expanded(
                                child:SizedBox(width: 3,)
                                ,),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height:35,),
                    MaterialButton(
                      padding: EdgeInsets.all(17),
                      child: Text('log in',
                        style: TextStyle(
                          color: Colors.white,
                        ),),
                      color: Colors.green[900],
                      shape: new RoundedRectangleBorder(borderRadius:BorderRadius.circular(15)),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>mainpage(center: selectedcenter,)));
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      );
  }
}


