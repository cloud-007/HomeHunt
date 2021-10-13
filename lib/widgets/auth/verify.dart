// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/screens/login_register/register_screen.dart';
import 'package:homehunt/screens/home/main_screen.dart';

class VerifyScreen extends StatefulWidget {
  UserCredential authResult;
  final File _userImageFile;
  final String _email;
  final String _username;
  final String _password;
  VerifyScreen(
    this.authResult,
    this._userImageFile,
    this._email,
    this._username,
    this._password,
  );

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  int totalSecond = 180;
  String imageUrl;
  bool once = false;
  bool done = false;

  @override
  void initState() {
    user = _auth.currentUser;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (totalSecond == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email verification timed out'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        user.delete();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => RegisterScreen(),
          ),
        );
      }
      if (!done) checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    user = _auth.currentUser;
    try {
      totalSecond -= 3;
      await user.reload();
      if (user.emailVerified) {
        done = true;
        widget.authResult = await _auth.signInWithEmailAndPassword(
          email: widget._email,
          password: widget._password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(widget.authResult.user.uid + '.jpg');

        await ref.putFile(widget._userImageFile);
        //...Fetching image url
        final url = await ref.getDownloadURL();

        User curUser = widget.authResult.user;
        curUser.updatePhotoURL(url);
        curUser.updateDisplayName(widget._username);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.authResult.user.uid)
            .set({
          'username': widget._username,
          'email': widget._email,
          'password': widget._password,
          'imageUrl': url,
        });
        final user = FirebaseAuth.instance.currentUser;
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        imageUrl = userData['imageUrl'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(),
          ),
        );
        if (once == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('user has been verified'),
              backgroundColor: Colors.green,
            ),
          );
        }
        once = true;
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Email verification failed!';
      if (e.message != null) {
        message = e.message.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (e) {
      String message = 'Email verification failed!';
      if (e.message != null) {
        message = e.message.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Text(
            'An email has been send to ${user.email}. You will be taken to the '
            'main screen as soon as you verify your email address.',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
