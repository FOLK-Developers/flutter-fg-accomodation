import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folkguideapp/mainpage.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: camel_case_types
class data extends StatefulWidget{
  data({this.center});
  final String center;
  @override
  bedavailable createState()=>bedavailable(center: center);
}

// ignore: camel_case_types
class bedavailable extends State<data>{
  bedavailable({this.center});
  final String center;
  num lb=0,mb=0,ub=0,rlb=0,rmb=0,rub=0,count=0,totalr=0,prob=0,allocs=0,alb=0,amb=0,aub=0;
  num ub1,lb1,mb1;
  Future<num> n;
  bool flag=true;
  String note="",note1="",tallocs="";
  static DateTime now = DateTime.now();
  static var  formatter = DateFormat('yyyy-MM-dd');
  static var today = formatter.format(now);
  TextEditingController lowerberth = TextEditingController();
  TextEditingController middleberth = TextEditingController();
  TextEditingController upperberth = TextEditingController();



  Future<void> requests() async {
    var col = await Firestore.instance.collection('request').document(today).collection("allrequests");
    col.getDocuments().then((value) async {
      if(value.documents.isNotEmpty){
        setState((){
          flag=false;
        });
      }
      else{
        setState(() {
          flag=true;
        });
      }
    });
  }

  Future<num> reqcount(String s,String status) async {
    var db = Firestore.instance.collection('requests').document(today).collection('allrequests');
    var docu= await db.where("preferred_berth",isEqualTo:s).where('status',isEqualTo: "Waiting for approval").getDocuments();
    docu.documents.forEach((element) {
      setState(() {
        if (status=="Waiting for approval") {
          if (s == "LOWER_BERTH") {
            rlb++;
            totalr++;
          }
          else if (s == "MIDDLE_BERTH") {
            rmb++;
            totalr++;
          }
          else {
            rub++;
            totalr++;
          }
        }
        else if(status=="Bed allocated"){
          if (s == "LOWER_BERTH") {
            alb++;
            allocs++;
          }
          else if (s == "MIDDLE_BERTH") {
            amb++;
            allocs++;
          }
          else {
            aub++;
            allocs++;
          }
        }
      });
    });
  }

  Future<num> bedData() async {
    var collectonRef = Firestore.instance.collection('beds');
    var doc =await collectonRef.document('details').get();
    if(doc.exists && flag) {
      setState(() async {
        lb= doc.data['lower_berth'];
        mb= doc.data['middle_berth'];
        ub= doc.data['upper_berth'];
        lb1=lb;
        mb1=mb;
        ub1=ub;
        count=lb+mb+ub;
        await reqcount("LOWER_BERTH","Waiting for approval");
        await reqcount("MIDDLE_BERTH","Waiting for approval");
        await reqcount("UPPER_BERTH","Waiting for approval");
        await reqcount("LOWER_BERTH","Bed allocated");
        await reqcount("MIDDLE_BERTH","Bed allocated");
        await reqcount("UPPER_BERTH","Bed allocated");
        if(totalr==0){
          note="No folks have requested beds for today.";
        }
        else if(totalr>0 && count==0){
          note="There is no beds to allocate.";
        }
        else if(totalr<=count){
          note="Beds available for all the requests.";
        }
        else if(count==0){
          note="There is no beds to allocate.";
        }
        else{
          prob=((count/totalr)*100).round();
          note="Beds available for only $prob %"
              "($count requests) of requests.";
        }
      });
    }
    else{
      setState(() {
        lb= doc.data['lower_berth'];
        mb= doc.data['middle_berth'];
        ub= doc.data['upper_berth'];
        count=lb+mb+ub;
        lb1=lb;
        mb1=mb;
        ub1=ub;
        note="No folks have requested beds for today.";
      });
    }
  }


  Column details(String field,num n){
    return Column(
      children: <Widget>[
        Text(field+":",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16
          ),),
        SizedBox(height: 6,),
        Text(n.toString(),
          style: TextStyle(
              color: Colors.green[900],
              fontSize:16
          ),),
      ],
    );
  }



  Future<void> updates() async{
    var collectonRef = Firestore.instance.collection('beds');
    var doc =await collectonRef.document('details');
    if(lb1!=null && mb1!=null && ub1!=null) {
      doc.updateData({
        "lower_berth": lb1,
        "middle_berth": mb1,
        "upper_berth": ub1,
      });
    }

  }

  // ignore: missing_return
  Material rooms(num R,num l,num m,num u){
      return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        color: Colors.white,
        elevation: 30,
        child:Padding(
          padding: EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Room number $R',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14
                ),),
              Row(
                children: [
                  Expanded(
                    child: Text("lower berth's: $l",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13
                        )
                    ),
                  ),
                  Expanded(
                    child: Text("middle berth's $m",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13
                        )
                    ),
                  ),
                  Expanded(
                    child: Text("upper berth's $u",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13
                        )
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      );
  }


  Future<bool> updatedata(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text("Add a room, $center"),
            content: Scrollbar(
              child: SingleChildScrollView(
                child:  Container(
                  child:Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("No. of lower bed's:",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                            ),),
                          SizedBox(width: 2,),
                          TextField(
                            controller: lowerberth,
                            keyboardType: TextInputType.number,
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            onChanged: (value){
                              this.lb1=num.tryParse(value);
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("No. of middle bed's:",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                            ),),
                          SizedBox(width: 2,),
                          TextField(
                            controller: upperberth,
                            keyboardType: TextInputType.number,
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            onChanged: (value){
                              this.ub1=num.tryParse(value);
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("No. of upper bed's:",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                            ),),
                          SizedBox(width: 2,),
                          TextField(
                            controller: middleberth,
                            keyboardType: TextInputType.number,
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            onChanged: (Value){
                              this.mb1=num.tryParse(Value);
                            },
                          ),
                          SizedBox(height:10),
                          Text('Note: Even individual fields can be added.')
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new MaterialButton(
                child: Text('Update'),
                onPressed: () {
                  lowerberth.clear();
                  upperberth.clear();
                  middleberth.clear();
                  updates();
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>mainpage()));
                  },
                padding: EdgeInsets.all(9),
                color: Colors.green[900],
                shape: new RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
              )
            ],
          );
        });
  }

  Column room(){
    List<Text> values = [Text('hello'),Text('hello'),Text('hello'),];
    return Column(
      children: [

      ],
    );
  }



  @override
  void initState(){
    super.initState();
    requests();
    bedData();
  }
  void noreqs(String info){
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(info),
    ));
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
            title: Text('Bed availability',
            style: TextStyle(
                color: Colors.green[900],
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontStyle: FontStyle.italic
            ),),
            centerTitle: true,
          ),
         body: Scrollbar(
          child:SingleChildScrollView(
          child:Padding(
          padding: EdgeInsets.all(18),
            child: Column(
            children: <Widget>[
            Container(
            padding: EdgeInsets.all(17),
            height: 290,
            alignment: Alignment.topCenter,
            child: Material(
            elevation: 40,
            color:  Colors.white70,
            child: Column(
            children: <Widget>[
            Text('Available bed details',
            style: TextStyle(
            color: Colors.black,
            fontSize: 19
            ),),
            SizedBox(height: 5,),
            Text('total available beds :$count',
            style:TextStyle(
            color:Colors.black,
            fontSize: 16
            )),
            SizedBox(height: 5,),
            Row(
            children: <Widget>[
            Expanded(child:details("Lower berth",lb)),
            Expanded(child:details("Middle berth", mb)),
            Expanded(child:details("Upper berth", ub)),
            ],
            ),
            SizedBox(height: 9,),
            SizedBox(width: double.infinity,height: 2,
            child: Container(
            color: Colors.black,
            ),),
            SizedBox(height: 9,),
            Text('Bed requests data',
            style:TextStyle(
            color:Colors.black,
            fontSize: 19
            )),
            SizedBox(height: 5,),
            Text('total Bed requests :$totalr',
            style:TextStyle(
            color:Colors.black,
            fontSize: 16
            )),
            SizedBox(height: 5,),
            Row(
            children: <Widget>[
            Expanded(child:details("Lower berth",rlb)),
            Expanded(child:details("Middle berth", rmb)),
            Expanded(child:details("Upper berth", rub)),
            ],
            ),
            ],
            ),
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(35)),
            ),
            ),
            SizedBox(height: 20,),
//            Container(
//            padding: EdgeInsets.all(16),
//            child: Text(note,
//            style: TextStyle(
//            fontSize: 16
//            ),)
//            ,),
            Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                rooms(1, 4, 5, 10),
                SizedBox(height:5),
                rooms(1, 4, 5, 10),
                SizedBox(height:5),
                rooms(1, 4, 5, 10),
                SizedBox(height:5),
                rooms(1, 4, 5, 10),
              ],
            ),
            SizedBox(height: 20,),
            MaterialButton(
            padding: EdgeInsets.all(18),
            child: Text('Update data',
            style: TextStyle(
            color: Colors.white,
            ),),
            color: Colors.green[900],
            shape: new RoundedRectangleBorder(side:BorderSide( width: 3,
            style: BorderStyle.solid),borderRadius:BorderRadius.circular(20)),
            onPressed: (){
//            updatedata(context);
//             noreqs(center);
            setState(() {
              note=center;
            });
            },
            )
            ],
            ),
    ),),)
    ));
  }
}





