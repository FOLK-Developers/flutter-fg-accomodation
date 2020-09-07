import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:folkguideapp/allocation.dart';
import 'package:folkguideapp/main.dart';
import 'data.dart';

// ignore: camel_case_types
class mainpage extends StatefulWidget{
  mainpage({this.center,this.no});
  final center,no;
  @override
  actionpage createState()=>actionpage(center:center,no: no);
}


// ignore: camel_case_types
class actionpage extends State<mainpage> {
  actionpage({this.center,this.no});
  String center,no;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.green[900],
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>myapp()));
              },
            );
          },
        ),
        backgroundColor: Colors.white,
        title: Text('Folk guide',
          style: TextStyle(
              color: Colors.green[900],
              fontWeight: FontWeight.bold,
              fontSize: 17,
              fontStyle: FontStyle.italic
          ),),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(
                padding: EdgeInsets.fromLTRB(1, 14, 1, 0),
                child: Column(
                  children: [
                    Icon(Icons.assignment, color: Colors.black, size: 18,),
                    Text('Bed availability',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
//                       fontWeight: FontWeight.bold
                      ),)
                  ],
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>data(center: center,no:no)));
                },
              ),
              SizedBox(width: 17,)
            ],
          )
        ],
      ),
      body: Center(
        child: allocation(center: center,no: no),
      ),
    ),
    );
  }
}
