import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folkguideapp/mainpage.dart';

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

class myapp extends StatefulWidget {
  @override
  authentication createState() => authentication();
}


class authentication extends State<myapp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: 25,),
              Text('Folk guide app',
              style: TextStyle(
                color: Colors.green[900],
                fontSize: 50
              ),),
              SizedBox(height: 30,),
              MaterialButton(
                padding: EdgeInsets.all(25),
                child: Text('Log in',
                  style: TextStyle(
                    color: Colors.white,
                  ),),
                color: Colors.green[900],
                shape: new RoundedRectangleBorder(side:BorderSide( width: 3,
                    style: BorderStyle.solid),borderRadius:BorderRadius.circular(20)),
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>mainpage()));
                },
              )
            ],
          ), 
        ),
      );
  }
}


