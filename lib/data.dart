import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:folkguideapp/mainpage.dart';
import 'package:folkguideapp/room.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class data extends StatefulWidget{
  data({this.center,this.no});
  final String center,no;
  @override
  bedavailable createState()=>bedavailable(center: center,type: false,no: no);
}

// ignore: camel_case_types
class bedavailable extends State<data>{
  bedavailable({this.center,this.type,this.no});
  final String center,no;
  final bool type;
  num lb=0,mb=0,ub=0,rlb=0,rmb=0,rub=0,count=0,totalr=0,prob=0,allocs=0,alb=0,amb=0,aub=0,i=0;
  String location='',admin='',rname='',doc='',docid='';
  num ub1=0,lb1=0,mb1=0,rcount=0,index=0;
  String note="",note1="",tallocs="";
  static DateTime now = DateTime.now();
  static var  formatter = DateFormat('yyyy-MM-dd');
  static var today = formatter.format(now);
  TextEditingController lowerberth = TextEditingController();
  TextEditingController middleberth = TextEditingController();
  TextEditingController upperberth = TextEditingController();
  TextEditingController roomname = TextEditingController();
  List<Container> roomslist = [];
  bool adm = false;


 Future checkforadmin() async{
   var admr = await Firestore.instance.collection('FOLKGuides').where('mobile_number',isEqualTo:no).getDocuments();
   admr.documents.forEach((ele){
     setState(() {
       adm = ele.data['admin'];
     });

   });
 }





  Column details(String field,num n){
    return Column(
      children: <Widget>[
        Text(field,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14
          ),),
        SizedBox(height: 6,),
        Text(n.toString(),
          style: TextStyle(
              color: Colors.green[900],
              fontSize:14
          ),),
      ],
    );
  }

  Row namefields(String field,String value){
    return Row(
      children: <Widget>[
        Text(field+":",
          style: TextStyle(
              color: Colors.black,
              fontSize: 14
          ),),
        SizedBox(height:3,),
        Text(value,
          style: TextStyle(
              color: Colors.green[900],
              fontSize:14
          ),),
      ],
    );
  }


  
    Future getdoc() async{
      var bed = await Firestore.instance.collection('Centers').where('centre',isEqualTo:center).getDocuments();
      bed.documents.forEach((checkforbed) {
        setState(() {
          docid = checkforbed.documentID;
        });
        }); 
    }




  // ignore: missing_return
  Future<void> updates(String rn,num l,num m,num b) async{
    setState(() async {
      var centerdoc =  Firestore.instance.collection('Centers').document(doc);
      var addroom = centerdoc.collection('data');
      var db = await centerdoc.get();
      rcount = db.data['roomcount'];
      if(rcount==null){
       centerdoc.setData({
          'roomcount' : 1 
       },merge: true).then((value) {
          addroom.document(rn).setData({
        'lowerberth':l,
        'middleberth':m,
        'upperberth':b
      });
      });
     }
    else{
      rcount++;
      addroom.document(rn).setData({
        'lowerberth':l,
        'middleberth':m,
        'upperberth':b
      }).then((value) {
          centerdoc.updateData({
            'roomcount': rcount
          });
          });
      }
     });
  }



  Future<bool> question(BuildContext context,String field,String text,String ddoc) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(field
            ,textAlign: TextAlign.left,),
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
                      var collection = Firestore.instance.collection('Centers').document(doc);
                                var db = await collection.get();
                                num temp = await db.data['roomcount'];  
                                temp = temp-1;
                                 collection.collection('data')
                                    .document(ddoc).delete().then((value) {
                                       collection.updateData({
                                      'roomcount': temp
                                      });
                                    });
                                    Navigator.of(context).pop();
                                  },
                    padding: EdgeInsets.all(9),
                  )
                ],
              )
            ],
          );
        });
  }


  Future reqcount() async {
    var db = Firestore.instance.collection(center).document(today).collection('allrequest');
    var docu = await db.where('status',isEqualTo:'Waiting for approval').getDocuments();
       if(docu.documents.isNotEmpty) {
         docu.documents.forEach((element) {
             if (element.data['preferred_berth']=="LOWER_BERTH") {
               setState(() {
                  rlb++;
                  totalr++;
               });  
             }
             else if (element.data['preferred_berth']== "MIDDLE_BERTH") {
               setState(() {
                  rmb++;
                  totalr++;
                  });
              }
             else {
               setState(() {
                rub++;
                totalr++;               
                });
             }
         });
       }
       }


    // bool checkroom(String room){
    // var checkroom = Firestore.instance.collection(center).document(today).collection('Activeallocs').where('room',isEqualTo:room).getDocuments();

    // return checkroom.documents.isEmpty;
    
    // }
     
   




  Container rooms(String rn,num l,num m,num u,bool flag,num i,bool edit){
    return Container(
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.stretch,
        children: [
          Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            elevation: 30,
            child: FlatButton(
              onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) =>
                      room(roomno: rn,centers: center,nlb: l,nmb: m,nub: u,doc:docid,),));
                },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:1,vertical:5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10,),
                        Text(rn,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),),
                        Expanded(
                          child:SizedBox(width: 40,),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit,color:adm==true?Colors.black:Colors.transparent),
                          onPressed: (){
                            if(!flag && edit && adm){
                              setState(() {
                              lowerberth.text = l.toString();
                              upperberth.text = u.toString();
                              middleberth.text = m.toString();
                              roomname.text = rn.toString();
                              lb1=num.parse(lowerberth.text);
                              mb1=num.parse(middleberth.text);
                              ub1=num.parse(upperberth.text);
                              rname=roomname.text;
                              updatedata(context,'$rn(Edit)','Save',rn).then((value) {
                                addroom();
                              });
                            });
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever,color:adm==true?Colors.black:Colors.transparent),
                         onPressed: () {
                            if(!flag && edit && adm){
                              setState(() {
                            question(context,'Remove, $rn','Do you really want to remove ,$rn.',rn).
                            then((value) {
                              setState(() {
                                roomslist.removeAt(i);
                                });
                              });
                            });
                            }
                            },
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Expanded(
                          child:details('lower berth', l),
                        ),
                        Expanded(
                            child: details('middle berth', m)
                        ),
                        Expanded(
                            child: details('upper berth', u)
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: SizedBox(
              height: 5,
            ),
          )
        ],
      ),
    );
  }

//   ignore: missing_return
  Future<void> addroom() async{
    num temp1=0,temp2=0,temp3=0;
    String flag='';
    var checkroom;
    var check =  Firestore.instance.collection(center).document(today).collection('Activeallocs');
    roomslist.clear();
    var collectionRef = await Firestore.instance.collection('Centers').where('centre',isEqualTo:center).getDocuments();
      collectionRef.documents.forEach((element) {
        flag = element.documentID;
      });
      setState((){
        doc = flag;
    });

    var centerdoc = await Firestore.instance.collection('Centers').document(doc).collection('data').where('lowerberth',isGreaterThan:0)
    .getDocuments();
    var db = await Firestore.instance.collection('Centers').document(doc).get();

            centerdoc.documents.forEach((roomN) async{
              temp1 = temp1 + roomN.data['lowerberth'];
              temp2 = temp2 + roomN.data['middleberth'];
              temp3 = temp3 + roomN.data['upperberth'];
              checkroom = await check.where('room',isEqualTo:roomN.documentID).getDocuments();
              roomslist.add(rooms(roomN.documentID, roomN.data['lowerberth'],
                  roomN.data['middleberth'], roomN.data['upperberth'],type,i,checkroom.documents.isEmpty));
                  setState(() {
                    i++;
                    });
            });
    setState((){
      lb = temp1;
      mb = temp2;
      ub = temp3;
      count = temp1 + temp2 + temp3;
      admin =  db.data['admin']!='null'?'':db.data['admin'];
      location = db.data['centre'];
   
    });

  }



  


          Row updatefields(String ftext,num n){
                return Row(
                          children: <Widget>[
                            Text(ftext,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              ),),
                            SizedBox(width: 3,),
                            Container(
                              width: 50,
                              child:  TextField(
                                cursorColor: Colors.green[900],
                                controller: n==1?lowerberth:n==2?middleberth:upperberth,
                                keyboardType: TextInputType.number,
                                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                onChanged: (value){
                                  setState(() {
                                    if(n==1){
                                      lb1 = num.tryParse(value);
                                      }
                                    else if(n==2){
                                      mb1 = num.tryParse(value);
                                      }
                                    else{
                                      ub1 = num.tryParse(value);
                                    }  
                                    });
                                    },
                                    decoration:InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.green[900])
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.green[900])
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }




  Future<bool> updatedata(BuildContext context,String text,String button,String edoc) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          var edgeInsets = EdgeInsets.symmetric(horizontal:5,vertical:0);
                    return AlertDialog(
                      title: Text(text),
                      content:Scrollbar(
                        child: SingleChildScrollView(
                          child:Container(
                            height: 300,
                            child:Container(
                            height: 300,
                            child: Padding(
                              padding: EdgeInsets.all(30) ,
                              child:Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text('Room no:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16
                                        ),),
                                      SizedBox(width: 3,),
                                      Container(
                                        width:300,
                                        child:  TextField(
                                          cursorColor: Colors.green[900],
                                          controller: roomname,
                                          onChanged: (value){
                                            setState(() {
                                              rname = value;
                                              });
                                              },
                                              decoration:InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.green[900])
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.green[900])
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  updatefields("No. of lower bed's  :",1),
                                  updatefields("No. of middle bed's:",2),
                                  updatefields("No. of upper bed's  :",3),
                                  ],
                              ),
                            )
                           ),
                          ),
                          ),
                          ),
                      contentPadding: edgeInsets,
            actions: <Widget>[
              new MaterialButton(
                child: Text(button),
                onPressed: () {
                  if(button=='Save') {
                    var db =  Firestore.instance.collection('Centers').document(doc);
                    if(edoc==rname){
                       db.collection('data').document(edoc).updateData({
                          "lowerberth" : lb1,
                          "middleberth" : mb1,
                          "upperberth" :ub1,
                        });
                        }
                    else{
                        db.collection('data').document(edoc).delete().then((value) async{
                          await db.collection('data').document(rname).setData({
                          "lowerberth" : lb1,
                          "middleberth" : mb1,
                          "upperberth" :ub1,
                        });
                        });
                      }
                        lowerberth.clear();
                        upperberth.clear();
                        middleberth.clear();
                        roomname.clear();
                        Navigator.of(context).pop();
                    }
                  else{
                    setState(() async {
                       updates(rname,lb1, mb1, ub1);
                       var checkroom = await Firestore.instance.collection(center).document(today).collection('Activeallocs').
                       where('room',isEqualTo:roomname.text).getDocuments();
                       roomslist.add(rooms(roomname.text,num.parse(lowerberth.text),
                      num.parse(middleberth.text),num.parse(upperberth.text),type,i,checkroom.documents.isEmpty));
                      lowerberth.clear();
                      upperberth.clear();
                      middleberth.clear();
                      roomname.clear();
                    });
                      Navigator.of(context).pop();
                  }
                },
                padding: EdgeInsets.all(9),
                color: Colors.green[900],
                shape: new RoundedRectangleBorder(borderRadius:BorderRadius.circular(11)),
              )
            ],
          );
        });
  }

  

  @override
  void initState(){
    super.initState();
    checkforadmin();

    getdoc();
    addroom();
 
     reqcount();


  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Scaffold(
          appBar: AppBar(
            leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.green[900],
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>mainpage(center:center,no: no,)));
                },
              );
            },
            ),
            backgroundColor: Colors.white,
            title: Text('Bed availability',
            style: TextStyle(
                color: Colors.green[900],
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontStyle: FontStyle.italic
            ),),
            centerTitle: true,
          ),
         body: Scrollbar(
           child:SingleChildScrollView(
             child:Padding(
               padding: EdgeInsets.all(20),
               child: Column(
                 children: <Widget>[
                   Container(
                     alignment: Alignment.topCenter,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         namefields('Administrator',admin),
                         SizedBox(height: 2,),
                         namefields('Location',location),
                         SizedBox(height: 2,),
                       ],
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.all(12),
                     height: 235,
                     alignment: Alignment.topCenter,
                     child: Material(
                       elevation: 40,
                       color:  Colors.white,
                       child: Column(
                         children: <Widget>[
                           Text('Available bed details',
                             style: TextStyle(
                                 color: Colors.black,
                                 fontSize: 15,
                               fontWeight: FontWeight.bold
                             ),),
                           SizedBox(height: 5,),
                           Text('total available beds :$count',
                               style:TextStyle(
                                   color:Colors.black,
                                   fontSize: 15
                               )),
                           SizedBox(height: 5,),
                           Row(
                             children: <Widget>[
                               Expanded(child:details("Lower berth",lb)),
                               Expanded(child:details("Middle berth", mb)),
                               Expanded(child:details("Upper berth", ub)),
                             ],
                           ),
                           SizedBox(height: 9,),
                           SizedBox(width: double.infinity,height: 2,
                             child: Container(
                               color: Colors.black,
                             ),),
                           SizedBox(height: 9,),
                           Text('Bed requests data',
                               style:TextStyle(
                                   color:Colors.black,
                                   fontSize: 15,
                                   fontWeight: FontWeight.bold
                               )),
                           SizedBox(height: 5,),
                           Text('total Bed requests :$totalr',
                               style:TextStyle(
                                   color:Colors.black,
                                   fontSize: 14
                               )),
                           SizedBox(height: 5,),
                           Row(
                             children: <Widget>[
                               Expanded(child:details("Lower berth",rlb)),
                               Expanded(child:details("Middle berth", rmb)),
                               Expanded(child:details("Upper berth", rub)),
                             ],
                           ),
                         ],
                       ),
                       shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(35)),
                     ),
                   ),
                   SizedBox(height: 5,),
                   Container(
                         padding: EdgeInsets.symmetric(horizontal: 14),
                         child: Column(
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children:roomslist
                         ),
                   ),
                   SizedBox(height:5,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       IconButton(
                         icon: Icon(Icons.add_circle,color:adm==true?Colors.green[900]:Colors.transparent,),
                         iconSize: 55,
                         onPressed: (){
                           if(adm){
                            updatedata(context,'Add room','Add','no');
                           }
                         },
                       ),
                       SizedBox(width: 25,)
                     ],
                   ),
                 ],
               ),
             ),
           ),
         ),
      ),
    );
  }
}





