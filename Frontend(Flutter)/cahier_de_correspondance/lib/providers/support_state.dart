
import 'package:flutter/material.dart';

import '../models/Support.dart';


class SupportState extends ChangeNotifier {
  late List<Support>_supports;

  List<Support> get supports => _supports;

    set supports(List<Support> newValue) {
    _supports = newValue;
    notifyListeners();
  }
  
}