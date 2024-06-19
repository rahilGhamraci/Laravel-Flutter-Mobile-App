import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:cahier_de_correspondance/registration.dart';

class RegistrationFirstStep extends StatefulWidget {
  const RegistrationFirstStep({super.key});

  @override
  State<RegistrationFirstStep> createState() => _RegistrationFirstStepState();
}

class _RegistrationFirstStepState extends State<RegistrationFirstStep> {
  List<String> listeRoles=["Élève","Tuteur"];
  String? selectedRole;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      key:_scaffoldKey,
      body:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     SizedBox(height: 60,),
                    Lottie.asset(
                                        'animations/107385-login.json',
                                        height: 180,
                                        alignment: Alignment.centerLeft,
                                        reverse:true,
                                        repeat: true,
                                        fit:BoxFit.cover,
                                        ),
                                      
                              
                              
                   SizedBox(height: 60,),
                   Text(
                              'Vous êtes?',
                              style: TextStyle(color:Color(0xFF33548A),fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                  SizedBox(height: 100,),
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                     child: DropdownButton(
                          value: selectedRole!=null ? selectedRole : null,
                          isExpanded: true,
                          onChanged: (newValue){
                                  setState(() {
                                    selectedRole=newValue as String?;
                                  });}, 
                         items: listeRoles.map((item) {
                         return DropdownMenuItem(
                           value: item,
                           child: new Text(item),
                           );
                           }).toList(), 
                     ),
                   ),
                   SizedBox(height: 40,),
                   Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                           child: InkWell(
                            onTap:(){
                              if(selectedRole!=null){
                               Get.to(Registration(role:selectedRole??""));
                              }else{
                                    final snackBar=SnackBar(content: Text("veuillez sélectionner un role svp",));
                                    _scaffoldKey.currentState!.showSnackBar(snackBar);
                              }
                              
                                     
                                  },
                           
                             child: Container(
                              width: screenWidth,
                              margin: EdgeInsets.only(bottom: 20),
                              height:50,
                              decoration: BoxDecoration(
                                borderRadius:BorderRadius.circular(20),
                                color:Color(0xFF33548A)),
                                child:Center(child: Text("Suivant",style:TextStyle(color:Colors.white,fontSize: 20)))
                                       ),
                           ),
                         ),
                          Container(
                                      margin: EdgeInsets.fromLTRB(10,20,10,20),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(text: "vous êtes enseignant ? "),
                                            TextSpan(
                                              text: 'Veuillez contactez votre établissemnet pour avoir les informations de votre compte',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF33548A)),
                                            ),
                                          ]
                                        )
                                      ),
                                    ),
                  ],
                ),
    );
  }
}