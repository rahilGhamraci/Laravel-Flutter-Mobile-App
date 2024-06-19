import 'package:cahier_de_correspondance/convocation_post_form.dart';
import 'package:cahier_de_correspondance/convocation_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cahier_de_correspondance/models/Convocation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'models/User.dart';
import 'providers/convocation_state.dart';
import 'services/api_calls.dart';
class Conovocations extends StatefulWidget {
  final User user;
  final int id;
  const Conovocations({super.key,required this.user,required this.id});

  @override
  State<Conovocations> createState() => _ConovocationsState();
}

class _ConovocationsState extends State<Conovocations> {
  bool convocationsAreLoaded=false;
  int convocationsLength=0;
  List<Convocation>? convocations=[];

   void initState(){
     super.initState();
     getData();
    
  }
  getData() async{
      if(widget.user.status=="Tuteur"){
          var jsonAnnonceBody=  await ApiCalls().get('/convocations_tut_room/'+widget.id.toString(),widget.user.token);
          if(jsonAnnonceBody != null){
              convocations=convocationFromJson(jsonAnnonceBody);
         if(convocations!=null){
          setState(() {
          convocationsAreLoaded=true;
          convocationsLength = convocations!.length;
      });
     }

          }else{
                 setState(() {
          convocationsAreLoaded=true;
          convocationsLength = 0;
      });

          }
        
      }else{
         var jsonAnnonceBody=  await ApiCalls().get('/convocations_room/'+widget.id.toString(),widget.user.token);
         if(jsonAnnonceBody !=null){
           convocations=convocationFromJson(jsonAnnonceBody);
         if(convocations!=null){
          setState(() {
          convocationsAreLoaded=true;
          convocationsLength = convocations!.length;
      });
     }

         }else{
           setState(() {
          convocationsAreLoaded=true;
          convocationsLength =0;
          
      });

         }
        
      }
  }
  Future<int> deleteConvocation(int id) async {
    var statusCode=  await ApiCalls().delete('/convocations/'+id.toString(),widget.user.token);
     
   
     return statusCode;
  }
 
  @override
  Widget build(BuildContext context) {
    
    return StatefulBuilder(
      builder: (context, setState) {
        final convocationState = Provider.of<ConvocationState>(context);

        return Scaffold(
            body:Column(
              children: [
                 SizedBox(height:10),
                Expanded(
                  child: Stack(
                    children: [Visibility(
                      visible: convocationsAreLoaded,
                      child: convocationsLength>0 ?ListView.builder(
                              itemCount: convocationsLength,
                              itemBuilder: (BuildContext context,int index){
                                return widget.user.status=="Enseignant"?Dismissible(
                                  key:Key(convocations![index].id.toString()),
                                  background: Container(
                          alignment:AlignmentDirectional.centerEnd,
                          color:Colors.red,
                          child: Icon(Icons.delete,color:Colors.white), ),
                          onDismissed: (direction)async{
                             int x=await deleteConvocation(convocations![index].id);
                             print(x);
                              if(x==200){
                            setState(() {
                                convocations!.removeAt(index);
                                convocationsLength=convocationsLength-1;
                             });
                              }
                          },
                          direction:DismissDirection.endToStart,
                          child:InkWell(
                                  onTap:(){
                                    Get.to(ConvocationDetailPage(user:widget.user,id:convocations![index].id,hasFile:convocations![index].filePath!=null,date:convocations![index].createdAt??DateTime.now() ,), arguments:[convocations![index].titre,convocations![index].contenu,convocations![index].fileName,convocations![index].nom,convocations![index].prenom]);
                                  },
                                  child: Container(
                                    height: 50,
                                    
                                    decoration:BoxDecoration(
                                    color:Colors.grey.shade200,
                                    borderRadius: BorderRadiusDirectional.circular(10)
                                                        
                                    ),
                                    margin: EdgeInsets.only(bottom: 5,left:10,right:10),
                                    padding: EdgeInsets.only(left:20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10,),
                                            Text(convocations![index].nom +" "+convocations![index].prenom,style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.bold)),
                                            SizedBox(height: 5,),
                                            Text(DateFormat('dd/MM/yyyy').format(convocations![index].createdAt??DateTime.now()).toString(),style:TextStyle(color:Colors.grey,fontSize:12)),
                                            SizedBox(height: 5,),
                                           
                                        ],),
                                         // Expanded(child:Container()),
                                           IconButton( onPressed: ()async{  
                                           // Get.to(ConvocationPostForm(operation:"Update",user:widget.user,roomId:widget.id,id:convocations![index].id), arguments:[]);},
                                           final newConvocationList = await Get.to<List<Convocation>>(
                                            () => ConvocationPostForm(
                                              convocations:convocations,
                                              convocationState:convocationState,
                                              operation:"Update",
                                              index:index,
                                              user:widget.user,
                                              roomId:widget.id,
                                              id:convocations![index].id),
                                            arguments: [convocations![index].titre,convocations![index].contenu],
                                             );
                                             setState(() {
                                              
                                              convocations!=newConvocationList;
                                 });},
                                           icon: Icon(Icons.change_circle,size:20,color:Colors.grey)
                                           ),
                                        
                                      ],
                                    ),
                                  ),
                                )
                                ):InkWell(
                                  onTap:(){
                                    Get.to(ConvocationDetailPage(user:widget.user,id:convocations![index].id,hasFile:convocations![index].filePath!=null,date:convocations![index].createdAt??DateTime.now() ,), arguments:[convocations![index].titre,convocations![index].contenu,convocations![index].fileName,convocations![index].nom,convocations![index].prenom]);
                                  },
                                  child: Container(
                                    height: 50,
                                    
                                    decoration:BoxDecoration(
                                    color:Colors.grey.shade200,
                                    borderRadius: BorderRadiusDirectional.circular(10)
                                                        
                                    ),
                                    margin: EdgeInsets.only(bottom: 5,left:10,right:10),
                                    padding: EdgeInsets.only(left:20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10,),
                                            Text(convocations![index].nom +" "+convocations![index].prenom,style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.bold)),
                                            SizedBox(height: 5,),
                                            Text(DateFormat('dd/MM/yyyy').format(convocations![index].createdAt??DateTime.now()).toString(),style:TextStyle(color:Colors.grey,fontSize:12)),
                                            SizedBox(height: 5,),
                                           
                                        ],),
                                        
                                      ],
                                    ),
                                  ),
                                );
                              }):Center(child:Text("aucune convocation à afficher")),
                            replacement: const Center(child: CircularProgressIndicator()),
                    ),
                     Visibility(
                    visible: widget.user.status=="Enseignant",
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.only(right: 30,bottom: 50),
                        child: FloatingActionButton(
                              onPressed:()async{  
 
                                           final newConvocationList = await Get.to<List<Convocation>>(
                                            () => ConvocationPostForm(
                                              convocations:convocations,
                                              convocationState:convocationState,
                                              operation:"Post",
                                              user:widget.user,
                                              roomId:widget.id,
                                            ),
                                            arguments: ["",""],
                                             );
                                             //if (mounted) {}
                                             setState(() {
                                              print(newConvocationList!.length);
                                              //convocations!.add(newConvocationList[newConvocationList.length-1]);
                                              convocations = newConvocationList;
                                              convocationsLength=convocationsLength+1;

                                 });},
                          child: Icon(Icons.add,color: Colors.white,),
                          backgroundColor: Color(0xFF33548A),
                          elevation: 0,
                        ),
                      ),
                    ),
                  )
                    ]
                  )),
              ],
            )
          );}
      );
     
    
  }
}