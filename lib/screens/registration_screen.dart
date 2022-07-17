import 'package:boom_chat/constants.dart';
import 'package:boom_chat/screens/chat_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id='registration_screen';

  RegistrationScreen({Key? key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner=false;
  final _auth=FirebaseAuth.instance;//Used to authenticate the users
  String email="",password="";

  Future<void> _showAlertDialog(String error)
  {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Failed'),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text('$error'),
                Text('Press Retry to try again with a different email id'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Email Id'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,//password
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password=value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 20.0,
                  child: MaterialButton(
                    onPressed: () async{
                      //Implement registration functionality.
                        setState(()
                        {
                          showSpinner=true;
                        });

                      try {
                       final newUser=await _auth.createUserWithEmailAndPassword(email: email, password: password);
                       if(newUser!=null)
                         {
                           Navigator.pushNamed(context, ChatScreen.id);
                         }

                     }on FirebaseAuthException catch(e)
                      {
                        if(e.code=='email-already-in-use')
                          {
                            String errorMessage='The email entered is already in use';
                            _showAlertDialog(errorMessage);
                          }
                      }
                     on Exception catch (e) {
                       print(e);
                     }
                        setState(() {
                          showSpinner = false;
                        });
                    },
                    elevation: 20.0,
                    minWidth: 200.0,
                    height: 42.0,
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
