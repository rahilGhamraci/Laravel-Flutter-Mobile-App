import 'package:flutter/material.dart';

import '../models/Convocation.dart';

class ConvocationState extends ChangeNotifier {
  late List<Convocation>_convocations;

  List<Convocation> get convocations => _convocations;

    set convocations(List<Convocation> newValue) {
    _convocations = newValue;
    notifyListeners();
  }
  
}


