import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:folkguideapp/data.dart';

// ignore: camel_case_types
class room extends StatefulWidget{
  room({this.roomno,this.centers,this.nlb,this.nmb,this.nub});
  final String roomno;
  final String centers;
  num nlb,nmb,nub;
  roomdata createState()=>roomdata(rn: roomno,centers: centers,nlb: nlb,nmb: nmb,nub: nub);
}

// ignore: camel_case_types
class roomdata extends State<room>{
  roomdata({this.rn,this.centers,this.nlb,this.nmb,this.nub});
  final String rn;
  final String centers;
  final num nlb,nmb,nub;
  String a1,a2,a3;
  num highest,smallest,mid;
  List <Row> bed = [];
  List <MaterialButton> middle = [];
  List <MaterialButton> upper = [];
  List <String> berths =['lb', 'mb','ub'];
  bedavailable b = bedavailable();


  // ignore: missing_return
  MaterialButton beds(Color col,String bedno){
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 3,vertical: 1),
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
              child: beds(lb!=0?Colors.green[900]:Colors.transparent, lb==0?'':'lb-$lb')
          ),
          Expanded(
              child: beds(mb!=0?Colors.green[900]:Colors.transparent, mb==0?'':'mb-$mb')
          ),
          Expanded(
              child: beds(ub!=0?Colors.green[900]:Colors.transparent, ub==0?'':'ub-$ub')
          ),
        ]
    );
  }


  void merge(){
    greatest(nlb, nmb, nub);
    smallests(nlb, nmb, nub);

    
    middles(nlb, nmb, nub);

    for(int i=1; i<=highest;i++){
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
    // TODO: implement initState
    super.initState();
     merge();
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>data(center:centers)));
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
        body:Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: bed
//              [
//                Row(
//                  children: [
//                    Expanded(
//                      child:beds(Colors.green[900],'lb-1'),
//                    ),
//                    Expanded(
//                      child:beds(Colors.green[900],'lb-1'),
//                    ),
//                    Expanded(
//                      child:beds(Colors.green[900],'lb-1'),
//                    ),
//                  ],
//                ),
//                addbeds(3, 4, 5)
//
//
//              ],
            )
          ),
        ),
      ),
    );
  }

}