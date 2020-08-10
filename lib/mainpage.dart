import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folkguideapp/allocation.dart';
import 'data.dart';

// ignore: camel_case_types
class mainpage extends StatefulWidget{
  mainpage({this.center});
  final center;
  @override
  actionpage createState()=>actionpage(center:center);
}


// ignore: camel_case_types
class actionpage extends State<mainpage>{
  actionpage({this.center});
  String center;
    int selectedIndex = 0;
    final widgetOptions = [
      allocation(),
      data(),
    ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('folk guide',
        style: TextStyle(
          color: Colors.green[900],
          fontStyle: FontStyle.italic
        ),),
      ),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        iconSize: 20.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.airline_seat_individual_suite,color: Colors.black,), title: Text('Bed requests',style: TextStyle(color: Colors.black),)),
          BottomNavigationBarItem(icon: Icon(Icons.assignment,color: Colors.black,), title: Text('Bed Availability',style: TextStyle(color: Colors.black),)),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.white,
        onTap: onItemTapped,
      ),
    ),
    );
  }

        void onItemTapped(int index) {
          setState(() {
            selectedIndex = index;
          });
        }
}
