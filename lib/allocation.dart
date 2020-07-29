import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class allocation extends StatefulWidget{
  @override
  allocationpage createState()=>allocationpage();
}

class allocationpage extends State<allocation>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child:requestlist()),
          Container(
            height: 50,
            color: Colors.green[900],
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    child: Text('Decline all',
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                    color: Colors.white,
                    shape: new RoundedRectangleBorder(side:BorderSide( width: 3,color: Colors.black,
                        style: BorderStyle.solid),borderRadius:BorderRadius.circular(20)),
                    onPressed: (){
                    },
                  ) ,
                ),
                Expanded(
                  child: MaterialButton(
                    child: Text('Accept all',
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                    color: Colors.white,
                    shape: new RoundedRectangleBorder(side:BorderSide( width: 3,color: Colors.black,
                        style: BorderStyle.solid),borderRadius:BorderRadius.circular(20)),
                    onPressed: (){
                    },
                  ) ,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class requestlist extends StatelessWidget{
  static DateTime now = DateTime.now();
  static var  formatter = DateFormat('yyyy-MM-dd');
  static var today = formatter.format(now);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('requests').document(today).
        collection('allrequests').where('status',isEqualTo: "Waiting for approval").snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default: return new ListView(
              children: snapshot.data.documents.map((
                  DocumentSnapshot document) {
                return  Material(
                    elevation: 15.0,
                    color: Colors.white70,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 7.0,),
                          Text("Folk Name :" + document['Folkname'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                            ),),
                          SizedBox(height: 7.0,),
                          Text("Mobile Number:" + document['Mobile_Number'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                            ),),
                          SizedBox(height: 7.0,),
                          Text("Preferred Berth:" +
                              document['preferred_berth'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                            ),),
                          SizedBox(height: 7.0,),
                          Text("Message to guide:" + document['Message'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                            ),),
                          SizedBox(height: 7.0,),
                          Text("Request status:" + document['status'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                            ),),
                          SizedBox(height: 10.0,),
                          SizedBox(width: double.infinity,
                            height: 3,
                            child: Container(
                              color: Colors.black,
                            ),)
                        ],
                      ),
                    )
                );
              }).toList(),
            );
          }
        });
  }
}