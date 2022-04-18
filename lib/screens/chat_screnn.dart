// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser; //this will giv us the email

class ChatScreen extends StatefulWidget {
  static const String screenRoute = "chat_screnn";

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextControler = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText; //this will giv us the message
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

// //shehabb@gmail.com
  void getCurrentUser() {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
      // AwesomeDialog(context: context,title: "Erroe",body: Text("The User is olredy sin in"),);
    }
  }

  // void getmessages()async{
  //  final messages=await _firestore.collection("messages").get();
  //   for(var message  in messages.docs ){
  //     print(message.data());
  //   }
  // }
  // void messagesStreams() async {
  //   await for (var snapshot in _firestore.collection("messages").snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900]!,
        title: Row(
          children: [
            Image.asset(
              "images/chat.png",
              height: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text("MessageMe"),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                //add her log out function
                _auth.signOut();
                Navigator.pop(context);
                // getmessages();
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBulder(),
            Container(
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.orange, width: 2))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextControler,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          border: InputBorder.none,
                          hintText: 'Write your messages here...'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextControler.clear();
                      _firestore.collection("messages").add({
                        "text": messageText,
                        "sender": signedInUser.email,
                        "time": FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      "send",
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageStreamBulder extends StatelessWidget {
  const MessageStreamBulder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").orderBy("time").snapshots(),
      builder: (context, snapshot) {
        List<MessageLine> messageWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 42, 78, 107),
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get("text");
          final messageSender = message.get("sender");
          final currentUser = signedInUser.email;

          final messageWidget = MessageLine(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({this.sender, this.text, required this.isMe, Key? key})
      : super(key: key);
  final String? sender;
  final String? text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$sender",
            style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 124, 95, 69)),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
            color: isMe ? Color.fromARGB(255, 0, 76, 163) : Color.fromARGB(255, 92, 155, 80),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 17, color: isMe ? Color.fromARGB(255, 253, 253, 253) : Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
