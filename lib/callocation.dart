import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folkguideapp/mainpage.dart';

import 'beds.dart';

// ignore: camel_case_types
class callocation extends StatefulWidget{
  callocation({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.center,this.doc,this.reqid,this.no});
  final String berth,profile,uname,message,phone,center,from,to,doc,reqid,no;
  
   @override
   custom_allocation createState()=>custom_allocation(berth: berth,
     uname:uname,message: message,phone: phone,center: center,from:from,to:to,docs: doc,reqid: reqid,no: no);
}
// ignore: camel_case_types
class custom_allocation extends State<callocation>{
   custom_allocation({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.center,this.docs,this.reqid,this.no});
  final String berth,profile,uname,message,phone,center,from,to,docs,reqid,no;
  String lroomn;
  bool count;
  String fgmessage,doc,selected='No,room selected';
  String note='Select a Room from below given list.';
  TextEditingController fgmessages = TextEditingController();
  List<Container> room = [];
  Color color= Colors.transparent;
  List<num> temp = [];
  String lrn;
  num li=0;
  num lower,middle,upper;
 
  



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

  Container rooms(String rn,num l,num m,num u,num i){
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
                setState(() {
                  if(count==false){
                      room.removeAt(i);
                      selected = rn;
                      room.insert(i,rooms(rn,l,m,u,i));
                      temp.add(l);
                      temp.add(m);
                      temp.add(u);
                      li = i;
                      lrn=rn;
                      count=true;
                      lower=l;
                      middle=m;
                      upper=u;
                  }
                  else if(count==true && selected==rn){
                      room.removeAt(li);
                      selected='No,room selected';
                      room.insert(li,rooms(rn,l,m,u,i));
                      temp.clear();
                      li=0;
                      lrn=rn;
                      count=false;
                  }
                  else if(count==true && selected!=rn){
                      selected = rn;
                      room.removeAt(li);
                      room.insert(li,rooms(lrn,temp.elementAt(0), temp.elementAt(1),temp.elementAt(2), li));
                      room.removeAt(i);
                      room.insert(i,rooms(rn,l,m,u,i));
                      li=i;
                      temp.add(l);
                      temp.add(m);
                      temp.add(u);
                      lrn=rn;
                      count=true;
                      lower=l;
                      middle=m;
                      upper=u;
                  }
                  
                });
                
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
                       Icon(Icons.check_circle_outline,color:selected==rn?Colors.green[900]:Colors.transparent)
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


  Future<void> addroom() async{
    String flag;
    num i=0;
    room.clear();
    var collectionRef = await Firestore.instance.collection('Centers').where('centre',isEqualTo:center).getDocuments();
      collectionRef.documents.forEach((element) {
        flag = element.documentID;
      });
      setState((){
        doc = flag;
    });

    var centerdoc = await Firestore.instance.collection('Centers').document(doc).collection('data').where('lowerberth',isGreaterThan:0)
    .getDocuments();
            centerdoc.documents.forEach((roomN) {
              setState(() {
                room.add(rooms(roomN.documentID, roomN.data['lowerberth'],
                  roomN.data['middleberth'], roomN.data['upperberth'],i++));
                });
          });
    }

  


  
  @override
  void initState() {
    super.initState();
    addroom();
    setState(() {
      count=false;
    });
    
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
            title: Text('Custom allocation',
            style: TextStyle(
                color: Colors.green[900],
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontStyle: FontStyle.italic
            ),),
            centerTitle: true,
          ),
          body: Padding(
                padding: EdgeInsets.symmetric(vertical:0,horizontal:0),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child:Scrollbar(
                              child: SingleChildScrollView(
                                child:Padding(
                              padding: EdgeInsets.symmetric(vertical:2,horizontal:8),
                              child: Column(
                              children:<Widget>[
                              Container(
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
      '-a0871.appspot.com/o/pexels-sourav-mishra-1149831.jpg?alt=media&token=cf023b19-f06e-4e64-baaa-d7d2398bf0b6'),
                                                backgroundColor: Colors.green[900],
                                                radius: 35,
                                              ),
                                            ),
                                      SizedBox(height:8),
                                      namefields('User-name',uname),
                                      SizedBox(height:5),
                                      namefields('Request','Requested $berth for'+DateTime.fromMillisecondsSinceEpoch(int.parse(from)).toUtc().toString().substring(0,16)+',to'
                                       +DateTime.fromMillisecondsSinceEpoch(int.parse(to)).toUtc().toString().substring(0,16)),
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
                                                      fontSize: 14,
                                                  ),
                                                ),
                                                ]
                                              ),
                                            ),
                                          ],
                                          ),
                                          SizedBox(height:5),
                                          namefields('Selected Room',selected)
                                        ],
                                        ),
                                       )
                                      ),
                                      )
                                    ),
                                    SizedBox(height: 10,),
                                    Text(note,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                      
                                    ),),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding:EdgeInsets.symmetric(horizontal:6),
                                      child:Column(
                                        children:room
                                        ),
                                        ),
                                      ]
                                    )
                                   )
                              )
                            )
                            ),
                          Container(
                            // alignment:Alignment.bottomCenter,
                            child:MaterialButton(
                              height: 55,
                              child: Text('Next',
                              style: TextStyle(
                                color:Colors.white,
                                fontSize:15,
                                ),
                                ),
                              color: Colors.green[900],
                              onPressed: (){
                                if(count){
                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>bed(berth: berth,
                                      uname: uname,message: message,phone: phone,from:from,to:to,
                                      roomno:selected,centers: center,nlb:lower ,nmb:middle,nub:upper,docs: docs,reqid: reqid,no: no,)));
                                      }
                                 },)
                          )
                          ],
                        )
                      ),
                    ),
                  );
                }
}



