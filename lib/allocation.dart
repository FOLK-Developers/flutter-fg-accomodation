import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
class allocation extends StatefulWidget{
  @override
  allocationpage createState()=>allocationpage();
}

class allocationpage extends State<allocation>{
  num lb=0,mb=0,ub=0,rlb=0,rmb=0,rub=0,count=0,totalr=0,prob=0;
  bool flag=false;
  String note="",note1="";
  static DateTime now = DateTime.now();
  static var  formatter = DateFormat('yyyy-MM-dd');
  static var today = formatter.format(now);

  Future<void> requests() async {
    var col = await Firestore.instance.collection('request').document(today).collection("allrequests");
    col.getDocuments().then((value) async {
      if(value.documents.isNotEmpty){
        setState((){
          flag=true;
        });
      }
      else{
        setState(() {
          flag=false;
        });
      }
    });
  }

  Future<num> allocaterequests() async {
    Navigator.of(context).pop();
  }

  Future<num> deletedrequests() async {
    var db = Firestore.instance.collection('requests').document(today).collection('allrequests');
    var docu= await db.where('status',isEqualTo: "Waiting for approval").getDocuments();
    if(docu!=null) {
      docu.documents.forEach((element) async {
        await Firestore.instance.collection('users').document(
            element.data['Mobile_Number']).
        collection('history').document(element.data['reqid']).updateData({
          "status": "Request was declined",
          "allocated": "No bed was allocated"
        }).then((value) async {
          await Firestore.instance.collection('requests').document(today).
          collection('allrequests').document(element.documentID).delete();
        });
      });
    }
    else{
      Navigator.of(context).pop();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Attendance Service isn't merged"),
      ));
    }
}
  Future<num> reqcount(String s) async {
    var db = Firestore.instance.collection('requests').document(today).collection('allrequests');
    var docu= await db.where("preferred_berth",isEqualTo:s).where('status',isEqualTo: "Waiting for approval").getDocuments();
    docu.documents.forEach((element) {
        setState(() {
          if (s == "LOWER_BERTH") {
            rlb++;
            totalr++;
          }
          else if (s == "MIDDLE_BERTH") {
            rmb++;
            totalr++;
          }
          else {
            rub++;
            totalr++;
          }
        });
    });
  }

  Future<void> bedData() async {
    var collectonRef = Firestore.instance.collection('beds');
    var doc =await collectonRef.document('details').get();
    if(flag) {
      setState(() async {
        lb=doc.data['lower_berth'];
        mb=doc.data['middle_berth'];
        ub=doc.data['upper_berth'];
        count=lb+mb+ub;
        await reqcount("LOWER_BERTH");
        await reqcount("MIDDLE_BERTH");
        await reqcount("UPPER_BERTH");
        if(totalr==0){
          note="There is no requests to allocate beds.";
          note1="There is no requests to decline requests.";
        }

        else if(totalr<=count){
          note="Do you want allocated beds to all $totalr requests.";
          note1="Do you want to decline all $totalr requests.";

        }
        else if(count==0){
          note="There is no beds to allocated.";
          note1="There is no beds to allocated.";

        }
        else{
          prob=((count/totalr)*100).round();
          note="Do you want allocated beds to all $totalr requests. Only $prob % ($count requests) of requests will get beds allocated.This For the given"
              " bed counts"
              " Rest of the request will be cancelled out";
          note1="Do you want to decline to all $totalr requests. $prob % ($count requests) of requests will get beds allocated. If the request is accepted";
        }
      });
    }
    else{
      setState(() async {
        lb = doc.data['lower_berth'];
        mb = doc.data['middle_berth'];
        ub = doc.data['upper_berth'];
        count = lb + mb + ub;
        note="There is no requests to allocate beds.";
        note1="There is no requests to decline requests.";
      });

    }
  }
  Future<bool> allocate(BuildContext context,String field,String text,bool val) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(field),
            content: Text(text),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.all(9),
                    color: Colors.green[900],
                    shape: new RoundedRectangleBorder(side:BorderSide( width: 3,
                        style: BorderStyle.solid),borderRadius:BorderRadius.circular(20)),
                  ),
                  SizedBox(width: 4,),
                  MaterialButton(
                    child: Text("Yes"),
                    onPressed: () {
                      if(val){

                      }
                      else{
                        deletedrequests();
                        Navigator.of(context).pop();
                      }
                    },
                    padding: EdgeInsets.all(9),
                    color: Colors.green[900],
                    shape: new RoundedRectangleBorder(side:BorderSide( width: 3,
                        style: BorderStyle.solid),borderRadius:BorderRadius.circular(20)),
                  )
                ],
              )
            ],
          );
        });
  }

  Widget data(){
    if (flag==true) {
      return Container(
          child:Center(
            child:Text("No folk have requested for bed,Today.",
              style: TextStyle(
                  color: Colors.green[900],
                  fontSize: 15
              ),) ,
          )
      );
    }
    else {
      return requestlist();
    }
  }


  @override
  void initState(){
    super.initState();
    requests();
    bedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child:data()),
          Container(
            height: 60,
            color: Colors.white,
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
                      allocate(context,"Declining requests.",note1,false);
                    },
                  ) ,
                ),
                SizedBox(width: 5,),
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
                      allocate(context,"Confirmation for allocation.",note,true);
                    },
                  ) ,
                )
              ],
            ),
          ),
          SizedBox(
            height: 1,
            child: Container(
              color: Colors.green[900],
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
            default: return  ListView(
                children: snapshot.data.documents.map((document) {
                  return new  Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: ListTile(
                      title: Material(
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
                         ),
                       ),
                      ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Decline',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async{
                        await Firestore.instance.collection('users').document(document['Mobile_Number']).
                        collection('history').document(document['reqid']).updateData({
                          "status":"Request was declined",
                          "allocated":"No bed was allocated"
                        }).then((value) async{
                          await Firestore.instance.collection('requests').document(today).
                          collection('allrequests').document(document.documentID).delete();
                        });
                        },
                    ),
                  ],);
            }).toList()
            );
          }
        });
  }
}



//children: snapshot.data.documents.map((
//DocumentSnapshot document) {

//)
//);
//}).toList(),