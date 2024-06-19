

import 'package:flutter/material.dart';


class DelaiState extends ChangeNotifier {
  late bool _delai;

  bool get delai => _delai;

    set delai(bool newValue) {
    _delai= newValue;
    notifyListeners();
  }
  
}