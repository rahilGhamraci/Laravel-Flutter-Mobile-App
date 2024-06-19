import 'package:cahier_de_correspondance/listes_presence.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cahier_de_correspondance/detail_page.dart';

import 'package:cahier_de_correspondance/liste_publications_page.dart';
import 'package:cahier_de_correspondance/models/Devoir.dart';
import 'package:cahier_de_correspondance/models/Support.dart';
import 'package:cahier_de_correspondance/models/Annonce.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'models/User.dart';
import 'providers/annonce_state.dart';
import 'providers/delai_state.dart';
import 'providers/devoir_state.dart';
import 'providers/support_state.dart';
import 'services/api_calls.dart';
class RoomPage extends StatefulWidget {
  final int id;
  final String nom;
  final String prenom;
  final User user;
  const RoomPage({super.key,
  required this.id, required this.nom, required this.prenom,required this.user
  });

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  var arg=Get.arguments;
   List <Annonce>? annonces;
     List <Support>? supports;
     List <Devoir>? devoirs;
     var annoncesIsLoaded=false;
     var supportsIsLoaded=false;
     var devoirsIsLoaded=false;
     var _nom;
     var _prenom;
     var annoncesLength=0;
      var supportsLength=0;
      var devoirsLength=0;
      bool isEnst=true;
     
      
      @override
  void initState(){
     super.initState();
     
     _nom=widget.nom;
     _prenom=widget.prenom;
     getData(widget.id);
    
  }
  getData(int id) async{
        
      var jsonAnnonceBody=  await ApiCalls().get('/annonces_room_page/'+id.toString(),widget.user.token);
      if(jsonAnnonceBody != null){
        annonces=annonceFromJson(jsonAnnonceBody);
     if(annonces!=null){
      setState(() {
        annoncesIsLoaded=true;
        annoncesLength = annonces!.length;
      });
     }else{
      setState(() {
        annoncesLength=0;
         });
      }
        
      }else{
        setState(() {
        annoncesIsLoaded=true;
        annoncesLength = 0;
      });

      }
      
      var jsonSupportBody=  await ApiCalls().get('/supports_room_page/'+id.toString(),widget.user.token);
       if(jsonSupportBody != null){
        supports=supportFromJson(jsonSupportBody);
     if(supports!=null){
      setState(() {
        supportsIsLoaded=true;
        supportsLength = supports!.length;
      });
     }else{
      setState(() {
        supportsLength=0;
         });
      }
       }else{
          setState(() {
        supportsIsLoaded=true;
        supportsLength = 0;
      });

       }
      
     
      var jsonDevoirBody=  await ApiCalls().get('/devoirs_room_page/'+id.toString(),widget.user.token);
       if(jsonDevoirBody != null){
           devoirs=devoirFromJson(jsonDevoirBody);
     if(devoirs!=null){
      setState(() {
        devoirsIsLoaded=true;
        devoirsLength = devoirs!.length; 
      });
     }else{
      setState(() {
        devoirsLength=0;
         });
      }
       }else{
        setState(() {
        devoirsIsLoaded=true;
        devoirsLength = 0; 
      });

       }
   
    

  }

  
  AnnonceState? annonceState;
  SupportState? supportState;
  DevoirState? devoirState;
   DelaiState? delaiState;
  @override
  Widget build(BuildContext context) {
    
    
    final screenHeight=MediaQuery.of(context).size.height;
    final statusBarHeight=MediaQuery.of(context).padding.top;
    
    return StatefulBuilder(
       builder: (context, setState) {
          annonceState = Provider.of<AnnonceState>(context);
          supportState = Provider.of<SupportState>(context);
          devoirState = Provider.of<DevoirState>(context);
          delaiState = Provider.of<DelaiState>(context);
        return  RefreshIndicator(
        onRefresh: () async{
          await getData(widget.id);
        },
        child: Scaffold(
          
          body:SingleChildScrollView(
            scrollDirection: Axis.vertical,   
            child: Container(
              width: double.maxFinite,
              height: screenHeight+statusBarHeight+50,
              //height:double.maxFinite,
              padding: const EdgeInsets.only(top:35, right: 10,left:10,),
              child: Stack(
                children:[Column(
                  children:[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Annonces",style:TextStyle(color:Colors.black,fontSize:20)),
                      InkWell(
                        onTap:()async{ 
                          if(widget.user.status!="Enseignant"){
                             Get.to(ListePublicationsPage(user:widget.user,id:widget.id), arguments:[ "Annonces",widget.nom+" "+widget.prenom]);
                          }else{
                            final newAnnonceList = await Get.to<List<Annonce>>(
                                            () => ListePublicationsPage(
                                              annonces:annonces,
                                              annonceState:annonceState,
                                              user:widget.user,
                                            id:widget.id

                                              
                                              ),
                                            arguments:[ "Annonces",widget.nom+" "+widget.prenom]
                                             );
                                             
                                             setState(() {

                                               annonces=newAnnonceList;
                                             
                                 });

                          }
                         
                          
                          },
                        child: Text("voir plus",style:TextStyle(color:Colors.black,fontSize:16))),
                    ],),
                    SizedBox(height: 10,),
                    Container(
                        width: double.maxFinite,
                        height: 200,
                        //color:Colors.red,
                        child:Visibility(
                          visible:annoncesIsLoaded,
                          child: annoncesLength> 0?ListView.builder(
                            itemCount: annonces?.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder:(BuildContext context,int index){
                              return UnconstrainedBox(
                                child: InkWell(
                                  onTap:(){
                                   
                                     Get.to(DetailPage(date:annonces![index].createdAt??DateTime.now(),user:widget.user,id:annonces![index].id??0,hasFile:['', null].contains(annonces![index].fileName)?false:true,name:annonces![index].enseignantPrenom+" "+annonces![index].enseignantNom ), arguments:["Annonces", annonces![index].titre, annonces![index].contenu,annonces![index].fileName,]);
                                  },
                                  child: Container(
                                    width: 155,
                                    height: 155,
                                    margin: const EdgeInsets.only(bottom:5, right: 10),
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
                                      //mainAxisAlignment:MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                       Row(
                                        children:[
                                          Container(
                                            width:30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color:Colors.white10
                                              ),
                                              child:Center(child: Text(annonces![index].enseignantPrenom[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:12)))
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(annonces![index].enseignantPrenom+" "+annonces![index].enseignantNom,style:TextStyle(color:Colors.black,fontSize:12)),
                                                  Text(DateFormat('dd/MM/yyyy').format(annonces![index].createdAt??DateTime.now()).toString(),style:TextStyle(color:Colors.black54,fontSize:10)),
                                                  ],),
                                                  ]),
                                      SizedBox(height: 5,),
                                      Text(annonces![index].titreResume,style:TextStyle(color:Colors.black,fontSize: 15)),
                                      SizedBox(height: 5,),
                                      Text(annonces![index].contenuResume,style:TextStyle(color:Colors.black54,fontSize: 12)),
                                      SizedBox(height: 5,),
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
                                ),
                              );
                              }
                            
                            ):const Center(child: Text("aucune annonce dans cette room à affichier",style:TextStyle(color:Colors.grey,fontSize:12)),),
                            replacement: const Center(child:CircularProgressIndicator(),),
                        )
                    ),
                     SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Supports",style:TextStyle(color:Colors.black,fontSize:20)),
                      InkWell(
                        onTap:()async{ 
                          if(widget.user.status!="Enseignant"){
                            Get.to(ListePublicationsPage(user:widget.user,id:widget.id), arguments:[ "Supports",widget.nom+" "+widget.prenom]);

                          }else{
                                  final newSupportList = await Get.to<List<Support>>(
                                            () => ListePublicationsPage(
                                              supports:supports,
                                              supportState:supportState,
                                              user:widget.user,
                                            id:widget.id

                                              
                                              ),
                                            arguments:[ "Supports",widget.nom+" "+widget.prenom]
                                             );
                                             
                                             setState(() {

                                               supports=newSupportList;
                                             
                                 });

                          }
                          
                     
                          },
                        child: Text("voir plus",style:TextStyle(color:Colors.black,fontSize:16))),
                    ],),
                    SizedBox(height: 10,),
                    Container(
                        width: double.maxFinite,
                        height: 200,
                        child:Visibility(
                          visible: supportsIsLoaded,
                          child:supportsLength> 0? ListView.builder(
                            itemCount: supports?.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder:(BuildContext context,int index){
                              return UnconstrainedBox(
                                child: InkWell(
                                  onTap:(){

                                     Get.to(DetailPage(date:supports![index].createdAt??DateTime.now(),user:widget.user,id:supports![index].id??0,hasFile:['', null].contains(supports![index].fileName)?false:true,name:supports![index].enseignantPrenom+" "+supports![index].enseignantNom ), arguments:["Supports", supports![index].titre,supports![index].contenu,supports![index].fileName,]);
                                  },
                                  child: Container(
                                    width: 155,
                                    height: 155,
                                    margin: const EdgeInsets.only(bottom:5, right: 10),
                                    padding: const EdgeInsets.only(top:10,left: 10,right: 10),
                                    decoration: BoxDecoration(
                                          borderRadius:BorderRadius.circular(15),
                                        color:Color(0xFFE67F4F),
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
                                              child:Center(child: Text(supports![index].enseignantPrenom[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:12)))
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(supports![index].enseignantPrenom+" "+supports![index].enseignantNom,style:TextStyle(color:Colors.black,fontSize:12)),
                                                  Text(DateFormat('dd/MM/yyyy').format(supports![index].createdAt??DateTime.now()).toString(),style:TextStyle(color:Colors.black54,fontSize:10)),
                                                  ],),
                                                  ]),
                                      SizedBox(height: 5,),
                                      Text(supports![index].titreResume,style:TextStyle(color:Colors.black,fontSize: 15)),
                                      SizedBox(height: 5,),
                                      Text(supports![index].contenuResume,style:TextStyle(color:Colors.black54,fontSize: 12)),
                                      SizedBox(height: 5,),
                                      Visibility(
                                        visible:!['', null].contains(supports![index].fileName),
                                        child: Row(children: [
                                          Icon(Icons.attach_file,size: 13,),
                                          SizedBox(width: 5,),
                                           Text("pièce jointe",style:TextStyle(color:Colors.black54,fontSize:10)),
                                        ],),
                                      ),
                                    ],),
                                      
                                  ),
                                ),
                              );
                              }
                            
                            ):const Center(child: Text("aucun support dans cette room à affichier",style:TextStyle(color:Colors.grey,fontSize:12)),),
                            replacement:const Center(child: CircularProgressIndicator()),
                        )
                    ),
                     SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Devoirs",style:TextStyle(color:Colors.black,fontSize:20)),
                       InkWell(
                        onTap:()async{ 
                          if(widget.user.status!="Enseignant"){
                            Get.to(ListePublicationsPage(user:widget.user,id:widget.id), arguments:[ "Devoirs",widget.nom+" "+widget.prenom]);

                          }else{
                            final newDevoirList = await Get.to<List<Devoir>>(
                                            () => ListePublicationsPage(
                                              devoirs:devoirs,
                                              devoirState:devoirState,
                                              user:widget.user,
                                            id:widget.id

                                              
                                              ),
                                            arguments:[ "Devoirs",widget.nom+" "+widget.prenom]
                                             );
                                             
                                             setState(() {

                                               devoirs=newDevoirList;
                                             
                                 });

                          }
                          
                           
                          },
                        child: Text("voir plus",style:TextStyle(color:Colors.black,fontSize:16))),
                    ],),
                    SizedBox(height: 10,),
                    Container(
                        width: double.maxFinite,
                        height: 200,
                        child:Visibility(
                          visible: devoirsIsLoaded,
                          child: devoirsLength>0?ListView.builder(
                            itemCount: devoirs?.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder:(BuildContext context,int index){
                              return UnconstrainedBox(
                                child: InkWell(
                                   onTap:()async{
                                    print(devoirs![index].delai);
                                     final newDelai = await Get.to<bool>(
                                                () =>DetailPage(
                                                  delaiState: delaiState,
                                                  delai:devoirs![index].delai,
                                                  date:devoirs![index].createdAt?? DateTime.now(),
                                                  user:widget.user,
                                                  id:devoirs![index].id??0,
                                                  hasFile:['', null].contains(devoirs![index].fileName)?false:true,
                                                  name:devoirs![index].enseignantPrenom+" "+devoirs![index].enseignantNom,
                                                  ),
                                                arguments: ["Devoirs",devoirs![index].titre,devoirs![index].contenu,devoirs![index].fileName,devoirs![index].enseignantPrenom+" "+devoirs![index].enseignantNom],
                                                 );
                                                 //if (mounted) {}
                                                 setState(() {
                                                  devoirs![index].delai=newDelai!;
                                                 });
                                      
                                        // Get.to(DetailPage(delai:devoirs![index].delai,date:devoirs![index].createdAt??DateTime.now(),user:widget.user,id:devoirs![index].id??0,hasFile:['', null].contains(devoirs![index].fileName)?false:true ,name:devoirs![index].enseignantPrenom+" "+devoirs![index].enseignantNom), arguments:[ "Devoirs",devoirs![index].titre,devoirs![index].contenu,devoirs![index].fileName,]);

                                       
                                    
                                  },
                                  child: Container(
                                    width: 155,
                                    height: 155,
                                    margin: const EdgeInsets.only(bottom:5, right: 10),
                                    padding: const EdgeInsets.only(top:10,left: 10,right: 10),
                                    decoration: BoxDecoration(
                                          borderRadius:BorderRadius.circular(15),
                                        color:Color(0xFF33548A),
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
                                              child:Center(child: Text(devoirs![index].enseignantPrenom[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:12)))
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(devoirs![index].enseignantPrenom+" "+devoirs![index].enseignantNom,style:TextStyle(color:Colors.black,fontSize:12)),
                                                  Text(DateFormat('dd/MM/yyyy').format(devoirs![index].createdAt??DateTime.now()).toString(),style:TextStyle(color:Colors.black54,fontSize:10)),
                                                  ],),
                                                  ]),
                                      SizedBox(height: 5,),
                                      Text(devoirs![index].titreResume,style:TextStyle(color:Colors.black,fontSize: 15)),
                                      SizedBox(height: 5,),
                                      Text(devoirs![index].contenuResume,style:TextStyle(color:Colors.black54,fontSize: 12)),
                                      SizedBox(height: 5,),
                                      Visibility(
                                        visible:!['', null].contains(devoirs![index].fileName),
                                        child: Row(children: [
                                          Icon(Icons.attach_file,size: 13,),
                                          SizedBox(width: 5,),
                                           Text("pièce jointe",style:TextStyle(color:Colors.black54,fontSize:10)),
                                        ],),
                                      ),
                                    ],),
                                      
                                  ),
                                ),
                              );
                              }
                            
                            ):const Center(child: Text("aucun devoir dans cette room à affichier",style:TextStyle(color:Colors.grey,fontSize:12)),),
                            replacement: const Center(child: CircularProgressIndicator()),
                        ),
                    ),
                  ]
                ),
               ]
              ),
            ),
          ),
        ),
      );}
    );
  }
}