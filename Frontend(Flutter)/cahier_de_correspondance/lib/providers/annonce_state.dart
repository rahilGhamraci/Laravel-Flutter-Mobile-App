
import '../models/Annonce.dart';
import 'package:flutter/material.dart';


class AnnonceState extends ChangeNotifier {
  late List<Annonce>_annonces;

  List<Annonce> get annonces => _annonces;

    set annonces(List<Annonce> newValue) {
    _annonces = newValue;
    notifyListeners();
  }
  
}