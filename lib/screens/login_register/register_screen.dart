// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, use_key_in_widget_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables, avoid_print, unused_local_variable, unnecessary_string_escapes

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homehunt/screens/login_register/login_screen.dart';
import 'package:homehunt/widgets/app_name.dart';
import 'package:homehunt/widgets/auth/veryfy_new.dart';
import 'package:homehunt/widgets/circular_indicator.dart';
import 'package:homehunt/widgets/image_picker/auth_image_picker.dart';

class RegisterScreen extends StatefulWidget {
  static String pageRoute = '/register-screen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  File _userImageFile;

  String _email = '';
  String _username = '';
  String _password = '';
  String imageUrl = 'assets/images/defaultProfile.jpg';

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _pickedImage(File image) {
    if (image == null) {
      _userImageFile = File('assets/images/defaultProfile.png');
    } else {
      _userImageFile = image;
    }
  }

  bool _tryValidate() {
    final isValid = _formKey.currentState.validate();
    if (_userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide a profile picture'),
          backgroundColor: Colors.blue,
        ),
      );
      return false;
    }
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

      authResult = await _auth
          .createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      )
          .then((_) {
        final user = FirebaseAuth.instance.currentUser;
        user.sendEmailVerification();
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => VerifyScreenNew(
              authResult,
              _userImageFile,
              _email,
              _username,
              _password,
            ),
          ),
        );
      });
      setState(() {
        isLoading = false;
      });
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(_width * 0.04),
        child: Center(
          ///to Place the widget in the center
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                ///placing the widget on by one
                children: <Widget>[
                  AppName(),
                  SizedBox(height: _height * (0.05)),

                  ///picking image if user signing up
                  UserImagePicker(_pickedImage),
                  SizedBox(height: _height * 0.01),

                  TextFormField(
                    cursorColor: Colors.black,
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

                  ///username field if only for signup page
                  SizedBox(height: _height * 0.03),
                  TextFormField(
                    cursorColor: Theme.of(context).primaryColorDark,
                    cursorHeight: _height * 0.025,
                    controller: _usernameController,
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Username should at least be 5 characters.';
                      } else {
                        return null;
                      }
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(RegExp("[' ']")),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      labelText: 'Username',
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
                      _username = value;
                    },
                    onSaved: (value) {
                      _username = value;
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
                        return 'Password must be at least 7 characters long';
                      } else {
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                          'Register',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: _height * 0.035,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  TextButton(
                    child: Text('Already have an account?',
                        style: TextStyle(
                          color: Colors.green,
                        )),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen(),
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
