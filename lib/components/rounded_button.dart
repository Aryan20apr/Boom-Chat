import 'package:flutter/material.dart';
class Roundedbutton extends StatelessWidget {
  const Roundedbutton({
    Key? key,this.buttonColor=Colors.black,this.title='Not Available',required this.onPressed}) : super(key: key);
  final Color buttonColor;
  final String title;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 20.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed:onPressed /*() {
            //Go to login screen.
            Navigator.pushNamed(context, LoginScreen.id);
          }*/,
          minWidth: 200.0,
          height: 42.0,
          splashColor: Colors.blue,
          child:  Text(
            title,style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}