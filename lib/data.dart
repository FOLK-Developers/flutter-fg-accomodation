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
  data({this.center});
  final String center;
  @override
  bedavailable createState()=>bedavailable(center: center);
}

// ignore: camel_case_types
class bedavailable extends State<data>{
  bedavailable({this.center});
  final String center;
  num lb=0,mb=0,ub=0,rlb=0,rmb=0,rub=0,count=0,totalr=0,prob=0,allocs=0,alb=0,amb=0,aub=0;
  String location='',admin='';
  num ub1=0,lb1=0,mb1=0,rcount=0,index=1;
  String note="",note1="",tallocs="";
  static DateTime now = DateTime.now();
  static var  formatter = DateFormat('yyyy-MM-dd');
  static var today = formatter.format(now);
  TextEditingController lowerberth = TextEditingController();
  TextEditingController middleberth = TextEditingController();
  TextEditingController upperberth = TextEditingController();
  List<Container> roomslist = [];
  roomdata r = roomdata();




  // ignore: missing_return
  Future<num> reqcount(String s,String status) async {
    var db = Firestore.instance.collection('requests').document(today).collection('allrequests');
    var docu= await db.where("preferred_berth",isEqualTo:s).where('status',isEqualTo: "Waiting for approval").getDocuments();
    docu.documents.forEach((element) {
      setState(() {
        if (status=="Waiting for approval") {
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
        }
        else if(status=="Bed allocated"){
          if (s == "LOWER_BERTH") {
            alb++;
            allocs++;
          }
          else if (s == "MIDDLE_BERTH") {
            amb++;
            allocs++;
          }
          else {
            aub++;
            allocs++;
          }
        }
      });
    });
  }





  Column details(String field,num n){
    return Column(
      children: <Widget>[
        Text(field,
          style: TextStyle(
              color: Colors.black,
              fontSize: 15
          ),),
        SizedBox(height: 6,),
        Text(n.toString(),
          style: TextStyle(
              color: Colors.green[900],
              fontSize:15
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
              fontSize: 15
          ),),
        SizedBox(height:3,),
        Text(value,
          style: TextStyle(
              color: Colors.green[900],
              fontSize:15
          ),),
      ],
    );
  }



  // ignore: missing_return
  Future<void> updates(num l,num m,num b) async{
    setState(() async {
      var collectionRef =  Firestore.instance.collection(center).document('room');
      var addroom =  collectionRef.collection('data');
      var db = await collectionRef.get();
      rcount = db.data['roomcount']+1;
    addroom.document('Room$rcount').setData({
        'rn' : rcount,
        'lowerberth':l,
        'middleberth':m,
        'upperberth':b
      }).then((value) {
          collectionRef.updateData({
            'roomcount': rcount
          }).catchError((error){
            collectionRef.collection('data').document('Room$rcount').delete();
            rcount--;
            question(context,'Failed adding Room$rcount',"Please try again",'doc',0,0);

          });
      });
    });
  }



  Future<bool> question(BuildContext context,String field,String text,String doc,num i,num rno) {
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
                      if(doc!='doc') {
                                var collection = Firestore.instance.collection(
                                    center).document('room');
                                var db = await collection.get();
                                num temp = await db.data['roomcount']; 
                                if (temp==rno) {
                                    rcount--;
                                    collection.updateData({
                                      'roomcount': rcount
                                    });
                                }
                                collection.collection('data')
                                    .document(doc).delete();
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





  Container rooms(String no,num l,num m,num u,num i,num rn){
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
                      room(roomno: no,centers: center,nlb: l,nmb: m,nub: u),));
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
                        Text('$no',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),),
                        Expanded(
                          child:SizedBox(width: 40,),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit,color: Colors.black,),
                          onPressed: (){
                            setState(() {
                              lowerberth.text = l.toString();
                              upperberth.text = u.toString();
                              middleberth.text = m.toString();
                              lb = lb-num.parse(lowerberth.text);
                              mb = mb-num.parse(middleberth.text);
                              ub = ub-num.parse(upperberth.text);
                              count=count-lb-mb-ub;
                              lb1=num.parse(lowerberth.text);
                              mb1=num.parse(middleberth.text);
                              ub1=num.parse(upperberth.text);
                              updatedata(context,'$no(Edit)','Save',no).then((value) {
//                                lb = lb+num.parse(lowerberth.text);
//                                mb = mb+num.parse(middleberth.text);
//                                ub = ub+num.parse(upperberth.text);
//                                count=count+lb+mb+ub;
                                addroom();
                              });
//                              .then((value) {
//                                roomslist.insert(i,rooms(no, num.parse(lowerberth.text), num.parse(middleberth.text),
//                                    num.parse(upperberth.text),i,rn));
//                              });
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever,color: Colors.black,),
                          onPressed: (){
                            setState(() {
//                              lb=lb-l;
//                              mb=mb-m;
//                              ub=ub-u;
//                              count=count-lb-mb-ub;
                            question(context,'Remove, $no','Do you really want to remove ,$no.',no,i,rn).
                            then((value) {
                                addroom();
                              });
                            });
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
    roomslist.clear();
    var collectionRef = Firestore.instance.collection(center);
    var addroom = await collectionRef.document('room').collection('data').getDocuments();
    var db = await collectionRef.document('room').get();
    var adminstrator = await Firestore.instance.collection('centers').document(center).get();
    setState(() {
      rcount = db.data['roomcount'];
           addroom.documents.forEach((roomN) {
              temp1 = temp1 + roomN.data['lowerberth'];
              temp2 = temp2 + roomN.data['middleberth'];
              temp3 = temp3 + roomN.data['upperberth'];
              roomslist.add(rooms(roomN.documentID, roomN.data['lowerberth'],
                  roomN.data['middleberth'], roomN.data['upperberth'],index,roomN.data['roomcount']));
              index++;
            });
      admin =  adminstrator.data['admin'];
      location = adminstrator.data['Location'];
      lb = temp1;
      mb = temp2;
      ub = temp3;
      count = temp1 + temp2 + temp3;
    });
  }



  Future<bool> updatedata(BuildContext context,String text,String button,String doc) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(text),
            content:SafeArea(
              child: Container(
                  height: 300,
                  child: Padding(
                    padding: EdgeInsets.all(30) ,
                    child:Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("No. of lower bed's:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              ),),
                            SizedBox(width: 13,),
                            Container(
                              width: 50,
                              child:  TextField(
                                cursorColor: Colors.green[900],
                                controller: lowerberth,
                                keyboardType: TextInputType.number,
                                decoration:InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.green[900])
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.green[900])
                                  ),
                                ),
                                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                onChanged: (value){
                                  this.lb1=num.tryParse(value);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("No. of middle bed's:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              ),),
                            SizedBox(width: 3,),
                            Container(
                              width: 50,
                              child:  TextField(
                                cursorColor: Colors.green[900],
                                controller: middleberth,
                                keyboardType: TextInputType.number,
                                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                onChanged: (value){
                                  this.mb1=num.tryParse(value);
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
                        Row(
                          children: <Widget>[
                            Text("No. of upper bed's:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              ),),
                            SizedBox(width: 13,),
                            Container(
                              width: 50,
                              child:  TextField(
                                cursorColor: Colors.green[900],
                                controller: upperberth,
                                keyboardType: TextInputType.number,
                                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                onChanged: (value){
                                  this.ub1=num.tryParse(value);
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
                      ],
                    ),
                  )
              ),
            ),
            contentPadding: EdgeInsets.all(5.0),
            actions: <Widget>[
              new MaterialButton(
                child: Text(button),
                onPressed: () {
                  if(button=='Save') {
                    Navigator.of(context).pop();
                    Firestore.instance.collection(center).document('room').
                    collection('data').document(doc).updateData({
                      "lowerberth" : lb1,
                      "middleberth" : mb1,
                      "upperberth" :ub1,
                    });
                    lowerberth.clear();
                    upperberth.clear();
                    middleberth.clear();
                  }
                  else{
                    updates(lb1, mb1, ub1).
                    then((value) {
                      setState(() {
                        addroom();
                        roomslist.add(rooms('Room$rcount',lb1,mb1,ub1,index,index));
                        rcount++;
                        lb = lb+num.parse(lowerberth.text);
                        mb = mb+num.parse(middleberth.text);
                        ub = ub+num.parse(upperberth.text);
                        count=lb+mb+ub;
                      });
                      lowerberth.clear();
                      upperberth.clear();
                      middleberth.clear();
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
    addroom();
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>mainpage(center:center,)));
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
               padding: EdgeInsets.all(18),
               child: Column(
                 children: <Widget>[
                   Container(
                     alignment: Alignment.topCenter,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         namefields('Administrator', admin),
                         SizedBox(height: 2,),
                         namefields('Location',location),
                         SizedBox(height: 2,),
                       ],
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.all(17),
                     height: 290,
                     alignment: Alignment.topCenter,
                     child: Material(
                       elevation: 40,
                       color:  Colors.white,
                       child: Column(
                         children: <Widget>[
                           Text('Available bed details',
                             style: TextStyle(
                                 color: Colors.black,
                                 fontSize: 16,
                               fontWeight: FontWeight.bold
                             ),),
                           SizedBox(height: 5,),
                           Text('total available beds :$count',
                               style:TextStyle(
                                   color:Colors.black,
                                   fontSize: 16
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
                                   fontSize: 17,
                                   fontWeight: FontWeight.bold
                               )),
                           SizedBox(height: 5,),
                           Text('total Bed requests :$totalr',
                               style:TextStyle(
                                   color:Colors.black,
                                   fontSize: 16
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
                         padding: EdgeInsets.symmetric(horizontal: 17),
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
                         icon: Icon(Icons.add_circle,color: Colors.green[900],),
                         iconSize: 55,
                         onPressed: (){
                            num temp = rcount+1;
                            updatedata(context,'Room-$temp','Add','no');
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





