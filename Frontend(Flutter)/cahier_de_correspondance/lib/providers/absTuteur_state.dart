import '../models/AbsTuteur.dart';
import 'package:flutter/material.dart';


class AbsTuteurState extends ChangeNotifier {
  late List<AbsTuteur>_absTuteur;

  List<AbsTuteur> get absTuteur => _absTuteur;

    set absTuteur(List<AbsTuteur> newValue) {
    _absTuteur = newValue;
    notifyListeners();
  }
  
}