import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:message_me/screens/chat_screnn.dart';
import 'package:message_me/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:message_me/App_localization.dart';

class RegisrationScreen extends StatefulWidget {
  static const String screenRoute = "registration_screen";
  const RegisrationScreen({Key? key}) : super(key: key);

  @override
  State<RegisrationScreen> createState() => _RegisrationScreenState();
}

class _RegisrationScreenState extends State<RegisrationScreen> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showspineer = false;
  late UserCredential userCredential;

  late String myemail;
  late String mypassword;
  register() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      setState(() {
        showspineer = true;
      });
      try {
        setState(() {
          showspineer = false;
        });
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: myemail, password: mypassword);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
            context: context,
            title: "Error",
            body: Text("password is too weak"),
          )..show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
            context: context,
            title: "Error",
            body: Text("The account already exists for that email"),
          )..show();
        }
        return Navigator.pushReplacementNamed(context, ChatScreen.screenRoute);
      } catch (e) {
        print(e);
      }
    } else {
      print("Nat valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showspineer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                child: Image.asset("images/logo.png"),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                key: formstate,
                child: Column(children: [
                  TextFormField(
                    validator: (val) {
                      if (val!.length > 100) {
                        return "Email can not to be alrger than 100 ";
                      }
                      if (val.length < 12) {
                        return "Email can not to be less than 12 letter ";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      mypassword = val!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      myemail = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your Email",
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  mypassword = value;
                },
                decoration: InputDecoration(
                  hintText: "Enter your Password",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink, width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              MyButton(
                  color: Colors.blue[800]!,
                  onPressed: () async {
                    await register();

                    // print(mypassword);
                    // print(myemail);
                    // Navigator.of(context).pushReplacementNamed(ChatScreen.screenRoute);
                  },
                  title: "register"),
            ],
          ),
        ),
      ),
    );
  }
}
