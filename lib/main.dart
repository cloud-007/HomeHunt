// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homehunt/screens/authentication/login_screen.dart';
import 'package:homehunt/screens/home/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  ///matches app color and status bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  //lock device orientation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
  //runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.lightBlue.shade800,
        backgroundColor: Colors.lightBlue.shade900,
        hoverColor: Color.fromRGBO(44, 130, 201, 0.2),
        primaryColorDark: Colors.white,
        errorColor: Colors.red,
        canvasColor: Colors.cyan.shade50,
        cardColor: Colors.amber.shade800,
        fontFamily: "Montserrat-ExtraLight",
      ),
      home: FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser.emailVerified
          ? MainScreen()
          : LoginScreen(),
    );
  }
}
