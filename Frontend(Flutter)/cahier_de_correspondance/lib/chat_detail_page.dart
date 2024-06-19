import 'package:cahier_de_correspondance/chat_bubble.dart';
import 'package:cahier_de_correspondance/models/Conversation.dart';
import 'package:cahier_de_correspondance/providers/conversation_state.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cahier_de_correspondance/models/Message.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'models/User.dart';
import 'services/api_calls.dart';


import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_socket_channel/io.dart';
import 'dart:io';
import 'dart:convert';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:flutter/scheduler.dart';



class ChatDetailPage extends StatefulWidget{
  final int id;
  final User user;
   Conversation? conversation;
   ConversationState? conversationState;
   ChatDetailPage({super.key,required this.user,this.conversation, this.conversationState,
 
  required this.id,
  });
  
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {



 
var arg=Get.arguments;
  List <Message>? messages;
  List<Message> messageList=[];
  
     var messagesAreLoaded=false;
        var isScrolling=true;
     var messagesLength=0;
     String str="";
    
     TextEditingController msg=TextEditingController();
     late ScrollController _scrollController ;
     FocusNode _focusNode = FocusNode();
     bool isReply=false;
      String reply="";
      bool backButtonPressed = false;
     
     
     void markAsReaded()async{
      var uri = Uri.parse(ApiCalls.baseUrl + "/conversation_read/"+widget.id.toString());
    final request = http.MultipartRequest('POST', uri);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
    request.headers.addAll(headers);
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print('readed');
    }

     }
     

   
   

    void initState(){
     super.initState();
       BackButtonInterceptor.add(backButtonInterceptor);
     setState(() {
       str=arg[0];
     });
     getData(widget.id);
      _scrollController = ScrollController();
      print(isScrolling);
     SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
      
      markAsReaded();
      //print(isScrolling);

 
connectionWebSocket();
 


 
  }
  void _scrollToBottom() {
  if (_scrollController.hasClients && mounted) {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
     setState(() {
        isScrolling=false;
     });
  } else {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }
}
  
connectionWebSocket()async{
final String serverUrl = 'ws://192.168.100.10:6001/app/ABCDEFG?protocol=7&client=websocket&version=7.0.3&flash=false';

WebSocket.connect(serverUrl).then((WebSocket socket) {
  print('Connected to server');

  // subscribe to the "public.newmessage.1" channel
  socket.add('{"event":"pusher:subscribe","data":{"channel":"public.newmessage.1","event":"NewMessageEvent"}}');


  socket.listen((data) {
    print("Received data: $data");
   Map<String, dynamic> jsonData = json.decode(data);
 if (jsonData.containsKey("data")) {
    var dataObj = json.decode(jsonData["data"]);

    if (dataObj is Map && dataObj.containsKey("message")) {
      Message newMessage = Message.fromJson(dataObj["message"]);
      print(newMessage.conversationId);
      print(widget.id);
      print(newMessage.conversationId==widget.id);
      print(newMessage.userId!=widget.user.id);
      if(mounted){
        if(newMessage.conversationId==widget.id && newMessage.userId!=widget.user.id){
           setState(() {
              newMessage.type="Receiver";
              messages!.add(newMessage);
             messagesLength=messagesLength+1;
             widget.conversation!.contenuMsg=newMessage.contenu;
             widget.conversation!.read=1;
             widget.conversation!.dateMsg=newMessage.createdAt;
             widget.conversation!.userIdMsg=newMessage.userId;

         } );
      }
       
            WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    

    });
             
                  
    

        }
  
      print("Received new message: $newMessage");
      // Do whatever you need to do with the new message object here
    }
  }
    
  }, onError: (error) {
    print('Error: $error');
  }, onDone: () {
    print('Disconnected from server');
  });
}).catchError((error) {
 print('Unable to connect to server: $error');
});
}
@override
void dispose() {
  _focusNode.dispose();
  _scrollController.dispose();
  BackButtonInterceptor.remove(backButtonInterceptor);
  msg.dispose();
   
  super.dispose();
}
bool backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    
    backButtonPressed = true;
    return false;
  }
    
  getData(int id) async{
     
      var jsonAnnonceBody=  await ApiCalls().get('/messages/'+id.toString(),widget.user.token);
      if(jsonAnnonceBody != null){
          messages=messageFromJson(jsonAnnonceBody);
     if(messages!=null){
      setState(() {
        messagesAreLoaded=true;
        messagesLength = messages!.length;
        
       
      });
      } 
     }else{
       setState(() {
        messagesAreLoaded=true;
        messagesLength = 0;
        
       
      });

     }
     
  }

  Future<void> sendMsg() async {
  try {
    var uri = Uri.parse(ApiCalls.baseUrl + "/messages");
    final request = http.MultipartRequest('POST', uri);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
    request.headers.addAll(headers);

    // Ensure that widget.id is an integer
    int conversationId = widget.id is int ? widget.id : int.parse(widget.id.toString());

    // Ensure that msg.text is a string
    String contenu = msg.text.toString();

    request.fields['conversation_id'] = conversationId.toString();
    request.fields['contenu'] = contenu;
    if(isReply){
       request.fields['reponse'] = reply;
     setState((){
         isReply=false;
     });
    }
    

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print(response.body);
        messageList = messageFromJson(response.body);
       
        messages!.addAll(messageList);
        setState((){
          messagesLength=messagesLength+1;
          widget.conversation!.contenuMsg=messageList[0].contenu;
             widget.conversation!.read=1;
             widget.conversation!.dateMsg=messageList[0].createdAt;
             widget.conversation!.userIdMsg=messageList[0].userId;
        });
        print(messages![messages!.length-1].contenu);
      
    
      
      
    } else {
      // Log the error
      print('Error sending message. Status code: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    // Log the error
    print('Error sending message: $e');
  }
}

void openKeyboard() {
  print('open');
  _focusNode.requestFocus();

   //FocusScope.of(context).requestFocus(_focusNode);
}

  @override
  Widget build(BuildContext context) {
   
    return WillPopScope(
        onWillPop: () async {
      
         if (backButtonPressed) {
        
          backButtonPressed = false; // Reset the flag
          setState(() {});
        
            print("Navigating back with annonces: ${widget.conversation}");
            Navigator.of(context).pop(widget.conversation);
          return false; // Prevent the default back button behavior
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                   Navigator.of(context).pop(widget.conversation);
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                ),
                SizedBox(width: 2,),
                Container(
                      margin: const EdgeInsets.only(top:5,bottom: 5),
                      width:40,
                      height: 40,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color:Color(0xFF33548A)
                     ),
                     child:Center(child: Text(str[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:16)))
                    ),
                SizedBox(width: 12,),
                Expanded(
                  child:  Text("${arg[0]}",style:TextStyle(color:Colors.black,fontSize:16,fontWeight: FontWeight.bold)),
                ),
              
              ],
            ),
          ),
        ),
      ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  Visibility(
                    visible:messagesAreLoaded ,
                    child:messagesLength>0?ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      controller: _scrollController,
                      itemCount: messagesLength+1,
                      //shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      //physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        if(index==messagesLength){
                          return Container(
                            height: 50,
                          );
                        }
                      return  SwipeTo(
                         // key:Key(messages![index].id.toString()),
                         onRightSwipe: () async{
                             
                            //await Future.delayed(Duration(seconds:1));
                            setState((){
                              isReply=true;
                              reply=messages![index].contenu;
                            });
                            print('gvf');
                            openKeyboard();
                          
                      
                          },
                          child: ChatBubble(
                            contenu:messages![index].contenu,
                            type:messages![index].type,
                            reponse:messages![index].reponse??"",

                          ),
                        );
                    
                      },
                           ):Center(child:Text("aucun message à afficher"),),
                           replacement: const Center(child:CircularProgressIndicator(),),
                  ),
                   
                              Visibility(
                                visible:isScrolling,
                                child: Container(color:Colors.white,child: Center(child: Text('chargement...')))),
                ],
              ),
            ),
            Align(
               alignment: Alignment.bottomCenter,
              child:Container(
                height:70,
                padding: EdgeInsets.only(left: 16,bottom: 10),
                width: double.infinity,
                color: Colors.white,
               
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                            height: 70,
                            width:200,
                             child: TextField(
                               focusNode: _focusNode,
                                controller: msg,
                                decoration: InputDecoration(
                                  hintText: "Tappez votre message...",
                                  hintStyle: TextStyle(color: Colors.grey.shade500),
                                  border: InputBorder.none
                                ),
                              ),
                           ),
                          SizedBox(width: 30,),
                          Container(
                                 
                                  padding: EdgeInsets.only(bottom: 10,top: 10,),
                                  child: Center(
                                    child: FloatingActionButton(
                      onPressed: ()async{
                        await sendMsg();
                        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                        msg.clear();
                      },
                      child: Icon(Icons.send,color: Colors.white,size:20),
                      backgroundColor: Color(0xFF789DC9),
                      elevation: 0,
                                    ),
                                  ),
                                ),
                    
                    
                  ],
                ),
              
            ),
            
            ),
           
         
          ],
        ),
      ),
    );
  }
}