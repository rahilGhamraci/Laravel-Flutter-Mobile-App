import 'package:cahier_de_correspondance/post_form.dart';
import 'package:cahier_de_correspondance/providers/absTuteur_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cahier_de_correspondance/models/AbsTuteur.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'justification_detail_page.dart';
import 'models/User.dart';
import 'services/api_calls.dart';
class AbsencesTuteurPage extends StatefulWidget {
  final int idElv;
  final User user;
  const AbsencesTuteurPage({super.key,required this.idElv,required this.user});

  @override
  State<AbsencesTuteurPage> createState() => _AbsencesTuteurPageState();
}

class _AbsencesTuteurPageState extends State<AbsencesTuteurPage> {
     List <AbsTuteur>? abs;
     var absAreLoaded=false;
     var absLength=0;
     List <AbsTuteur>? selectedAbs=[];

    void initState(){
     super.initState();
     getData();
    
  }
  getData() async{
     
      var jsonAnnonceBody=  await ApiCalls().get('/index_absences_tuteur/'+widget.idElv.toString(),widget.user.token);
      if(jsonAnnonceBody != null){
        abs=absTuteurFromJson(jsonAnnonceBody);
          if(abs!=null){
         setState(() {
        absAreLoaded=true;
        absLength = abs!.length;
      });
     }
      }else{
         setState(() {
        absAreLoaded=true;
        absLength = 0;
      });

      }
      
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
    return StatefulBuilder(
      builder: (context, setState) {
        final absTuteurState = Provider.of<AbsTuteurState>(context);

        return  RefreshIndicator(
        onRefresh: () async{
          await getData();
        },
        child: Scaffold(
           key:_scaffoldKey,
          body:Column(children: [
                 SizedBox(height: 5,),
                 Expanded(
                   child: Stack(
                     children:[ Visibility(
                      visible: absAreLoaded,
                       child: absLength>0 ? ListView.builder(
                          itemCount:absLength,
                          itemBuilder: (BuildContext context,int index){
                            return InkWell(
                              onTap:(){
                                  if(abs![index].justificationId==null){
                                        setState(() {
                                  abs![index].isSelected=!abs![index].isSelected;
                                   if(abs![index].isSelected){
                                       selectedAbs!.add(abs![index]);
                                       print(selectedAbs![selectedAbs!.length-1].id);
                                       print(selectedAbs!.length);
                                   }else{
                                  
                                    selectedAbs!.removeWhere((element) => element.id==abs![index].id  );
                                    print(selectedAbs!.length);
                                   }
                                });
                                        
                                    }
                              },
                              child: Container(
                                height: 50,
                                
                                decoration:BoxDecoration(
                                color:abs![index].isSelected?Color(0xFF789DC9):Colors.grey.shade200,
                                borderRadius: BorderRadiusDirectional.circular(10)
                                   
                                ),
                                margin: EdgeInsets.only(bottom: 5,left:10,right:10),
                                padding: EdgeInsets.only(left:20,right: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(" le "+DateFormat('dd/MM/yyyy').format(abs![index].date),style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.bold)),
                                        SizedBox(height: 5,),
                                        Text("la séance de "+abs![index].seance,style:TextStyle(color:abs![index].isSelected?Colors.white:Colors.grey,fontSize:12)),
                                       
                                       
                                    ],),
                                  
                                   Visibility(
                                    visible: abs![index].justificationId!=null,
                                    child: InkWell(
                                      onTap:() async{
                                        print(abs![index].justificationId);
                                       
                                          final newabsList = await Get.to<List<AbsTuteur>>(
                                            () => JustificationDetailPage(
                                              absTuteur: abs,
                                              absTuteurState: absTuteurState,
                                              absId:abs![index].id,
                                              user:widget.user,
                                              id:abs![index].justificationId??0,
                                              hasFile:abs![index].filePath!=null,
                                              date:abs![index].createdAt??DateTime.now() ,), 
                                              arguments:[abs![index].objet,abs![index].text,abs![index].fileName,]);
                                             //if (mounted) {}
                                             setState(() {
                                              print(newabsList!.length);
                                              abs = newabsList;
                                            

                                 });
                                      },
                                      child: Row(
                                        children: [
                                          Text("justifiée",style: TextStyle(fontSize: 12),),
                                          Icon(Icons.check_circle,color:Colors.black,size:15),
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            );
                          }):Center(child: Text("aucune absence à afficher"),),
                          replacement: const Center(child:CircularProgressIndicator(),),
                     ),
                     Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: ()async{   
                         // Get.to(PostForm(user:widget.user,operation:"Post",selectedAbs:selectedAbs), arguments:["Justifications",]);
                          
                                           final newabsList = await Get.to<List<AbsTuteur>>(
                                            () => PostForm(
                                              absTuteur:abs,
                                              absTuteurState:absTuteurState,
                                              operation:"Post",
                                              user:widget.user,
                                              selectedAbs:selectedAbs
                                            ),
                                            arguments: ["Justifications","",""],
                                             );
                                             //if (mounted) {}
                                             setState(() {
                                              print(newabsList!.length);
                                              //convocations!.add(newConvocationList[newConvocationList.length-1]);
                                              abs = newabsList;
                                            

                                 });
                          },
                        child: Container(
                          height: 50,
                          width: 150,
                           margin: EdgeInsets.only(bottom:30),
                          //padding: EdgeInsets.only(right: 30,left:30,top:15),
                           decoration: BoxDecoration(
                            color:Color(0xFF33548A),
                            borderRadius: BorderRadius.circular(20)
                           ),
                           child: Center(child: Text("justifier",style: TextStyle(color:Colors.white,fontSize: 16,),)),
                        ),
                      ),
                    ),]
                   ),
                 )
          ],)
        ),
      );}
    );
  }
}