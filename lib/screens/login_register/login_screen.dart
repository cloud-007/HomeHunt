// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, use_key_in_widget_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables, avoid_print, unnecessary_string_escapes, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homehunt/screens/login_register/register_screen.dart';
import 'package:homehunt/screens/login_register/reset_password.dart';
import 'package:homehunt/screens/home/main_screen.dart';
import 'package:homehunt/widgets/app_name.dart';
import 'package:homehunt/widgets/circular_indicator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isWrongPassword = false;

  String _email = '';
  String _password = '';
  String imageUrl = '';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _tryValidate() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  void _trySubmit() async {
    UserCredential authResult;
    if (_tryValidate() == false) return;
    try {
      print(_email);
      print(_password);
      setState(() {
        isLoading = true;
      });
      authResult = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      imageUrl = userData['imageUrl'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => MainScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred, please check your credentials!';
      if (e.message != null) {
        message = e.message.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        isLoading = false;
        isWrongPassword = true;
      });
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(_width * 0.04),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                ///placing the widget on by one
                children: <Widget>[
                  AppName(),
                  SizedBox(height: _height * 0.07),
                  SizedBox(height: _height * 0.07),

                  ///email field
                  TextFormField(
                    cursorColor: Theme.of(context).primaryColorDark,
                    cursorHeight: _height * 0.025,
                    controller: _emailController,
                    key: ValueKey('email'),
                    validator: (value) {
                      bool emailValid =
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`"
                                  "{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                      if (!emailValid) {
                        return 'Please check yor email';
                      } else {
                        return null;
                      }
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(RegExp("[' ']")),
                    ],
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: _height * 0.02,
                        letterSpacing: 1.2,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColorDark,
                          width: 0.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: _height * 0.02,
                      letterSpacing: 1.2,
                    ),
                    onChanged: (value) {
                      _email = value;
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                  ),

                  SizedBox(height: _height * 0.03),

                  ///password field for both login and signup
                  TextFormField(
                    cursorColor: Theme.of(context).primaryColorDark,
                    cursorHeight: _height * 0.025,
                    controller: _passwordController,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        if (value.isNotEmpty) isWrongPassword = true;
                        return 'Password must be at least 7 characters long';
                      } else {
                        isWrongPassword = false;
                        return null;
                      }
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(RegExp("[' ']")),
                    ],
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: _height * 0.02,
                        letterSpacing: 1.2,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColorDark,
                          width: 0.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: _height * 0.02,
                      letterSpacing: 1.2,
                    ),
                    onChanged: (value) {
                      _password = value;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                  if (isWrongPassword)
                    Padding(
                      padding: EdgeInsets.only(right: _width * 0.005),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      ResetPassword(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: _width * 0.032,
                                color: Colors.red,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: _height * 0.012),
                  if (isLoading) CircularIndicator(),
                  if (!isLoading)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.shade900,
                          width: 0.50,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: _trySubmit,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: _height * 0.035,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'New User? ',
                          style: TextStyle(
                            fontSize: _width * 0.037,
                            color: Colors.blueGrey,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(width: _width * 0.01),
                        Text(
                          'Register Now!',
                          style: TextStyle(
                            fontSize: _width * 0.037,
                            color: Colors.green,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => RegisterScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
