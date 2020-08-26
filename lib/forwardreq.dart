import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  TextEditingController fgmessages = TextEditingController();
  List<Container> ele = [];

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
              fontSize: 13,
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
                    fontSize: 13,
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
                                padding: EdgeInsets.symmetric(horizontal:5,vertical:5),
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
      '-a0871.appspot.com/o/pexels-sourav-mishra-1149831.jpg?alt=media&token=cf023b19-f06e-4e64-baaa-d7d2398bf0b6'),                                                backgroundColor: Colors.green[900],
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
                                                      fontSize: 13,
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
          padding: EdgeInsets.symmetric(horizontal:10,vertical:12),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,     
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close), 
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
                       fgmessage = value;
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
          body: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical:2,horizontal:2),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children:ele
                  ),
                  SizedBox(height:20),
                  Row( 
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                      MaterialButton(
                        padding: EdgeInsets.all(3),
                        child: Text('+ msg',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10
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
                    SizedBox(height:5,),   
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
                      shape: new RoundedRectangleBorder(borderRadius:BorderRadius.circular(15)),
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