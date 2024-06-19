import 'dart:io';

import 'package:cahier_de_correspondance/models/DevoirsRemis.dart';
import 'package:cahier_de_correspondance/providers/delai_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'models/Devoir.dart';
import 'models/User.dart';
import 'services/api_calls.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class ListeDevoirsRemis extends StatefulWidget {
  final int id;
  final User user;
    bool? delai;
    DelaiState? delaiState;
  ListeDevoirsRemis({super.key, this.delai,this.delaiState,
  required this.id,required this.user});

  @override
  State<ListeDevoirsRemis> createState() => _ListeDevoirsRemisState();
}

class _ListeDevoirsRemisState extends State<ListeDevoirsRemis> {
  List<DevoirsRemis>? devoirs;
  bool devoirsAreLoaded=false;
  int devoirsLength=0;
   List<Devoir>? devoir;
   Devoir? dvr;
   bool backButtonPressed = false;
   bool onLoading=false;

   
  void initState(){
     super.initState();
        BackButtonInterceptor.add(backButtonInterceptor);
     getData();
    
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
  getData() async{
     
      var jsonAnnonceBody=  await ApiCalls().get('/devoirs_remis_enst/'+widget.id.toString(),widget.user.token);
       if(jsonAnnonceBody != null){
        devoirs=devoirsRemisFromJson(jsonAnnonceBody);
     if(devoirs!=null){
      setState(() {
        devoirsAreLoaded=true;
        devoirsLength = devoirs!.length;
      });
     }

       }else{
          setState(() {
        devoirsAreLoaded=true;
        devoirsLength = 0;
      });

       }
      
     
  }
    Future _downloadFile(int id,String fileName)async{
      setState((){
        onLoading=true;
      });
      var dio= Dio();
      final dirPath=await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
      final tempDir = await getTemporaryDirectory();
        bool fileExists = await File('$dirPath/${fileName}').exists();
        print("1/"+fileExists.toString());
        if (!fileExists) {
        fileExists = await File('${tempDir.path}/${fileName}').exists();
        print("2/"+fileExists.toString());
       }
        if (fileExists) {
          print("il existe deja");
          print('${dirPath}/${fileName}');
            setState((){
        onLoading=false;
      });
          OpenFile.open('${dirPath}/${fileName}');
        }else{
       var response =await dio.download(ApiCalls.baseUrl+"/devoirs_remis_telechargement/"+id.toString(), '${dirPath}/${fileName}');
        print(response.statusCode);
          setState((){
        onLoading=false;
      });
        OpenFile.open('${dirPath}/${fileName}');

        }
    }


    Future<int> changerDelai(bool _delai) async{
       var uri = Uri.parse(ApiCalls.baseUrl+"/devoirs/"+widget.id.toString());
   final request = http.MultipartRequest('POST', uri);
       
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
     request.headers.addAll(headers);
     if(_delai==true){
         request.fields['delai'] = "1";
     }else{
        request.fields['delai'] = "0";
     }
   
     
   
    
     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.statusCode);
      if(response.statusCode==200){
        print(response.body);
         devoir=devoirFromJson(response.body);
         if(devoir!=null){
            
            setState(() {
              widget.delai=devoir![0].delai;
            },);
         }
        
       }
       return response.statusCode;
      
     
    } catch (e) {
      print(e);
     
    }
    return 0;

    }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
      
         if (backButtonPressed) {
        
          backButtonPressed = false; // Reset the flag
          setState(() {});
        
            print("Navigating back with annonces: ${widget.delai}");
            Navigator.of(context).pop(widget.delai);
          return false; // Prevent the default back button behavior
        }

        return true;
      },
      child: Scaffold(
        body:Column(
          children: [
            SizedBox(height: 40,),
            Row(children: [
              IconButton(icon:Icon(Icons.arrow_back_ios,color:Colors.black,size:16),onPressed:(){
                        //Get.back();
                          Navigator.of(context).pop(widget.delai);
                       }),
                Text("Liste des devoirs remis ",style:TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
                Expanded(child:Container()),
                 InkWell(
                  onTap:()async {
                        print(widget.delai!);
                        
                      int x= await changerDelai(! widget.delai!);
                   
                  },
                  child: Text(widget.delai! ?"Délai échu":"En cours",style:TextStyle(color: widget.delai! ?Color(0xFFE67F4F):Color(0xFF789DC9),fontSize: 14,))),
                 SizedBox(width: 5,),
            ],),
            SizedBox(height: 5,),
            Expanded(
              child: Stack(
                children: [
                  Visibility(
                    visible: devoirsAreLoaded,
                    child: devoirsLength>0?ListView.builder(
                      itemCount: devoirsLength,
                      itemBuilder: (BuildContext context,int index){
                        return Container(
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
                                  Text(devoirs![index].elvNom+" "+devoirs![index].elvPrenom,style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5,),
                                  Text("Remis le "+devoirs![index].createdAt,style:TextStyle(color:Colors.grey,fontSize:12)),
                                  SizedBox(height: 5,),
                                 
                              ],),
                               IconButton(icon:Icon(Icons.download,),onPressed:(){
                                _downloadFile(devoirs![index].id,devoirs![index].fileName);
                                          
                             }),
                            ],
                          ),
                        );
                      }):Center( child:Text("Auncun devoir n'est remis",style:TextStyle(color:Colors.grey,fontSize:12)),),
                       replacement: const Center(child:CircularProgressIndicator(),),
                  ),
                  Visibility(
              visible: onLoading,
              child: Padding(
                padding:EdgeInsets.only(top:160,left:150),
                child: CircularProgressIndicator())
            )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}