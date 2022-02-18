import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notification_app/home_page.dart';
import 'package:notification_app/services/authentication_helper.dart';
import 'package:notification_app/verification_screens/login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseMessaging.instance.getToken().then((value) {
        AuthHelper().storeToken(value);
      });
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Circular',
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Circular',
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
      );
    }
  }
}
