import 'package:cahier_de_correspondance/providers/delai_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cahier_de_correspondance/detail_page.dart';
import 'package:cahier_de_correspondance/models/Devoir.dart';
import 'package:cahier_de_correspondance/models/Support.dart';
import 'package:cahier_de_correspondance/services/api_calls.dart';
import 'package:cahier_de_correspondance/post_form.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models/Annonce.dart';
import 'models/User.dart';
import 'providers/annonce_state.dart';
import 'providers/devoir_state.dart';
import 'providers/support_state.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';


class ListePublicationsPage extends StatefulWidget {

  final int id;
  final User user;
  List<Annonce>? annonces;
    AnnonceState? annonceState;
    List<Support>? supports;
    SupportState? supportState;
    List<Devoir>? devoirs;
    DevoirState? devoirState;
  ListePublicationsPage({super.key,
  this.annonces,this.annonceState,this.supports,this.supportState,this.devoirs,this.devoirState,
  required this.id,
  required this.user,
  });

  @override
  State<ListePublicationsPage> createState() => _ListePublicationsPageState();
}

class _ListePublicationsPageState extends State<ListePublicationsPage> {
   var arg=Get.arguments;
   
     get color => color;
     List <Annonce>? annonces;
     List <Annonce>? foundAnnonces;
     List <Support>? supports;
     List <Support>? foundSupports;
     List <Devoir>? devoirs;
     List <Devoir>? foundDevoirs;
     var isLoaded=false;
     int foundAnnoncesLength=0;
      int foundSupportsLength=0;
       int foundDevoirsLength=0;
       bool isTextFieldUsed = false;
       bool backButtonPressed = false;
      
   
     
  @override
  void initState(){
     super.initState();
       //_isMounted = true;
     getData(widget.id);
      BackButtonInterceptor.add(backButtonInterceptor);
    
  }
  @override
  void dispose() {
    
    BackButtonInterceptor.remove(backButtonInterceptor);
    super.dispose();
  }

bool backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // Set the flag to indicate that the back button was pressed
    backButtonPressed = true;
    return false;
  }


   
  getData(int id) async{
     if("${arg[0]}"=="Annonces"){
      var jsonResponseBody=  await ApiCalls().get('/annonces_room/'+id.toString(),widget.user.token);
      if (jsonResponseBody != null) {
  annonces = annonceFromJson(jsonResponseBody);
  setState(() {
    isLoaded = true;
    foundAnnoncesLength = annonces!.length;
    foundAnnonces = List<Annonce>.from(annonces!);
  });
}else{
  setState(() {
    isLoaded = true;
    foundAnnoncesLength = 0;
    foundAnnonces = [];
  });

}
     }else  if("${arg[0]}"=="Supports"){
      var jsonResponseBody=  await ApiCalls().get('/supports_room/'+id.toString(),widget.user.token);
      if (jsonResponseBody != null) {
         supports=supportFromJson(jsonResponseBody);
     if(supports!=null){
    
         setState(() {
        isLoaded=true;
        foundSupportsLength=supports!.length;
          foundSupports=List<Support>.from(supports!);
      });
       
     
     }
      }else{
         setState(() {
        isLoaded=true;
        foundSupportsLength=0;
          foundSupports=[];
      });

      }
     
     }else  if("${arg[0]}"=="Devoirs"){
      var jsonResponseBody=  await ApiCalls().get('/devoirs_room/'+id.toString(),widget.user.token);
       if (jsonResponseBody != null) {
         devoirs=devoirFromJson(jsonResponseBody);
     if(devoirs!=null){
      setState(() {
        isLoaded=true;
        foundDevoirsLength=devoirs!.length;
          foundDevoirs=List<Devoir>.from(devoirs!);
      });
     }
       }else{
        setState(() {
        isLoaded=true;
        foundDevoirsLength=0;
          foundDevoirs=[];
      });

       }
     
     }

  }
  void Filtre(String enteredKeyWord){
   
    if(enteredKeyWord.isEmpty){
         if("${arg[0]}"=="Annonces"){
          setState(() {
              foundAnnonces = List<Annonce>.from(annonces!);
              foundAnnoncesLength=annonces!.length;
          });
         
         }else if("${arg[0]}"=="Supports"){
          setState(() {
             foundSupports=List<Support>.from(supports!);
              foundSupportsLength=supports!.length;
          });
          
         }else{
          setState(() {
              foundDevoirs=List<Devoir>.from(devoirs!);
                 foundDevoirsLength=devoirs!.length;
          });
          

         }
    }else{
      if("${arg[0]}"=="Annonces"){
          setState(() {
             foundAnnonces=annonces!.where((element) => element.titre.contains(enteredKeyWord)).toList();
             foundAnnoncesLength=foundAnnonces!.length;
          });
        
         }else if("${arg[0]}"=="Supports"){
          setState(() {
               foundSupports=supports!.where((element) => element.titre.contains(enteredKeyWord)).toList();
                 foundSupportsLength=foundSupports!.length;
          });
        
         }else{
          setState(() {
             foundDevoirs=devoirs!.where((element) => element.titre.contains(enteredKeyWord)).toList();
               foundDevoirsLength=foundDevoirs!.length;
          });
           

         }
      
    }
  }
   Future<int> deletePublication(int id) async {
    var statusCode;
    if("${arg[0]}"=="Annonces"){
       statusCode=statusCode=  await ApiCalls().delete('/annonces/'+id.toString(),widget.user.token);
    }else if("${arg[0]}"=="Supports"){
       statusCode=statusCode=  await ApiCalls().delete('/supports/'+id.toString(),widget.user.token);
    }else{
       statusCode=statusCode=  await ApiCalls().delete('/devoirs/'+id.toString(),widget.user.token);
    }
    
     
   
     return statusCode;
  }
  AnnonceState? annonceState;
  SupportState? supportState;
  DevoirState? devoirState;
  DelaiState ? delaiState;
  @override
  Widget build(BuildContext context) {
   
    final screenWidth=MediaQuery.of(context).size.width;
    return  WillPopScope(
      onWillPop: () async {
        print("vhjcvxh");
         if (backButtonPressed) {
          print("button pressed");
          backButtonPressed = false; // Reset the flag
          setState(() {});
             print(widget.user.status);
          if (widget.user.status == "Enseignant") {
              print("enst");
            if ("${arg[0]}" == "Annonces") {
              print("ann");
              if (annonces != null) {
              if (annonces!.length <= 5) {
                widget.annonceState!.annonces = annonces!;
                widget.annonces = annonces!;
              } else {
                widget.annonceState!.annonces = annonces!.sublist(0, 5);
                widget.annonces = annonces!.sublist(0, 5);
              }
              print("Navigating back with annonces: ${widget.annonces}");
              Navigator.of(context).pop(widget.annonces);
            } else {
              print("Annonces list is null");
            }
            } else if ("${arg[0]}" == "Supports") {
              if (supports!.length <= 5) {
                widget.supportState!.supports = supports!;
                widget.supports = supports;
              } else {
                widget.supportState!.supports = supports!.sublist(0, 5);
                widget.supports = supports!.sublist(0, 5);
              }
              Navigator.of(context).pop(widget.supports);
            } else if ("${arg[0]}" == "Devoirs") {
              if (devoirs!.length <= 5) {
                widget.devoirState!.devoirs = devoirs!;
                widget.devoirs = devoirs!;
              } else {
                widget.devoirState!.devoirs = devoirs!.sublist(0, 5);
                widget.devoirs = devoirs!.sublist(0, 5);
              }
              Navigator.of(context).pop(widget.devoirs);
            }
          } else {
            Get.back();
          }

          return false; // Prevent the default back button behavior
        }

        return true;
      },
      child: StatefulBuilder(
          builder: (context, setState) {
            if("${arg[0]}"=="Annonces"){
                 annonceState = Provider.of<AnnonceState>(context);
            }else if("${arg[0]}"=="Supports"){
                 supportState = Provider.of<SupportState>(context);
            }else if("${arg[0]}"=="Devoirs"){
                  devoirState = Provider.of<DevoirState>(context);
                  delaiState = Provider.of<DelaiState>(context);
      
            }
          
      
            return  RefreshIndicator(
            onRefresh: () async{
              await getData(widget.id);
            },
            child: Scaffold(
              body:Column(children:[
               SizedBox(height: 30,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                IconButton(icon:Icon(Icons.arrow_back_ios,color:Colors.black),onPressed:(){
                           if(widget.user.status=="Enseignant"){
                            if("${arg[0]}"=="Annonces"){
                              print("hgh");
                               if(annonces!.length<=5){
                                                        widget.annonceState!.annonces=annonces!;
                                                    widget.annonces=annonces!;
    
                                                   }else{
                                                        widget.annonceState!.annonces=annonces!.sublist(0,5);
                                                    widget.annonces=annonces!.sublist(0,5);
    
                                                   }
                               Navigator.of(context).pop(widget.annonces);
                            } if("${arg[0]}"=="Supports"){
                               if(supports!.length<=5){
                                                     widget.supportState!.supports=supports!;
                                                    widget.supports=supports;
    
                                                   }else{
                                                     widget.supportState!.supports=supports!.sublist(0,5);
                                                    widget.supports=supports!.sublist(0,5);
             
                                                   }
                               Navigator.of(context).pop(widget.supports);
                            }else if("${arg[0]}"=="Devoirs"){
                                if(devoirs!.length<=5){
                                                     widget.devoirState!.devoirs=devoirs!;
                                                    widget.devoirs=devoirs!;
    
                                                   }else{
                                                     widget.devoirState!.devoirs=devoirs!.sublist(0,5);
                                                    widget.devoirs=devoirs!.sublist(0,5);
                                                   }
                               Navigator.of(context).pop(widget.devoirs);
                            }
                           
                           }else{
                            Get.back();
                           }   
                            
                }),
                Text("${arg[0]}",style:TextStyle(color:Colors.black,fontSize:16,fontWeight: FontWeight.bold)),
                Container(
                            margin: const EdgeInsets.only(top:5, right: 10,bottom: 5,left:10),
                            width:40,
                            height: 40,
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color:Color(0xFF33548A)
                           ),
                           child:Center(child: Text(widget.user.name[0].toUpperCase(),style:TextStyle(color:Colors.white,fontSize:16)))
                          ),
               ]),
               SizedBox(height: 10,),
               Padding(
                padding:EdgeInsets.only(left:10,right:10),
                 child: TextField(
                  onChanged:(value){
                     setState(() {
          isTextFieldUsed = true;
        });
        Filtre(value);
                  } ,
                  decoration: InputDecoration(
                    labelText:'Rehcercher',suffixIcon:Icon(Icons.search)
                  ),
                 ),
               ),
               SizedBox(height: 10,),
               Expanded(
                 child: Stack(
                   children:[Visibility(
                     visible: isLoaded,
                     child: ListView.builder(
                      itemCount: "${arg[0]}"=="Annonces"?foundAnnoncesLength:"${arg[0]}"=="Supports"?foundSupportsLength:foundDevoirsLength,
                     itemBuilder: (BuildContext context,int index){
                      return widget.user.status=="Enseignant"?Dismissible(
                        key:Key("${arg[0]}"=="Annonces"?foundAnnonces![index].id.toString():"${arg[0]}"=="Supports"?foundSupports![index].id.toString():foundDevoirs![index].id.toString()),
                        background: Container(
                              alignment:AlignmentDirectional.centerEnd,
                              color:Colors.red,
                              child: Icon(Icons.delete,color:Colors.white), ),
                              onDismissed: (direction)async{
                                if("${arg[0]}"=="Annonces"){
                                   int x=await deletePublication(foundAnnonces![index].id??0);
                                 print(x);
                                  if(x==200){
                                setState(() {
                                 
                                      final foundIndex = annonces!.indexOf(foundAnnonces![index]);
                                      annonces!.removeAt(foundIndex);
                                      foundAnnonces!.removeAt(index);
                                      foundAnnoncesLength=foundAnnoncesLength-1;
                                             
                                           
                                      
                                         if(annonces!.length<=5){
                                                        widget.annonceState!.annonces=annonces!;
                                                    widget.annonces=annonces!;
    
                                                   }else{
                                                        widget.annonceState!.annonces=annonces!.sublist(0,5);
                                                    widget.annonces=annonces!.sublist(0,5);
    
                                                   }
                                    
                                 });
                                  }
        
                                }else if ("${arg[0]}"=="Supports"){
                                   int x=await deletePublication(foundSupports![index].id??0);
                                 print(x);
                                  if(x==200){
                                setState(() {
                                   final index1 = supports!.indexWhere((c) => c.id == foundSupports![index].id);
                                      
                                      
                                         supports!.removeAt(index1);
                                         foundSupports!.removeAt(index);
                                         foundSupportsLength=foundSupportsLength-1;
                                      
                                        
                                       if(supports!.length<=5){
                                                     widget.supportState!.supports=supports!;
                                                    widget.supports=supports;
    
                                                   }else{
                                                     widget.supportState!.supports=supports!.sublist(0,5);
                                                    widget.supports=supports!.sublist(0,5);
             
                                                   }
                                    
                                 });
                                  }
                                  
        
                                }else if ("${arg[0]}"=="Devoirs"){
                                   int x=await deletePublication(foundDevoirs![index].id??0);
                                 print(x);
                                  if(x==200){
                                setState(() {
                                   final index1 = devoirs!.indexWhere((c) => c.id == foundDevoirs![index].id);
                                 
                                      
                                           devoirs!.removeAt(index1);
                                           foundDevoirs!.removeAt(index);
                                           foundDevoirsLength=foundDevoirs!.length;
    
                                     
                                    if(devoirs!.length<=5){
                                                     widget.devoirState!.devoirs=devoirs!;
                                                    widget.devoirs=devoirs!;
    
                                                   }else{
                                                     widget.devoirState!.devoirs=devoirs!.sublist(0,5);
                                                    widget.devoirs=devoirs!.sublist(0,5);
                                                   }
                                   
                                 });
                                  }
        
                                }
                                
                              },
                              direction:DismissDirection.endToStart,
                              child: InkWell(
                        onTap:()async{          if("${arg[0]}"=="Devoirs" ){
                           final newDelai = await Get.to<bool>(
                                                () =>DetailPage(
                                                  delaiState: delaiState,
                                                  delai:foundDevoirs![index].delai,
                                                  date:foundDevoirs![index].createdAt?? DateTime.now(),
                                                  user:widget.user,
                                                  id:foundDevoirs![index].id??0,
                                                  hasFile:['', null].contains(foundDevoirs![index].fileName)?false:true,
                                                  name:foundDevoirs![index].enseignantPrenom+" "+foundDevoirs![index].enseignantNom,
                                                  ),
                                                arguments: ["${arg[0]}",foundDevoirs![index].titre,foundDevoirs![index].contenu,foundDevoirs![index].fileName,foundDevoirs![index].enseignantPrenom+" "+foundDevoirs![index].enseignantNom],
                                                 );
                                                 //if (mounted) {}
                                                 setState(() {
                                                  foundDevoirs![index].delai=newDelai!;
                                                 });
                                   
                        }else{
                                Get.to(DetailPage(date:("${arg[0]}"=="Annonces"?foundAnnonces![index].createdAt:"${arg[0]}"=="Supports"?foundSupports![index].createdAt:foundDevoirs![index].createdAt)??DateTime.now(),user:widget.user,id: "${arg[0]}"=="Annonces"?foundAnnonces![index].id??0:"${arg[0]}"=="Supports"?foundSupports![index].id??0:foundDevoirs![index].id??0 ,hasFile:['', null].contains("${arg[0]}"=="Annonces"?foundAnnonces![index].fileName:"${arg[0]}"=="Supports"?foundSupports![index].fileName:foundDevoirs![index].fileName)?false:true,name:"${arg[0]}"=="Annonces"?foundAnnonces![index].enseignantPrenom+" "+foundAnnonces![index].enseignantNom:"${arg[0]}"=="Supports"?foundSupports![index].enseignantPrenom+" "+foundSupports![index].enseignantNom:foundDevoirs![index].enseignantPrenom+" "+foundDevoirs![index].enseignantNom ), arguments:["${arg[0]}", "${arg[0]}"=="Annonces"?foundAnnonces![index].titre:"${arg[0]}"=="Supports"?foundSupports![index].titre:foundDevoirs![index].titre ,"${arg[0]}"=="Annonces"?foundAnnonces![index].contenu:"${arg[0]}"=="Supports"?foundSupports![index].contenu:foundDevoirs![index].contenu,"${arg[0]}"=="Annonces"?foundAnnonces![index].fileName:"${arg[0]}"=="Supports"?foundSupports![index].fileName:foundDevoirs![index].fileName,"${arg[0]}"=="Annonces"?foundAnnonces![index].enseignantPrenom+" "+foundAnnonces![index].enseignantNom:"${arg[0]}"=="Supports"?foundSupports![index].enseignantPrenom+" "+foundSupports![index].enseignantNom:foundDevoirs![index].enseignantPrenom+" "+foundDevoirs![index].enseignantNom]);
                        }
                                          
                                        },
                        child: Container(
                                            width: screenWidth-40,
                                            height: 140,
                                            margin: const EdgeInsets.only(bottom:10, right: 20,left:20),
                                            padding: const EdgeInsets.only(top:5,left: 10,right: 10),
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
                                                      child:Center(child: Text("${arg[0]}"=="Annonces"?foundAnnonces![index].enseignantPrenom[0].toUpperCase():"${arg[0]}"=="Supports"?foundSupports![index].enseignantPrenom[0].toUpperCase():foundDevoirs![index].enseignantPrenom[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:12)))
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("${arg[0]}"=="Annonces"?foundAnnonces![index].enseignantPrenom+" "+foundAnnonces![index].enseignantNom:"${arg[0]}"=="Supports"?foundSupports![index].enseignantPrenom+" "+foundSupports![index].enseignantNom:foundDevoirs![index].enseignantPrenom+" "+foundDevoirs![index].enseignantNom,style:TextStyle(color:Colors.black,fontSize:12)),
                                                          Text(DateFormat('dd/MM/yyyy').format(("${arg[0]}"=="Annonces"?annonces![index].createdAt:"${arg[0]}"=="Supports"?supports![index].createdAt:devoirs![index].createdAt)??DateTime.now()).toString(),style:TextStyle(color:Colors.black54,fontSize:10)),
                                                          ],),
                                                          Expanded(child:Container()),
                                               IconButton(onPressed:()async{ 
                                                //Get.to(PostForm(user:widget.user,operation:"Update",id:"${arg[0]}"=="Annonces"?annonces![index].id:"${arg[0]}"=="Supports"?supports![index].id:devoirs![index].id), arguments:["${arg[0]}",]);
                                                if("${arg[0]}"=="Annonces"){
                                                  final newAnnonceList = await Get.to<List<Annonce>>(
                                                () => PostForm(
                                                  annonces:foundAnnonces,
                                                  annonceState:annonceState,
                                                  operation:"Update",
                                                  user:widget.user,
                                                  id:foundAnnonces![index].id,
      
                                                  
                                                  ),
                                                arguments:["${arg[0]}",foundAnnonces![index].titre,foundAnnonces![index].contenu]
                                                 );
                                                 
                                                 setState(() {
                                                   foundAnnonces!=newAnnonceList;
                                                   final index1 = annonces!.indexWhere((c) => c.id == foundAnnonces![index].id);
                                                   annonces![index1]=foundAnnonces![index];
                                                   if(annonces!.length<=5){
                                                        widget.annonceState!.annonces=annonces!;
                                                        widget.annonces=annonces!;
    
                                                   }else{
                                                        widget.annonceState!.annonces=annonces!.sublist(0,5);
                                                    widget.annonces=annonces!.sublist(0,5);
    
                                                   }
                                              
                                                 
                                     });
      
                                                }else if("${arg[0]}"=="Supports"){
                                                  final newSupportList = await Get.to<List<Support>>(
                                                () => PostForm(
                                                  supports:foundSupports,
                                                  supportState:supportState,
                                                  operation:"Update",
                                                  user:widget.user,
                                                  id:foundSupports![index].id,
      
                                                  
                                                  ),
                                                arguments:["${arg[0]}",foundSupports![index].titre,foundSupports![index].contenu]
                                                 );
                                                 setState(() {
                                                  
                                                  //supports!=newSupportList;
                                                  foundSupports!=newSupportList;
                                                   final index1 = supports!.indexWhere((c) => c.id == foundSupports![index].id);
                                                   supports![index1]=foundSupports![index];
                                                   if(supports!.length<=5){
                                                     widget.supportState!.supports=supports!;
                                                    widget.supports=supports;
    
                                                   }else{
                                                     widget.supportState!.supports=supports!.sublist(0,5);
                                                    widget.supports=supports!.sublist(0,5);
             
                                                   }
                                                    
                                     });
      
                                                }else if("${arg[0]}"=="Devoirs"){
                                                  final newDevoirList = await Get.to<List<Devoir>>(
                                                () => PostForm(
                                                  devoirs:foundDevoirs,
                                                  devoirState:devoirState,
                                                  operation:"Update",
                                                  user:widget.user,
                                                  id:foundDevoirs![index].id,
      
                                                  
                                                  ),
                                                arguments:["${arg[0]}",foundDevoirs![index].titre,foundDevoirs![index].contenu]
                                                 );
                                                 setState(() {
                                                  
                                                   //devoirs!=newDevoirList;
                                                   foundDevoirs!=newDevoirList;
                                                   final index1 = devoirs!.indexWhere((c) => c.id == foundDevoirs![index].id);
                                                   devoirs![index1]=foundDevoirs![index];
                                                   if(devoirs!.length<=5){
                                                     widget.devoirState!.devoirs=devoirs!;
                                                    widget.devoirs=devoirs!;
    
                                                   }else{
                                                     widget.devoirState!.devoirs=devoirs!.sublist(0,5);
                                                    widget.devoirs=devoirs!.sublist(0,5);
                                                   }
                                                    
                                     });
                                                  
                                                }
                                                }, icon: Icon(Icons.change_circle,size:20,color:Colors.white54))
                              
                                                          ]),
                                             // SizedBox(height: 5,),
                                              Text("${arg[0]}"=="Annonces"?foundAnnonces![index].titreResume:"${arg[0]}"=="Supports"?foundSupports![index].titreResume:foundDevoirs![index].titreResume,style:TextStyle(color:Colors.black,fontSize: 15)),
                                              SizedBox(height: 5,),
                                              Text("${arg[0]}"=="Annonces"?foundAnnonces![index].contenuResume:"${arg[0]}"=="Supports"?foundSupports![index].contenuResume:foundDevoirs![index].contenuResume,style:TextStyle(color:Colors.black54,fontSize: 12)),
                                               SizedBox(height: 5,),
                                               Visibility(
                                                visible:!['', null].contains("${arg[0]}"=="Annonces"?foundAnnonces![index].fileName:"${arg[0]}"=="Supports"?foundSupports![index].fileName:foundDevoirs![index].fileName),
                                                child: Row(children: [
                                                Icon(Icons.attach_file,size: 13,),
                                                SizedBox(width: 5,),
                                                 Text("pièce jointe",style:TextStyle(color:Colors.black54,fontSize:10)),
                                              ],),
                                            ),
                                            ],),
                                              
                                          ),
                      ),
                      ):InkWell(
                        onTap:(){          if("${arg[0]}"=="Devoirs"){
                           Get.to(DetailPage(delai:foundDevoirs![index].delai,date:("${arg[0]}"=="Annonces"?foundAnnonces![index].createdAt:"${arg[0]}"=="Supports"?foundSupports![index].createdAt:foundDevoirs![index].createdAt)??DateTime.now(),user:widget.user,id: "${arg[0]}"=="Annonces"?foundAnnonces![index].id??0:"${arg[0]}"=="Supports"?foundSupports![index].id??0:foundDevoirs![index].id??0 ,hasFile:['', null].contains("${arg[0]}"=="Annonces"?foundAnnonces![index].fileName:"${arg[0]}"=="Supports"?foundSupports![index].fileName:foundDevoirs![index].fileName)?false:true,name:"${arg[0]}"=="Annonces"?foundAnnonces![index].enseignantPrenom+" "+foundAnnonces![index].enseignantNom:"${arg[0]}"=="Supports"?foundSupports![index].enseignantPrenom+" "+foundSupports![index].enseignantNom:foundDevoirs![index].enseignantPrenom+" "+foundDevoirs![index].enseignantNom ), arguments:["${arg[0]}", "${arg[0]}"=="Annonces"?foundAnnonces![index].titre:"${arg[0]}"=="Supports"?foundSupports![index].titre:foundDevoirs![index].titre ,"${arg[0]}"=="Annonces"?foundAnnonces![index].contenu:"${arg[0]}"=="Supports"?foundSupports![index].contenu:foundDevoirs![index].contenu,"${arg[0]}"=="Annonces"?foundAnnonces![index].fileName:"${arg[0]}"=="Supports"?foundSupports![index].fileName:foundDevoirs![index].fileName,]);
                        }else{
                            Get.to(DetailPage(date:("${arg[0]}"=="Annonces"?foundAnnonces![index].createdAt:"${arg[0]}"=="Supports"?foundSupports![index].createdAt:foundDevoirs![index].createdAt)??DateTime.now(),user:widget.user,id: "${arg[0]}"=="Annonces"?foundAnnonces![index].id??0:"${arg[0]}"=="Supports"?foundSupports![index].id??0:foundDevoirs![index].id??0 ,hasFile:['', null].contains("${arg[0]}"=="Annonces"?foundAnnonces![index].fileName:"${arg[0]}"=="Supports"?foundSupports![index].fileName:foundDevoirs![index].fileName)?false:true,name:"${arg[0]}"=="Annonces"?foundAnnonces![index].enseignantPrenom+" "+foundAnnonces![index].enseignantNom:"${arg[0]}"=="Supports"?foundSupports![index].enseignantPrenom+" "+foundSupports![index].enseignantNom:foundDevoirs![index].enseignantPrenom+" "+foundDevoirs![index].enseignantNom ), arguments:["${arg[0]}", "${arg[0]}"=="Annonces"?foundAnnonces![index].titre:"${arg[0]}"=="Supports"?foundSupports![index].titre:foundDevoirs![index].titre ,"${arg[0]}"=="Annonces"?foundAnnonces![index].contenu:"${arg[0]}"=="Supports"?foundSupports![index].contenu:foundDevoirs![index].contenu,"${arg[0]}"=="Annonces"?foundAnnonces![index].fileName:"${arg[0]}"=="Supports"?foundSupports![index].fileName:foundDevoirs![index].fileName,]);
                        }
                                         
                                       
                                        },
                        child: Container(
                                            width: screenWidth-40,
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
                                                      child:Center(child: Text("${arg[0]}"=="Annonces"?foundAnnonces![index].enseignantPrenom[0].toUpperCase():"${arg[0]}"=="Supports"?foundSupports![index].enseignantPrenom[0].toUpperCase():foundDevoirs![index].enseignantPrenom[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:12)))
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("${arg[0]}"=="Annonces"?foundAnnonces![index].enseignantPrenom+" "+foundAnnonces![index].enseignantNom:"${arg[0]}"=="Supports"?foundSupports![index].enseignantPrenom+" "+foundSupports![index].enseignantNom:foundDevoirs![index].enseignantPrenom+" "+foundDevoirs![index].enseignantNom,style:TextStyle(color:Colors.black,fontSize:12)),
                                                          Text(DateFormat('dd/MM/yyyy').format(("${arg[0]}"=="Annonces"?foundAnnonces![index].createdAt:"${arg[0]}"=="Supports"?foundSupports![index].createdAt:foundDevoirs![index].createdAt)??DateTime.now()).toString(),style:TextStyle(color:Colors.black54,fontSize:10)),
                                                          ],),
                                                         
                              
                                                          ]),
                                              SizedBox(height: 5,),
                                              Text("${arg[0]}"=="Annonces"?foundAnnonces![index].titreResume:"${arg[0]}"=="Supports"?foundSupports![index].titreResume:foundDevoirs![index].titreResume,style:TextStyle(color:Colors.black,fontSize: 15)),
                                              SizedBox(height: 5,),
                                              Text("${arg[0]}"=="Annonces"?foundAnnonces![index].contenuResume:"${arg[0]}"=="Supports"?foundSupports![index].contenuResume:foundDevoirs![index].contenuResume,style:TextStyle(color:Colors.black54,fontSize: 12)),
                                               SizedBox(height: 10,),
                                               Visibility(
                                                visible:!['', null].contains("${arg[0]}"=="Annonces"?foundAnnonces![index].fileName:"${arg[0]}"=="Supports"?foundSupports![index].fileName:foundDevoirs![index].fileName),
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
                     replacement: const Center(child: 
                     CircularProgressIndicator()),
                   ),
                    Visibility(
                      visible: widget.user.status=="Enseignant",
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: EdgeInsets.only(right: 30,bottom: 50),
                          child: FloatingActionButton(
                            onPressed: ()async{   
                              //Get.to(PostForm(user:widget.user,operation:"Post",id:widget.id), arguments:["${arg[0]}",]);
                              if("${arg[0]}"=="Annonces"){
                                
                                               final newAnnonceList = await Get.to<List<Annonce>>(
                                                () =>PostForm(
                                                  annonces:foundAnnonces,
                                                  annonceState:annonceState,
                                                  operation:"Post",
                                                  user:widget.user,
                                                  id:widget.id,
                                                ),
                                                arguments: ["${arg[0]}","",""],
                                                 );
                                                 //if (mounted) {}
                                                 setState(() {
                                                  
                                                  if(newAnnonceList!.length !=foundAnnoncesLength){
                                                     foundAnnonces = newAnnonceList;
                                                  foundAnnoncesLength=foundAnnoncesLength+1;
                                                   annonces!.insert(0,newAnnonceList[0]) ;
                                                  //annonces= newAnnonceList;
                                                  if(annonces!.length<=5){
                                                        widget.annonceState!.annonces=annonces!;
                                                    widget.annonces=annonces!;
    
                                                   }else{
                                                        widget.annonceState!.annonces=annonces!.sublist(0,5);
                                                    widget.annonces=annonces!.sublist(0,5);
    
                                                   }

                                                  }
                                                  
                                                  
                                                  
      
                                     });
      
                              }else if("${arg[0]}"=="Supports"){
                                final newSupportList = await Get.to<List<Support>>(
                                                () =>PostForm(
                                                  supports:foundSupports,
                                                  supportState:supportState,
                                                  operation:"Post",
                                                  user:widget.user,
                                                  id:widget.id,
                                                ),
                                                arguments: ["${arg[0]}","",""],
                                                 );
                                                 //if (mounted) {}
                                                 setState(() {
                                                print(newSupportList!.length);
                                                if(newSupportList.length != foundSupportsLength){
                                                  foundSupports = newSupportList;
                                                  foundSupportsLength=foundSupportsLength+1;
                                                   supports!.insert(0,newSupportList[0]) ;
                                                  
                                                    if(supports!.length<=5){
                                                     widget.supportState!.supports=supports!;
                                                    widget.supports=supports;
    
                                                   }else{
                                                     widget.supportState!.supports=supports!.sublist(0,5);
                                                    widget.supports=supports!.sublist(0,5);
             
                                                   }

                                                }
                                                   
                                                
      
                                     });
      
                              }else if("${arg[0]}"=="Devoirs"){
                                 final newDevoirList = await Get.to<List<Devoir>>(
                                                () =>PostForm(
                                                  devoirs:foundDevoirs,
                                                  devoirState:devoirState,
                                                  operation:"Post",
                                                  user:widget.user,
                                                  id:widget.id,
                                                ),
                                               arguments: ["${arg[0]}","",""],
                                                 );
                                                 //if (mounted) {}
                                                 setState(() {
                                                 if(newDevoirList!.length != foundDevoirsLength){
                                                  foundDevoirs = newDevoirList;
                                                  foundDevoirsLength=foundDevoirsLength+1;
                                                  devoirs!.insert(0,newDevoirList[0]) ;
                                                   if(devoirs!.length<=5){
                                                     widget.devoirState!.devoirs=devoirs!;
                                                    widget.devoirs=devoirs!;
    
                                                   }else{
                                                     widget.devoirState!.devoirs=devoirs!.sublist(0,5);
                                                    widget.devoirs=devoirs!.sublist(0,5);
                                                   }

                                                 }
                                                  
                                                  
      
                                     });
      
                              }
                              },
                            child: Icon(Icons.add,color: Colors.white,),
                            backgroundColor: Color(0xFF33548A),
                            elevation: 0,
                          ),
                        ),
                      ),
                    )
                   ]
                 ),
               ),
               
              ]),
            ),
          );}
        
      ),
    );
  }
}