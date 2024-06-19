import 'package:cahier_de_correspondance/eleve_home_page.dart';
import 'package:cahier_de_correspondance/enfants_tuteur_page.dart';
import 'package:flutter/material.dart';
import 'package:cahier_de_correspondance/room_page.dart';
import 'package:cahier_de_correspondance/rooms.dart';
import 'package:cahier_de_correspondance/chats_page.dart';

import 'models/User.dart';
class MainPage extends StatefulWidget {
  final User user;
  const MainPage({super.key,
  required this.user});
  
  @override
  State<MainPage> createState() => MainPageState();

}

class MainPageState extends State<MainPage> {
  @override
  int currentIndex=0;
   List pages=[];
   void initState(){
     super.initState();
     print(widget.user.status);
     if(widget.user.status=="Tuteur"){
            pages=[
             EnfantsTuteurPage(user:widget.user),
             ChatPage(user:widget.user)
    
  ];
     }else if(widget.user.status=="Eleve"){
            pages=[
             EleveHomePage(user:widget.user),
             ChatPage(user:widget.user)
    
  ];
     }else {
         pages=[
          Rooms(user: widget.user,),
          ChatPage(user:widget.user)
    
  ];
     }
   
   }
  double xOffset=0;
  double yOffset=0;
  double scaleFactor=1;
  bool isDrawerOpen=false;
   
   void onTap(int index){
    setState(() {
      currentIndex=index;
    });

   
   }
  
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:Duration(microseconds: 250),
      transform: Matrix4.translationValues(xOffset,yOffset,0)..scale(scaleFactor),
      child: Scaffold(
        appBar: AppBar(
         
          backgroundColor: Colors.white,
          leading: isDrawerOpen?IconButton(icon:Icon(Icons.arrow_back_ios,color:Colors.black),onPressed:(){
                     setState(() {
                    
                      xOffset=0;
                       yOffset=0;
                       scaleFactor=1;
                       isDrawerOpen=false;
     });
                  }):
          IconButton(icon:Icon(Icons.menu_rounded,color:Colors.black),onPressed:(){
                     setState(() {
                    
                      xOffset=230;
                       yOffset=150;
                       scaleFactor=0.6;
                       isDrawerOpen=true;
     });
                  }),
          title:Text(widget.user.status=="Tuteur"?"Elèves":widget.user.status=="Eleve"?"Publications":"Rooms",style:TextStyle(color:Colors.black,fontSize:16)),
          centerTitle: true,
          elevation: 0,
          actions: [
           
                  CircleAvatar(
                    backgroundColor:Color(0xFF789DC9),
                    child:Text(widget.user.name[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:16))
                  ),
                  SizedBox(width: 10,),
          ]),
        body:pages.length>0?pages[currentIndex]:Container(child: Center(child: CircularProgressIndicator())),
         backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
           unselectedFontSize: 0,
           selectedFontSize: 0,
           backgroundColor: Colors.white,
           selectedItemColor: Color(0xFF789DC9),
           unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle:TextStyle(color:Color(0xFF789DC9), fontSize: 10),
            unselectedLabelStyle:TextStyle(color:Colors.grey,fontSize: 10),
            currentIndex: currentIndex,
            onTap: onTap,
    
        items: [
            BottomNavigationBarItem(label: "home",icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: "chat",icon: Icon(Icons.chat_bubble_outline_rounded)),
          
          ]),
      ),
    );
  }

}