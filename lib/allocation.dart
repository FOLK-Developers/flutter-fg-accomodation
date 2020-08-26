import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:folkguideapp/forwardreq.dart';
import 'package:intl/intl.dart';

import 'callocation.dart';
import 'forwardreq.dart';
// ignore: camel_case_types
class allocation extends StatefulWidget{
  allocation({this.center});
  final String center;
  @override
  allocationpage createState()=>allocationpage(center: center);
}

// ignore: camel_case_types
class allocationpage extends State<allocation>{
  allocationpage({this.center});
  final String center;
  String zone;
  num lb=0,mb=0,ub=0,rlb=0,rmb=0,rub=0,count=0,totalr=0,prob=0,allocs=0,alb=0,amb=0,aub=0;
  bool flag=false;
  String note="Loading..",note1="Loading..",req="Loading..";
  static DateTime now = DateTime.now();
  static var  formatter = DateFormat('yyyy-MM-dd');
  static var today = formatter.format(now);


  Future allocater(String berth,String no,String reqid,String docid) async {
    num temp;
    num type;
    if(berth=="LOWER_BERTH"){
//      setState(() {
        alb++;
        temp=alb;
        type=1;
          rlb--;
          lb--;
//      });
    }
    else if(berth=="MIDDLE_BERTH"){
//      setState(() {
        amb++;
        temp=amb;
        type=2;
          rmb--;
          mb--;
//      });
    }
    else if(berth=="UPPER_BERTH"){
//      setState(() {
        aub++;
        temp=aub;
        type=3;
          rub--;
          ub--;
//      });
    }
          await Firestore.instance.collection('users').document(no).
          collection('history').document(reqid).updateData({
            "status": "Bed allocated",
            "allocated": "$berth-$temp"
          }).then((value) async {
            await Firestore.instance.collection('requests').document(today).
            collection('allrequests').document(docid).updateData({
              "status": "Bed allocated",
              "allocated": "$berth-$temp",
              "type":type
            });
          });
  }



//
//  Future<void> bedupdater(String reqid,String berth,String docid,String no,String tbc,num count,num type) async {
//            await Firestore.instance.collection('users').document(no).
//            collection('history').document(reqid).updateData({
//              "status": "Bed allocated",
//              "allocated": "$berth",
//              "type": "$type"
//            }).then((value) async {
//              await Firestore.instance.collection('requests').document(today).
//              collection('allrequests').document(docid).updateData({
//                "status": "Bed allocated",
//                "allocated": "$berth"
//              });
//            }).then((value)  async{
//              var collectonRef = Firestore.instance.collection('beds');
//              var doc = await collectonRef.document('details');
//              doc.updateData({
//                "$tbc": count,
//              });
//            });
//  }



//  Future<void> allocater2() async{
//
//    var collectionRef = Firestore.instance.collection('beds');
//    var Beddoc = await collectionRef.document('details').get();
//    num tempbc = await Beddoc.data['lower_berth']+Beddoc.data['lower_berth']+Beddoc.data['lower_berth'];
//    var db = Firestore.instance.collection('requests').document(today).collection('allrequests');
//    var reqdocs= await db.where('status',isEqualTo: "Waiting for approval").getDocuments();
//
//    if(tempbc!=0) {
//      //check for request, If request exists allocated bed to them.
//
//             var allocatelb= await db.where('status',isEqualTo: "Bed allocated").where("type",isEqualTo: 1).getDocuments();
//             var allocatemb= await db.where('status',isEqualTo: "Bed allocated").where("type",isEqualTo: 2).getDocuments();
//             var allocateub= await db.where('status',isEqualTo: "Bed allocated").where("type",isEqualTo: 3).getDocuments();
//
//             if(reqdocs.documents.isNotEmpty) {
//               reqdocs.documents.forEach((requests) async{
//
//                 if(requests.data['preferred_berth']=='LOWER_BERTH' && Beddoc.data['lower_berth']>0){
//                   num alloclb;
//                   allocatelb.documents.forEach((lowerberth) async {
//                     alloclb++;
//                   });
//                   alloclb++;
//                   await bedupdater(requests.data['reqid'],"LOWERBERTH-$alloclb",requests.documentID,requests.data['Mobile_Number'],
//                   "lower_berth",Beddoc.data['lower_berth']-1,1);
//                 }
//
//                 else if(requests.data['preferred_berth']=='MIDDLE_BERTH' && Beddoc.data['middle_berth']>0) {
//                   num allocmb;
//                   allocatemb.documents.forEach((middleberth) async {
//                     allocmb++;
//                   });
//                   allocmb++;
//                   await bedupdater(requests.data['reqid'],"MIDDLEBERTH-$allocmb",requests.documentID,requests.data['Mobile_Number']
//                       ,'middle_berth',Beddoc.data['middle_berth']-1,2);
//                 }
//
//                 else if(requests.data['preferred_berth']=='UPPER_BERTH' && Beddoc.data['upper_berth']>0) {
//                   num allocub;
//                   allocateub.documents.forEach((upperberth) async {
//                     allocub++;
//                   });
//                   allocub++;
//                   await bedupdater(requests.data['reqid'],"UPPERBERTH-$allocub",requests.documentID,requests.data['Mobile_Number']
//                   ,'upper_berth', Beddoc.data['upper_berth']-1,3);
//                 }
//
//                 else {
//                         if(Beddoc.data['upper_berth']>0) {
//                           num allocllb;
//                           allocatelb.documents.forEach((lowerberth) async {
//                             allocllb++;
//                           });
//                           allocllb++;
//                           await bedupdater(requests.data['reqid'],"LOWERBERTH-$allocllb",requests.documentID,requests.data['Mobile_Number'],
//                               "lower_berth",Beddoc.data['lower_berth']-1,1);
//                         }
//
//                         else if(Beddoc.data['middle_berth']>0) {
//                           num alloclmb;
//                           allocatemb.documents.forEach((middleberth) async {
//                             alloclmb++;
//                           });
//                           alloclmb++;
//                           await bedupdater(requests.data['reqid'],"MIDDLEBERTH-$alloclmb",requests.documentID,requests.data['Mobile_Number']
//                               ,'middle_berth',Beddoc.data['middle_berth']-1,2);
//                         }
//
//                         else if(Beddoc.data['upper_berth']!=0) {
//                           num alloclub;
//                           allocateub.documents.forEach((upperberth) async {
//                             alloclub++;
//                           });
//                           alloclub++;
//                           await bedupdater(requests.data['reqid'],"UPPERBERTH-$alloclub",requests.documentID,requests.data['Mobile_Number']
//                               ,'upper_berth', Beddoc.data['upper_berth']-1,3);
//                         }
//                         else {
//                           //decline requests, Status No beds vacant, Currently
//                           deleterequests("No beds available, Currently");
//                         }
//                 }
//                 noreqs("Beds, Allocated Successfully.");
//               });
//             }
//            else {
//                 //No requests to allocate beds.
//               noreqs("No requests, To allocate bed.");
//            }
//    }
//    else if(reqdocs.documents.isEmpty){
//      //There is no requests
//      noreqs("No requests,To allocate beds.");
//    }
//    else {
//      //decline requests, Status No beds vacant, Currently
//      noreqs("No beds,To allocated beds.");
//    }
//  }






  Future allocaterequests() async {
        var db = Firestore.instance.collection('requests').document(today).collection('allrequests');
        var docu= await db.where('status',isEqualTo: "Waiting for approval").getDocuments();
        if(docu!=null && totalr!=0 && count!=0 ) {
//    && totalr<=count
          docu.documents.forEach((element) async {
            if (element.data['preferred_berth'] == "LOWER_BERTH"  && lb!=0) {
//            && rlb <= lb
              await allocater("LOWER_BERTH", element.data['Mobile_Number'],
                  element.data['reqid'], element.documentID);
            }
            else if (element.data['preferred_berth'] == "MIDDLE_BERTH"  && mb!=0) {
//            && rmb <= mb
              await allocater("MIDDLE_BERTH", element.data['Mobile_Number'],
                  element.data['reqid'], element.documentID);
            }
            else if (element.data['preferred_berth'] == "UPPER_BERTH"&& ub!=0) {
//            && rub <= ub
            await allocater("UPPER_BERTH", element.data['Mobile_Number'],
                  element.data['reqid'], element.documentID);
            }
            else {
              if (lb> 0) {
                await allocater("LOWER_BERTH" , element.data['Mobile_Number'],
                    element.data['reqid'], element.documentID);
              }
              else if (mb> 0) {
                await allocater("MIDDLE_BERTH" , element.data['Mobile_Number'],
                    element.data['reqid'], element.documentID);
              }
              else if (ub>0)
              {
                await allocater("UPPER_BERTH" , element.data['Mobile_Number'],
                    element.data['reqid'], element.documentID);
              }
              else {
//                deleterequests("No beds available, Currently.");
                await Firestore.instance.collection('users').document(element.data['Mobile_Number']).
                 collection('history').document(element.data['reqid']).updateData({
                  "status":"No beds available, Currently",
                  "allocated":"No bed was allocated"
                }).then((value){
                  db.document(element.documentID).delete();
                });
              }
            }
          });
          var collectonRef = Firestore.instance.collection('beds');
          var doc = collectonRef.document('details');
          doc.updateData({
            "lower_berth": lb,
            "middle_berth": mb,
            "upper_berth": ub
          });
          noreqs("Beds allocated successfully.");
        }
//        else if(totalr>count && count!=0){
//          num decline=totalr-count;
//          num i=0;
//          var docutodecline= await db.where('status',isEqualTo: "Waiting for approval").orderBy("rtime",descending: true)
//          .getDocuments();
//          docutodecline.documents.forEach((element) async {
//            if(i<=decline){
//              await Firestore.instance.collection('users').document(element.data['Mobile_Number']).
//               collection('history').document(element.data['reqid']).updateData({
//                "status":"No beds available, Currently",
//                "allocated":"No bed was allocated"
//              }).then((value){
//                db.document(element.documentID).delete();
//              });
//              i++;
//            }
//            else{
//              allocaterequests();
//            }
//          });
//        }
        else if(count==0){
          noreqs("No beds nor Requests , To allocate bed.");
        }
        else{
          noreqs("No requests, To allocate bed.");
        }
      }



      Future deleterequests(String status) async {
        var db = Firestore.instance.collection('requests').document(today).collection('allrequests');
        var docu= await db.where('status',isEqualTo: "Waiting for approval").getDocuments();
        if(totalr!=0) {
          docu.documents.forEach((element) async {
            await Firestore.instance.collection('users').document(
                element.data['Mobile_Number']).
            collection('history').document(element.data['reqid']).updateData({
              "status":status,
              "allocated":"No bed was allocated"
            }).then((value) async {
              await Firestore.instance.collection('requests').document(today).
              collection('allrequests').document(element.documentID).delete();
            });
          });
          noreqs("Request's declined, Successfully.");
        }
        else{
          noreqs("No requests found, To decline.");
        }
      }
      void noreqs(String info){
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(info),
        ));
      }

//      Future<num> reqcount(String berth,String status,num n) async {
//
//      if(status=="Waiting for approval"){
//        var db = Firestore.instance.collection('requests').document(today).collection('allrequests');
//        var docu= await db.where("preferred_berth",isEqualTo:berth).where('status',isEqualTo: status).getDocuments();
//        if(docu.documents.isNotEmpty) {
//          docu.documents.forEach((element) {
//            setState(() {
//              if (berth == "LOWER_BERTH") {
//                rlb++;
//                totalr++;
//              }
//              else if (berth == "MIDDLE_BERTH") {
//                rmb++;
//                totalr++;
//               }
//              else {
//                rub++;
//                totalr++;
//              }
//            });
//          });
//        }
//      }
//      else{
//        var db = Firestore.instance.collection('requests').document(today).collection('allrequests');
//        var doc= await db.where('status',isEqualTo: status).where('type',isEqualTo: n).getDocuments();
//        if(doc.documents.isNotEmpty) {
//          doc.documents.forEach((element) {
//            setState(() {
//              if (berth == "LOWER_BERTH") {
//                alb++;
//                allocs++;
//              }
//              else if (berth == "MIDDLE_BERTH") {
//                amb++;
//                allocs++;
//              }
//              else {
//                aub++;
//                allocs++;
//              }
//            });
//          });
//        }
//      }
//  }
//
//      Future<void> bedData() async {
//        var collectonRef = Firestore.instance.collection('beds');
//        var doc =await collectonRef.document('details').get();
//        if(doc.exists) {
//          setState(() async {
//            lb=doc.data['lower_berth'];
//            mb=doc.data['middle_berth'];
//            ub=doc.data['upper_berth'];
//            count=lb+mb+ub;
//            await reqcount("LOWER_BERTH","Waiting for approval",0);
//            await reqcount("MIDDLE_BERTH","Waiting for approval",0);
//            await reqcount("UPPER_BERTH","Waiting for approval",0);
//            await reqcount("LOWER_BERTH","Bed allocated",1);
//            await reqcount("MIDDLE_BERTH","Bed allocated",2);
//            await reqcount("UPPER_BERTH","Bed allocated",3);
//            if(allocs!=0){
//              req="All request has got beds allocated,For Today";
//            }
//            if(totalr==0){
//              note="There is no requests to allocate beds.";
//              note1="There is no requests to decline requests.";
//            }
//            else if(totalr<=count){
//              note="Do you want allocate beds to all requests($totalr requests).";
//              note1="Do you want to decline all requests($totalr requests).";
//
//            }
//            else if(count==0){
//              note="There is no beds to allocate.";
//              note1="There is no beds to allocate. And do you want to decline all requests.";
//            }
//            else if(count==0 && totalr==0){
//              note="There is no beds nor requests to allocate.";
//              note1="There is no beds nor requests to  Decline.";
//            }
//            else{
//              prob=((count/totalr)*100).round();
//              note="Do you want to allocate beds to all $totalr requests. Only $prob % ($count requests) of requests will get beds allocated.This For the given"
//                  " bed counts"
//                  " Rest of the request will be cancelled out";
//              note1="Do you want to decline to all $totalr requests. $prob % ($count requests) of requests will get beds allocated. If the request is accepted";
//            }
//          });
//        }
//        else{
//          setState(() async {
//            lb = doc.data['lower_berth'];
//            mb = doc.data['middle_berth'];
//            ub = doc.data['upper_berth'];
//            count = lb + mb + ub;
//            note="There is no requests to allocate beds..";
//            note1="There is no requests to decline requests..";
//            req="No, Folk have requested for bed today.";
//          });
//
//        }
//      }

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
                      FlatButton(
                        child: Text("No",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        padding: EdgeInsets.all(9),
                      ),
                      SizedBox(width: 4,),
                      FlatButton(
                        child: Text("Yes",
                        style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                        ),),
                        onPressed: () async{
                          if(val==true){
                              await allocaterequests();
                              Navigator.of(context).pop();
                            }
                          else {
                              await deleterequests("Request was declined,By guide.");
                              Navigator.of(context).pop();
                            }
                          },
                        padding: EdgeInsets.all(9),
                      )
                    ],
                  )
                ],
              );
            });
      }

      Widget data(){
        if (totalr>0) {
          return requestlist();
        }
        else {
          return Container(
              child:Center(
                child:Text("$req",
                  style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 15
                  ),) ,
              )
          );
        }
      }

//        @override
//        void onLoading() {
//          showDialog(
//            context: context,
//            barrierDismissible: false,
//            builder: (BuildContext context) {
//              return Dialog(
//                child: new Row(
//                  mainAxisSize: MainAxisSize.min,
//                  children: [
//                    new CircularProgressIndicator(),
//                    new Text("Loading"),
//                  ],
//                ),
//              );
//            },
//          );
//          new Future.delayed(new Duration(seconds: 5), () {
//            Navigator.pop(context); //pop dialog
//            build(context);
//          });
//        }

      @override
      void initState(){
      super.initState();
//       bedData();
         zone = center;
      }

      @override
      Widget build(BuildContext context)
      {
        return  Scaffold(
            body:Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(child:requestlist(center: center,)),
                    Container(
                      height: 50,
                      color: Colors.transparent,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 10,),
                          Expanded(
                            child: MaterialButton(
                              elevation: 10,
                              child: Text('Decline all',
                                style: TextStyle(
                                  color: Colors.black,
                                ),),
                              color: Colors.white,
                              shape: new RoundedRectangleBorder(side:BorderSide( width: 2,color: Colors.black,
                                  style: BorderStyle.solid),borderRadius:BorderRadius.circular(20)),
                              onPressed: (){
                                allocate(context,"Declining requests.",note1,false);
                              },
                            ) ,
                          ),
                          SizedBox(width: 25,),
                          Expanded(
                            child: MaterialButton(
                              elevation: 8,
                              child: Text('Accept all',
                                style: TextStyle(
                                  color: Colors.black,
                                ),),
                              color: Colors.white70,
                              shape: new RoundedRectangleBorder(side:BorderSide( width: 2,color: Colors.black,
                                  style: BorderStyle.solid),
                              borderRadius:BorderRadius.circular(20)),
                              onPressed: (){
                                allocate(context,"Confirmation for allocation.",note,true);
                              },
                            ) ,
                          ),
                          SizedBox(width: 10,)
                        ],
                      ),
                    ),
                  ],
                )
        );
      }
    }


// ignore: must_be_immutable
// ignore: camel_case_types
class requestlist extends StatelessWidget{
  requestlist({this.center});
  final String center;
  static DateTime now = DateTime.now();
  static var  formatter = DateFormat('yyyy-MM-dd');
  static var today = formatter.format(now);
  final List<String> images = ['https://firebasestorage.googleapis.com/v0/b/folkapp-a0871.''appspot.com/o/pexels-fabian-wiktor-994605.jpg?alt=media&token=75531d8e'
      '   -3cf5-4f3d-b06b-cc7745114b37','https://firebasestorage.googleapis.com/v0/b/folkapp-a0871.appspot.com/o/pexels-jiarong-deng-1034662.jpg?alt=media&'
      'token=c827d22a-4d31-4747-97f9-7ce32a05d7ba','https://firebasestorage.googleapis.com/v0/b/folkapp-a0871.appspot.com/o/pexels-pavlo-luchkovski-337909.'
  'jpg?alt=media&token=1a650cfa-752c-440e-81f3-56fd92da5923','https://firebasestorage.googleapis.com/v0/b/folkapp-a0871.appspot.com/o/pexels-ricardo-esqui'
      'vel-1586298.jpg?alt=media&token=39c1928e-88f9-4754-ab2d-4c38fc518da3','https://firebasestorage.googleapis.com/v0/b/folkapp-a0871.appspot.com/o/pexe'
      'ls-stijn-dijkstra-2583852.jpg?alt=media&token=f9308f22-ec5c-44aa-99bc-3ec99c1157f0','https://firebasestorage.googleapis.com/v0/b/folkapp-a0871.apps'
      'pot.com/o/pexels-todd-trapani-2754200.jpg?alt=media&token=ae149bf0-412d-4880-819c-33352aafa2a6','https://firebasestorage.googleapis.com/v0/b/folkapp'
      '-a0871.appspot.com/o/pexels-sourav-mishra-1149831.jpg?alt=media&token=cf023b19-f06e-4e64-baaa-d7d2398bf0b6'];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('requests').document(today).
        collection('allrequests').where('status',isEqualTo: "Waiting for approval").
        snapshots(),
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
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                            SizedBox(height:9,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topRight,
                                      child:CircleAvatar(
                                        backgroundImage: NetworkImage(images.elementAt(Random().nextInt(6))),
                                        backgroundColor: Colors.green[900],
                                        radius: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 8,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(document['Folkname'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      SizedBox(height: 7.0,),
                                      Text("Requested "+
                                          document['preferred_berth'].toString().toLowerCase()
                                          +" for "+document['Date'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12
                                        ),),
                                      Text(document['Message']=='No message'? "" :"Message :" + document['Message'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15
                                        ),),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            ],
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
                  ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Allocate',
                        color: Colors.green[900],
                        icon: Icons.priority_high,
                        onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        callocation(berth: document['preferred_berth'],phone:document['Mobile_Number'],
                        message: document['Message'],uname: 
                        document['Folkname'],from:document['Date'],to:document['Date'],profile: images.elementAt(2),
                        center:center)));  
                        },
                      ),
                      IconSlideAction(
                        caption: 'Forward',
                        color: Colors.green[700],
                        icon: Icons.forward,
                        onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        forwardreq(berth: document['preferred_berth'],phone:document['Mobile_Number'],
                        message: document['Message'],uname: 
                        document['Folkname'],from:document['Date'],to:document['Date'],profile: images.elementAt(2),
                        center:center)));                         
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



