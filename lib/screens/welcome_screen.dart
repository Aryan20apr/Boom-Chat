import 'package:boom_chat/screens/login_screen.dart';
import 'package:boom_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'login_screen.dart';
import 'package:boom_chat/components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen'; //Associated with the class
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with
        SingleTickerProviderStateMixin //Turn this WelcomeScreen state object to
// something that can act as the ticker ,
// we have to use the with keyword and specify
// that this class can act as single state ticker.
//If there are multiple animations, use TickerProviderStateMixin
    {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: 1),
        upperBound: 1.0,
        vsync: this //Here we provide current screen's state object therefore this  a//Here we provide a ticker provider.
      // Usually the ticker provider is the state object
    );

    //animation=CurvedAnimation(parent: controller, curve: Curves.decelerate);//When using curved Animation, upper bound cannot be greater then 1

    animation=ColorTween(begin: Colors.blueGrey,end: Colors.white).animate(controller);
    controller.forward();
    //By default animation controllers will animate a number .
    // So for every tick of that ticker it will increase that number. It usually goes from 0 to 1
    //In 1s we can get 60 from the ticker, therefore the controller willl move from 0 to 1 in 60 steps.
    //controller.reverse(from:1.0);
    controller.addListener(() //Listen to the value of controller, the actual animation.
    {
      setState((){});//This is called to tell that the opacity specified below is going to be dirty and we have to rebuild our screen by calling build() method
      print(controller.value);//We can use this number for various purposes such as changing the opacity of the color
    });


    /* animation.addStatusListener((status) { //Listens for the status of the animation
      //End of reverse animation is dismissed and of forward animation is complete
      if(status==AnimationStatus.completed)
        {
          controller.reverse(from: 1.0);
        }
      else if(status==AnimationStatus.dismissed)
        controller.forward();
    });*/
  }
  @override
  void dispose()//If the widget is destroyed dispose the controller so that it does not stay in memory and use the resources
  {
    print('In Dispose');
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.red.withOpacity(controller.value),
      backgroundColor: animation.value,//Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 60,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  // const Text(
                  //   'Boom Chat',
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 45.0,
                  //     fontWeight: FontWeight.w900,
                  //   ),
                  // ),
                  AnimatedTextKit(animatedTexts: [ColorizeAnimatedText('Boom Chat', textStyle: TextStyle(fontSize: 45.0,fontWeight: FontWeight.w900), colors: kcolorizeColors),])
                ],
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            Roundedbutton(title: 'Log in',buttonColor: Colors.redAccent,onPressed: (){
              Navigator.pushNamed(context, LoginScreen.id);

            },),
            /*Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 20.0,
                child: MaterialButton(
                  onPressed: () {
                    //Go to registration screen.
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  splashColor: Colors.blue[900],
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Register',
                  ),
                ),
              ),
            ),*///Extracted to RoundedButton
            Roundedbutton(title: "Sign Up",buttonColor:Colors.lightBlueAccent,onPressed: ()
            {
              Navigator.pushNamed(context, RegistrationScreen.id);
            })
          ],
        ),
      ),
    );
  }
}


