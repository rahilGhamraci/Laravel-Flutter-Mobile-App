import 'package:cahier_de_correspondance/absences_tuteur.dart';
import 'package:cahier_de_correspondance/liste_presence.dart';
import 'package:cahier_de_correspondance/listes_presence.dart';
import 'package:cahier_de_correspondance/login.dart';
import 'package:cahier_de_correspondance/registration.dart';
import 'package:cahier_de_correspondance/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:cahier_de_correspondance/drawer.dart';
import 'package:cahier_de_correspondance/post_form.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'convocation_post_form.dart';
import 'models/User.dart';
import 'providers/absTuteur_state.dart';
import 'providers/annonce_state.dart';
import 'providers/conversation_state.dart';
import 'providers/convocation_state.dart';
import 'providers/delai_state.dart';
import 'providers/devoir_state.dart';
import 'providers/justification_state.dart';
import 'providers/support_state.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isWelcomeDisplayed = prefs.getBool('isWelcomeDisplayed');
 if (isWelcomeDisplayed == null || !isWelcomeDisplayed) {
  // show the welcome page
  runApp(
    /*GetMaterialApp(debugShowCheckedModeBanner: false,home: WelcomePage(),)*/
  MultiProvider(
       providers: [
        ChangeNotifierProvider(create: (_) => JustificationState()),
        ChangeNotifierProvider(create: (_) => ConvocationState()),
        ChangeNotifierProvider(create: (_) => SupportState()),
        ChangeNotifierProvider(create: (_) => AnnonceState()),
        ChangeNotifierProvider(create: (_) => DevoirState()),
        ChangeNotifierProvider(create: (_) => AbsTuteurState()),
        ChangeNotifierProvider(create: (_) => DelaiState()),
          ChangeNotifierProvider(create: (_) => ConversationState()),
    
     ],
  child: GetMaterialApp(debugShowCheckedModeBanner: false,home: WelcomePage(),)
)
  );
} else {
   List<String>? userInfo = prefs.getStringList('userInfo');
   bool? isLogged = prefs.getBool('isLogged');
   if(isLogged ==null || !isLogged){
       runApp(
       // GetMaterialApp(debugShowCheckedModeBanner: false,home:Login())
       MultiProvider(
       providers: [
        ChangeNotifierProvider(create: (_) => JustificationState()),
        ChangeNotifierProvider(create: (_) => ConvocationState()),
        ChangeNotifierProvider(create: (_) => SupportState()),
        ChangeNotifierProvider(create: (_) => AnnonceState()),
        ChangeNotifierProvider(create: (_) => DevoirState()),
        ChangeNotifierProvider(create: (_) => AbsTuteurState()),
         ChangeNotifierProvider(create: (_) => DelaiState()),
          ChangeNotifierProvider(create: (_) => ConversationState()),
     ],
  child: GetMaterialApp(debugShowCheckedModeBanner: false,home:Login())
)
        );
   }else{
    
    int id = int.parse(userInfo![0]);
    String name = userInfo[1];
    String email = userInfo[2];
    
    String status = userInfo[3];
    String token = userInfo[4];
     User user=User(id: id, name: name, email: email, status: status, token: token);
     runApp(
     
      MultiProvider(
       providers: [
        ChangeNotifierProvider(create: (_) => JustificationState()),
        ChangeNotifierProvider(create: (_) => ConvocationState()),
        ChangeNotifierProvider(create: (_) => SupportState()),
        ChangeNotifierProvider(create: (_) => AnnonceState()),
        ChangeNotifierProvider(create: (_) => DevoirState()),
        ChangeNotifierProvider(create: (_) => AbsTuteurState()),
          ChangeNotifierProvider(create: (_) => DelaiState()),
           ChangeNotifierProvider(create: (_) => ConversationState()),
    
     ],
  child: GetMaterialApp(debugShowCheckedModeBanner: false,home:DrawerPage(user:user))
)
      );
   }
   //print(userInfo![0]);
  
   
  
  
}
   
   
  

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home:WelcomePage(),
      // DrawerPage(Role:"Eleve"),
    );
  }
}

