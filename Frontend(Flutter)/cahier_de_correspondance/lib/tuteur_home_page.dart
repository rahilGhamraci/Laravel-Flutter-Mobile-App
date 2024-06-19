import 'package:cahier_de_correspondance/absences_tuteur.dart';
import 'package:cahier_de_correspondance/annonces_adm.dart';
import 'package:cahier_de_correspondance/bulletins_page.dart';
import 'package:cahier_de_correspondance/room_page.dart';
import 'package:cahier_de_correspondance/rooms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'convocations_page.dart';
import 'edt_page.dart';
import 'liste_publications_page.dart';
import 'models/User.dart';
class TuteurHomePage extends StatefulWidget {
   final int  idElv;
   final User user;
   TuteurHomePage({super.key, required this.idElv,required this.user
  });

  @override
  State<TuteurHomePage> createState() => _TuteurHomePageState();
}

class _TuteurHomePageState extends State<TuteurHomePage> with TickerProviderStateMixin {
     var arg=Get.arguments;
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 6, vsync: this);
    return Scaffold(
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
      body:Column(
         crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          SizedBox(height:30),
          Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
               labelPadding: const EdgeInsets.only(left:10, right:10),
               controller: _tabController,
               labelColor:  Colors.black,
               unselectedLabelColor: Colors.grey,
               isScrollable: true,
               indicatorSize: TabBarIndicatorSize.label,
               indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color:Color(0xFF789DC9),
               ),
               

              tabs: [
                Tab(child:Container(
                  height:35,
                  padding:EdgeInsets.only(right:10,left:10),
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:Border.all(color:Color(0xFF789DC9),width:1)
                   ),
                   child:Align(alignment:Alignment.center,
                   child:Text("Rooms"))
                )),
                 Tab(child:Container(
                  height:35,
                  padding:EdgeInsets.only(right:10,left:10),
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:Border.all(color:Color(0xFF789DC9),width:1)
                   ),
                   child:Align(alignment:Alignment.center,
                   child:Text("Absences"))
                )),
                 Tab(child:Container(
                  height:35,
                  padding:EdgeInsets.only(right:10,left:10),
                 
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:Border.all(color:Color(0xFF789DC9),width:1)
                   ),
                   child:Align(alignment:Alignment.center,
                   child:Text("Convocations"))
                )),
                Tab(child:Container(
                  height:35,
                  padding:EdgeInsets.only(right:10,left:10),
                 
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:Border.all(color:Color(0xFF789DC9),width:1)
                   ),
                   child:Align(alignment:Alignment.center,
                   child:Text("Emplois du temp"))
                )),
                Tab(child:Container(
                  height:35,
                  padding:EdgeInsets.only(right:10,left:10),
                 
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:Border.all(color:Color(0xFF789DC9),width:1)
                   ),
                   child:Align(alignment:Alignment.center,
                   child:Text("Notes"))
                )),
                 Tab(child:Container(
                  height:35,
                  padding:EdgeInsets.only(right:10,left:10),
                 
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:Border.all(color:Color(0xFF789DC9),width:1)
                   ),
                   child:Align(alignment:Alignment.center,
                   child:Text("Annonces Administratives"))
                )),
              ]),
          ),
         ),
         Expanded(
           child: TabBarView(
                controller: _tabController,
              children: [
                Rooms(user:widget.user,idElv: widget.idElv),
                AbsencesTuteurPage(user:widget.user,idElv: widget.idElv),
                Conovocations(user:widget.user,id:widget.idElv),
                EdtPage(id:widget.idElv,user:widget.user),
                BulletinsPage(id:widget.idElv,user:widget.user),
                AnnoncesAdm(user:widget.user,id:widget.idElv),
         
              ]),
         ),
       

      ])
    );
  }
}

