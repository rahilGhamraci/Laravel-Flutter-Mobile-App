import 'dart:ui';
import 'package:cahier_de_correspondance/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
   final PageController _pageController = PageController(initialPage: 0);
  List<String> texts=["l'application qui reunit toute la famille pédagogique","Contactez vos enseignants plus facilement","Suivez la scolarisation de vos enfants plus facilement","Restez toujours en contact avec vos élèves et leurs parents"];
  List<String> animation=["22472-campus-library-school-building-maison-002-mocca-animation","student","101465-back-to-school-brighter-colors","126604-school-background-removed"];
  List<Color> colors=[Color(0xFF789DC9),Color(0xFF33548A),Color(0xFF789DC9),Color(0xFFE67F4F)];
  bool dernierepage=false;

  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;
    final screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:Colors.white,
      body:Column(
        children: [
          Container(
            height:screenHeight*(3/4),
            child: PageView.builder(
              onPageChanged:(index){
                if(index==3){
                  setState(() {
                    dernierepage=true;
                  });
                }else{
                   setState(() {
                    dernierepage=false;
                  });
                }
              },
                  itemCount: 4,
                  controller: _pageController,
                  itemBuilder: ((context, index) {
                    return  Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              SizedBox(height: 220,),
                              Expanded(child: Column(children: [
                                Lottie.asset(
                                    'animations/${animation[index]}.json',
                                    height: 200,
                                    alignment: Alignment.centerLeft,
                                    reverse:true,
                                    repeat: true,
                                    fit:BoxFit.cover,
                                    ),
                                  
                          
                          
                            SizedBox(height: 20,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(texts[index],textAlign:TextAlign.center,style:TextStyle(fontSize: 20,color:colors[index],fontWeight:FontWeight.bold))),
                              SizedBox(height: 50,),
                                   Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (indexDots){
                              return Container(
                                margin: const EdgeInsets.only(bottom: 2),
                                height: 8,
                                width: index==indexDots?15:8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: index==indexDots?colors[index]:colors[index].withOpacity(0.3),
                                  ),
                                  
                          );
                      
                        }),
                        ),
                              ],)),
                             
                        ],),
                    );
                    
                  })),
          ),
                 SizedBox(height: 90,),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                     child: InkWell(
                      onTap:()async{
                          if (dernierepage) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool('isWelcomeDisplayed', true);
                                  Get.offAll(Login());
                            } else {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            }
                      },
                       child: Container(
                        width: screenWidth,
                        margin: EdgeInsets.only(bottom: 20),
                        height:50,
                        decoration: BoxDecoration(
                          borderRadius:BorderRadius.circular(20),
                          color: dernierepage?Color(0xFFE67F4F):Color(0xFF33548A)),
                          child:Center(child: Text(dernierepage?"Commencer":"Suivant",style:TextStyle(color:Colors.white,fontSize: 20)))
                                 ),
                     ),
                   ),
        ],
      ),
           
       
    );
  }
}

