import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folkguideapp/data.dart';
import 'package:folkguideapp/mainpage.dart';

// ignore: camel_case_types
class forwardreq extends StatefulWidget{
  forwardreq({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.center});
  final String berth,profile,uname,message,phone,center,from,to;
     @override
     forward createState()=>forward( berth: berth,
     uname: uname,message: message,phone: phone,center: center,from:from,to:to);
    
}

// ignore: camel_case_types
class forward extends State<forwardreq>{
 forward({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.center});
  final String berth,uname,message,phone,center,from,to,profile;
  List<String> centers = [];
  String selectedcenter='Mumbai',fgmessage;
  bedavailable b = bedavailable();
  TextEditingController fgmessages = TextEditingController();

  Future<void> getcenters() async{
    var db = await Firestore.instance.collection('Centers').getDocuments();
    db.documents.forEach((element){
      setState(() {
        centers.add(element.data['centre']);
      });
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
          selectedcenter = centers[selectedIndex];
        });
      },
      children: centerlist,
    );
  }



  @override
  void initState() {
    super.initState();
    getcenters();
    }
      Row namefields(String field,String value){
    return Row(
      children: <Widget>[
        Text(field+":",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16
          ),),
        SizedBox(width:3,),
        Text(value,
          style: TextStyle(
              color: Colors.black,
              fontSize:16
          ),),
      ],
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
          body: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                                      alignment: Alignment.center,
                                      child:CircleAvatar(
                                        backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/folkapp'
                                      '-a0871.appspot.com/o/pexels-sourav-mishra-1149831.jpg?alt=media&token=cf023b19-'
                                      'f06e-4e64-baaa-d7d2398bf0b6'),
                                        backgroundColor: Colors.green[900],
                                        radius: 45,
                                      ),
                                    ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 7,),
                        b.namefields('user name',uname),
                        SizedBox(height: 7,),
                        b.namefields('preferred berth',berth),
                        SizedBox(height: 7,),
                        b.namefields('date','from $from to $to'),
                        SizedBox(height: 7,),
                        b.namefields('message',message),
                        SizedBox(height: 7,),
                        b.namefields('Phone Number',phone),
                        ],
                        )
                  ,),
                  SizedBox(height: 20,),
                  Container(
                    // height: 300,
                    child: TextField(
                      maxLines: 3,
                      controller : fgmessages,
                      onChanged:(value){
                       fgmessage = value;
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.green[900])),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.green[900])),
                        labelText: 'message',
                        labelStyle: TextStyle(
                          color: Colors.green[900]
                        )
                      ),
                      )
                  ),
                  SizedBox(height: 20,),
                  Row( 
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Expanded(child: SizedBox(width:2),),
                       Text('Forward to:',
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
                   SizedBox(height: 40,),
                   Container(
                     width:100,
                     height: 40,
                     child: MaterialButton(
                      padding: EdgeInsets.all(5),
                      child: Text('Send',
                        style: TextStyle(
                          color: Colors.white,
                        ),),
                      color: Colors.green[900],
                      shape: new RoundedRectangleBorder(borderRadius:BorderRadius.circular(7)),
                      onPressed: (){
                      },
                    ),
                   )
                 ]
                ),
              )
             ),
             ),
      ),
    );
  }
  
}