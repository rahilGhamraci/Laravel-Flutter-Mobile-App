import 'package:cahier_de_correspondance/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'models/User.dart';
import 'services/api_calls.dart';
import 'package:cahier_de_correspondance/models/Bulletin.dart';
class BulletinsPage extends StatefulWidget {
  int? id;
  final User user;
   BulletinsPage({super.key, this.id,required this.user});

  @override
  State<BulletinsPage> createState() => _BulletinsPageState();
}

class _BulletinsPageState extends State<BulletinsPage> {
  bool bulletinsAreLoaded=false;
  var bulletinsLength=0;
  List<Bulletin>? bulletins;

   void initState(){
     super.initState();
     getData();
    
  }
  getData() async{
      if(widget.user.status=="Tuteur"){
          var jsonAnnonceBody=  await ApiCalls().get('/bulletin_enfants/'+widget.id.toString(),widget.user.token);
         if(jsonAnnonceBody != null){
      bulletins=bulletinFromJson(jsonAnnonceBody);
     if(bulletins!=null){
      setState(() {
        bulletinsAreLoaded=true;
        bulletinsLength = bulletins!.length;
      });
     }
         }else{
           setState(() {
        bulletinsAreLoaded=true;
        bulletinsLength = 0;
      });

         }
      }else{
         var jsonAnnonceBody=  await ApiCalls().get('/mes_bulletins',widget.user.token);
            if(jsonAnnonceBody != null){
      bulletins=bulletinFromJson(jsonAnnonceBody);
     if(bulletins!=null){
      setState(() {
        bulletinsAreLoaded=true;
        bulletinsLength = bulletins!.length;
      });
     }
      }else{
         setState(() {
        bulletinsAreLoaded=true;
        bulletinsLength = 0;
      });

      }
      }
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        await getData();
      },
      child: Scaffold(
        body: Column(
          children:[
            SizedBox(height: 10,),
            Expanded(
              child: Visibility(
                visible:bulletinsAreLoaded,
                child:bulletinsLength > 0? ListView.builder(
                      itemCount: bulletinsLength,
                      itemBuilder: (BuildContext context,int index){
                        return InkWell(
                          onTap:(){
                            if(widget.user.status=="Tuteur"){
                                Get.to(NotesPage(user:widget.user,id:widget.id), arguments:[bulletins![index].trimestre,bulletins![index].anneeScolaire]);
                            }else{
                              Get.to(NotesPage(user:widget.user,), arguments:[bulletins![index].trimestre,bulletins![index].anneeScolaire]);
                            }
                           
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
                                    Text(bulletins![index].trimestre,style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5,),
                                    Text(bulletins![index].anneeScolaire,style:TextStyle(color:Colors.grey,fontSize:12)),
                                    SizedBox(height: 5,),
                                   
                                ],),
                               
                              ],
                            ),
                          ),
                        );
                      }):Center(child:Text("aucune note à afficher")),
                      replacement: const Center(child: CircularProgressIndicator()),
              ),
            )
          ]
        )),
    );
  }
}