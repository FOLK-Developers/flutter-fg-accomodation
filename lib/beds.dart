import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:folkguideapp/date_picker_timeline.dart';
import 'package:folkguideapp/room.dart';
import 'package:intl/intl.dart';
import 'callocation.dart';
import 'mainpage.dart';

// ignore: camel_case_types
class bed extends StatefulWidget{
  bed({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.roomno,this.centers,this.nlb,this.nmb,this.nub,this.docs,this.reqid});
  final String roomno;
  final String centers;
  final num nlb,nmb,nub;
  final String berth,profile,uname,message,phone,from,to,docs,reqid;
  berths createState()=>berths(berth: berth,
     uname: uname,message: message,phone: phone,from:from,to:to,
     roomno: roomno,centers: centers,nlb: nlb,nmb: nmb,nub: nub,docs: docs,reqid: reqid);
}

// ignore: camel_case_types
class berths extends State<bed>{
  berths({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.roomno,this.centers,this.nlb,this.nmb,this.nub,this.docs,this.reqid});
  final String roomno;
  final String centers;
  final num nlb,nmb,nub;
  final String berth,profile,uname,message,phone,from,to,reqid,docs;
  num c=0,type;
  // ignore: non_constant_identifier_names
  String a1,a2,a3,From,To;
  // ignore: non_constant_identifier_names
  num highest,smallest,mid;
  List <Row> bed = [];
  String selected = 'No, bed selected',status='No, bed assigned.Yet',btn='allocate';
  String date = '',date2='',time='',time2='',docid;
  var db  = Firestore.instance.collection('Centers');
  roomdata room = roomdata();
  static DateTime now = DateTime.now();
  static var  formatter = DateFormat('yyyy-MM-dd');
  static var today = formatter.format(now);
  bool active = false;

   

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


  


  Row fromandto(String field1,String field2){
    return Row(
      children: [
        SizedBox(width:12),
        Expanded(
          child:Column(
            children:[
               Text(field1,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                  ),),
              DatePicker(
                  DateTime.now(),
                  onDateChange: (value){
                        if(field1=='From'){
                          setState(() {
                            date = value.toString();
                            });
                        }
                        else{
                          setState(() {
                            date2 = value.toString();
                            });
                        }
                      },
                      ),
                      ]
                      ) 
          ),
          SizedBox(width:10),
          Column(
              children: [
                Text(field2,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                      ),),
                      TimePickerSpinner(
                        is24HourMode: true,
                        normalTextStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                        highlightedTextStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.green[900],
                          fontWeight: FontWeight.bold
                          ),
                        spacing:5,
                        itemHeight:30,
                        isForce2Digits: true,
                        onTimeChange: (value) {
                          if(field1=='From'){
                            setState(() {
                              time = value.toString();
                              });
                          }
                          else{
                            setState(() {
                              time2 = value.toString();
                              });
                          }
                        }
                        )
                        ],
          ),
          ]
      );
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
                      mainpage(center: centers,)));

               
                },
                padding: EdgeInsets.all(9),
              )
            ],
          );
        });
  }

  Future allocating(String bedno,String from,String to,num type) async{
    var allocating = Firestore.instance.collection(centers).document(today).collection('allrequest').document(docs);
    var hUpdate =  Firestore.instance.collection('Profile').document(phone).collection('history').document(reqid);
    allocating.updateData({
      'allocated':roomno+','+bedno,
      'status':'Ready to occupy',
      'from':from,
      'to':to
    }).then((value){
      hUpdate.updateData({
        'allocated':roomno+','+bedno,
        'status':'Ready to occupy',
        'from':from,
        'to':to
        });
      db.document(docid).collection('Activeallocs').add({
        'allocated':roomno+','+bedno,
        'allocated_to':phone,
        'reqid':reqid,
        'type':type,
        'room':roomno
        });
        }).then((value) {
          question(context,bedno,'bed no.'+bedno+' from '+roomno+' was successfully allocated to $uname');
          });

  }



   


  Scrollbar dateselect(String bedno,num type){
    return Scrollbar(
       child: SingleChildScrollView(
         child:Padding(
           padding:EdgeInsets.all(15),
           child:Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children:<Widget>[
                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children:<Widget>[
                         IconButton(
                           icon: Icon(Icons.close),
                           color: Colors.black,
                           onPressed: (){
                             Navigator.of(context).pop();
                           }),
                          
                         SizedBox(
                           width:5
                         )
                         ]
                         ),
                         fromandto('From','Time'),
                         SizedBox(height:12),
                         fromandto('To','Time'),
                         SizedBox(height:3),
                         namefields('name',uname),
                         namefields('Selected-berth','$roomno-$selected'),
                        //  namefields('Date','from:'+date.substring(0,10)+time.substring(10,16)+'-'+date2.substring(0,10)+time2.substring(10,16)),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             MaterialButton(
                              child: Text(btn,
                              style: TextStyle(
                                color:Colors.white,
                                fontSize:15,
                                ),
                                ),
                              color: Colors.green[900],
                              onPressed: (){
                               if(date!='null' && date2!='null'){

                                 From = date.substring(0,10)+time.substring(10,16);
                                 To = date2.substring(0,10)+time2.substring(10,16);
                                 setState(() {
                           
                                   From =DateTime.utc(int.parse(From.substring(0,4)),int.parse(From.substring(5,7))
                                                 ,int.parse(From.substring(8,10)),int.parse(From.substring(11,13)),int.parse(From.substring(14,16)),
                                                 ).millisecondsSinceEpoch.toString();
                                  To = DateTime.utc(int.parse(To.substring(0,4)),int.parse(To.substring(5,7))
                                  ,int.parse(To.substring(8,10)),int.parse(To.substring(11,13)),int.parse(To.substring(14,16))).toUtc().millisecondsSinceEpoch.toString(); 
                                   
                                 });
                                 
                                
                                 allocating(bedno,From,To,type);
                               }

                              },
                              )
                              

                           ],
                         ),
                   ]      
                 )
         )
       )
       );
  }

  Future<bool> checkforbed(String berth) async{
    bool temp = false;
    var checkforbed = await db.document(docid).collection('Activeallocs').where('allocated',isEqualTo: roomno+','+berth).
    getDocuments();
    checkforbed.documents.forEach((checking) {
      if(checking.data['allocated']== roomno+','+berth)
      setState(() {
        temp = true;
          });
      });

      return temp;
      }
  




  // ignore: missing_return
  MaterialButton beds(Color col,String bedno,num type){
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 3,vertical: 1),
      onPressed: () async{
           

        if(await checkforbed(bedno)){
           room.question(context, bedno,"Oops,Bed selected isn't Vacant.");
           }
        else{
          selected = bedno;
           showModalBottomSheet(
             context: context, 
             builder: (BuildContext context){
               return dateselect(bedno,type);
             });
          }
        },
      child: Container(
        height: 100,
        width: 60,
        child: Material(
          color: col,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 6,),
              Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                  ),
                 child: Container(
                   width:40,
                   height: 20,
                   child:Text('$bedno',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                         color: Colors.black,
                         fontSize: 12,
                         fontWeight: FontWeight.bold
                     ),),
                 ),
              ),
              ],
          )
        ),
      ),
    );
  }

  void greatest(num l,num m,num u){
    setState(() {
      if(l>=m && l>=u){
        highest = nlb;
        a1 = 'lb';
      }
      else if(m>=l && m>=u){
        highest = nmb;
        a1 = 'mb';
      }
      else{
        highest = nub;
        a1 = 'ub';
      }
    });
  }

  void smallests(num l,num m,num u){
    setState(() {
      if(l<=m && l<=u){
        smallest = nlb;
        a2 = 'lb';
      }
      else if(m<=l && m<=u){
        smallest = nmb;
        a2 = 'mb';
      }
      else{
        smallest = nub;
        a2 = 'ub';
      }
    });
  }

  void middles(num l,num m,num u){
    setState(() {
      if(u==highest && m==smallest || u==smallest && m==highest){
        mid = nlb;
        a3= 'lb';
      }
      else if(u==highest && l==smallest  || l==highest && u==smallest){
        mid = nmb;
        a3 = 'mb';
      }
      else{
        mid = nub;
        a3 = 'ub';
      }
    });
  }


  // ignore: missing_return
  Row addbeds(num lb,num mb,num ub) {
    return Row(
        children: [
          Expanded(
              child: lb==0?MaterialButton(onPressed: (){},):beds(Colors.green[900],'lb-$lb',1)
          ),
          Expanded(
              child: mb==0?MaterialButton(onPressed: (){}):beds(Colors.green[900],'mb-$mb',2)
          ),
          Expanded(
              child: ub==0?MaterialButton(onPressed: (){}):beds(Colors.green[900],'ub-$ub',3)
          ),
        ]
    );
  }


  void merge(num l,num m,num u){
    // ignore: unnecessary_statements
    for(int i=0; i<=highest;i++){
      if(i<=smallest){
        bed.add(addbeds(i, i, i));
      }
      else if(i<=mid){
        if(a2=='lb') {
          bed.add(addbeds(0, i, i));
        }
        else if(a2=='mb') {
          bed.add(addbeds(i, 0, i));
        }
        else{
          bed.add(addbeds(i, i, 0));
        }
      }
      else {
        if(a1=='lb') {
          bed.add(addbeds(i, 0, 0));
        }
        else if(a1=='mb') {
          bed.add(addbeds( 0, i,0));
        }
        else{
          bed.add(addbeds(0, 0, i));
        }
      }
    }
  }

    Future getdoc() async{
      var bed = await db.where('centre',isEqualTo:centers).getDocuments();
      bed.documents.forEach((checkforbed) {
        setState(() {
          docid = checkforbed.documentID;
        });
        }); 
    }


    @override
  void initState() {
    super.initState();
    greatest(nlb,nmb,nub);
    smallests(nlb,nmb,nub);
    middles(nlb,nmb,nub);
    merge(nlb,nmb,nub);
    getdoc();
    
    }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:AppBar(
          leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.green[900],
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>callocation(berth:berth,profile:profile,
                  uname:uname,message:message,phone:phone,
                   from:from,to:to,center:centers,doc: docs,reqid: reqid,
                  )));
                },
              );
            },
          ),
          backgroundColor: Colors.white,
          title: Text(roomno,
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
          children :<Widget>[
                Expanded(
                  child:ListView(
                  children: bed,
                  )
                ),
              
                ]
        )   
      ),
    );
  }
}