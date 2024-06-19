import 'package:cahier_de_correspondance/registration_first_step.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'forget_password.dart';
import 'login.dart';
import 'models/User.dart';
import 'services/api_calls.dart';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';


class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> with TickerProviderStateMixin {
 
   late TextEditingController _emailController;
   late TextEditingController _passwordController;
    late TextEditingController _otpController;
   final _formKey=GlobalKey<FormState>();
  
   
   var _email;
  var _password;
  var _otp;
 bool _isAnimating = true;

@override
void initState() {
  super.initState();

  _emailController = TextEditingController();
   _passwordController = TextEditingController();
    _otpController = TextEditingController();
  _isAnimating = true;
}

  @override
  void dispose() {
   
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

 void _handleTextChanged(String text) {
  setState(() {
    _email = text;
    _isAnimating = text.isEmpty;
  });
}

 void _handleTextChanged1(String text) {
  setState(() {
    _password = text;
    _isAnimating = text.isEmpty;
  });
}

void _handleTextChanged2(String text) {
  setState(() {
    _otp = text;
    _isAnimating = text.isEmpty;
  });
}

  Future<int> resetPassword()async{
    if(_formKey.currentState!.validate() ){
     
        var uri = Uri.parse(ApiCalls.baseUrl+'/reset_password');
        final request = http.MultipartRequest('POST', uri);
        
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
    };
     request.headers.addAll(headers);

      request.fields['email'] = _email;
      request.fields['password'] = _password;
       request.fields['otp'] = _otp;
     
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
                        'Définir un nouveau mot de passe',
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
                              Container(
                                child: TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty ){
                                   return "Ce champ est obligatoir";
                    }
                  },
                     controller: _passwordController,
                      onChanged: _handleTextChanged1,
                                  obscureText: true,
                                    decoration: InputDecoration(
                                    labelText: "Mot de passe",
                                    hintText: "Entrez votre mot de passe",
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
                              Container(
                                child: TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty ){
                                   return "Ce champ est obligatoir";
                    }
                  },
                     controller: _otpController,
                      onChanged: _handleTextChanged2,
                                  obscureText: true,
                                    decoration: InputDecoration(
                                    labelText: "Code envoyé par mail",
                                    hintText: "Entrez le code",
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
                              SizedBox(height: 50,),
                           
                             
                              InkWell(
                                onTap:()async{
                                  
                                   int x=await resetPassword();
                                   if(x==200){
                                        final snackBar=SnackBar(content: Text("mot de passe restauré, vous pouvez désormais vous connectez ",));
                                    _scaffoldKey.currentState!.showSnackBar(snackBar);
                                    await Future.delayed(Duration(seconds: 2));
                                  
                                    Get.offAll(Login());

                                   }else{
                                     final snackBar=SnackBar(content: Text("information erronées,veuillez réessayer",));
                                    _scaffoldKey.currentState!.showSnackBar(snackBar);
                                   }
                                  
                                },
                                child: Container(
                                      width: 300,
                                      height:50,
                                      decoration: BoxDecoration(
                                        borderRadius:BorderRadius.circular(20),
                                        color: Color(0xFF33548A)),
                                        child:Center(child: Text("Modifier Mot de passe",style:TextStyle(color:Colors.white,fontSize: 20)))
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