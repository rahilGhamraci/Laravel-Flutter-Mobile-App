import 'package:cahier_de_correspondance/models/Etabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer.dart';
import 'models/ResponseMsg.dart';
import 'models/User.dart';
import 'services/api_calls.dart';

class Registration extends StatefulWidget {
  final String role;
  const Registration({super.key,required this.role});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
   final _formKey=GlobalKey<FormState>();
   late TextEditingController _emailController;
   late TextEditingController _passwordController;
   late TextEditingController _nameController;
   late TextEditingController _passwordConfirmationController;
   late TextEditingController _idController;
   late TextEditingController _nssController;
     late TextEditingController _otpController;
      late GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
   User? user;
   ResponseMsg? msg;
   var _email;
  var _password;
  var _name;
  var _password_confirmation;
  var _id;
  var _nss;
  var _otp;
   bool _isAnimating = true;
   bool _isCodeSent = false;
 
 
     Etabs? selectedEtab;
     List<Etabs>? etabs;
     bool etabsAreLoaded=false;
      int etabsLength=0;
    
  void initState(){
     super.initState();
       _scaffoldKey = GlobalKey<ScaffoldState>();
       _emailController = TextEditingController();
       _passwordController = TextEditingController();
       _nameController = TextEditingController();
       _passwordConfirmationController = TextEditingController();
       _idController = TextEditingController();
       _nssController = TextEditingController();
       _otpController = TextEditingController();
      _isAnimating = true;
     getData();
    
  }
   void _handleEmailChanged(String text) {
  setState(() {
    _email = text;
    _isAnimating = text.isEmpty;
  });
}

 void _handlePasswordChanged(String text) {
  setState(() {
    _password = text;
    _isAnimating = text.isEmpty;
  });
}
 void _handleOtpChanged(String text) {
  setState(() {
    _otp = text;
    _isAnimating = text.isEmpty;
  });
}
void _handlePasswordConfirmationChanged(String text) {
  setState(() {
    _password_confirmation = text;
    _isAnimating = text.isEmpty;
  });
}

 void _handleNameChanged(String text) {
  setState(() {
    _name = text;
    _isAnimating = text.isEmpty;
  });
}
void _handleIdChanged(String text) {
  setState(() {
    _id = text;
    _isAnimating = text.isEmpty;
  });
}

 void _handleNssChanged(String text) {
  setState(() {
    _nss = text;
    _isAnimating = text.isEmpty;
  });
}
  getData() async{
     
      var client=http.Client();
      var url=Uri.parse(ApiCalls.baseUrl+'/etabs');
      var response=await client.get(url);

  if(response.statusCode==200){
   
  etabs=etabsFromJson(response.body);
     if(etabs!=null){
      setState(() {
        etabsAreLoaded=true;
        etabsLength = etabs!.length;
      
      });
     }
   
  }
      
  }
  Future<int> sendCode()async{
    if(_formKey.currentState!.validate() ){
     
        var uri = Uri.parse(ApiCalls.baseUrl+'/email_verfication');
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
  Future<int> register()async{
    if(_formKey.currentState!.validate() ){
      if(widget.role=="Élève"){
           var uri = Uri.parse(ApiCalls.baseUrl+'/eleve_registration');
        final request = http.MultipartRequest('POST', uri);
        
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
    };
     request.headers.addAll(headers);

      request.fields['email'] = _email;
      request.fields['name'] = _name;
      request.fields['password'] = _password;
      request.fields['password_confirmation'] = _password_confirmation;
      request.fields['id'] = _id;
      request.fields['etablissement_id'] = selectedEtab!.id.toString();
       request.fields['otp'] = _otp;

     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode==200){
        setState((){
       user=userFromJson(response.body);
        });
      }else{
        msg=responseMsgFromJson(response.body);
      }
      return response.statusCode;
    } catch (e) {
      print(e);
     
    }
      }else{
         var uri = Uri.parse(ApiCalls.baseUrl+'/tuteur_registration');
        final request = http.MultipartRequest('POST', uri);
        
       Map<String, String> headers = {
      "Accept": "application/json",
      "content_type":"application/form-data",
    };
     request.headers.addAll(headers);

      request.fields['email'] = _email;
      request.fields['name'] = _name;
      request.fields['password'] = _password;
      request.fields['password_confirmation'] = _password_confirmation;
      request.fields['nss'] = _nss;
       request.fields['otp'] = _otp;
      

     
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode==200){
        setState((){
       user=userFromJson(response.body);
        });
      }else{
        print(response.body);
        msg=responseMsgFromJson(response.body);
      }
      return response.statusCode;
    } catch (e) {
      print(e);
     
    }
       
      }
       
    }
    return 0;
  }
   bool isEmailValid(String email) {
   String emailPattern = r'^[a-zA-Z0-9_.+-]+@(gmail\.com|yahoo\.com|yahoo\.fr|outlook\.com|outlook\.fr|hotmail\.com|hotmail\.fr)$';

  RegExp regExp = RegExp(emailPattern);
  print(regExp.hasMatch(email));
  return regExp.hasMatch(email) ;
}
bool validatePassword(String password) {
  // Vérifie si le mot de passe est une combinaison de min 8 caractères et de chiffres
  RegExp passwordRegex = RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{8,}$');
  return passwordRegex.hasMatch(password);
}
  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;
   
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
                                      
                              
                    SizedBox(height: 10,) ,  
                    Text(
                                'Bienvenue',
                                style: TextStyle(color:Color(0xFF33548A),fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Créer votre compte',
                                style: TextStyle(color: Color(0xFF789DC9)),
                              ),
                   SafeArea(child: Container(
                    padding: EdgeInsets.only(left:10,right:10,bottom:20),
                    margin: EdgeInsets.only(left:10,right:10,bottom:20),
                    child:Column(children: [
                             Form(
                                key: _formKey,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: TextFormField(
                                          validator: (value) {
                                                      if(value!.isEmpty || !isEmailValid(value)){
                                   return "Entrez une adresse valide";
                    }
                                    },
                                    controller: _emailController,
                                    onChanged: _handleEmailChanged,
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
                                           validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Ce champ est obligatoir";
                                      }
                                    },
                                    controller: _nameController,
                                    onChanged: _handleNameChanged,
                                          decoration: InputDecoration(
                                            labelText: "Nom d'utilisateur",
                                            hintText: "Entrez un nom d'utilisateur",
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
                                           validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Ce champ est obligatoir";
                                      }
                          
                                       if ( !validatePassword(value)) {
                                        return "ça doit contenir minimum 8 caractères et chiffres ";
                                      }
                                    },
                                    controller: _passwordController,
                                    onChanged: _handlePasswordChanged,
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
                                           validator: (value) {
                                      if (value!.isEmpty ) {
                                        return "Ce champ est obligatoir";
                                      }
                                       
                                    },
                                    controller: _passwordConfirmationController,
                                    onChanged: _handlePasswordConfirmationChanged,
                                          obscureText: true,
                                            decoration: InputDecoration(
                                            labelText: "confirmation du mot de passe",
                                            hintText: "Confirmez votre mot de passe",
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
                                      Visibility(
                                        visible: widget.role=="Élève",
                                        child: Column(children: [
                                               Container(
                                        child: TextFormField(
                                           validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Ce champ est obligatoir";
                                      }
                                    },
                                    controller: _idController,
                                    onChanged: _handleIdChanged,
                                          decoration: InputDecoration(
                                            labelText: "ID",
                                            hintText: "Entrez votre eleve ID",
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
                                      SizedBox(height: 20.0),
                                      Visibility(
                                        visible: etabsAreLoaded,
                                        child: etabsLength>0?Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Container(
                                              height: 50,
                                              child: DropdownButton(
                                                value: selectedEtab!=null ? selectedEtab : null,
                                                isExpanded: true,
                                                onChanged: (nouvelleValue){
                                                  setState(() {
                                                    selectedEtab=nouvelleValue as Etabs?;
                                                    });}, 
                                                    items: etabs!.map((item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: new Text(item.nom+" ,"+item.commune+" ,"+item.wilaya)
                                                        );
                                                        }).toList(), 
                                                         ),
                                            ),
                                         
                                                   ):Center(child:Text("aucun etablissemnt à afficher")),
                                                   replacement: const Center(child: CircularProgressIndicator()),
                                      ),
             
                                        ],),
                                        replacement:Container(
                                        child: TextFormField(
                                           validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Ce champ est obligatoir";
                                      }
                                    },
                                     controller: _nssController,
                                    onChanged: _handleNssChanged,
                                          decoration: InputDecoration(
                                            labelText: "Nss",
                                            hintText: "Entrez votre numéro de securité social",
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
                                      ),
                                      SizedBox(height:10),
                                     Visibility(
                                      visible:_isCodeSent,
                                       child: Container(
                                          child: TextFormField(
                                            validator: (value) {
                                                        if(value!.isEmpty && _isCodeSent){
                                                                        return "Ce champs est obligatoire";
                                                         }
                                                                         },
                                                                         controller: _otpController,
                                                                         onChanged: _handleOtpChanged,
                                            decoration: InputDecoration(
                                              
                                              labelText: "Code",
                                              hintText: "Entrez le code envoyé par mail",
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
                                     ),
          
                                      SizedBox(height: 20,),
                                      InkWell(
                                        onTap:()async{
                                          if (_formKey.currentState!.validate()) {
                                            if(!_isCodeSent){
                                           
                                              int y= await sendCode();
                                           
                                             if(y==200){
                                             
                                              Future.delayed(Duration(milliseconds: 100), () {
                                              final snackBar = SnackBar(
                                                content: Text("vous pouvez récupérer le code à partir de votre boite de réception"),
                                                      );
                                                _scaffoldKey.currentState!.showSnackBar(snackBar);
                                                    });
                                            
                                              setState((){
                                                _isCodeSent= true;
                                              });

                                            }else{
                                               final snackBar=SnackBar(content: Text("code non envoyé,veuillez réessayer"));
                                               _scaffoldKey.currentState!.showSnackBar(snackBar);   
                                    
                                           }
                                          }else{
                                             if(selectedEtab!=null || widget.role=='Tuteur'){
                                  
                                   int x=await register();
                                   print(x);
                                   if(x==200){
                                     List<String> userInfo = [user!.status, user!.token];
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setStringList('userInfo', userInfo);
                                    prefs.setBool('isLogged', true);
                                   
                                   Get.offAll(DrawerPage(user:user!));
                                   }else{
                                     final snackBar=SnackBar(content: Text("veuillez réessayer"));
                                    _scaffoldKey.currentState!.showSnackBar(snackBar);
                                   }

                                }else{
                                  final snackBar=SnackBar(content: Text("veuillez sélectionnez un établissement",));
                                    _scaffoldKey.currentState!.showSnackBar(snackBar);

                                }

                                          }
  
                                          }
                                       
                                          
                                         
                                        
                               
                                  
                                  
                                },
                                        child: Container(
                                              width: 300,
                                              height:50,
                                              decoration: BoxDecoration(
                                                borderRadius:BorderRadius.circular(20),
                                                color: Color(0xFF33548A)),
                                                child:Center(child: Text(_isCodeSent ?"Terminer":"S'inscrire",style:TextStyle(color:Colors.white,fontSize: 20)))
                                         ),
                                      ),
                           
                                     
                                    ],
                                  )
                              ),
                    ],)
                   ))
                ],),
              ),
    );
  }
}