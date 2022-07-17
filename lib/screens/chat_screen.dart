import 'package:boom_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:boom_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

final _fireStore = FirebaseFirestore.instance;
late User loggedInUser;
class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  String? messageText;
  final messageTextController = TextEditingController();
  Future<bool> popState() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit '),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              //SystemNavigator.popUntil(context, (route) => false);
              SystemNavigator.pop();
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() //Check if there is a current user who signed in
  {
    try {
      final user = _auth.currentUser!;
      //Get current user
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  /* void getMessages() async//For displaying messages in the chat_screen
  {
  final messages=await _fireStore.collection('messages').get();//Returns Future<QuerySnapshot>--QuerySnapShot is datatype that comes from firebase, Snapshot of data in our current collection
  for(var message in messages.docs)
    {
      print(message.data());
    }
  }*/
  void
      messagesStream() async //Listen to the stream of messages coming from the firebase
  {
    await for (var snapshot in _fireStore //This firebase's query snapshot
        .collection('messages')
        .snapshots()) //Instead of future query snapshots, it returns a stream of snapshots like a list of futures
    //By subscribing to the stream we can listen to all the changes that happens to the messages collection.
    {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //getMessages();
    messagesStream();
    return WillPopScope(
      onWillPop: popState,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  //Implement logout functionality
                  _auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, WelcomeScreen.id, (route) => false);
                }),
          ],
          title: const Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessageStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          //Do something with the user input.
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        messageTextController.clear(); //Clear the textfield
                        //Implement send functionality.
                        //messageText+loggedInUser.email
                        // print(
                        //     'Message is $messageText Logged in user is $loggedInUser');
                       await _fireStore.collection('messages').add(
                            {'text': messageText, 'sender': loggedInUser.email,'time': Timestamp.now()});
                      },
                      child: const Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        builder: (context,
                snapshot) //This snapshot is not the same as we used above. This is flutter's async snapshot
//Async snapshot actually contain the query snapshot from firebase
            {
          if (snapshot.hasData) {
            final messages =
                snapshot.data!.docs.reversed; //Access data inside Async snapshot
            //Reverse helps to display message at bottom instead of top
            List<MessageBubble> messageBubbles = [];
            for (var message
                in messages) //message is document snapshot from firebase
            {
              final messageText = message.get(
                  'text'); //Returns the value at the field or null if the field doesn't exist.//This does not exist now- Data is a map of keys which are consisting of string and the value can be dynamic
              final messageSender = message.get('sender');
              final Timestamp messageTime = message.get('time');
              final currentuser=loggedInUser.email;

//final messageWidget=Text('$messageText from $messageSender');
              final messageBubble =
                  MessageBubble(sender: messageSender, text: messageText,isLoggedInUser: currentuser==messageSender,time:messageTime);
              messageBubbles.add(messageBubble);
            }
            return Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                reverse: true,
                children: messageBubbles,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.red),
            );
          }
        },
        stream: _fireStore
            .collection('messages').orderBy('time',descending:false)
            .snapshots()); //Snapshots() return a stream of query snapshots. It is a dat ype that comes from firebase cloud firestore
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.sender, required this.text, required this.isLoggedInUser, required this.time});
  final String sender;
  final String text;
  final bool isLoggedInUser;
  final Timestamp time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isLoggedInUser? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            ' $sender, ${DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000).toString()}',
            style: const TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            elevation: 5.0,
            borderRadius:  BorderRadius.only(
                topLeft: isLoggedInUser ? const Radius.circular(30):Radius.circular(0),
                bottomLeft: const Radius.circular(30),
                bottomRight: const Radius.circular(30),
                topRight: isLoggedInUser ? const Radius.circular(0):const Radius.circular(30)),
            color: isLoggedInUser ? Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                text,
                style:  TextStyle(
                  color: isLoggedInUser ? Colors.white:Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
