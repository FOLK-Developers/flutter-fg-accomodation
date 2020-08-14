import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folkguideapp/data.dart';

// ignore: camel_case_types
class room extends StatefulWidget{
  room({this.beds,this.centers});
  final String beds;
  final String centers;
  roomdata createState()=>roomdata(beds: beds,centers: centers);
}

// ignore: camel_case_types
class roomdata extends State<room>{
  roomdata({this.beds,this.centers});
  final String beds;
  final String centers;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:AppBar(
          leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.green[900],
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>data(center:centers)));
                },
              );
            },
          ),
          backgroundColor: Colors.white,
          title: Text(beds,
            style: TextStyle(
                color: Colors.green[900],
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontStyle: FontStyle.italic
            ),),
          centerTitle: true,
        ),
      ),
    );
  }

}