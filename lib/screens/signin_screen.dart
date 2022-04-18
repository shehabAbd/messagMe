import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:message_me/screens/chat_screnn.dart';
import 'package:message_me/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SigninScreen extends StatefulWidget {
  static const String screenRoute = "signin_screen";
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  signIn() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      setState(() {
        showspiner = true;
      });
      try {
        setState(() {
            showspiner = false;
          },);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
           if (userCredential != null) {
          return
          Navigator.pushReplacementNamed(context, ChatScreen.screenRoute);
        }
        return  Navigator.of(context).pushReplacementNamed("homepage");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
                  context: context,
                  title: "Erorr",
                  body: Text('No user found for that email.'))
              .show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
                  context: context,
                  title: "Erorr",
                  body: Text('Wrong password provided for that user.'))
              .show();
        }
      }}}
  //     try {
  //       setState(() {
  //           showspiner = false;
  //         },);
  //       final user = await _auth.signInWithEmailAndPassword(
  //           email: email, password: password);
  //       
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     print("Nat valid");
  //   }
  // }

  bool showspiner = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showspiner,
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
                child: Column(
                  children: [
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
                        password = val!;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (val) {
                        email = val;
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
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                validator: (val) {
                  if (val!.length > 100) {
                    return "Password can not to be alrger than 100 ";
                  }
                  if (val.length < 4) {
                    return "Password can not to be less than 4 letter ";
                  }
                  return null;
                },
                onSaved: (val) {
                  password = val!;
                },
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (val) {
                  password = val;
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
                  color: Colors.yellow[900]!,
                  onPressed: () async {
                    await signIn();
                         
                  },
                  title: "sign in"),
            ],
          ),
        ),
      ),
    );
  }
}
