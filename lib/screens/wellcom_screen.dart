import 'package:flutter/material.dart';
import 'package:message_me/screens/registration_screen.dart';
import 'package:message_me/screens/signin_screen.dart';
import 'package:message_me/widgets/my_button.dart';

class WellcomScreen extends StatefulWidget {
  static const String screenRoute = "wellcom_screen";

  const WellcomScreen({Key? key}) : super(key: key);

  @override
  State<WellcomScreen> createState() => _WellcomScreenState();
}

class _WellcomScreenState extends State<WellcomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 180,
                  child: Image.asset("images/logo.png"),
                ),
                Text(
                  "MessageMe",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff2e386b)),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            MyButton(
              color: Colors.yellow[900]!,
              title: 'Sign in',
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(SigninScreen.screenRoute);
              },
            ),
            MyButton(
              color: Colors.blue,
              title: "register",
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RegisrationScreen.screenRoute);
              },
            )
          ],
        ),
      ),
    );
  }
}
