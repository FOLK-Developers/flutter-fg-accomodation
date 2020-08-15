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
  num nlb,nmb,nub,highest;
  List <Text> lb = [];
  List <Text> mb = [];
  List <Text> ub = [];
  List <String> berths =['lb', 'mb','ub'];

  Container bed(String roomn,String bedno,Color colors){
    return Container(
      width: 8,
      height: 18,
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          MaterialButton(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(7)
           ),
            child: Text('$bedno',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            child: SizedBox(
              height: 3,
            ),
          )
        ],
      )
    );
  }

  void greatest(num l,num m,num u){
    setState(() {
      if(l>=m && l>=u){
        highest = nlb;
      }
      else if(m>=l && m>=u){
        highest = nmb;
      }
      else{
        highest = nub;
      }

    });

  }

  // ignore: missing_return
  Row addbeds(){
   for (String berth in berths){
     if(berth=='lb'){
       for (int i=0;i<=highest;i++){
         if(i<=nlb) {
//           bed('$rn', 'lb$i', Colors.green[900])
           lb.add(Text('lb$i'));
         }
         else{
           lb.add(Text(''));
         }
       }
     }
     else if(berth=='mb'){
       for (int i=0;i<=highest;i++){
         if(i<=nlb) {
           mb.add(Text('mb$i'));
         }
         else{
           mb.add(Text(''));
         }
       }
     }
     else{
       for (int i=0;i<=highest;i++){
         if(i<=nlb) {
           mb.add(Text('ub$i'));
         }
         else{
           mb.add(Text(''));
         }
       }
     }
   }

   return Row(
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: [
        Expanded(
          child: Column(
            children:lb,
          ),
        ),
       Expanded(
         child: Column(
           children:mb,
         ),
       ),
       Expanded(
         child: Column(
           children:ub,
         ),
       )
     ],
   );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    greatest(nlb, nmb, nub);
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
            padding: EdgeInsets.fromLTRB(10,3, 10, 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:[
//                addbeds()
              ]
            ),
          ),
        ),
      ),
    );
  }

}