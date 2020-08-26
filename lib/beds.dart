import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folkguideapp/date_picker_timeline.dart';
import 'callocation.dart';

// ignore: camel_case_types
class bed extends StatefulWidget{
  bed({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.roomno,this.centers,this.nlb,this.nmb,this.nub});
  final String roomno;
  final String centers;
  final num nlb,nmb,nub;
  final String berth,profile,uname,message,phone,from,to;
  berths createState()=>berths(berth: berth,
     uname: uname,message: message,phone: phone,from:from,to:to,
     roomno: roomno,centers: centers,nlb: nlb,nmb: nmb,nub: nub);
}

// ignore: camel_case_types
class berths extends State<bed>{
  berths({this.berth,this.profile,this.uname,this.message,this.phone,
  this.from,this.to,this.roomno,this.centers,this.nlb,this.nmb,this.nub});
  final String roomno;
  final String centers;
  final num nlb,nmb,nub;
  final String berth,profile,uname,message,phone,from,to;
  num c=0;
  String a1,a2,a3;
  // ignore: non_constant_identifier_names
  num highest,smallest,mid;
  List <Row> bed = [];
  String selected = 'No, bed selected',status='No, bed assigned.Yet',btn='allocate';
  String date = '',date2='';
   

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

 



   


  Scrollbar dateselect(){
    return Scrollbar(
       child: SingleChildScrollView(
         child:Padding(
           padding:EdgeInsets.all(15),
           child:Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children:<Widget>[
                     SizedBox(height:5),
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
                         Text('from',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                              ),),
                         DatePicker(
                               DateTime.now(),
                               onDateChange: (value){
                                 date = value.toString();
                               },
                              ),
                         Text('to',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                              ),),
                         DatePicker(
                              DateTime.now(),
                              onDateChange: (value){
                                date2 = value.toString();
                              },
                              ),  
                         SizedBox(height:5),
                         namefields('User-name',uname),
                         namefields('Selected-berth','$roomno-$selected'),
                         namefields('Date','from $date to $date2'),
                         namefields('Status',status),
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
                              onPressed: (){},
                              )
                              

                           ],
                         ),
                   ]      
                 )
         )
       )
       );
  }
  




  // ignore: missing_return
  MaterialButton beds(Color col,String bedno){
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 3,vertical: 1),
      onPressed: (){
        //  setState(() {
           selected = bedno;
           showModalBottomSheet(
             context: context, 
             builder: (BuildContext context){
               return dateselect();
             });
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>callocation(berth:berth,profile:profile,
                  uname:uname,message:message,phone:phone,
                   from:from,to:to,center:centers,
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