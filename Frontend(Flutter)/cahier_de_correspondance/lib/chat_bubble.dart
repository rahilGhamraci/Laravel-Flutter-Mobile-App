import 'package:cahier_de_correspondance/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget{
  
  final String contenu;
  final String type;
  final String  reponse;
 
  
  ChatBubble({required this.contenu,required this.type,required this.reponse});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
      child: Align(
        alignment: (widget.type == "Receiver"?Alignment.topLeft:Alignment.topRight),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
              if (widget.reponse != null) // Display indicator if it's a reply
              Container(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  widget.reponse,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: (widget.type  == "Receiver"?Colors.white:Colors.grey.shade200),
              ),
              padding: EdgeInsets.all(16),
              child: Text(widget.contenu),
            ),
          ],
        ),
      ),
    );
  }
}