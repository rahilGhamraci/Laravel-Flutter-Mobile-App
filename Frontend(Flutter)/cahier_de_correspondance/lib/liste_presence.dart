import 'package:cahier_de_correspondance/justification_detail_page.dart';
import 'package:cahier_de_correspondance/models/Absence.dart';
import 'package:cahier_de_correspondance/models/ListeAbsences.dart';
import 'package:cahier_de_correspondance/models/ListeEleve.dart';
import 'package:cahier_de_correspondance/models/ListeElvAbs.dart';
import 'package:cahier_de_correspondance/models/ListesAbsences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'models/User.dart';
import 'services/api_calls.dart';
class ListePresence extends StatefulWidget {
  int? id;
  DateTime? date;
  final int roomId;
  User user;
   ListePresence({super.key,required this.user,
   required this.roomId, this.id,this.date});

  @override
  State<ListePresence> createState() => _ListePresenceState();
}

class _ListePresenceState extends State<ListePresence> {
  TextEditingController _date = TextEditingController();
  TextEditingController seance = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
  String _seance="";
  final formKey=GlobalKey<FormState>();
 
  var arg=Get.arguments;
 
 DateTime? pickeddate=DateTime.now();
 var liste;
  bool elvsAreLoaded=false;
  var elvsLength=0;
  List<ListeEleve>? elvs;
  bool absSansListe=false;
  bool elvsAbsAreLoaded=false;
  var elvsAbsLength=0;
  List<ListeElvAbs>? elvsAbs;

   void initState(){
     super.initState();
    
     if("${arg[0]}"=="Consultation"){
           seance.text="${arg[1]}";
           _date.text=DateFormat('dd/MM/yyyy').format(widget.date??DateTime.now());
          getData2(widget.id??0);
     }else{
      elvsAbs=[];
     }
      getData();
    
  }
  getData() async{
     
      var jsonAnnonceBody=  await ApiCalls().get('/elv_liste/'+widget.roomId.toString(),widget.user.token);
      if(jsonAnnonceBody != null){
        elvs=listeEleveFromJson(jsonAnnonceBody);
     if(elvs!=null){
      setState(() {
        elvsAreLoaded=true;
        elvsLength = elvs!.length;
      });
     }
      }else{
         setState(() {
          elvsAreLoaded=true;
          elvsLength = 0;
      });

      }
      
     
  }
  getData2(int id) async{
     
      var jsonAnnonceBody=  await ApiCalls().get('/index_absences/'+id.toString(),widget.user.token);
         if(jsonAnnonceBody != null){
           elvsAbs=listeElvAbsFromJson(jsonAnnonceBody);
     if(elvsAbs!=null){
      setState(() {
        elvsAbsAreLoaded=true;
        elvsAbsLength = elvsAbs!.length;
        print(elvsAbsLength);
      
      });
     }else{
      setState(() {
        elvsAbs=[];
      });
     }
         }else{
          setState(() {
            elvsAbs=[];
           });

         }
     
     
  }

  addListe(dynamic object)async{
     var jsonAnnonceBody=  await ApiCalls().post('/liste_absences',widget.user.token,object);
    if(jsonAnnonceBody != null){
      liste=listeAbsencesFromJson(jsonAnnonceBody);
      print(liste);
     if(liste!=null){
         absSansListe=false;
     }

    }
      
      
  }

  addAbsence(dynamic object,int id)async{
     var jsonAnnonceBody=  await ApiCalls().post('/absences',widget.user.token,object);
     var abs=absenceFromJson(jsonAnnonceBody);
      print(abs);
     if(abs!=null){
          getData2(id);
     }
  }
  Future<int> deleteAbsence(int id,int listeId) async {
    var statusCode=  await ApiCalls().delete('/absences/'+id.toString()+'/'+listeId.toString(),widget.user.token);
     return statusCode;
  }

  int checkId(int index){

     return elvsAbs!.indexWhere((p) => p.id == elvs![index].id && p.nom == elvs![index].nom && p.prenom== elvs![index].prenom && p.dateNaissance == elvs![index].dateNaissance && p.classeId== elvs![index].classeId && p.tuteurId== elvs![index].tuteurId && p.updatedAt== elvs![index].updatedAt && p.createdAt== elvs![index].createdAt && p.userId== elvs![index].userId  );
    
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key:_scaffoldKey,
      body:Padding(
        padding: EdgeInsets.only(left:20,right:20),
        child: Column(children: [
          SizedBox(height: 50,),
         Form(
          key:formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Container(
                  width: 145,
                  height: 45,
                  child: TextFormField(
                    controller: _date,
                    onTap: ()async{
                      FocusScope.of(context).requestFocus(new FocusNode());
                      pickeddate=await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate:DateTime(2101),
                    );
                    if(pickeddate !=null){
                      setState(() {
                        print(pickeddate);
                        _date.text= DateFormat('dd/MM/yyyy').format(pickeddate!);
                      });
                    }
                },
                         decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top:18.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderSide: BorderSide(color:Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon:Icon(Icons.calendar_today_rounded),
                          hintText: "la date"),
                          validator: (value){
                          if(value!.isEmpty){
                            return "ce champ est obligatoir";
                          }
                        },
                       ),
                ),
             
              
              Container(
                width: 100,
                height: 45,
                //padding: EdgeInsets.only(left:10),
                child: TextFormField(
                       controller: seance,
                       decoration: InputDecoration(
                       contentPadding: EdgeInsets.only(left:18.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderSide: BorderSide(color:Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        hintText: "la séance"),
                      validator: (value){
                        if(value!.isEmpty){
                          return "ce champ est obligatoir";
                        }
                      },
                       onChanged: (value){
                        setState(() {
                          _seance=value;
                          print(_seance);
                        });
                      },
                     ),
              ),
         Visibility(
          visible: "${arg[0]}"=="Ajout",
           child: IconButton(icon:Icon(Icons.add,color:!absSansListe?Colors.black:Colors.red),onPressed:(){
            if(formKey.currentState!.validate() ){
              ListeAbsences liste=ListeAbsences(date: pickeddate??DateTime.now(), seance: _seance, roomId: widget.roomId.toString(), );
              var uploadListe=listeAbsencesToJson(liste);
              addListe(uploadListe);
              if(absSansListe == false){
                final snackBar=SnackBar(content: Text("liste ajoutée",));
                     _scaffoldKey.currentState!.showSnackBar(snackBar);

              }
            }
           }),
         ),
         ],)),
         SizedBox(height: 20,),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
          Text("Liste des élèves",style:TextStyle(color:Colors.black,fontSize:16,fontWeight: FontWeight.bold)),
          Icon(Icons.assignment,)
         ],),
        
         Expanded(
           child: Visibility(
            visible: elvsAreLoaded,
             child: elvsLength>0?ListView.builder(
              itemCount: elvsLength,
              itemBuilder: (BuildContext context,int index){
              return InkWell(
                onTap:elvsAbs!.indexWhere((p) => p.id == elvs![index].id && p.nom == elvs![index].nom && p.prenom== elvs![index].prenom && p.dateNaissance == elvs![index].dateNaissance && p.classeId== elvs![index].classeId && p.tuteurId== elvs![index].tuteurId && p.updatedAt== elvs![index].updatedAt && p.createdAt== elvs![index].createdAt && p.userId== elvs![index].userId  ) !=-1?(){
                     final snackBar=SnackBar(content: Text("l'élève est déja marqué comme absent",));
                     _scaffoldKey.currentState!.showSnackBar(snackBar);
                }:(){
                 setState((){
                  Absence abs;
                  if("${arg[0]}"=="Ajout"){
                    if(liste!=null){
                     abs=Absence(eleveId: elvs![index].id, listeAbsencesId:liste!.id);
                       var uploadListe=absenceToJson(abs);
                    addAbsence(uploadListe,liste!.id);
                    }else{
                      print(liste);
                      setState((){
                        absSansListe=true;
                      });
                       final snackBar=SnackBar(content: Text("veuillez d'abord ajouter une liste",));
                     _scaffoldKey.currentState!.showSnackBar(snackBar);
                    }
                  }else{
                      abs=Absence(eleveId: elvs![index].id, listeAbsencesId:widget.id??0);
                     var uploadListe=absenceToJson(abs);
                     addAbsence(uploadListe,widget.id??0);
                  }
                  
                 });
                },
                child: Container(
                          height: 50,
                          
                          decoration:BoxDecoration(
                          color:elvsAbs!.indexWhere((p) => p.id == elvs![index].id && p.nom == elvs![index].nom && p.prenom== elvs![index].prenom && p.dateNaissance == elvs![index].dateNaissance && p.classeId== elvs![index].classeId && p.tuteurId== elvs![index].tuteurId && p.updatedAt== elvs![index].updatedAt && p.createdAt== elvs![index].createdAt && p.userId== elvs![index].userId  ) !=-1?Colors.red.shade200:Colors.grey.shade200,
                          borderRadius: BorderRadiusDirectional.circular(10)
                  
                          ),
                          margin: EdgeInsets.only(bottom: 5,left:10,right:10),
                          padding: EdgeInsets.only(left:20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(elvs![index].nom+" "+elvs![index].prenom,style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.bold)),
                               Row(
                                 children: [
                                   Visibility(
                                    visible: checkId(index) !=-1 && elvsAbs![checkId(index)].justificationId!=null,
                                     child:  InkWell(
                                      onTap:(){Get.to(JustificationDetailPage(user:widget.user,id:elvsAbs![checkId(index)].justificationId??0,hasFile:elvsAbs![checkId(index)].filePath!=null,date:elvsAbs![checkId(index)].justificationCreatedAt??DateTime.now() ,), arguments:[elvsAbs![checkId(index)].objet,elvsAbs![checkId(index)].text,elvsAbs![checkId(index)].fileName,elvsAbs![checkId(index)].tuteurNom,elvsAbs![checkId(index)].tuteurPrenom]);},
                                      child: Text("justifiée",style: TextStyle(fontSize: 12),)),
                                   ),
                                    Visibility(
                                visible: elvsAbs!.indexWhere((p) => p.id == elvs![index].id && p.nom == elvs![index].nom && p.prenom== elvs![index].prenom && p.dateNaissance == elvs![index].dateNaissance && p.classeId== elvs![index].classeId && p.tuteurId== elvs![index].tuteurId && p.updatedAt== elvs![index].updatedAt && p.createdAt== elvs![index].createdAt && p.userId== elvs![index].userId  ) !=-1,
                                 child: IconButton(icon:Icon(Icons.cancel_rounded ,),onPressed:()async{
                                 int x;
                                 if("${arg[0]}"=="Ajout"){
                                     x=await deleteAbsence(elvs![index].id,liste!.id);
                                      if(x==200){
                                      getData2(liste!.id);
                                     }else{
                                      print(x);
                                     }
                                 }else{
                                    x=await deleteAbsence(elvs![index].id,widget.id??0);
                                     if(x==200){
                                        getData2(widget.id??0);
                                     }else{
                                      print(x);
                                     }
                                 }
                                }),
                               ),
                                 ],
                               ),
                              
                            ],
                          ),
                        ),
              );
             }):Center(child:Text("aucun élève à afficher",style:TextStyle(color:Colors.grey,fontSize:14)),),
          replacement: const Center(child:CircularProgressIndicator(),),
           ),
         )
         
        ],),
      )
    );
  }
}