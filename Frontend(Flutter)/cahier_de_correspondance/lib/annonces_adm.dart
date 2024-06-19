import 'package:cahier_de_correspondance/services/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'detail_page.dart';
import 'models/AnnonceAdmin.dart';
import 'models/User.dart';

class AnnoncesAdm extends StatefulWidget {
  final int id;
  final User user;
  const AnnoncesAdm({super.key,required this.id,required this.user});

  @override
  State<AnnoncesAdm> createState() => _AnnoncesAdmState();
}

class _AnnoncesAdmState extends State<AnnoncesAdm> {

  List<AnnonceAdministrative>? annonces;
  int annoncesLength=0;
  bool annoncesAreLoaded=false;
        @override
  void initState(){
     super.initState();
    
     getData();
    
  }
 getData()async{
  var jsonResponseBody=  await ApiCalls().get('/annonces_administratives_index/'+widget.id.toString(),widget.user.token);
    if(jsonResponseBody != null){
   annonces=annonceAdministrativeFromJson(jsonResponseBody);
     if(annonces!=null){
      print("hgf");
      setState(() {
        annoncesAreLoaded=true;
        annoncesLength=annonces!.length;
      });
     }else{
       setState(() {
        annoncesAreLoaded=true;
        annoncesLength=0;
      });

     }
 }
 }
  @override
  Widget build(BuildContext context) {
     final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body:Column(
        children: [
          SizedBox(height: 30,),
          Expanded(
            child: Visibility(
              visible:annoncesAreLoaded,
              child: ListView.builder(
                itemCount:annoncesLength,
                itemBuilder: (BuildContext context,int index){
                  return InkWell(
                            onTap:(){          
                                               Get.to(DetailPage(date:annonces![index].createdAt,user:widget.user,id:annonces![index].id,hasFile:['', null].contains(annonces![index].fileName)?false:true ), arguments:["Annonces Administratives", annonces![index].titre ,annonces![index].contenu,annonces![index].fileName,]);
                                           
                                            },
                            child: Container(
                                                width: screenWidth,
                                                height: 140,
                                                margin: const EdgeInsets.only(bottom:10, right: 20,left:20),
                                                padding: const EdgeInsets.only(top:10,left: 10,right: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:BorderRadius.circular(15),
                                                    color:Color(0xFF789DC9),
                                                   
                                                    boxShadow: [
                                                    BoxShadow(
                                                    blurRadius:10,
                                                    offset:Offset(5,9) ,
                                                    color: Colors.black.withOpacity(0.5)
                                                    ),]
                                                  ),
                                                child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                   
                                                   Row(
                                                children:[
                                                  Container(
                                                    width:30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      color:Colors.white10,
                                                      ),
                                                      child:Center(child: Text("A",style:TextStyle(color:Colors.black,fontSize:12)))
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Administration",style:TextStyle(color:Colors.black,fontSize:12)),
                                                          Text(DateFormat('dd/MM/yyyy').format(annonces![index].createdAt).toString(),style:TextStyle(color:Colors.black54,fontSize:10)),
                                                          ],),
                                                         
                              
                                                          ]),
                                              SizedBox(height: 5,),
                                                  Text(annonces![index].titre,style:TextStyle(color:Colors.black,fontSize: 15)),
                                                  SizedBox(height: 5,),
                                                  Text(annonces![index].contenuResume,style:TextStyle(color:Colors.black54,fontSize: 12)),
                                                   SizedBox(height: 10,),
                                                   Visibility(
                                                    visible:!['', null].contains(annonces![index].fileName),
                                                    child: Row(children: [
                                                    Icon(Icons.attach_file,size: 13,),
                                                    SizedBox(width: 5,),
                                                     Text("pièce jointe",style:TextStyle(color:Colors.black54,fontSize:10)),
                                                  ],),
                                                ),
                                                ],),
                                                  
                                              ),
                          );
                }),
                 replacement: const Center(child:CircularProgressIndicator(),),
            ),
          ),
        ],
      )
    );
  }
}