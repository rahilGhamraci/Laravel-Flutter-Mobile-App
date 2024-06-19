import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'models/Convocation.dart';
import 'models/Tuteur.dart';
import 'models/User.dart';
import 'providers/convocation_state.dart';
import 'services/api_calls.dart';

class ConvocationPostForm extends StatefulWidget {
  final int roomId;
  final User user;
  int? id;
  int? index;
  final String operation;
  final List<Convocation>? convocations;
  ConvocationState? convocationState;
  ConvocationPostForm({super.key, required this.convocations,this.index,required this.roomId,required this.user,required this.operation,this.id, this.convocationState});

  @override
  State<ConvocationPostForm> createState() => _ConvocationPostFormState();
}

class _ConvocationPostFormState extends State<ConvocationPostForm> {
   var arg=Get.arguments;
  final formKey=GlobalKey<FormState>();
  var _titre;
  var _contenu;
  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedfile;
  File? fileToUpload;
  bool filepicked=false;
  Color couleur=Colors.black;
  Tuteur? selectedTutor;


   List<Tuteur>? tuteurs;
  bool tuteursAreLoaded=false;
  int tuteursLength=0;
   List<Convocation>? convocation;
   Convocation? conv;
   TextEditingController _titreController = TextEditingController();
     TextEditingController _contenuController = TextEditingController();

  void initState(){
     super.initState();
      if(widget.operation!= "Post"){
      
         _titreController.text = arg[0];
        _contenuController.text = arg[1];
   
     }
     getData();
    
  }
  getData() async{
     
      var jsonAnnonceBody=  await ApiCalls().get('/liste_tuteurs/'+widget.roomId.toString(),widget.user.token);
     if(jsonAnnonceBody != null){
       tuteurs=tuteurFromJson(jsonAnnonceBody);
     if(tuteurs!=null){
      setState(() {
        tuteursAreLoaded=true;
        tuteursLength = tuteurs!.length;
        
      });
     }

     }else{
        setState(() {
        tuteursAreLoaded=true;
        tuteursLength = 0;
        
      });

     }
     
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
  Future<int> add()async{
      if(formKey.currentState!.validate() ){
        var uri = Uri.parse(ApiCalls.baseUrl+"/convocations");
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
      request.fields['room_id'] = widget.roomId.toString();
      request.fields['tuteur_id'] = selectedTutor!.id.toString();
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.statusCode);
          if(response.statusCode==200){
        print(response.body);
         convocation=convocationFromJson(response.body);
         if(convocation!=null){
              setState(() {
                 conv=convocation![0];
                 print(conv!.nom);
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
  Future<int> update()async{
     var uri = Uri.parse(ApiCalls.baseUrl+"/convocations/"+widget.id.toString());
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
      if(selectedTutor!=null){
        request.fields['tuteur_id'] = selectedTutor!.id.toString();
      }
    
     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
       if(response.statusCode==200){
        print(response.body);
         convocation=convocationFromJson(response.body);
         if(convocation!=null){
              setState(() {
                 conv=convocation![0];
                 print(conv!.nom);
              });
            
         }
        
       }
       print(response.statusCode);
       return response.statusCode;
      
     
    } catch (e) {
      print(e);
     
    }
  return 0;

  }
  @override
  Widget build(BuildContext context) {
     final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
    return Scaffold(
      key:_scaffoldKey,
      body:Container(
        padding: const EdgeInsets.only(left: 20,right:20,top:40),
        child: Form(
          key:formKey,
          child: SingleChildScrollView(
            reverse:true,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       
                       IconButton(icon:Icon(Icons.arrow_back_ios,color:Colors.black,size:16),onPressed:(){
                       
                        Get.back();
                        // Get.to(ListePublicationsPage(color:Color(0xFF789DC9),id:widget.id), arguments:[ "Annonces","amrous imane"]);
                       }),
                       Text("Ajout Convocation",style:TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
                     ],
                   ),
                   SizedBox(height: 20,),
                 Visibility(
                  visible: tuteursAreLoaded,
                   child:tuteursLength>0? DropdownButton(
                    value: selectedTutor!=null ? selectedTutor : null,
                    isExpanded: true,
                    onChanged: (newValue){
                            setState(() {
                              selectedTutor=newValue as Tuteur?;
                              print(newValue);
                            });}, 
                   items: tuteurs!.map((item) {
                   return DropdownMenuItem(
                     value: item,
                     child: new Text(item.nom+" "+item.prenom),
                     );
                     }).toList(), 
                     ):Text("aucun tuteur à afficher"),
                     replacement: const Center(child: CircularProgressIndicator()),
                 ),
                    SizedBox(height: 10,),
                   TextFormField(
                    controller:  _titreController,
                    decoration: InputDecoration(
                      hintText: "Entrez un titre",
                      border:OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(10))
                        ),),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Ce champ est obligatoir";
                      }
                    },
                    onChanged: (value){
                      setState(() {
                            _titre=value;
                        });
                    },
                   ),
                    SizedBox(height: 20,),
                   TextFormField(
                      controller:_contenuController,
                      minLines:1,
                      maxLines:5,
                    decoration: InputDecoration(
                      hintText:"Entrez une description",
                      border:OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(10))
                        ),),
                      
                    validator: (value){
                      if(value!.isEmpty){
                        return "Ce champ est obligatoir";
                      }
                    },
                     onChanged: (value){
                      setState(() {
                        _contenu=value;
                      });
                    },
                   ),
                   SizedBox(height: 5,),
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
                    
                    Container(
                      margin: EdgeInsets.only(top:40),
                     padding: EdgeInsets.only(right: 30,bottom: 50),
                     child: widget.operation=="Post"?FloatingActionButton(
                     onPressed: () async{
                      if(selectedTutor==null){
                         final snackBar=SnackBar(content: Text("veuillez d'abord selectionner un tuteur",));
                       _scaffoldKey.currentState!.showSnackBar(snackBar);
                      }else{
                           int x= await add() ;
                      print(x);
                      if(x==200){
                        final snackBar=SnackBar(content: Text("Convocation Ajoutée",));
                       _scaffoldKey.currentState!.showSnackBar(snackBar);
                       
                         widget.convocations!.insert(0,conv!) ;
                         widget.convocationState!.convocations= widget.convocations!;
                         Navigator.of(context).pop(widget.convocations!);
                      }else{
                        final snackBar=SnackBar(content: Text("veuillez réessayer",));
                       _scaffoldKey.currentState!.showSnackBar(snackBar);
                      }
                      }
                   
                     },
                     child: Icon(Icons.add,color: Colors.white,),
                     backgroundColor: Color(0xFF33548A),
                     elevation: 0,
                  ):FloatingActionButton(
                     onPressed: () async{
                    
                           int x= await update() ;
                      print(x);
                      if(x==200){
                        final snackBar=SnackBar(content: Text("Convocation Modifiée",));
                       _scaffoldKey.currentState!.showSnackBar(snackBar);
                        final index = widget.convocations!.indexWhere((c) => c.id == conv!.id);
                         widget.convocations![index] = conv!;
                        widget.convocationState!.convocations= widget.convocations!;
                       Navigator.of(context).pop(widget.convocations!);
                      }else{
                        final snackBar=SnackBar(content: Text("veuillez réessayer",));
                       _scaffoldKey.currentState!.showSnackBar(snackBar);
                      }
                     
                   
                     },
                     child: Icon(Icons.change_circle,color: Colors.white,),
                     backgroundColor: Color(0xFF33548A),
                     elevation: 0,
                  )
                ),
            
                   ],)
                  
              ]),
          ),
           
          
          )
          ) 
          ,);
  }
}