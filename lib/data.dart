import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:folkguideapp/mainpage.dart';
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
  num ub1=0,lb1=0,mb1=0,rcount=0;
  Future<num> n;
  bool flag=true;
  String note="",note1="",tallocs="";
  static DateTime now = DateTime.now();
  static var  formatter = DateFormat('yyyy-MM-dd');
  static var today = formatter.format(now);
  TextEditingController lowerberth = TextEditingController();
  TextEditingController middleberth = TextEditingController();
  TextEditingController upperberth = TextEditingController();
  List<Material> roomslist = [];


  Future<void> requests() async {
    var col = await Firestore.instance.collection('request').document(today).collection("allrequests");
    col.getDocuments().then((value) async {
      if(value.documents.isNotEmpty){
        setState((){
          flag=false;
        });
      }
      else{
        setState(() {
          flag=true;
        });
      }
    });
  }

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


  Future<num> bedData() async {
    var collectonRef = Firestore.instance.collection('beds');
    var doc =await collectonRef.document('details').get();
    if(doc.exists && flag) {
      setState(() async {
        var collectionRef = Firestore.instance.collection(center).document('room').collection('data');
        var getdoc = await collectionRef.getDocuments();
        // ignore: non_constant_identifier_names
        var admin = await  Firestore.instance.collection('centers').document(center).get();
        admin = admin.data['admin'];
        location = admin.data['Location'];
        if(collectionRef.document()!=null) {
          getdoc.documents.forEach((room) {
            lb = lb+room.data['lowerberth'];
            mb = mb+room.data['middleberth'];
            ub = lb+room.data['upperberth'];
          });
        }
        count=lb+mb+ub;
        await reqcount("LOWER_BERTH","Waiting for approval");
        await reqcount("MIDDLE_BERTH","Waiting for approval");
        await reqcount("UPPER_BERTH","Waiting for approval");
        await reqcount("LOWER_BERTH","Bed allocated");
        await reqcount("MIDDLE_BERTH","Bed allocated");
        await reqcount("UPPER_BERTH","Bed allocated");
        if(totalr==0){
          note="No folks have requested beds for today.";
        }
        else if(totalr>0 && count==0){
          note="There is no beds to allocate.";
        }
        else if(totalr<=count){
          note="Beds available for all the requests.";
        }
        else if(count==0){
          note="There is no beds to allocate.";
        }
        else{
          prob=((count/totalr)*100).round();
          note="Beds available for only $prob %"
              "($count requests) of requests.";
        }
      });
    }
    else{
      setState(() {
        lb= doc.data['lower_berth'];
        mb= doc.data['middle_berth'];
        ub= doc.data['upper_berth'];
        count=lb+mb+ub;
        note="No folks have requested beds for today.";
      });
    }
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
    num rooms=1;
    var collectionRef = Firestore.instance.collection(center).document('room').collection('data');
    var getdoc = await collectionRef.getDocuments();
    if(collectionRef.document()!=null) {
      getdoc.documents.forEach((room) {
        rooms++;
      });
    }
    collectionRef.document('Room$rooms').setData({
      "lowerberth" : l,
      "middleberth" : m,
      "upperberth" : b,
    });
  }

  Future<bool> question(BuildContext context,String field,String text,String doc) {
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
                      Firestore.instance.collection(center).document('room').collection('data')
                          .document(doc).delete();
                    },
                    padding: EdgeInsets.all(9),
                  )
                ],
              )
            ],
          );
        });
  }





  Material rooms(String no,num l,num m,num u){
    return Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        color: Colors.white,
        elevation: 30,
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal:3,vertical:5),
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
                      lowerberth.text = l.toString();
                      upperberth.text = u.toString();
                      middleberth.text = m.toString();
                      updatedata(context,"$no(Edit)");
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_forever,color: Colors.black,),
                    onPressed: (){
                      question(context,'Remove,$no','Do you want to remove ,$no.',no);
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
        )
    );
  }

//   ignore: missing_return
  Future<void> addroom() async{
    rcount=1;
    var collectionRef = Firestore.instance.collection(center).document('room').collection('data');
    var getdoc = await collectionRef.getDocuments();
    if(collectionRef.document()!=null)
      getdoc.documents.forEach((roomN) {
        rcount++;
        setState(() {
          roomslist.add(rooms(roomN.documentID, roomN.data['lowerberth'], roomN.data['middleberth'], roomN.data['upperberth']));
          roomslist.add(Material(
            color: Colors.transparent,
            child: SizedBox(height: 5,),
          ));
        });
      });
  }



  Future<bool> updatedata(BuildContext context,String text) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(text),
            content: Container(
                 height: 300,
                  child: Padding(
                    padding: EdgeInsets.all(30) ,
                    child: Column(
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
            contentPadding: EdgeInsets.all(5.0),
            actions: <Widget>[
              new MaterialButton(
                child: Text('Add Room'),
                onPressed: () {
                  lowerberth.clear();
                  upperberth.clear();
                  middleberth.clear();
                  updates(lb1, mb1, ub1);
                  Navigator.of(context).pop();
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
    requests();
    bedData();
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
                           updatedata(context,'$rcount');
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





