import 'package:cahier_de_correspondance/tuteur_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/EnfantsTuteur.dart';

import 'models/User.dart';
import 'services/api_calls.dart';

class EnfantsTuteurPage extends StatefulWidget {
  final User user;
  const EnfantsTuteurPage({super.key,required this.user});

  @override
  State<EnfantsTuteurPage> createState() => _EnfantsTuteurPageState();
}

class _EnfantsTuteurPageState extends State<EnfantsTuteurPage> {

   bool elvsAreLoaded=false;
  var elvsLength=0;
  List<EnfantsTuteur>? elvs;

   void initState(){
     super.initState();
     getData();
    
  }
 getData() async{
     
      var jsonAnnonceBody=  await ApiCalls().get('/eleves_tuteur',widget.user.token);
      if(jsonAnnonceBody != null){
          elvs=enfantsTuteurFromJson(jsonAnnonceBody);
     if(elvs!=null){
      setState(() {
        elvsAreLoaded=true;
        elvsLength = elvs!.length;
      });
     }

      }else{
          setState(() {
            elvsAreLoaded=true;
            elvsLength = 0;
      });

      }
    
     
  }
  @override
  Widget build(BuildContext context) {
     final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.only(top:20),
        child: Visibility(
          visible: elvsAreLoaded,
          child: ListView.builder(
            itemCount:elvsLength,
            itemBuilder: (BuildContext context,int index){
              return InkWell(
                onTap:(){ 
                
                  Get.to(TuteurHomePage(idElv: elvs![index].id,user:widget.user), arguments:[ elvs![index].nom+" "+elvs![index].prenom]);},
                child: Container(
                  width:screenWidth-40 ,
                  height: 100,
                  margin: const EdgeInsets.only(bottom:10, right: 20,left:20),
                  padding: const EdgeInsets.only(top:20,left: 10,right: 10),
                 decoration: BoxDecoration(
                 borderRadius:BorderRadius.circular(15),
                    color:Color(0xFF789DC9),     
                    boxShadow: [
                    BoxShadow(
                      blurRadius:10,
                                        offset:Offset(5,9) ,
                                        color: Colors.black.withOpacity(0.5)
                                        ),]
                                      ),
                   child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     
                      Row(
                        mainAxisAlignment:MainAxisAlignment.start,
                        children: [
                          Text(elvs![index].nom+" "+elvs![index].prenom,style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:16)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.start,
                        children: [
                          Text(elvs![index].niveau+" "+elvs![index].section,style:TextStyle(color:Colors.black,fontSize:14)),
                        ],
                      ),
                      SizedBox(height: 10,)
              
                    ],
                   ),
                ),
              );
            }),
            replacement: const Center(child: CircularProgressIndicator()),
        ),
      )
    );
  }
}