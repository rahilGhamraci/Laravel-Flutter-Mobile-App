import 'package:cahier_de_correspondance/models/User.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cahier_de_correspondance/models/Room.dart';
import 'package:cahier_de_correspondance/room_page.dart';
import 'package:cahier_de_correspondance/second_main_page.dart';

import 'services/api_calls.dart';
class Rooms extends StatefulWidget {
  final User user;
  int? idElv;
  Rooms({super.key,
  required this.user,this.idElv});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  List<Room>? rooms;
 
  bool isLoaded=false;
   @override
  void initState(){
     super.initState();
     getData();
  }
  getData() async{
    if(widget.user.status=="Enseignant"){
      var jsonResponseBody=  await ApiCalls().get('/enst_rooms',widget.user.token);
      if(jsonResponseBody != null){
            rooms=roomFromJson(jsonResponseBody);
     if(rooms!=null){
      setState(() {
        isLoaded=true;
      });
     }

      }else{
         setState(() {
        isLoaded=true;
      });

      }
  
     }else  if(widget.user.status=="Eleve"){
      var jsonResponseBody=  await ApiCalls().get('/elv_rooms',widget.user.token);
        if(jsonResponseBody != null){
            rooms=roomFromJson(jsonResponseBody);
     if(rooms!=null){
      setState(() {
        isLoaded=true;
      });
     }
        }else{
           setState(() {
        isLoaded=true;
      });

        }
    
     }else  if(widget.user.status=="Tuteur"){
      var jsonResponseBody=  await ApiCalls().get('/tuteur_rooms/'+widget.idElv.toString(),widget.user.token);
       if(jsonResponseBody != null){
          rooms=roomFromJson(jsonResponseBody);
     if(rooms!=null){
      setState(() {
        isLoaded=true;
      });
     }
       }else{
           setState(() {
        isLoaded=true;
      });

       }
    
     }

  }
  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.only(top:20),
        child: Visibility(
          visible: isLoaded,
          child: ListView.builder(
            itemCount: rooms?.length,
            itemBuilder: (BuildContext context,int index){
              return InkWell(
                onTap:(){ 
                  print(rooms![index].id);
                  Get.to(SecondMainPage(user:widget.user,id:rooms![index].id,nom:rooms![index].nom,prenom: rooms![index].prenom,), arguments:[ rooms![index].niveau+" ,"+"Section "+rooms![index].section,rooms![index].id]);},
                child: Container(
                  width:screenWidth-40 ,
                  height: 100,
                  margin: const EdgeInsets.only(bottom:10, right: 20,left:20),
                  padding: const EdgeInsets.only(top:20,left: 10,right: 10),
                 decoration: BoxDecoration(
                 borderRadius:BorderRadius.circular(15),
                    color:Color(0xFF789DC9),
                     image: DecorationImage(
                    image:AssetImage("assets/Capture.PNG"),
                    fit:BoxFit.fill
                     ),        
                    boxShadow: [
                    BoxShadow(
                      blurRadius:10,
                                        offset:Offset(5,9) ,
                                        color: Colors.black.withOpacity(0.5)
                                        ),]
                                      ),
                   child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:CrossAxisAlignment.end,
                    children: [
                     
                      Column(
                        
                        children: [
                          Text(rooms![index].niveau+","+"Section "+rooms![index].section,style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold,fontSize:16)),
                          Text(rooms![index].nom+" "+rooms![index].prenom,style:TextStyle(color:Colors.black,fontSize:14)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.end,
                        children: [
                          Text(rooms![index].matiere,style:TextStyle(color:Color(0xFF33548A),fontSize:14)),
                        ],
                      ),
                      SizedBox(height: 10,)
              
                    ],
                   ),
                ),
              );
            }),
            replacement: const Center(child: CircularProgressIndicator()),
        ),
      )
    );
  }
}