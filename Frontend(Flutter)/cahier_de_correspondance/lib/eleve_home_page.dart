import 'package:cahier_de_correspondance/annonces_adm.dart';
import 'package:cahier_de_correspondance/bulletins_page.dart';
import 'package:cahier_de_correspondance/listes_presence.dart';
import 'package:cahier_de_correspondance/room_page.dart';
import 'package:cahier_de_correspondance/rooms.dart';
import 'package:flutter/material.dart';

import 'edt_page.dart';
import 'liste_publications_page.dart';
import 'models/User.dart';
class EleveHomePage extends StatefulWidget {
  /*int id;
  String nom;
  String prenom;*/
  final User user;
   EleveHomePage({super.key,required this.user,
  //required this.id,required this.nom,required this.prenom
  });

  @override
  State<EleveHomePage> createState() => _EleveHomePageState();
}

class _EleveHomePageState extends State<EleveHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 4, vsync: this);
    return Scaffold(
      body:Column(
         crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          SizedBox(height:15),
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
                   child:Text("Emploi du temps"))
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
                //Tab(text: "Publications",),
                //Tab(text: "Listes Presence",),
                //Tab(text: "Convocations",),
              ]),
          ),
         ),
         Expanded(
           child: TabBarView(
                controller: _tabController,
              children: [
                Rooms(user:widget.user),
                EdtPage(user:widget.user),
                BulletinsPage(user:widget.user),
                AnnoncesAdm(user:widget.user,id:widget.user.id),
                
         
              ]),
         ),
       

      ])
    );
  }
}

