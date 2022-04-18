import 'package:flutter/material.dart';
import 'package:message_me/App_localization.dart';
import 'package:message_me/screens/chat_screnn.dart';
import 'package:message_me/screens/registration_screen.dart';
import 'package:message_me/screens/signin_screen.dart';
import 'package:message_me/screens/wellcom_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(const MyApp());
}
  final _auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false ,
      // supportedLocales: [
      //   Locale("en" , "US"),
      //   Locale("ar" , "YE"),

      // ],
      // localizationsDelegates: [
      //     Applocalization.delegate,
      //     GlobalMaterialLocalizations.delegate
          
          
      //           ],
      //           localeResolutionCallback: (locale,supportedLocales){
      //             for (var supportedLocale in supportedLocales ) {
      //               // ignore: unrelated_type_equality_checks
      //               if (supportedLocale.languageCode == locale!.languageCode ){
      //                 return supportedLocale;
      //               } 
      //               if (supportedLocale.countryCode == locale.countryCode){
      //                 return supportedLocale;
      //               }
      //             }
      //             return supportedLocales.first;
      //           },
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.blue),
      // home: ChatScreen(),
      initialRoute: _auth.currentUser != null ? ChatScreen.screenRoute : WellcomScreen.screenRoute,
      routes: {
        ChatScreen.screenRoute:(context)=> ChatScreen(),
        RegisrationScreen.screenRoute:(context)=> RegisrationScreen(),
        SigninScreen.screenRoute:(context)=> SigninScreen(),
        WellcomScreen.screenRoute:(context)=> WellcomScreen(),
      },
    );
  }
}
