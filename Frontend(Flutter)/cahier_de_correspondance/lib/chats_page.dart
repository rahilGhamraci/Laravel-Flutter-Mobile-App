import 'package:cahier_de_correspondance/models/Discussion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cahier_de_correspondance/chat_detail_page.dart';
import 'package:cahier_de_correspondance/models/Conversation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'models/Message.dart';
import 'models/User.dart';
import 'models/Users.dart';
import 'providers/conversation_state.dart';
import 'services/api_calls.dart';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
class ChatPage extends StatefulWidget {
  final User user;
  const ChatPage({super.key,required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
     List <Conversation>? conversations;
     var conversationsAreLoaded=false;
     var conversationsLength=0;

     List <Users>? users;
     var usersAreLoaded=false;
     var usersLength=0;
     Discussion? conv;

    void initState(){
     super.initState();
     getData();
     getUsers();
     connectionWebSocket();
    
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
         for (var i = 0; i < conversations!.length; i++) {
                final index = conversations!.indexWhere((c) => c.id == newMessage.conversationId);
                if(index != -1){
                  setState(() {
                    conversations![index].contenuMsg=newMessage.contenu;
                    conversations![index].dateMsg=newMessage.createdAt;
                    conversations![index].read=0;
                    
                   
                        Conversation element = conversations!.removeAt(index);
                        print(element.contenuMsg);
                        
                        conversations!.insert(0, element); 
                          
                  });
                }
                      
    
        
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
  getData() async{
     
      var jsonAnnonceBody=  await ApiCalls().get('/conversations',widget.user.token);
      if(jsonAnnonceBody != null){
           conversations=conversationFromJson(jsonAnnonceBody);
     if(conversations!=null){
      setState(() {
        conversationsAreLoaded=true;
        conversationsLength = conversations!.length;
      });
     }
      }else{
         setState(() {
        conversationsAreLoaded=true;
        conversationsLength = 0;
      });

      }
     
     
  }

  getUsers() async{
      
      var jsonAnnonceBody=  await ApiCalls().get('/users',widget.user.token);
          if(jsonAnnonceBody != null){
      users=usersFromJson(jsonAnnonceBody);
     if(users!=null){
      setState(() {
        usersAreLoaded=true;
        usersLength = users!.length;
      });
     }
          }else{
             setState(() {
             usersAreLoaded=true;
             usersLength = 0;
      });

          }
  }
  Future<int> addConversation(int id)async{
        var uri = Uri.parse(ApiCalls.baseUrl+"/conversations");
        final request = http.MultipartRequest('POST', uri);
         Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
      "Authorization": "Bearer " + widget.user.token
    };
     request.headers.addAll(headers);

      request.fields['second_user_id'] = id.toString();
        try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode==200){
        conv=discussionFromJson(response.body);
      }
      
     return response.statusCode;
    } catch (e) {
      print(e);
     
    }
    return 0;
     
  }
  void ShowUsers(){
   
    showModalBottomSheet(
      context: context,
       shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30))
       ),
      builder: (context){
        
        return  Container(
            height: MediaQuery.of(context).size.height/2,
           
            child:Column(
              children: [
                 SizedBox(height: 16,),
                Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                   SizedBox(height: 10,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                     // color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                    ),
                    child:Visibility(
                      visible: usersAreLoaded,
                      child: usersLength>0? ListView.builder(
                        itemCount: usersLength,
                        itemBuilder: (context, index) {
                          return InkWell(
                                onTap:() async{
                                  int x=await addConversation(users![index].id);
                                  if(x==200){
                                    Get.to(ChatDetailPage(id: conv!.id,user:widget.user,),arguments:[conv!.otherUserName]);
                                  }else{
                                                print(x);
                                  }
                                  
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 5,bottom: 5),
                                  child:ListTile(
                                    leading: Container(
                                    
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Color(0xFF789DC9)
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: Icon(Icons.person,size: 20,color: Colors.black,),
                                    ),
                                    title: Text(users![index].name),
                                    subtitle: Text(users![index].status),
                                  ),
                                ),
                              );
                              
                           
                    
                          
                        }):Text("aucun contact à afficher"),
                        replacement: const Center(child:CircularProgressIndicator(),),
                    )
                      ),
                ),
              ],
            )
            );
         
      });
  }
  String formatMessageTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp) - Duration(hours:1);

  if (difference.inSeconds < 60) {
    return 'maintenant';
  } else if (difference.inMinutes < 60) {
    return 'il y\'a ${difference.inMinutes} min';
  } else if (difference.inHours < 24) {
    return 'il y\'a  ${difference.inHours} h';
  } else if (difference.inDays < 2) {
    return 'hier';
  } else {
    return DateFormat('dd/MM/yyyy').format(timestamp);
  }
}
  ConversationState ? conversationState;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatefulBuilder(
          builder: (context, setState) {
            conversationState = Provider.of<ConversationState>(context);
            return RefreshIndicator(
           onRefresh: () async{
          await getData();
          await getUsers();
        },
          child: Stack(
            children:[ Visibility(
              visible:conversationsAreLoaded ,
              child: ListView.builder(
                itemCount: conversationsLength,
                itemBuilder:(BuildContext context,int index){
                  return InkWell(
                     onTap: ()async{
                     
                     final conv = await Get.to<Conversation>(
                         () =>ChatDetailPage(
                        conversation: conversations![index],
                        conversationState: conversationState,
                        user:widget.user,
                        id: conversations![index].id,),
                        arguments:[conversations![index].userName]
                        );
                      
                      setState((){
                       conversations![index]=conv!;
                       conv.read=1;
                      });
                      },
                    child: Container(
                      width: double.maxFinite,
                      height: 50,
                      child: Row(
                        children:[
                           Container(
                                margin: const EdgeInsets.only(top:5,bottom: 5,left:10),
                                width:40,
                                height: 40,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color:Color(0xFF789DC9)
                               ),
                               child:Center(child: Text(conversations![index].userName[0].toUpperCase(),style:TextStyle(color:Colors.black,fontSize:16)))
                              ),
                              SizedBox(width: 10,),
                              Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(conversations![index].userName,style:TextStyle(color:Colors.black,fontSize:16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(conversations![index].contenuMsg??"",style:TextStyle(color:conversations![index].read==0 && conversations![index].userIdMsg!=widget.user.id ? Colors.black:Colors.grey,fontSize:14)),
                                      SizedBox(width: 5,),
                                      Text(formatMessageTimestamp(conversations![index].dateMsg?? DateTime.now()),style:TextStyle(color:conversations![index].read==0 && conversations![index].userIdMsg!=widget.user.id ? Colors.black:Colors.grey,fontSize:12)),
                                    ],
                                  ),
                                ],
                              ),
                        ]
                      ),
                    ),
                  );
                }),
                replacement: const Center(child:CircularProgressIndicator(),),
            ),
            Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.only(right: 30,bottom: 50),
                        child: FloatingActionButton(
                          onPressed: (){  ShowUsers();},
                          child: Icon(Icons.add,color: Colors.white,),
                          backgroundColor: Color(0xFF33548A),
                          elevation: 0,
                        ),
                      ),
                    ),
            ]
          ),
        );
          }
      )
    );
  }
}