import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notification_app/home_page.dart';
import 'package:notification_app/services/authentication_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffFEC37B),
                      Color(0xffFF4184),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: size.width * .8,
                          height: size.width * .8,
                          child: Lottie.asset('assets/images/login.json')),
                      SizedBox(height: size.height * .1),
                      InkWell(
                        onTap: () {
                          setState(() {
                            showSpinner = true;
                          });
                          AuthHelper().signInWithGoogle().then((value) async {
                            setState(() {
                              showSpinner = false;
                            });
                            await FirebaseMessaging.instance
                                .getToken()
                                .then((value) {
                              AuthHelper().storeToken(value);
                              // print(value);
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          });
                        },
                        child: Container(
                          height: size.height * .07,
                          width: size.width * .7,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Sign In With Google',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
