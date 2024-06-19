
import 'dart:io';
import 'package:cahier_de_correspondance/liste_devoirs_remis.dart';
import 'package:cahier_de_correspondance/models/DevoirRemis.dart';
import 'package:cahier_de_correspondance/post_form.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:external_path/external_path.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:cahier_de_correspondance/models/menu_items.dart';
import 'package:provider/provider.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';


import 'models/User.dart';
import 'providers/delai_state.dart';
import 'services/api_calls.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final User user;
  final DateTime date;
  String? name;
  bool? delai;
   DelaiState? delaiState;
  
  final bool hasFile;
   DetailPage({super.key,this.name,this.delai,this.delaiState,
  required this.id,
   required this.user,
   required this.date,
  required this.hasFile});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var arg=Get.arguments;
  var _id;
  var _hasFile;
  bool devoirRemis=false;
  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedfile;
  File? fileToUpload;
  bool onSaving=false;
  bool onUpdating=false;
   bool onVisulaizing=false;
   bool onLoading=false;
   bool onLoading1=false;
   bool onDeterminerSiDevoirRemis =true;
  DevoirRemis? devoir;
  bool show=true;
  String str="";
  bool backButtonPressed = false;

  List<SendMenuItems> menuItems = [
    SendMenuItems(text: "Visualiser le devoir ", icons: Icons.insert_drive_file, color: Colors.amber),
    SendMenuItems(text: "Modifier", icons: Icons.change_circle,color: Colors.blue),
    SendMenuItems(text: "Supprimer", icons: Icons.delete, color: Colors.orange),
    
  ];

  @override
  void initState(){
     super.initState();
         BackButtonInterceptor.add(backButtonInterceptor);
         print("delai"); print(widget.delai);
     show=true;
     verfierSiDevoirRemis();
     _hasFile=widget.hasFile;
     _id=widget.id;
     if(widget.name !=null){
      setState(() {
        str=widget.name??"";
      });
     }

    
    
  }

   @override
  void dispose() {
    
    BackButtonInterceptor.remove(backButtonInterceptor);
    super.dispose();
  }

bool backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    
    backButtonPressed = true;
    return false;
  }
   verfierSiDevoirRemis() async{
    print("ghgghgfhgf");
    print(widget.id.toString());
     var jsonResponse=  await ApiCalls().getDevoir('/devoirs_remis/'+widget.id.toString(),widget.user.token);
     
     print(jsonResponse.statusCode);
      if(jsonResponse.statusCode==200){
         devoir=devoirRemisFromJson(jsonResponse.body);
        
     if(devoir!=null){
      setState(() {
        print(devoir!.id.toString());
       devoirRemis=true;
      });
     }
      }
       setState((){
          onDeterminerSiDevoirRemis=false;
         });
     
     
    
  }
   Future openDevoirRemis()async{
    setState(() {
      onVisulaizing=true;
    });
    print("devoir remis opne");
    print(devoir!.id.toString());
     final file =await downloadFile(ApiCalls.baseUrl+"/devoirs_remis_telechargement/"+devoir!.id.toString(),devoir!.fileName);
         if(file==null) {  print("file null");  return;}
         print('Path:${file.path}');
         OpenFile.open(file.path);
         setState(() {
      onVisulaizing=false;
    });
  }
  void updateDevoirRemis()async{
    setState((){
      onUpdating=true;
    });
    print(onUpdating);
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
            
        });
      
         var uri = Uri.parse(ApiCalls.baseUrl+"/devoirs_remis/"+devoir!.id.toString());
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
     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.statusCode);
      if(response.statusCode==200){
       devoir=devoirRemisFromJson(response.body);
        setState((){
      onUpdating=false;
    });
      
      }
    } catch (e) {
      print(e);
      
    }
      }
    } catch (e) {
      print(e);
    }
  }
  Future<int> deleteDevoirRemis() async {
    var statusCode=  await ApiCalls().delete('/devoirs_remis/'+devoir!.id.toString(),widget.user.token);
     
     if(statusCode==200){
      setState(() {
       devoirRemis=false;
       
      });
      
     }
     return statusCode;
  }

  void ShowMenuDevoirRemis(){
   
    showModalBottomSheet(
      context: context,
       shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30))
       ),
      builder: (context){
        return  StatefulBuilder(builder: (context, setState) {
          return Container(
              height: MediaQuery.of(context).size.height/2,
             
              child:Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                ),
                child:Column(children: [
                  SizedBox(height: 16,),
                    Center(
                      child: Container(
                        height: 4,
                        width: 50,
                        color: Colors.grey.shade200,
                      ),
                    ),
                     SizedBox(height: 10,),
                     InkWell(
                      onTap:()async{openDevoirRemis();},
                       child: Container(
                            padding: EdgeInsets.only(top: 10,bottom: 10),
                            child:ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: menuItems[0].color.shade50,
                                ),
                                height: 50,
                                width: 50,
                                child: Icon(menuItems[0].icons,size: 20,color: menuItems[0].color.shade400,),
                              ),
                              title: Text(menuItems[0].text),
                            ),
                          ),
                     ),
                        InkWell(
                          onTap:()=>updateDevoirRemis(),
                          child: Container(
                            padding: EdgeInsets.only(top: 10,bottom: 10),
                            child:ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: menuItems[1].color.shade50,
                                ),
                                height: 50,
                                width: 50,
                                child: Icon(menuItems[1].icons,size: 20,color: menuItems[1].color.shade400,),
                              ),
                              title: Text(menuItems[1].text),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap:()async{
                            int x= await deleteDevoirRemis(); 
                            if(x==200){
                              Navigator.pop(context);
                            }
                            
                            },
                          child: Container(
                            padding: EdgeInsets.only(top: 10,bottom: 10),
                            child:ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: menuItems[2].color.shade50,
                                ),
                                height: 50,
                                width: 50,
                                child: Icon(menuItems[2].icons,size: 20,color: menuItems[2].color.shade400,),
                              ),
                              title: Text(menuItems[2].text),
                            ),
                          ),
                        ),
                      
                ],)
              ),
            );
        }
        );
        ;
      });
  }

  void SubmitFile()async{
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
            onSaving=true;
        });
      
         var uri = Uri.parse(ApiCalls.baseUrl+"/devoirs_remis");
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
      print(request.files.length);
      print(request.headers);
      request.fields['devoir_id'] = widget.id.toString();
     print(request.fields);
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
       print(response.body);
      print(response.statusCode);
      if(response.statusCode==200){
           devoir=devoirRemisFromJson(response.body);
        setState(() {
          devoirRemis=true;
          onSaving=false;
        });
       
       
        
         
      }
    } catch (e) {
      print(e);
      
    }
      }
    } catch (e) {
      print(e);
    }
  }
 
  Future _downloadFile()async{
    setState((){
      onLoading=true;
    });
   print(_id);
    var dio= Dio();
     
      final dirPath=await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
       final tempDir = await getTemporaryDirectory();
        bool fileExists = await File('$dirPath/${arg[3]}').exists();
        print("1/"+fileExists.toString());
        if (!fileExists) {
        fileExists = await File('${tempDir.path}/${arg[3]}').exists();
        print("2/"+fileExists.toString());
       }
        if (fileExists) {
          print("il existe deja");
          //await File('$dirPath/${arg[3]}').delete();
          print(_id.toString());
          print('${dirPath}/${arg[3]}');
          OpenFile.open('${dirPath}/${arg[3]}');
        }else{
          print('${dirPath}/${arg[3]}'); 
      if("${arg[0]}"=="Annonces" || "${arg[0]}"=="Annonces Administratives"){
       
         var response =await dio.download(ApiCalls.baseUrl+"/annonces_telechargement/"+_id.toString(), '${dirPath}/${arg[3]}');
        print(response.statusCode);
        OpenFile.open('${dirPath}/${arg[3]}');
      }else if ("${arg[0]}"=="Supports"){
         print(_id);
          var response =await dio.download(ApiCalls.baseUrl+"/supports_telechargement/"+_id.toString(), '${dirPath}/${arg[3]}');
          print(response.statusCode);
          OpenFile.open('${dirPath}/${arg[3]}');
      }else if ("${arg[0]}"=="Devoirs"){
          var response =await dio.download(ApiCalls.baseUrl+"/devoirs_telechargement/"+_id.toString(), '${dirPath}/${arg[3]}');
          print(response.statusCode);
          OpenFile.open('${dirPath}/${arg[3]}');
      }
        }
     
      setState((){
      onLoading=false;
    });
   
  }
   Future openFile()async{
     setState((){
      onLoading1=true;
    });
    print(_id);
    print("${arg[0]}");
    if("${arg[0]}"=="Annonces"|| "${arg[0]}"=="Annonces Administratives"){
        final file =await downloadFile(ApiCalls.baseUrl+"/annonces_telechargement/"+_id.toString(),"${arg[3]}");
         if(file==null) return;
         print('Path:${file.path}');
          setState((){
      onLoading1=false;
    });
         OpenFile.open(file.path);
      }else if ("${arg[0]}"=="Supports"){
          final file =await downloadFile(ApiCalls.baseUrl+"/supports_telechargement/"+_id.toString(),"${arg[3]}");
          if(file==null) return;
         print('Path:${file.path}');
          setState((){
      onLoading1=false;
    });
         OpenFile.open(file.path);
      }else if ("${arg[0]}"=="Devoirs"){
          final file =await downloadFile(ApiCalls.baseUrl+"/devoirs_telechargement/"+_id.toString(),"${arg[3]}");
          if(file==null) return;
          print('Path:${file.path}');
           setState((){
      onLoading1=false;
    });
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
 
 DelaiState ? delaiState;
  @override
  Widget build(BuildContext context) {
    
     final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
     final screenHeight=MediaQuery.of(context).size.height;
    final statusBarHeight=MediaQuery.of(context).padding.top;
    final screenWidth=MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
      
         if (backButtonPressed) {
        
          backButtonPressed = false; 
          setState(() {});
            if("${arg[0]}"=="Devoirs"){
                        Navigator.of(context).pop(widget.delai);
                      }else{
                        Get.back();
                      }
            
          return false; // anuller le comporetement par défaut
        }

        return true;
      },
      child: StatefulBuilder(
       builder: (context, setState) {
            
                   delaiState = Provider.of<DelaiState>(context);
              
            
        
              return Scaffold(
                key: _scaffoldKey,
          body: Stack(
            children: [
              Container(
                 width: double.maxFinite,
                  height: screenHeight+statusBarHeight,
                  padding: const EdgeInsets.only(top:35, right: 10,left:10,),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      InkWell(
                         onTap: (){
                          if("${arg[0]}"=="Devoirs" ){
                            Navigator.of(context).pop(widget.delai);
                          }else{
                            Get.back();
                          }
                            
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
                      Text("Détail",style:TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
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
                             //str[0].toUpperCase()
                             child:Center(child: Text( "${arg[0]}"=="Annonces Administratives"?"A":str[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:16)))
                            ),
                            SizedBox(width: 10,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text( "${arg[0]}"=="Annonces Administratives"?"Administration":str,style:TextStyle(color:Colors.black,fontSize:14)),
                              Text(DateFormat('dd/MM/yyyy').format(widget.date).toString(),style:TextStyle(color:Colors.grey,fontSize:12)),
                                             
                            ],),
                            //SizedBox(width: 130,),
                            Expanded(child:Container()),
                              Visibility(
                                visible: widget.user.status=="Enseignant" && "${arg[0]}"=="Devoirs",
                                child: IconButton(icon:Icon(Icons.assignment,),onPressed:()async{
                                  final newDelai = await Get.to<bool>(
                                                      () =>ListeDevoirsRemis(
                                                        delaiState: delaiState,
                                                        delai:widget.delai,
                                                        user:widget.user,
                                                        id:widget.id ),
                                                      arguments: [],
                                                       );
                                                       //if (mounted) {}
                                                       setState(() {
                                                        widget.delai=newDelai;
                                                       });
                                  // Get.to(ListeDevoirsRemis(delai:widget.delai,user:widget.user,id:widget.id ), arguments:[]);
                                            
                                                   }),
                              ),
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
                             Text("${arg[1]}",style:TextStyle(color:Colors.black,fontSize:20,fontWeight:FontWeight.bold)),
                             SizedBox(height: 5,),
                             Text("${arg[2]}",style:TextStyle(color:Colors.black,fontSize:14)),
                      
                                  ]),
                      )),
                    SizedBox(height: 10,),
                    Visibility(
                      visible: _hasFile,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                child:  onLoading1? CircularProgressIndicator():Text("Visualiser le fichier",style:TextStyle(color:Colors.white,fontSize:16)),
                              ),
                            ),
                          ),
                            (widget.user.status=="Eleve" && "${arg[0]}"=="Devoirs")?SizedBox(width: 5,):Expanded(child: Container()),
                          InkWell(
                           onTap:()=>_downloadFile(),
                            child: Container(
                               width: 50,
                               height: 50,
                               decoration:BoxDecoration(
                                color:Color(0xFF789DC9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child:onLoading? CircularProgressIndicator():Icon(Icons.download,color:Colors.black)
                            ),
                          ),
                          SizedBox(width: 5,),
                           Visibility(
                            visible: widget.user.status=="Eleve" && "${arg[0]}"=="Devoirs",
                             child: InkWell(
                             onTap: !onDeterminerSiDevoirRemis?devoirRemis?(){ShowMenuDevoirRemis();}:()=>SubmitFile():(){},
                              child: Container(
                                padding: EdgeInsets.only(left: 5),
                                 width: 110,
                                 height: 50,
                                 decoration:BoxDecoration(
                                  color:Color(0xFF789DC9),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child:Visibility(
                                  visible: !onSaving,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      onDeterminerSiDevoirRemis?CircularProgressIndicator():!devoirRemis?Text("Remettre",style:TextStyle(color:Colors.black,fontSize:16)):Text("Remis",style:TextStyle(color:Colors.black,fontSize:16)),
                                       onDeterminerSiDevoirRemis?Container():!devoirRemis? Icon(Icons.assignment_return,color:Colors.black):Icon(Icons.assignment_turned_in ,color:Colors.black),
                                    ],
                                  ),
                                  replacement: const Center(child:CircularProgressIndicator(),),
                                )
                              ),
                                             ),
                           ),
                               
                        ],
                      
                      ),
                      replacement: Visibility(
                        visible: widget.user.status=="Eleve" && "${arg[0]}"=="Devoirs",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                          InkWell(
                              onTap:(){
                                if(devoirRemis){
                                   ShowMenuDevoirRemis();
                                }else{
                                  if(!widget.delai!){
                                       SubmitFile();
                                  }else{
                                    print("délai dépassé",);
                                       final snackBar=SnackBar(content: Text("délai dépassé, contactez votre prof s'il s'agit d'une erreur",));
                                        _scaffoldKey.currentState!.showSnackBar(snackBar);
                                  }
                                 
                                }
                               },
                              child: Container(
                                 width: 110,
                                 height: 50,
                                 padding: EdgeInsets.only(left: 5),
                                 decoration:BoxDecoration(
                                  color:Color(0xFF789DC9),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child:Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    !devoirRemis?Text("Remettre",style:TextStyle(color:Colors.black,fontSize:16)):Text("Remis",style:TextStyle(color:Colors.black,fontSize:16)),
                                    !devoirRemis? Icon(Icons.assignment_return,color:Colors.black):Icon(Icons.assignment_turned_in ,color:Colors.black),
                                    
                                  ],
                                )
                              ),
                                             ),
      
                        ],)),
                    ),
                    SizedBox(height: 10,)
                  ],)
              ),
              Visibility(
              visible: onUpdating || onVisulaizing,
              child: Padding(
                padding:EdgeInsets.only(top:160,left:150),
                child: CircularProgressIndicator())
            )
            ],
            
          ),
          );}
      ),
    );
  }
}