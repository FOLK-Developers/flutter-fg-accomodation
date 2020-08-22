
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folkguideapp/date_picker_timeline.dart';
import 'package:folkguideapp/mainpage.dart';

// ignore: camel_case_types
class callocation extends StatefulWidget{
  callocation({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.center});
  final String berth,profile,uname,message,phone,center,from,to;
  
   @override
   custom_allocation createState()=>custom_allocation(berth: berth,
     uname: uname,message: message,phone: phone,center: center,from:from,to:to);
}
// ignore: camel_case_types
class custom_allocation extends State<callocation>{
   custom_allocation({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.center});
  final String berth,profile,uname,message,phone,center,from,to;
  String lroomn;
  bool choose=false;
  num count=0;
  String fgmessage,doc,selected='';
  TextEditingController fgmessages = TextEditingController();
  List<Row> rooms=[];
  num i=0;



  Row namefields(String field,String value){
    return Row(
      children: <Widget>[
        Text(field+" :",
          style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold
          ),),
        SizedBox(width:3,),
        Text(value,
          style: TextStyle(
              color: Colors.black,
              fontSize:14
          ),),
      ],
    );
  }

   Container beds(String roomn,String berth,num lb,num mb,num ub,int i){
    return Container(
      height: 100,
      child: Material(
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17)
          ),
        elevation :30,      
      child:MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
      onPressed: (){
        setState(() { 
          if(selected=='$roomn-$berth' && count==1){
          count=0;  
          selected = '';
          rooms.removeAt(i);
          rooms.insert(i,addbeds(roomn,lb,mb,ub,i));
          }
          else if(count==0 ){
          selected = '$roomn-$berth';
          rooms.removeAt(i);
          rooms.insert(i,addbeds(roomn,lb,mb,ub,i));
          count++;
          choose=true;
         }

       
        });
      },
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.check,color:selected=='$roomn-$berth'?Colors.green[900]:
                  Colors.transparent
                  ,size: 45
                  ,),
              SizedBox(height: 6,),
              Text('$roomn',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 1),
                SizedBox(height: 1,
                child: Container(
                  color: Colors.black
                ),),
                SizedBox(height: 1),
                Text('$berth',
                textAlign: TextAlign.center,
                style: TextStyle(
                color: Colors.black,
                fontSize: 9,
                fontWeight: FontWeight.bold
                ),),
                ],
          )
        ),
    )
    );
  }

  Row addbeds(String roomn,num lb,num mb,num ub,int i) {
    return  Row(children: [
                 Expanded(
                   child: lb==0?MaterialButton(onPressed: (){},):beds(roomn,'lower berth',lb,mb,ub,i)
                ),
                SizedBox(width: 7),
                Expanded(
                    child: mb==0?MaterialButton(onPressed: (){},):beds(roomn,'middle berth',lb,mb,ub,i)
                ),
                SizedBox(width: 7),
                Expanded(
                    child: ub==0?MaterialButton(onPressed: (){},):beds(roomn,'upper berth',lb,mb,ub,i)
                ),
               ],);
  }


   Future<void> addroom() async{
    String flag;
    rooms.clear();
    var collectionRef = await Firestore.instance.collection('Centers').where('centre',isEqualTo:center).getDocuments();
      collectionRef.documents.forEach((element) {
        flag = element.documentID;
      });
      setState((){
        doc = flag;
    });

    var centerdoc = await Firestore.instance.collection('Centers').document(doc).collection('data').
    where('lowerberth',isGreaterThanOrEqualTo:0)
    .getDocuments();
            centerdoc.documents.forEach((roomN) {
              setState(() {
                 rooms.add(addbeds(roomN.documentID, roomN.data['lowerberth'],
                  roomN.data['middleberth'], roomN.data['upperberth'],i));
                  rooms.add(Row(
                   children: [
                     SizedBox(height: 3,)
                   ],
                  ));
                  i=i+2;
                });
            });
   }


  
  @override
  void initState() {
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
            title: Text('Custom allocation',
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
                padding: EdgeInsets.symmetric(vertical:10,horizontal:25),
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
                        namefields('Name',uname),
                        SizedBox(height: 7,),
                        namefields('Preferred berth',berth),
                        SizedBox(height: 7,),
                        namefields('Date','from $from to $to'),
                        SizedBox(height: 7,),
                        namefields('Phone Number',phone), 
                        SizedBox(height: 7,),
                        namefields(message=='No messsage'?'':'Message',message=='No messsage'?'':message),
                        ],
                        )
                  ,),
                  SizedBox(height: 20,),
                  Column(
                   children:rooms,),
                  SizedBox(height:25,),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('From',
                        style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize:17,
                        ),),
                        DatePicker(
                        DateTime.now(),
                        onDateChange: (date) {
                                // New date selected
                                // print(date.day.toString());
                         },
                        ),
                      ],
                     ),
                     SizedBox(height: 15,),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                             Text('To',
                            style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize:17,
                            ),),
                            SizedBox(height: 4,),
                            DatePicker(
                            DateTime.now(),
                            onDateChange: (date) {
                                    // New date selected
                                    // print(date.day.toString());
                            },
                            ),
                            
                          ],
                        ),
                    SizedBox(height: 20,),
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       namefields('Selected',selected)
                    ],),
                  SizedBox(height: 20,),
                  Container(
                     width:100,
                     height: 40,
                     child: MaterialButton(
                      padding: EdgeInsets.all(5),
                      child: Text('Allocate',
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