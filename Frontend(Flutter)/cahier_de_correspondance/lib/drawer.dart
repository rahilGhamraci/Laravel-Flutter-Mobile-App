import 'package:flutter/material.dart';
import 'package:cahier_de_correspondance/main_page.dart';
import 'package:cahier_de_correspondance/menu_page.dart';

import 'models/User.dart';
class DrawerPage extends StatefulWidget {
  final User user;
  
  const DrawerPage({super.key,
  required this.user});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(children: [
          MenuPage(user:widget.user),
          MainPage(user:widget.user)
      ],)
    );
  }
}