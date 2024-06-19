import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'services/api_calls.dart';
import 'models/User.dart';


class ConvocationDetailPage extends StatefulWidget {
    final bool hasFile;
  final int id;
  final  DateTime date;
  final User user;
  const ConvocationDetailPage({super.key,
  required this.hasFile,
  required this.id,
  required this.date,
  required this.user,});

  @override
  State<ConvocationDetailPage> createState() => _ConvocationDetailPageState();
}

class _ConvocationDetailPageState extends State<ConvocationDetailPage> {
  var arg=Get.arguments;
  String str="";

   @override
  void initState(){
     super.initState();
     setState(() {
       str=arg[3];
     });
  }

  Future openFile()async{
    final file =await downloadFile(ApiCalls.baseUrl+"/convocations_telechargement/"+widget.id.toString(),"${arg[2]}");
         if(file==null) return;
         print('Path:${file.path}');
         OpenFile.open(file.path);
   

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
        var response =await dio.download(ApiCalls.baseUrl+"/convocations_telechargement/"+widget.id.toString(), '${dirPath}/${arg[2]}');
        print(response.statusCode);
        if(response.statusCode==200){
           OpenFile.open('${dirPath}/${arg[2]}'); 
        }
        
        }
   
  }
  @override
  Widget build(BuildContext context) {
     final screenHeight=MediaQuery.of(context).size.height;
    final statusBarHeight=MediaQuery.of(context).padding.top;
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
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
                      Get.back();
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
                Text("Détail Convocation",style:TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
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
                       child:Center(child: Text(str[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:16)))
                      ),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text("${arg[3]}"+" "+"${arg[4]}",style:TextStyle(color:Colors.black,fontSize:14)),
                        Text("le "+DateFormat('dd/MM/yyyy').format(widget.date),style:TextStyle(color:Colors.grey,fontSize:12)),
                                       
                      ],),
                      SizedBox(width: 140,),
                       
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
                       Text("${arg[0]}",style:TextStyle(color:Colors.black,fontSize:20,fontWeight:FontWeight.bold)),
                       SizedBox(height: 5,),
                       Text("${arg[1]}",style:TextStyle(color:Colors.black,fontSize:16)),
                
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
                          child:  Text("Visualiser le fichier",style:TextStyle(color:Colors.white,fontSize:16)),
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
                        child:Icon(Icons.download,color:Colors.black)
                      ),
                    ),
                   
                    
                         
                  ],
                
                ),
            
              ),
              SizedBox(height: 10,)
            ],)
        ),);
   
  }
}