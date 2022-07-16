import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:boom_chat/screens/welcome_screen.dart';
import 'package:boom_chat/screens/login_screen.dart';
import 'package:boom_chat/screens/registration_screen.dart';
import 'package:boom_chat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BoomChat());
}

class BoomChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*theme: ThemeData.dark().copyWith(//Due to this the text color in text fields is white, therefore remove this to see the hint text
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),*/
      initialRoute: FirebaseAuth.instance.currentUser==null?WelcomeScreen.id:ChatScreen.id,
      routes: {
        //WelcomeScreen().id: (context) => WelcomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
