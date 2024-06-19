import 'package:cahier_de_correspondance/listes_presence.dart';
import 'package:cahier_de_correspondance/room_page.dart';
import 'package:flutter/material.dart';

import 'annonces_adm.dart';
import 'convocations_page.dart';
import 'liste_publications_page.dart';
import 'models/User.dart';
class EnstHomePage extends StatefulWidget {
  int id;
  String nom;
  String prenom;
  User user;
   EnstHomePage({super.key,
  required this.id,required this.nom,required this.prenom,required this.user});

  @override
  State<EnstHomePage> createState() => _EnstHomePageState();
}

class _EnstHomePageState extends State<EnstHomePage> with TickerProviderStateMixin {
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
                   child:Text("Publications"))
                )),
                 Tab(child:Container(
                  height:35,
                  padding:EdgeInsets.only(right:10,left:10),
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:Border.all(color:Color(0xFF789DC9),width:1)
                   ),
                   child:Align(alignment:Alignment.center,
                   child:Text("Listes de presence"))
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
                RoomPage(user:widget.user,id:widget.id,nom:widget.nom,prenom:widget.prenom),
                ListesPresence(user:widget.user,id:widget.id),
                Conovocations(user:widget.user,id:widget.id),
                  AnnoncesAdm(user:widget.user,id:widget.id),
         
              ]),
         ),
       

      ])
    );
  }
}

