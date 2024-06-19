
import 'package:flutter/material.dart';

import '../models/Devoir.dart';


class DevoirState extends ChangeNotifier {
  late List<Devoir>_devoirs;

  List<Devoir> get devoirs => _devoirs;

    set devoirs(List<Devoir> newValue) {
    _devoirs = newValue;
    notifyListeners();
  }
  
}