
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'models/User.dart';
import 'reset_password.dart';
import 'services/api_calls.dart';
import 'dart:async';



class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> with TickerProviderStateMixin {
 
   late TextEditingController _emailController;
  
   final _formKey=GlobalKey<FormState>();
  
   User? user;
   var _email;
 
 bool _isAnimating = true;

@override
void initState() {
  super.initState();

  _emailController = TextEditingController();

  _isAnimating = true;
}

  @override
  void dispose() {
   
    _emailController.dispose();
   
    super.dispose();
  }

 void _handleTextChanged(String text) {
  setState(() {
    _email = text;
    _isAnimating = text.isEmpty;
  });
}



  Future<int> sendCode()async{
    if(_formKey.currentState!.validate() ){
     
        var uri = Uri.parse(ApiCalls.baseUrl+'/forget_password');
        final request = http.MultipartRequest('POST', uri);
        
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
    };
     request.headers.addAll(headers);

      request.fields['email'] = _email;
     
     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
     
      return response.statusCode;
    } catch (e) {
      print(e);
     
    }
    }
    return 0;
  }
  bool isEmailValid(String email) {
  final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}
  @override
  Widget build(BuildContext context) {
     final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
    return Scaffold(
      key:_scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 40,),
             
            _isAnimating ? Lottie.asset(
                                        'animations/107385-login.json',
                                        height: 180,
                                        alignment: Alignment.centerLeft,
                                        reverse:true,
                                        repeat: true,
                                        fit:BoxFit.cover,
                                        )
        : Container(),
                  
                      
           SizedBox(height: 20,),
           SafeArea(child: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child:Column(children: [
                     
                      Text(
                        'Récuppérez votre compte',
                        style: TextStyle(color: Color(0xFF789DC9)),
                      ),
                             
                      SizedBox(height: 20,),    
                     Form(
                        key: _formKey,
                          child: Column(
                            children: [
                               
                              Container(
                                child: TextFormField(
                                 
                                   validator: (value){
                                    if(value!.isEmpty || !isEmailValid(value)){
                                   return "Entrez une adresse valide";
                    }
                  },
                 controller: _emailController,
                 onChanged: _handleTextChanged,

                 /*  onChanged: (value){
                  
                    setState(() {
                     _email=value;
                    
                    });
                  },*/
                                  decoration: InputDecoration(
                                    
                                    labelText: "Email",
                                    hintText: "Entrez votre adresse",
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.grey)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
    ),
                                ),
                                
                              ),
                              SizedBox(height: 30.0),
                             
                           
                             
                              SizedBox(height: 10,),
                              InkWell(
                                onTap:()async{
                                  
                                
                                   int x=await sendCode();
                                   if(x==200){
                                  
                                   final snackBar=SnackBar(content: Text("Code envoyé, vérifiez votre boite mail",));
                                    _scaffoldKey.currentState!.showSnackBar(snackBar);
                                    await Future.delayed(Duration(seconds: 2));
                                    Get.offAll(ResetPassword());

                                   }else{
                                     final snackBar=SnackBar(content: Text("Une erreur s'est produite,veuillez réessayer",));
                                    _scaffoldKey.currentState!.showSnackBar(snackBar);
                                   }
                                  
                                },
                                child: Container(
                                      width: 300,
                                      height:50,
                                      decoration: BoxDecoration(
                                        borderRadius:BorderRadius.circular(20),
                                        color: Color(0xFF33548A)),
                                        child:Center(child: Text("Envoyer Code",style:TextStyle(color:Colors.white,fontSize: 20)))
                                 ),
                              ),
                   
                             
                            ],
                          )
                      ),
            ],)
           ))
        ],),
      ),);
  }
}