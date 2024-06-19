import 'package:flutter/material.dart';

import '../models/Justification.dart';

class JustificationState extends ChangeNotifier {
  late Justification _justification;

  Justification get justification => _justification;

  set justification(Justification newValue) {
    _justification = newValue;
    notifyListeners();
  }
}