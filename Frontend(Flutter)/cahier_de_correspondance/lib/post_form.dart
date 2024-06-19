import 'package:cahier_de_correspondance/models/Justification.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'models/AbsTuteur.dart';
import 'models/Absence.dart';
import 'models/Annonce.dart';
import 'models/Devoir.dart';
import 'models/Support.dart';
import 'models/User.dart';
import 'providers/absTuteur_state.dart';
import 'providers/annonce_state.dart';
import 'providers/devoir_state.dart';
import 'providers/justification_state.dart';
import 'providers/support_state.dart';
import 'services/api_calls.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';



class PostForm extends StatefulWidget {
   int? id;
   final String operation;
   List <AbsTuteur>? selectedAbs;
   List <AbsTuteur>? absTuteur;
   final User user;
    JustificationState? justificationState;
    AbsTuteurState? absTuteurState;
    List<Annonce>? annonces;
    AnnonceState? annonceState;
    List<Support>? supports;
    SupportState? supportState;
    List<Devoir>? devoirs;
    DevoirState? devoirState;
   PostForm({super.key,
   this.id,
   required this.operation,
   required this.user,
   this.selectedAbs,this.absTuteur,this.absTuteurState,
   this.justificationState,this.annonces,this.annonceState,this.supports,this.supportState,this.devoirs,this.devoirState,});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
   var arg=Get.arguments;
   Justification? justification;
  final formKey=GlobalKey<FormState>();
  var _titre;
  var _contenu;
  var _objet;
  var _text;
  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedfile;
  File? fileToUpload;
  bool filepicked=false;
  var _id;
  Color couleur=Colors.black;
  String typepublication="";
  List<Support>? support;
   Support? sup;
   List<Annonce>? annonce;
   Annonce? ann;
   List<Devoir>? devoir;
   Devoir? dvr;
   bool backButtonPressed = false;

    TextEditingController _titreController = TextEditingController();
     TextEditingController _contenuController = TextEditingController();

  @override
  void initState(){
     super.initState();
     BackButtonInterceptor.add(backButtonInterceptor);
     if(widget.operation!= "Post"){
      
         _titreController.text = arg[1];
        _contenuController.text = arg[2];
   
     }
     if("${arg[0]}"=="Annonces"){
        setState(() {
          typepublication="Annonce";
        });
     }else if("${arg[0]}"=="Supports"){
         typepublication="Support";
     }else if("${arg[0]}"=="Devoirs"){
        typepublication="Devoir";
     }else if("${arg[0]}"=="Justifications"){
        typepublication="Justification";
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
  
  void pickFile()async{
    try {
      result=await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if(result!=null){
        setState(() {

           fileName=result!.files.first.name;
            print(fileName);
           pickedfile=result!.files.first;
          fileToUpload=File(pickedfile!.path.toString());
          filepicked=true;
        });
      }
    } catch (e) {
      print(e);
    }
  }


  
  Future<int> sendFile()async{
      print("ngdd");
    if("${arg[0]}"=="Annonces"){
      if(formKey.currentState!.validate() ){
        var uri = Uri.parse(ApiCalls.baseUrl+"/annonces");
        final request = http.MultipartRequest('POST', uri);
        if(filepicked){
        final mimeTypeData =
        lookupMimeType(fileToUpload!.path.toString(), headerBytes: [0xFF, 0xD8])?.split('/');
       final file = await http.MultipartFile.fromPath('file', fileToUpload!.path.toString(),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
        request.files.add(file);
        }
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
     request.headers.addAll(headers);

      request.fields['titre'] = _titre;
      request.fields['contenu'] = _contenu;
      request.fields['room_id'] = widget.id.toString();
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.statusCode);
      if(response.statusCode==200){
        print(response.body);
         annonce=annonceFromJson(response.body);
         if(annonce!=null){
              setState(() {
                 ann=annonce![0];
                
              });
            
         }
        
       }
      return response.statusCode;
    } catch (e) {
      print(e);
      
    }
  }  

    }else if("${arg[0]}"=="Supports"){
      if(formKey.currentState!.validate() ){
        if(!filepicked){
           setState(() {
             couleur=Colors.red;
           });
        }else{
        var uri = Uri.parse(ApiCalls.baseUrl+"/supports");
        final request = http.MultipartRequest('POST', uri);
        final mimeTypeData =
        lookupMimeType(fileToUpload!.path.toString(), headerBytes: [0xFF, 0xD8])?.split('/');
       final file = await http.MultipartFile.fromPath('file', fileToUpload!.path.toString(),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
        request.files.add(file);
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
     request.headers.addAll(headers);

      request.fields['titre'] = _titre;
      request.fields['contenu'] = _contenu;
      request.fields['room_id'] = widget.id.toString();
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode==200){
        print(response.body);
         support=supportFromJson(response.body);
         if(support!=null){
              setState(() {
                 sup=support![0];
                
              });
            
         }
        
       }
      
      return response.statusCode;
    } catch (e) {
      print(e);
      
    }
        }
  }  


    }else  if("${arg[0]}"=="Devoirs"){
         if(formKey.currentState!.validate() ){
        var uri = Uri.parse(ApiCalls.baseUrl+"/devoirs");
        final request = http.MultipartRequest('POST', uri);
        if(filepicked){
        final mimeTypeData =
        lookupMimeType(fileToUpload!.path.toString(), headerBytes: [0xFF, 0xD8])?.split('/');
       final file = await http.MultipartFile.fromPath('file', fileToUpload!.path.toString(),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
        request.files.add(file);
        }
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
     request.headers.addAll(headers);

      request.fields['titre'] = _titre;
      request.fields['contenu'] = _contenu;
      request.fields['room_id'] = widget.id.toString();
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body);
        if(response.statusCode==200){
        print(response.body);
         devoir=devoirFromJson(response.body);
         if(devoir!=null){
              setState(() {
                 dvr=devoir![0];
                
              });
            
         }
        
       }
     return response.statusCode;
    } catch (e) {
      print(e);
     
    }
  }  
    }else  if("${arg[0]}"=="Justifications"){
         if(formKey.currentState!.validate() ){
        var uri = Uri.parse(ApiCalls.baseUrl+"/justifications");
        final request = http.MultipartRequest('POST', uri);
        if(filepicked){
        final mimeTypeData =
        lookupMimeType(fileToUpload!.path.toString(), headerBytes: [0xFF, 0xD8])?.split('/');
       final file = await http.MultipartFile.fromPath('file', fileToUpload!.path.toString(),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
        request.files.add(file);
        }
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
     request.headers.addAll(headers);

      request.fields['objet'] = _objet;
      request.fields['text'] = _text;
     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      if(response.statusCode==200){
       Justification j=justificationFromJson(response.body);
       print(widget.selectedAbs!.length);
      
        
               Abs a=Abs(justificationId:j.id);
               String objJson=jsonEncode(a);
               print(objJson);
       for (var i = 0; i < widget.selectedAbs!.length; i++) {
              
               var jsonAnnonceBody=  await ApiCalls().post('/absences/'+widget.selectedAbs![i].id.toString(),widget.user.token,objJson);
              /* Absence absUpdated=absenceFromJson(jsonAnnonceBody);
               print(absUpdated.id);*/
                final index = widget.absTuteur!.indexWhere((a) => a.id == widget.selectedAbs![i].id);
                       widget.absTuteur![index].justificationId = j.id;
                       widget.absTuteur![index].isSelected=false;
    
        
         }
      
      }
     
      
     return response.statusCode;
    } catch (e) {
      print(e);
     
    }
  }  
    }
          return 0;       
}

Future<int> update()async{
 
  if("${arg[0]}"=="Justifications"){
    
   var uri = Uri.parse(ApiCalls.baseUrl+"/justifications/"+widget.id.toString());
   final request = http.MultipartRequest('POST', uri);
        if(filepicked){
        final mimeTypeData =
        lookupMimeType(fileToUpload!.path.toString(), headerBytes: [0xFF, 0xD8])?.split('/');
       final file = await http.MultipartFile.fromPath('file', fileToUpload!.path.toString(),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
        request.files.add(file);
        }
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
     request.headers.addAll(headers);
      if(_objet!=null){
            request.fields['objet'] = _objet;
      }
       if(_text!=null){
              request.fields['text'] = _text;
      }
    
     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode==200){
        justification=justificationFromJson(response.body);
       print(justification!.id);
       
      
      }
       print(response.statusCode);
       return response.statusCode;
      
     
    } catch (e) {
      print(e);
     
    }
  }else if("${arg[0]}"=="Annonces"){
     var uri = Uri.parse(ApiCalls.baseUrl+"/annonces/"+widget.id.toString());
   final request = http.MultipartRequest('POST', uri);
        if(filepicked){
        final mimeTypeData =
        lookupMimeType(fileToUpload!.path.toString(), headerBytes: [0xFF, 0xD8])?.split('/');
       final file = await http.MultipartFile.fromPath('file', fileToUpload!.path.toString(),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
        request.files.add(file);
        }
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
     request.headers.addAll(headers);
      if(_titre!=null){
            request.fields['titre'] = _titre;
      }
       if(_contenu!=null){
              request.fields['contenu'] = _contenu;
      }
    
     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
       print(response.statusCode);
        if(response.statusCode==200){
        print(response.body);
         annonce=annonceFromJson(response.body);
         if(annonce!=null){
              setState(() {
                 ann=annonce![0];
                
              });
            
         }
        
       }
       return response.statusCode;
      
     
    } catch (e) {
      print(e);
     
    }

  }else if ("${arg[0]}"=="Supports"){
    var uri = Uri.parse(ApiCalls.baseUrl+"/supports/"+widget.id.toString());
   final request = http.MultipartRequest('POST', uri);
        if(filepicked){
        final mimeTypeData =
        lookupMimeType(fileToUpload!.path.toString(), headerBytes: [0xFF, 0xD8])?.split('/');
       final file = await http.MultipartFile.fromPath('file', fileToUpload!.path.toString(),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
        request.files.add(file);
        }
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
     request.headers.addAll(headers);
       if(_titre!=null){
            request.fields['titre'] = _titre;
      }
       if(_contenu!=null){
              request.fields['contenu'] = _contenu;
      }
    
     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
        if(response.statusCode==200){
        print(response.body);
         support=supportFromJson(response.body);
         if(support!=null){
              setState(() {
                 sup=support![0];
                
              });
            
         }
        
       }
       return response.statusCode;
      
     
    } catch (e) {
      print(e);
     
    }

  }else if ("${arg[0]}"=="Devoirs"){
    var uri = Uri.parse(ApiCalls.baseUrl+"/devoirs/"+widget.id.toString());
   final request = http.MultipartRequest('POST', uri);
        if(filepicked){
        final mimeTypeData =
        lookupMimeType(fileToUpload!.path.toString(), headerBytes: [0xFF, 0xD8])?.split('/');
       final file = await http.MultipartFile.fromPath('file', fileToUpload!.path.toString(),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
        request.files.add(file);
        }
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
     request.headers.addAll(headers);
       if(_titre!=null){
            request.fields['titre'] = _titre;
      }
       if(_contenu!=null){
              request.fields['contenu'] = _contenu;
      }
    
     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode==200){
        print(response.body);
         devoir=devoirFromJson(response.body);
         if(devoir!=null){
              setState(() {
                 dvr=devoir![0];
                
              });
            
         }
        
       }
       return response.statusCode;
      
     
    } catch (e) {
      print(e);
     
    }

  }
  return 0;
}

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: () async {
     
         if (backButtonPressed) {
        
          backButtonPressed = false; // Reset the flag
          setState(() {});
            
          if("${arg[0]}"=="Annonces"){
                        Navigator.of(context).pop(widget.annonces!);
                 
                       }else if("${arg[0]}"=="Supports"){
                        Navigator.of(context).pop(widget.supports!);
    
                       } else if("${arg[0]}"=="Devoirs"){
                        Navigator.of(context).pop(widget.devoirs!);
    
                       } else if("${arg[0]}"=="Justifications"){
                        if(widget.operation=="Post"){
                           Navigator.of(context).pop(widget.absTuteur!);
    
                        }else{
                          Navigator.of(context).pop(justification);
    
                        }
    
                       }

          return false; // Prevent the default back button behavior
        }

        return true;
      },
      child: Scaffold(
        key:_scaffoldKey,
        body:Container(
          padding: const EdgeInsets.only(left: 20,right:20,top:40),
          child: Form(
            key:formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       
                       IconButton(icon:Icon(Icons.arrow_back_ios,color:Colors.black,size:16),onPressed:(){
                       if("${arg[0]}"=="Annonces"){
                        Navigator.of(context).pop(widget.annonces!);
                 
                       }else if("${arg[0]}"=="Supports"){
                        Navigator.of(context).pop(widget.supports!);
    
                       } else if("${arg[0]}"=="Devoirs"){
                        Navigator.of(context).pop(widget.devoirs!);
    
                       } else if("${arg[0]}"=="Justifications"){
                        if(widget.operation=="Post"){
                           Navigator.of(context).pop(widget.absTuteur!);
    
                        }else{
                          Navigator.of(context).pop(justification);
    
                        }
    
                       }
                        //Get.back();
                      }),
                       Text((widget.operation=="Post"?"Ajout ":"Modification ")+typepublication,style:TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
                     ],
                   ),
                   SizedBox(height: 20,),
                   TextFormField(
                    controller: _titreController,
                    decoration: InputDecoration(
                      hintText: "${arg[0]}"=="Justifications"?"Entrez l'objet de votre justification":"Entrez le titre",
                      border:OutlineInputBorder(
                        borderRadius:BorderRadius.all(Radius.circular(10))
                      )
                      ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Ce champ est obligatoir";
                      }
                    },
                    onChanged: (value){
                      setState(() {
                        if("${arg[0]}"=="Justifications"){
                          _objet=value;}else{
                            _titre=value;
                          }
                        
                      });
                    },
                   ),
                    SizedBox(height: 20,),
                   TextFormField(
                    controller: _contenuController,
                    minLines:1,
                    maxLines:5,
                    keyboardType:TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText:"${arg[0]}"=="Justifications"?"Entrez le text votre justification" :"Entrez une description",
                      border:OutlineInputBorder(
                        borderRadius:BorderRadius.all(Radius.circular(10))
                      )),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Ce champ est obligatoir";
                      }
                    },
                     onChanged: (value){
                      setState(() {
                       if("${arg[0]}"=="Justifications"){
                          _text=value;
                          }else{
                            _contenu=value;
                          }
                      });
                    },
                   ),
                   SizedBox(height: 30,),
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    InkWell(
                      onTap:()=>pickFile(),
                      child: Visibility(
                        visible: !filepicked,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Text("joindre un fichier",style:TextStyle(color: couleur,fontSize: 12,)),
                             SizedBox(width:2),
                             Icon(Icons.attach_file,color:couleur,size:15),
                          ],),
                          replacement:  Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Text("1 fichier join",style:TextStyle(color: Colors.black,fontSize: 12,)),
                             SizedBox(width:2),
                             Icon(Icons.attach_file,size:15),
                          ],),
                      ),
                    ),
                    
                    Visibility(
                      visible:widget.operation=="Post",
                      child: Container(
                        margin: EdgeInsets.only(top:40),
                       padding: EdgeInsets.only(right: 30,bottom: 50),
                       child: FloatingActionButton(
                       onPressed: () async{
                       
                        int x= await sendFile() ;
                        print(x);
                        if(x==200){
                          final snackBar=SnackBar(content: Text(typepublication+" Ajouté(e)",));
                         _scaffoldKey.currentState!.showSnackBar(snackBar);
                         if("${arg[0]}"=="Annonces"){
                             widget.annonces!.insert(0,ann!) ;
                         widget.annonceState!.annonces= widget.annonces!;
                         Navigator.of(context).pop(widget.annonces!);
    
                          }else if("${arg[0]}"=="Supports"){
                            widget.supports!.insert(0,sup!) ;
                         widget.supportState!.supports= widget.supports!;
                         Navigator.of(context).pop(widget.supports!);
    
                          }else if("${arg[0]}"=="Devoirs"){
                            widget.devoirs!.insert(0,dvr!) ;
                         widget.devoirState!.devoirs= widget.devoirs!;
                         Navigator.of(context).pop(widget.devoirs!);
    
                          }else if("${arg[0]}"=="Justifications"){
                            
                           
                         widget.absTuteurState!.absTuteur= widget.absTuteur!;
                         Navigator.of(context).pop(widget.absTuteur!);
    
                          }
    
                        }else{
                          final snackBar=SnackBar(content: Text("veuillez réessayer",));
                         _scaffoldKey.currentState!.showSnackBar(snackBar);
                        }
                       },
                       child: Icon(Icons.add,color: Colors.white,),
                       backgroundColor: Color(0xFF33548A),
                       elevation: 0,
                                    ),
                                  ),
                                  replacement: Container(
                        margin: EdgeInsets.only(top:40),
                       padding: EdgeInsets.only(right: 30,bottom: 50),
                       child: FloatingActionButton(
                       onPressed: () async{
                        int x= await update() ;
                        print(x);
                        if(x==200){
                          final snackBar=SnackBar(content: Text(typepublication+" Modifi(e)",));
                          _scaffoldKey.currentState!.showSnackBar(snackBar);
                          if("${arg[0]}"=="Annonces"){
                            final index = widget.annonces!.indexWhere((c) => c.id == ann!.id);
                         widget.annonces![index] = ann!;
                         widget.annonceState!.annonces= widget.annonces!;
                         Navigator.of(context).pop(widget.annonces!);
    
                          }else if("${arg[0]}"=="Supports"){
                            final index = widget.supports!.indexWhere((c) => c.id == sup!.id);
                         widget.supports![index] = sup!;
                         widget.supportState!.supports= widget.supports!;
                         Navigator.of(context).pop(widget.supports!);
    
                          }else if("${arg[0]}"=="Devoirs"){
                            final index = widget.devoirs!.indexWhere((c) => c.id == dvr!.id);
                         widget.devoirs![index] = dvr!;
                         widget.devoirState!.devoirs= widget.devoirs!;
                         Navigator.of(context).pop(widget.devoirs!);
    
                          }else if("${arg[0]}"=="Justifications"){
                            
                            widget.justificationState!.justification = justification!;
                           Navigator.of(context).pop(justification);
    
                          }
                         
                        }else{
                          final snackBar=SnackBar(content: Text("veuillez réessayer",));
                         _scaffoldKey.currentState!.showSnackBar(snackBar);
                        }
                       },
                       child: Icon(Icons.change_circle,color: Colors.white,),
                       backgroundColor: Color(0xFF33548A),
                       elevation: 0,
                                    ),
                                  ),
                    ),
            
                   ],)
                  
              ]),
             
            
            )
            ) 
            ,),
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