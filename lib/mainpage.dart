import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folkguideapp/allocation.dart';

import 'data.dart';

class mainpage extends StatefulWidget{
  @override
  actionpage createState()=>actionpage();
}


class actionpage extends State<mainpage>{
    int selectedIndex = 0;
    final widgetOptions = [
      allocation(),
      data(),
    ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text('Folk Guide app'),
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
          BottomNavigationBarItem(icon: Icon(Icons.assignment,color: Colors.black,), title: Text('bed Availability',style: TextStyle(color: Colors.black),)),
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
