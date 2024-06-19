import 'package:cahier_de_correspondance/enst_home_page.dart';
import 'package:flutter/material.dart';
import 'package:cahier_de_correspondance/room_page.dart';
import 'package:cahier_de_correspondance/rooms.dart';
import 'package:cahier_de_correspondance/chats_page.dart';
import 'package:get/get.dart';

import 'models/User.dart';
class SecondMainPage extends StatefulWidget {
  final int id;
  final String nom;
  final String prenom;
  final User  user;
  const SecondMainPage({super.key,
  required this.id,
  required this.nom,
  required this.prenom,
   required this.user,
  });
  
  @override
  State<SecondMainPage> createState() => SecondMainPageState();

}

class SecondMainPageState extends State<SecondMainPage> {
    var arg=Get.arguments;
  @override
  int currentIndex=0;
  int _id=0;
  List pages=[];

  void initState(){
     super.initState();
     _id=widget.id;
     currentIndex=0;
     print(_id);
     if (widget.user.status=="Enseignant"){
      pages=[
       EnstHomePage(user:widget.user,id: _id,nom:widget.nom,prenom:widget.prenom),
       ChatPage(user:widget.user)
    ];
     }else {
        pages=[
        RoomPage(user:widget.user,id: _id,nom:widget.nom,prenom:widget.prenom),
        ChatPage(user:widget.user)
    ];
     }
   
  }
  /* */
  /*  */

  
  
  
  
  
   
   void onTap(int index){
    setState(() {
      currentIndex=index;
    });

   
   }
  
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
         
          backgroundColor: Colors.white,
          leading: IconButton(icon:Icon(Icons.arrow_back_ios,color:Colors.black),onPressed:(){
        
               Get.back();
                  }),
     
          title:Text("${arg[0]}",style:TextStyle(color:Colors.black,fontSize:16)),
          centerTitle: true,
          elevation: 0,
          actions: [
             CircleAvatar(
                    backgroundColor:Color(0xFF789DC9),
                    child:Text(widget.user.name[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:16))
                  ),
                  SizedBox(width: 10,),
          ]),
          //list?.elementAt(<index>) ?? ""
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
      );
    
  }

  
}