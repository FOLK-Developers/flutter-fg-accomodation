import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folkguideapp/mainpage.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class forwardreq extends StatefulWidget{
  forwardreq({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.center,this.doc,this.reqid});
  final String berth,profile,uname,message,phone,center,from,to,doc,reqid;
     @override
     forward createState()=>forward( berth: berth,
     uname: uname,message: message,phone: phone,center: center,from:from,to:to,doc: doc,reqid: reqid);
    
}

// ignore: camel_case_types
class forward extends State<forwardreq>{
 forward({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.center,this.doc,this.reqid});
  final String berth,uname,message,phone,center,from,to,profile,doc,reqid;
  var db  = Firestore.instance.collection('Centers');
  List<String> centers = [];
  String selectedcenter='Mumbai',fgmessage,docid,fwdmsg;
  TextEditingController fgmessages = TextEditingController();
  List<Container> ele = [];
  String selected='Not selected, Yet';
  static DateTime now = DateTime.now();
  static var  formatter = DateFormat('yyyy-MM-dd');
  static var today = formatter.format(now);

  Future<void> getcenters() async{
    var db = await Firestore.instance.collection('Centers').getDocuments();
    db.documents.forEach((element){
      setState(() {
        centers.add(element.data['centre']);
      });
    });
  }

    Future getdoc() async{
      var bed = await db.where('centre',isEqualTo:centers).getDocuments();
      bed.documents.forEach((checkforbed) {
        setState(() {
          docid = checkforbed.documentID;
        });
        }); 
    }


    Future<bool> question(BuildContext context,String bedno,String summary) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(bedno
              ,textAlign: TextAlign.left,),
            content: Text(summary),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
                onPressed: () async{
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      mainpage(center: center,)));

               
                },
                padding: EdgeInsets.all(9),
              )
            ],
          );
        });
  }


  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String center in centers) {
      var newItem = DropdownMenuItem(
        child: Text(center),
        value: center,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedcenter,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          fwdmsg =fwdmsg=='No message'?'[Fwd from:$center]':fwdmsg+'[Fwd from:$center]';
          selectedcenter = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> centerlist = [];
    for (String centers in centers) {
      centerlist.add(Text(centers));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          fwdmsg =fwdmsg=='No message'?'[Fwd from:$center]':fwdmsg+'[Fwd from:$center]';
          selectedcenter = centers[selectedIndex];
        });
      },
      children: centerlist,
    );
  }


  // ignore: non_constant_identifier_names
  Future Forward() async{
    var db = Firestore.instance.collection('Profile').document(phone).collection('history').document(reqid);
    var cRecord =  Firestore.instance.collection(center).document(today).collection('allrequest').document(doc);
    var forward =  Firestore.instance.collection(selectedcenter).document(today).collection('allrequest');

    db.updateData({
      'status':'Forward to $selectedcenter',
      }).then((value){
          cRecord.updateData({
              'status':'Forward to $selectedcenter',
              }).then((value) {
                forward.add( {
                    "Folkname": uname,
                    "Mobile_Number": phone,
                    "preferred_berth": berth,
                    "Message":fwdmsg,
                    "status":"Waiting for approval",
                    "allocated":"null",
                    "type":0,
                    "reqid":reqid,
                    "rtime":from.substring(12,16),
                    'from':from.substring(0,16),
                    'to': to.substring(0,16)
                  });    
                  question(context,'Fwd successfully','Request was successfully forwarded to $selectedcenter center.');                                  
                });
                });

  }



  @override
  void initState() {
    super.initState();
    getcenters();
    setState(() {
      fwdmsg = message;
    });
    ele.add(Request());
    }


   Row namefields(String field,String value,){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width:10),
        Text(field+":",
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold
          ),),
        SizedBox(width:1,),
        Expanded(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Text(value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
            ]
          )
        ),
      ],
    );
  }



  // ignore: non_constant_identifier_names
  Container Request(){
    return  Container(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal:7,vertical:5),
                                child: Material(
                                elevation:40,
                                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                child:Padding(
                                  padding: EdgeInsets.all(15),
                                  child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(height:8),
                                    Container(
                                              alignment: Alignment.center,
                                              child:CircleAvatar(
backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/folkapp'
      '-a0871.appspot.com/o/pexels-sourav-mishra-1149831.jpg?alt=media&token=cf023b19-f06e-4e64-baaa-d7d2398bf0b6'),                                               
       backgroundColor: Colors.green[900],
                                                radius: 35,
                                               ),
                                            ),
                                      SizedBox(height:8),
                                      namefields('User-name', uname),
                                      SizedBox(height:5),
                                      namefields('Request','Requested $berth for $from to $to'),
                                      SizedBox(height:5),
                                      namefields('Phone number', phone),
                                      SizedBox(height:5),
                                      namefields('Forward to', selected),
                                      SizedBox(height:5),
                                      Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,  
                                              children: <Widget>[
                                                SizedBox(width:10),
                                                Column(
                                                  children: [
                                                    Text(message=='No message'?'':'Message :',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                  )
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(message=='No message'?'':message,
                                                      style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                  ),
                                                ),
                                                ]
                                              ),
                                            ),
                                          ],
                                          ),
                                        
                                          ],
                                        ),
                                       )
                                      ),
                                      )
                                    );
  }


Container messages(){
  return Container(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal:5,vertical:5),
      child: Material(
      shape: new RoundedRectangleBorder(borderRadius:BorderRadius.circular(35)),
      elevation: 40,
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:8,vertical:8),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,     
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close,size: 20,), 
                    onPressed:(){
                       setState(() {
                         ele.removeLast();
                       });
                    })
                    ],
                  ),
                   TextField(
                      maxLines: 3,
                      controller : fgmessages,
                      onChanged:(value){
                        if(fwdmsg=='No message'){
                          setState(() {
                            fwdmsg = '[Fwd from:$center,msg:$value]';
                          });
                        }
                        else{
                        setState(() {
                         fwdmsg =fwdmsg+'[Fwd from:$center,msg:$value]';
                        });
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(7),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black)),
                        labelText: 'Message',
                        labelStyle: TextStyle(
                          color: Colors.black
                        )
                    ),
                  ),
                  ],     
                  )
                 )
                ),
              ) 
          ),
       );
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
            title: Text('Forward request',
            style: TextStyle(
                color: Colors.green[900],
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontStyle: FontStyle.italic
            ),),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child:Scrollbar(
                child: SingleChildScrollView(
                  child:Padding(
                    padding: EdgeInsets.symmetric(vertical:2,horizontal:8),
                    child: Column(
                      children:<Widget>[
                          Column(
                            children:ele
                          ),
                          SizedBox(height:2),
                          Row( 
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                              MaterialButton(
                                padding: EdgeInsets.all(3),
                                child: Text('+ msg',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13
                                    ),),
                                  color: Colors.green[900],
                                  shape: new RoundedRectangleBorder(borderRadius:BorderRadius.circular(30)),
                                  onPressed: (){
                                    if(ele.length==1)
                                    setState(() {
                                      ele.add(messages());
                                      });
                                    }),
                              ]
                            ),
                            Row( 
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Expanded(child: SizedBox(width:2),),
                                Text('Forward to :',
                                  style: TextStyle(
                                    fontSize: 16
                                  ),),
                                Container( 
                                          width:100,
                                          height:30,
                                          color: Colors.white,
                                          child: Platform.isIOS ? iOSPicker() : androidDropdown(),
                                        ),
                                Expanded(child: SizedBox(width:2),),
                                ],
                            ),
                            ]
                     ),
                    ),
                ),
              ),
            ),
            Container(
              child:MaterialButton(
                height: 55,
                child: Text('Forward',
                style: TextStyle(
                  color:Colors.white,
                  fontSize:15,
                  ),
                  ),
                  color: Colors.green[900],
                  onPressed: (){
                    Forward();
                  },
                  )
                  )
                  ]
                ),
      ),
    );
  }
  
}






// Expanded(
//                      child: Column(
//                        children: [
//                          
                 
//                     SizedBox(height:5,),   
//                     

//                        ]
//                        ,)
                  
//                    ),
                  