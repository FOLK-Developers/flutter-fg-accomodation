import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:folkguideapp/data.dart';

// ignore: camel_case_types
class room extends StatefulWidget{
  room({this.roomno,this.centers,this.nlb,this.nmb,this.nub,this.doc,this.no});
  final String roomno;
  final String centers,doc,no;
  final num nlb,nmb,nub;
  roomdata createState()=>roomdata(rn: roomno,centers: centers,nlb: nlb,nmb: nmb,nub: nub,doc: doc,no: no);
}

// ignore: camel_case_types
class roomdata extends State<room>{
  roomdata({this.rn,this.centers,this.nlb,this.nmb,this.nub,this.doc,this.no});
  final String rn;
  final String centers,doc,no;
  num nlb,nmb,nub;
  num c=0;
  String a1,a2,a3,docid,name='',phone='',from='',to='';
  // ignore: non_constant_identifier_names
  num highest,smallest,mid;
  List <Row> bed = [];
  List <MaterialButton> middle = [];
  List <MaterialButton> upper = [];
  List <String> berths =['lb', 'mb','ub'];
  var db  = Firestore.instance.collection('Centres');
  bool active = false;
  bool adm = false;

  Future checkforadmin() async{
    var admr = await Firestore.instance.collection('FOLKGuides').where('mobile_number',isEqualTo:no).
    where('accommodation_admin',arrayContains: centers).getDocuments();
    this.adm = admr.documents.isNotEmpty;

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
                },
                padding: EdgeInsets.all(9),
              )
            ],
          );
        });
  }

  Future<bool> deallocate(BuildContext context,String bedno,String summary,bool admin,String reqid,String udoc,String Cdoc,String authorised) {
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
                child: Text('deallocate',
                  style: TextStyle(
                      color: authorised==no ?Colors.black:Colors.transparent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
                onPressed: () async{
                  if(authorised==no){
                       db.document(doc).collection('AccommodationRequest').document(Cdoc).updateData({
                         'status':'Request was declined by fg'
                       });
                       db.document(doc).collection('Activeallocs').where('allocate',isEqualTo: bedno).getDocuments().then((value) {
                         value.documents.forEach((element) {
                           db.document(doc).collection('Activeallocs').document(element.documentID).delete();
                         });
                       });
                       Firestore.instance.collection('Profile').document(udoc).collection('history').document(reqid).
                        updateData({
                        'status':'Request was declined by fg'
                        });

                  }
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.all(9),
              ),
              FlatButton(
                child: Text("Ok",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
                onPressed: () async{

                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.all(9),
              ),
            ],
          );
        });
  }


  Future getdoc(berth) async{

     String reqid,udoc,cdoc;
     var  beduser, hUpdate,details;
     var profile =  Firestore.instance.collection('Profile');
     var center = await Firestore.instance.collection('Centres').where('centre',isEqualTo:centers).getDocuments();
     center.documents.forEach((checkfor) async {
         cdoc = checkfor.documentID;
     });
     details = db.document(cdoc).collection('Activeallocs');
     var temp = await details.where('allocated',isEqualTo:rn+','+berth).getDocuments();
          if(temp.documents.isNotEmpty) {
              temp.documents.forEach((active) async {
                reqid = active.data['reqid'];
                profile.where('mobile', isEqualTo: active.data['allocated_to'])
                    .getDocuments()
                    .then((value) {
                  value.documents.forEach((elements) async {
                    udoc = elements.documentID;
                    beduser = await profile.document(udoc).collection('history').document(reqid).get();
                    deallocate(context,berth,'Occupied By, Name:' + beduser.data['name'] + ',From:' +
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(beduser.data['from'])).toUtc()
                            .toString()
                            .substring(0, 16)
                        + ',to:' + DateTime.fromMillisecondsSinceEpoch(
                        int.parse(beduser.data['to'])).toUtc()
                        .toString()
                        .substring(0, 16),
                        adm,
                        reqid,
                        udoc,
                        active.documentID,beduser.data['fg']);
                  });
                });
              });
          }
          else{
            question(context, berth,'Bed is vacant, Currently.');
          }
        }





  // ignore: missing_return
  MaterialButton beds(Color col,String bedno){
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 3,vertical: 1),
      onPressed: () async {
        // await checkforbed(bedno).then((value) {
          await getdoc(bedno);
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
              child: lb==0?MaterialButton(onPressed: (){},):beds(Colors.green[900],'lb-$lb')
          ),
          Expanded(
              child: mb==0?MaterialButton(onPressed: (){}):beds(Colors.green[900],'mb-$mb')
          ),
          Expanded(
              child: ub==0?MaterialButton(onPressed: (){}):beds(Colors.green[900],'ub-$ub')
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

 

  @override
  void initState() {
    super.initState();
    greatest(nlb,nmb,nub);
    smallests(nlb,nmb,nub);
    middles(nlb,nmb,nub);
    merge(nlb,nmb,nub);

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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      data(center:centers,no:no,)));
                },
              );
            },
          ),
          backgroundColor: Colors.white,
          title: Text(rn,
            style: TextStyle(
                color: Colors.green[900],
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontStyle: FontStyle.italic
            ),),
          centerTitle: true,
        ),
        body: ListView(
          children: bed,
        )
      ),
    );
  }

}