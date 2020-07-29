import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class data extends StatefulWidget{
  @override
  bedavailable createState()=>bedavailable();
}




class bedavailable extends State<data>{
  num lb=0,mb=0,ub=0,requests=0,rlb=0,rmb=0,rub=0;

  Column details(String field,num n){
    return Column(
      children: <Widget>[
        Text(field+":",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16
        ),),
        SizedBox(height: 6,),
        Text(n.toString(),
          style: TextStyle(
              color: Colors.white,
              fontSize: 17
          ),)
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Material(
          color:  Colors.green[900],
          child: Column(
            children: <Widget>[
              Text('Available Beds',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19
                ),),
              SizedBox(height: 5,),
              Row(
                children: <Widget>[
                  details("Lower berth", lb),
                  details("Middle berth", mb),
                  details("Upper berth", ub),
                ],
              ),
              SizedBox(height: 9,),
              SizedBox(width: double.infinity,height: 2,
                child: Container(
                  color: Colors.white,
                ),),
              SizedBox(height: 9,),
              Text('Bed requests data',
              style:TextStyle(
                color:Colors.white,
                  fontSize: 19
              )),
              SizedBox(height: 5,),
              Text('total Bed requests :$requests',
                  style:TextStyle(
                      color:Colors.white,
                      fontSize: 17
                  )),
              SizedBox(height: 5,),
              Row(
                children: <Widget>[
                  details("Lower berth", rlb),
                  details("Middle berth", rmb),
                  details("Upper berth", rub),
                ],
              ),
                    ],
          ),
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15)),
        ),
      )
    );
  }
}



