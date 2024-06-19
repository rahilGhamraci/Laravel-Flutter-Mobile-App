import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'models/Edt.dart';
import 'models/User.dart';
import 'services/api_calls.dart';

class EdtPage extends StatefulWidget {
  int? id;
  final User  user;
   EdtPage({super.key, this.id,required this.user});

  @override
  State<EdtPage> createState() => _EdtPageState();
}

class _EdtPageState extends State<EdtPage> {
    bool edtsAreLoaded=false;
  var edtsLength=0;
  List<Edt>? edts;
  bool onLoading=false;

   void initState(){
     super.initState();
     getData();
    
  }
  getData() async{
      if(widget.user.status=="Tuteur"){
          var jsonAnnonceBody=  await ApiCalls().get('/edts/'+widget.id.toString(),widget.user.token);
          if(jsonAnnonceBody != null){
              edts=edtFromJson(jsonAnnonceBody);
     if(edts!=null){
      setState(() {
        edtsAreLoaded=true;
        edtsLength = edts!.length;
      });
     }

          }else{
             setState(() {
        edtsAreLoaded=true;
        edtsLength =0;
      });

          }
        
      }else{
         var jsonAnnonceBody=  await ApiCalls().get('/edts',widget.user.token);
          if(jsonAnnonceBody != null){
      edts=edtFromJson(jsonAnnonceBody);
     if(edts!=null){
      setState(() {
        edtsAreLoaded=true;
        edtsLength = edts!.length;
      });
     }
          }else{
             setState(() {
               edtsAreLoaded=true;
               edtsLength = 0;
      });

          }
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
       var response =await dio.download(ApiCalls.baseUrl+"/edts_telechargement/"+id.toString(), '${dirPath}/${fileName}');
        print(response.statusCode);
        if(response.statusCode==200){
            setState((){
      onLoading=false;
    });
        OpenFile.open('${dirPath}/${fileName}');
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
        body:Stack(
          children: [
            Column(
              children: [
                 SizedBox(height:10),
                Expanded(
                  child: Visibility(
                    visible: edtsAreLoaded,
                    child: edtsLength>0 ?ListView.builder(
                            itemCount: edtsLength,
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
                                        Text(edts![index].anneeScolaire,style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.bold)),
                                        SizedBox(height: 5,),
                                        Text(edts![index].trimestre+" Trimestre",style:TextStyle(color:Colors.grey,fontSize:12)),
                                        SizedBox(height: 5,),
                                       
                                    ],),
                                     IconButton(icon:Icon(Icons.download,),onPressed:(){
                                    _downloadFile(edts![index].id,edts![index].fileName);
                                                
                                   }),
                                  ],
                                ),
                              );
                            }):Center(child:Text("aucun emploi à afficher")),
                          replacement: const Center(child: CircularProgressIndicator()),
                  )),
              ],
            ),
               Visibility(
              visible: onLoading,
              child: Padding(
                padding:EdgeInsets.only(top:160,left:150),
                child: CircularProgressIndicator())
            )
          ],
        )
      ),
    );
  }
}