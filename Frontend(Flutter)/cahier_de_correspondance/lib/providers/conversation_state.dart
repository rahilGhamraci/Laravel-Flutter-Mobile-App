
import '../models/Conversation.dart';
import 'package:flutter/material.dart';


class ConversationState extends ChangeNotifier {
  late Conversation _conversation;

  Conversation get conversation => _conversation;

    set conversation(ConversationnewValue) {
    _conversation= ConversationnewValue;
    notifyListeners();
  }
  
}