import 'package:cahier_de_correspondance/registration_first_step.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'forget_password.dart';
import 'models/User.dart';
import 'services/api_calls.dart';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
 
   late TextEditingController _emailController;
   late TextEditingController _passwordController;
   final _formKey=GlobalKey<FormState>();
  
   User? user;
   var _email;
  var _password;
 bool _isAnimating = true;

@override
void initState() {
  super.initState();

  _emailController = TextEditingController();
   _passwordController = TextEditingController();
  _isAnimating = true;
}

  @override
  void dispose() {
   
    _emailController.dispose();
    _passwordController.dispose();
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

  Future<int> login()async{
    if(_formKey.currentState!.validate() ){
     
        var uri = Uri.parse(ApiCalls.baseUrl+'/login');
        final request = http.MultipartRequest('POST', uri);
        
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
    };
     request.headers.addAll(headers);

      request.fields['email'] = _email;
      request.fields['password'] = _password;
     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode==200){
        setState((){
       user=userFromJson(response.body);
        });
      }
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
                        'Bienvenue',
                        style: TextStyle(color:Color(0xFF33548A),fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Accedez à votre compte',
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
                             InkWell(
                                onTap: (){
                                    Get.to(ForgetPassword());
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left:50,top:10),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: "mot de passe oublié? "),
                                        TextSpan(
                                          text: 'Récuperer',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF33548A)),
                                        ),
                                      ]
                                    )
                                  ),
                                ),
                              ),
                              SizedBox(height: 50,),
                              InkWell(
                                onTap:()async{
                                
                                  
                                   int x=await login();
                                   if(x==200){
                                    List<String> userInfo = [user!.id.toString(),user!.name,user!.email,user!.status, user!.token];
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setStringList('userInfo', userInfo);
                                    prefs.setBool('isLogged', true);
                                  
                                    Get.offAll(DrawerPage(user:user!));

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
                                        child:Center(child: Text("s'authentifier",style:TextStyle(color:Colors.white,fontSize: 20)))
                                 ),
                              ),
                               SizedBox(height: 10,),
                              
                            
                   
                              InkWell(
                                onTap: (){
                                    Get.to(RegistrationFirstStep());
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right:20,left:20,top:10),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: "vous avez pas de compte? "),
                                        TextSpan(
                                          text: 'Créer',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF33548A)),
                                        ),
                                      ]
                                    )
                                  ),
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