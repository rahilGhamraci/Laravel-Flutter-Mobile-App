import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'models/User.dart';
import 'services/api_calls.dart';

class MenuPage extends StatefulWidget {
  final User user;
  const MenuPage({super.key,required this.user});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Future<int> logout()async{
    var uri = Uri.parse(ApiCalls.baseUrl+'/logout');
        final request = http.MultipartRequest('POST', uri);
       
       Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization':'Bearer '+widget.user.token,
     
    };
     request.headers.addAll(headers);
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.statusCode);
      return response.statusCode;
    } catch (e) {
      print(e);
     
    }
    return 0;
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
    return Scaffold(
      key:_scaffoldKey,
      backgroundColor: Color(0xFF33548A),
      body: Padding(
        padding:EdgeInsets.only(left:10),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150,),
          
              Container(
                 
                          width:100,
                          height: 100,
                          margin: const EdgeInsets.only(left: 40),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color:Color(0xFF789DC9)
                         ),
                         child:Center(child: Icon(Icons.person,size:50,color:Color(0xFF33548A)))
              ),
             /* SizedBox(height: 10,),
               Row(
                                  children: [
                                    for(int i=0; i<70;i++)
                                    i.isEven? Container(
                                      width: 3,
                                      height: 1,
                                      decoration:BoxDecoration(
                                        color:Color(0xFF33548A),
                                        borderRadius: BorderRadius.circular(2))
                                      ):Container(
                                         width: 3,
                                       height: 1,
                                       color:Colors.white,
                                      ),
                               ] ),*/
              SizedBox(height:20),
          
                 Container(
                  padding:EdgeInsets.only(left:45,),
                  child: Text(widget.user.name,style:TextStyle(color:Colors.white,fontSize:14))),
                 SizedBox(height: 5,),
                 Container(
                  padding:EdgeInsets.only(left:30,),
                  child: Text(widget.user.email,style:TextStyle(color:Colors.white,fontSize:12))),
             
           
          SizedBox(height: 240,),
         
          InkWell(
            onTap:() async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('userInfo');
              prefs.setBool('isLogged', false);
              int x= await logout();
              if(x==200){
                Get.off(Login());
              }else{
                  final snackBar=SnackBar(content: Text("veuillez réessayer",));
                  _scaffoldKey.currentState!.showSnackBar(snackBar);
              }
            },
            child: Container(
              margin:EdgeInsets.only(left:45,),
              width:130,
              height:30,
                decoration: BoxDecoration(
                          borderRadius:BorderRadius.circular(20),
                          color:Color(0xFFE67F4F)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Text("Déconnecter",style:TextStyle(color:Colors.white,fontSize:14)),
                 Icon(Icons.logout,color:Colors.white),
              ],),
            ),
          )
        ]),
      ),
    );
  }
}