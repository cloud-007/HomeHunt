// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/screens/authentication/register_screen.dart';
import 'package:homehunt/screens/home/main_screen.dart';
import 'package:homehunt/widgets/circular_indicator.dart';

class VerifyScreenNew extends StatefulWidget {
  UserCredential authResult;
  final File _userImageFile;
  final String _email;
  final String _username;
  final String _password;
  VerifyScreenNew(this.authResult, this._userImageFile, this._email,
      this._username, this._password,
      {Key key})
      : super(key: key);

  @override
  _VerifyScreenNewState createState() => _VerifyScreenNewState();
}

class _VerifyScreenNewState extends State<VerifyScreenNew> {
  bool isLoading = false;
  bool once = false;
  final _auth = FirebaseAuth.instance;
  User user;

  Future<void> _trySubmit() async {
    setState(() {
      isLoading = true;
    });
    user = _auth.currentUser;
    await user.reload();
    print(user.emailVerified);
    if (user.emailVerified == false) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Email is not verified yet'),
            backgroundColor: Theme.of(context).errorColor),
      );
      return;
    }
    try {
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

      User curUser = FirebaseAuth.instance.currentUser;
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
        'uid': FirebaseAuth.instance.currentUser.uid,
      });
      await Future.delayed(const Duration(seconds: 5), () {});
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
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
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      user.delete();
      String message = 'Email verification failed!';
      if (e.message != null) {
        message = e.message.toString();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RegisterScreen(),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = true;
      });
      user.delete();
      String message = 'Email verification failed!';
      if (e.message != null) {
        message = e.message.toString();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RegisterScreen(),
        ),
      );

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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'An email has been send to ${widget._email}. Click Continue after '
                'you verify your email address.',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              if (isLoading) CircularIndicator(),
              if (!isLoading)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade500,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: _trySubmit,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
