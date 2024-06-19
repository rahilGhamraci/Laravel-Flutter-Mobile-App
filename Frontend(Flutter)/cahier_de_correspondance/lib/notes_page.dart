import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/Note.dart';
import 'models/User.dart';
import 'services/api_calls.dart';

class NotesPage extends StatefulWidget {
  final User user;
  int? id;
   NotesPage({super.key,required this.user,this.id});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  var arg=Get.arguments;
  bool notesAreLoaded=false;
  var notesLength=0;
  List<Note>? notes;

   void initState(){
     super.initState();
     getData();
    
  }
  getData() async{
      if(widget.user.status=="Tuteur"){
          var jsonAnnonceBody=  await ApiCalls().get('/notes_enfants/'+widget.id.toString()+"/${arg[0]}/${arg[1]}",widget.user.token);
       if(jsonAnnonceBody != null){
          notes=noteFromJson(jsonAnnonceBody);
     if(notes!=null){
      setState(() {
        notesAreLoaded=true;
        notesLength = notes!.length;
      });
     }

       }else{
        setState(() {
        notesAreLoaded=true;
        notesLength = 0;
      });

       }
    
      }else{
             var jsonAnnonceBody=  await ApiCalls().get('/notes/${arg[0]}/${arg[1]}',widget.user.token);
             if(jsonAnnonceBody != null){
              notes=noteFromJson(jsonAnnonceBody);
              if(notes!=null){
              setState(() {
                notesAreLoaded=true;
                notesLength = notes!.length;
            });
         }

             }else{
               setState(() {
                notesAreLoaded=true;
                notesLength = 0;
            });

             }
      
      }
     
     
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body:Padding(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
          Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children:[
              SizedBox(height: 45,),
              Row(
                children: [
                  Text("Année Scolaire:",style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.bold)),
                    Text(" ${arg[0]}",style:TextStyle(color:Colors.black,fontSize:14,)),
                ],
              ),
              SizedBox(height: 5,),
             Row(
               children: [
                 Text("Trimestre: ",style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.bold)),
                 Text("${arg[1]}",style:TextStyle(color:Colors.black,fontSize:14,)),
               ],
             ),
            SizedBox(height: 15,),
              Container(
               // margin:const EdgeInsets.only(right:20,left:20),
                width: screenWidth,
                height:1,
                color:Colors.grey,
              ),
          ]),
           SizedBox(height:10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text("Matiere",style:TextStyle(color:Colors.grey,fontSize:12)),
          
            Text("CC",style:TextStyle(color:Colors.grey,fontSize:12)),
           
            Text("Tp",style:TextStyle(color:Colors.grey,fontSize:12)),
           
            Text("Moy devoirs",style:TextStyle(color:Colors.grey,fontSize:12)),
           
            Text("Examen",style:TextStyle(color:Colors.grey,fontSize:12)),
            SizedBox(width:0.5),
          ],),
          SizedBox(height:10,),
            Container(
               // margin:const EdgeInsets.only(right:20,left:20),
                width: screenWidth,
                height:1,
                color:Colors.grey,
              ),
          Expanded(
            child:  Visibility(
              visible: notesAreLoaded,
              child: notesLength>0 ?ListView.builder(
                      itemCount: notesLength,
                      itemBuilder: (BuildContext context,int index){
                        
                         return  Container(
                            height: 50,
                            //margin: EdgeInsets.only(bottom: 5,left:10,right:10),
                             padding: EdgeInsets.only(right:10),
                            child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                Text(notes![index].matiere,style:TextStyle(color:Colors.black,fontSize:12)),
                                Text(notes![index].cc.toString(),style:TextStyle(color:Colors.black,fontSize:12)),
                                Text(notes![index].tp.toString(),style:TextStyle(color:Colors.black,fontSize:12)),
                                Text(notes![index].moyDevoirs.toString(),style:TextStyle(color:Colors.black,fontSize:12)),
                                Text(notes![index].examen.toString(),style:TextStyle(color:Colors.black,fontSize:12)),
                               // SizedBox(width:1),
                      ],),
                          
                        );
                      }):  Text("aucune notes à afficher",style:TextStyle(color:Colors.black,fontSize:12)),
                       replacement: const Center(child: CircularProgressIndicator())
            ),
          )
        ],),
      )
    );
  }
}