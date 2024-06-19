import 'package:cahier_de_correspondance/post_form.dart';
import 'package:cahier_de_correspondance/services/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:external_path/external_path.dart';
import 'dart:convert';
import 'models/AbsTuteur.dart';
import 'models/Justification.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'providers/absTuteur_state.dart';
import 'providers/justification_state.dart';
import 'models/User.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';




class JustificationDetailPage extends StatefulWidget {
  final bool hasFile;
  final int id;
  final  DateTime date;
  final User user;
  int? absId;
  List <AbsTuteur>? absTuteur;
   AbsTuteurState? absTuteurState;
  JustificationDetailPage({super.key,this.absTuteur,this.absTuteurState,
  required this.hasFile,
  required this.id,
  required this.date,
  required this.user,
  this.absId});

  @override
  State<JustificationDetailPage> createState() => _JustificationDetailPageState();
}

class _JustificationDetailPageState extends State<JustificationDetailPage> {
    var arg=Get.arguments;
     bool justificationisLoaded=false;
     String car="";
    
    Justification? justification;
    bool backButtonPressed = false;

   void initState(){
     super.initState();
      BackButtonInterceptor.add(backButtonInterceptor);
     getData();
     if(widget.user.status=="Enseignant"){
         setState(() {
       car=arg[3];
     });
     }
    
    
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
  getData() async{
      if(widget.user.status=="Tuteur"){
          var jsonAnnonceBody=  await ApiCalls().get('/justifications_tuteur/'+widget.id.toString(),widget.user.token);
         
          justification=justificationFromJson(jsonAnnonceBody);
     if(justification!=null){
      setState(() {
        justificationisLoaded=true;
      
      });
     
     }
      }else{
         var jsonAnnonceBody=  await ApiCalls().get('/justifications_enst/'+widget.id.toString(),widget.user.token);
        
        justification=justificationFromJson(jsonAnnonceBody);
     if(justification!=null){
      setState(() {
        justificationisLoaded=true;
       
      });
     }
      }
  }

  Future openFile()async{

         if(widget.user.status=="Enseignant"){
         final file =await downloadFile(ApiCalls.baseUrl+"/justifications_telechargement/"+widget.id.toString(),"${arg[2]}");
         if(file==null) return;
         print('Path:${file.path}');
         OpenFile.open(file.path);
       }else{
        String name=justification!.fileName??"";
       final file =await downloadFile(ApiCalls.baseUrl+"/justifications_telechargement/"+widget.id.toString(),name);
         if(file==null) return;
         print('Path:${file.path}');
         OpenFile.open(file.path);
       }
   

  }
   Future<File?> downloadFile(String url,String fileName)async{
     final appStorage= await getApplicationDocumentsDirectory();
     final file =File('${appStorage.path}/$fileName');
     try{
     final response =await Dio().get(
      url,
      options:Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: 0
      )
     );
     print(response.statusCode);
     final raf=file.openSync(mode:FileMode.write);
     raf.writeFromSync(response.data);
     await raf.close();

     return file;
     }catch(e){
        return null;
     }
  }
   Future _downloadFile()async{

    var dio= Dio();
    
      final dirPath=await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
       if(widget.user.status=="Enseignant"){
       //verifier que le fichier n'est pas deja telechargé
       final tempDir = await getTemporaryDirectory();
        bool fileExists = await File('$dirPath/${arg[2]}').exists();
        print("1/"+fileExists.toString());
        if (!fileExists) {
        fileExists = await File('${tempDir.path}/${arg[2]}').exists();
        print("2/"+fileExists.toString());
       }
        if (fileExists) {
          print("il existe deja");
          print('${dirPath}/${arg[2]}');
          OpenFile.open('${dirPath}/${arg[2]}');
        }else{
           var response =await dio.download(ApiCalls.baseUrl+"/justifications_telechargement/"+widget.id.toString(), '${dirPath}/${arg[2]}');
          print(response.statusCode);
          if(response.statusCode==200){
               OpenFile.open('${dirPath}/${arg[2]}'); 
     
          }
       

        }
         
       }else{
        String name=justification!.fileName??"";
         final tempDir = await getTemporaryDirectory();
        bool fileExists = await File('$dirPath/${name}').exists();
        print("1/"+fileExists.toString());
        if (!fileExists) {
        fileExists = await File('${tempDir.path}/${name}').exists();
        print("2/"+fileExists.toString());
       }
       if (fileExists) {
          print("il existe deja");
          print('${dirPath}/${name}');
          OpenFile.open('${dirPath}/${name}');
        }else{
           var response =await dio.download(ApiCalls.baseUrl+"/justifications_telechargement/"+widget.id.toString(), '${dirPath}/'+name);
        print(response.statusCode);
        OpenFile.open('${dirPath}/${name}'); 
        }
        
       }
  }
    deleteJustification() async {
   
      // set to null le champ justification_id de l'absence qu'on veut supprimer sa justification
      Abs a=Abs(justificationId:null);
               String objJson=jsonEncode(a);
               print(widget.absId.toString());
               print(objJson);
        var jsonAnnonceBody=  await ApiCalls().post('/absences/'+widget.absId.toString(),widget.user.token,objJson);

        // mise a jour de la liste des abs
          final index = widget.absTuteur!.indexWhere((c) => c.id == widget.absId);
                         widget.absTuteur![index].justificationId = null;
                         widget.absTuteur![index].fileName = null;
                         widget.absTuteur![index].filePath = null;
                         widget.absTuteur![index].tuteurId = null;
        // verifier qu'in ne y'a plus d'absences qui ont comme justification id notre justification
        // recuperer le nombre d'absences qui ont comme valeur de justificatin_id la justification en question
        var client=http.Client();
        var url=Uri.parse(ApiCalls.baseUrl+'/nb_absences/'+widget.id.toString());
        var _headers={
          'Authorization':'Bearer '+widget.user.token,
          };
       var response=await client.get(url,headers: _headers);
       if(response.statusCode==200){
          var nbAbs=json.decode(response.body);
          print("nombre abs");
          print(nbAbs);
          if(nbAbs==0){
            var statusCode=  await ApiCalls().delete('/justifications/'+widget.id.toString(),widget.user.token);
          }
       }
       
  }
  @override
  Widget build(BuildContext context) {
   final screenHeight=MediaQuery.of(context).size.height;
    final statusBarHeight=MediaQuery.of(context).padding.top;
    final screenWidth=MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
      
         if (backButtonPressed) {
        
          backButtonPressed = false; // Reset the flag
          setState(() {});
        
            print("Navigating back with annonces: ${widget.absTuteur}");
            Navigator.of(context).pop(widget.absTuteur);
          return false; // Prevent the default back button behavior
        }

        return true;
      },
      child: StatefulBuilder(
        builder: (context, setState) {
          final justificationState = Provider.of<JustificationState>(context);
    
          return Scaffold(
          body: RefreshIndicator(
               onRefresh: () async{
            await getData();
          },
            child: Stack(
              children: [
                ListView(),
                Container(
                 width: double.maxFinite,
                  height: screenHeight+statusBarHeight,
                  padding: const EdgeInsets.only(top:35, right: 10,left:10,),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      InkWell(
                         onTap: (){
                              Navigator.of(context).pop(widget.absTuteur);
                          },
                        child: Container(
                           width:40,
                         height: 40,
                         decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                         ),
                         child:Icon(Icons.arrow_back_ios,color:Colors.black)
                        ),
                      ),
                      Text("Détail Justification",style:TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
                       Container(
                            width:40,
                            height: 40,
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color:Color(0xFFE67F4F)
                           ),
                           child:Center(child: Text(widget.user.name[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:16)))
                          ),
                    ],),
                    SizedBox(height: 20,),
                    //infos compte qui a publié +date
                    Padding(
                      padding: const EdgeInsets.only(left:10),
                      child: Row(
                        children:[
                        Container(
                              width:40,
                              height: 40,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color:Color(0xFF789DC9),
                             ),
                             child:Center(child: Text(widget.user.status=="Enseignant"?car[0].toUpperCase():widget.user.name[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:16)))
                            ),
                            SizedBox(width: 10,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(widget.user.status=="Enseignant"?"${arg[3]} ${arg[4]}":"vous",style:TextStyle(color:Colors.black,fontSize:14)),
                              Text("le "+DateFormat('dd/MM/yyyy').format(widget.date),style:TextStyle(color:Colors.grey,fontSize:12)),
                                             
                            ],),
                            Visibility(visible:widget.user.status=="Enseignant",child: SizedBox(width: 140,),replacement: SizedBox(width: 100,),),
                            Visibility(
                              visible:widget.user.status=="Tuteur",
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                
                                IconButton(onPressed:()async { 
                                  //Get.to(PostForm(user:widget.user,operation:"Update",id:widget.id), arguments:["Justifications",]);
                                  final newJustification = await Get.to<Justification>(
                                  () => PostForm(
                                    user:widget.user,
                                    operation:"Update",
                                    justificationState: justificationState,
                                    id:widget.id,
                                         ),
                                         arguments: ["Justifications",justification!.objet,justification!.text],
                                 );
                                 setState(() {
                                  if(newJustification!=null){
                                   justificationState.justification = newJustification;
                                    justification=justificationState.justification;
                                  }
                                  
                                   });
                                  },
                                   icon: Icon(Icons.change_circle)),
                                 IconButton(onPressed:()async{
                               
                              await deleteJustification(); 
                           
                                 Navigator.of(context).pop(widget.absTuteur);
                            
                                 }, icon: Icon(Icons.delete))
                              ],),
                            )
                             
                      ]),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      margin:const EdgeInsets.only(right:20,left:20),
                      width: screenWidth-40,
                      height:1,
                      color:Color(0xFF33548A),
                    ),
                    SizedBox(height: 15,),
                    Expanded(
                      child: Padding(
                        padding:EdgeInsets.only(left:20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                             Text(widget.user.status=="Enseignant"?"${arg[0]}":justificationisLoaded?justification!.objet:"",style:TextStyle(color:Colors.black,fontSize:20,fontWeight:FontWeight.bold)),
                             SizedBox(height: 5,),
                             Text(widget.user.status=="Enseignant"?"${arg[1]}":justificationisLoaded?justification!.text:"",style:TextStyle(color:Colors.black,fontSize:16)),
                      
                                  ]),
                      )),
                    SizedBox(height: 10,),
                    Visibility(
                      visible: widget.hasFile,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                          onTap:()=> openFile(),
                            child: Container(
                              width: 160,
                              height: 50,
                              decoration:BoxDecoration(
                                color:Color(0xFF33548A),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child:Center(
                                child:  Visibility(
                                  visible: widget.user.status=="Enseignant" || justificationisLoaded,
                                  child: Text("Visualiser le fichier",style:TextStyle(color:Colors.black,fontSize:16)),
                                  replacement:CircularProgressIndicator(),),
                              ),
                            ),
                          ),
                        
                          InkWell(
                           onTap:()=>_downloadFile(),
                            child: Container(
                               width: 50,
                               height: 50,
                               decoration:BoxDecoration(
                                color:Color(0xFF789DC9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child:Visibility(
                                visible: widget.user.status=="Enseignant" || justificationisLoaded,
                                child: Icon(Icons.download,color:Colors.black),
                                 replacement:CircularProgressIndicator(),),
                               
                            ),
                          ),
                         
                          
                               
                        ],
                      
                      ),
                  
                    ),
                    SizedBox(height: 10,)
                  ],)
              ),
            ]),
          ),);
          }),
    );
  }
}
class Abs {
  
  int? justificationId;

  Abs({
        this.justificationId,
    });

  Map toJson() => {
        'justification_id': justificationId,
       
      };
}