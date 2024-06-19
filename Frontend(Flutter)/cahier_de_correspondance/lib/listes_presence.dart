import 'package:cahier_de_correspondance/liste_presence.dart';
import 'package:cahier_de_correspondance/models/ListesAbsences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'models/User.dart';
import 'services/api_calls.dart';

class ListesPresence extends StatefulWidget {
  final int id;
  final User user;
  const ListesPresence({super.key,
  required this.id,required this.user});

  @override
  State<ListesPresence> createState() => _ListesPresenceState();
}

class _ListesPresenceState extends State<ListesPresence> {
  bool listesAreLoaded=false;
  var listesLength=0;
  List<ListesAbsences>? listes;

   void initState(){
     super.initState();
     getData();
    
  }
  getData() async{
     
      var jsonAnnonceBody=  await ApiCalls().get('/index_liste_absences/'+widget.id.toString(),widget.user.token);
      if(jsonAnnonceBody != null){
         listes=listesAbsencesFromJson(jsonAnnonceBody);
     if(listes!=null){
      setState(() {
        listesAreLoaded=true;
        listesLength = listes!.length;
      });
     }

      }else{
         setState(() {
        listesAreLoaded=true;
        listesLength = 0;
      });

      }
     
     
  }
  Future<int> deleteListe(int id) async {
    var statusCode=  await ApiCalls().delete('/liste_absences/'+id.toString(),widget.user.token);
     
   
     return statusCode;
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
       onRefresh: () async{
        await getData();
      },
      child: Scaffold(
        body:Column(
          children: [
           
            SizedBox(height: 15,),
            Expanded(
              child: Visibility(
                visible: listesAreLoaded,
                child: listesLength>0?ListView.builder(
                  itemCount: listesLength,
                  itemBuilder: (BuildContext context,int index){
                    return Dismissible(
                      key:Key(listes![index].id.toString()),
                       background: Container(
                        alignment:AlignmentDirectional.centerEnd,
                        color:Colors.red,
                        child: Icon(Icons.delete,color:Colors.white), ),
                        onDismissed: (direction)async{
                           int x=await deleteListe(listes![index].id);
                           print(x);
                            if(x==200){
                          setState(() {
                              listes!.removeAt(index);
                              listesLength=listesLength-1;
                           });
                            }
                        },
                        direction:DismissDirection.endToStart,
                      child: InkWell(
                        onTap:(){
                           Get.to(ListePresence(user:widget.user,roomId:widget.id,id:listes![index].id,date: listes![index].date,), arguments:["Consultation",listes![index].seance]);
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
                                  Text("Liste du "+DateFormat('dd/MM/yyyy').format(listes![index].date).toString(),style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5,),
                                  Text(listes![index].seance,style:TextStyle(color:Colors.grey,fontSize:12)),
                                  SizedBox(height: 5,),
                                 
                              ],),
                             
                            ],
                          ),
                        ),
                      ),
                    );
                  }):Center( child:Text("Auncune à affichier",style:TextStyle(color:Colors.grey,fontSize:12)),),
                   replacement: const Center(child:CircularProgressIndicator(),),
              ),
            ),
             Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.only(right: 30,bottom: 50),
                      child: FloatingActionButton(
                        onPressed: (){   Get.to(ListePresence(user:widget.user,roomId:widget.id), arguments:["Ajout"]);},
                        child: Icon(Icons.add,color: Colors.white,),
                        backgroundColor: Color(0xFF33548A),
                        elevation: 0,
                      ),
                    ),
                  ),
          ],
        )
      ),
    );
  }
}