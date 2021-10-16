// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homehunt/screens/login_register/login_screen.dart';
import 'package:homehunt/widgets/app_name.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  final _emailController = TextEditingController();
  bool isLoading = false;
  bool hasError = false;

  final _auth = FirebaseAuth.instance;

  bool validateAndSave() {
    final FormState form = _formKey.currentState;
    FocusScope.of(context).unfocus();
    if (form.validate()) {
      print('Form is valid');
      return true;
    } else {
      print('Form is invalid');
      return false;
    }
  }

  Future<void> _trySubmit() async {
    UserCredential authResult;
    if (validateAndSave() == false) return;
    setState(() {
      isLoading = true;
    });
    try {
      await _auth.sendPasswordResetEmail(email: _email);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset link has been send to ' + _email),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: _height * .20),
                  child: AppName(),
                ),
                SizedBox(height: _height * 0.13),
                TextFormField(
                  cursorColor: Theme.of(context).primaryColorDark,
                  cursorHeight: _height * 0.025,
                  controller: _emailController,
                  key: ValueKey('email'),
                  validator: (value) {
                    bool emailValid =
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`"
                                "{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
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
                      fontSize: _height * 0.018,
                      letterSpacing: 1.2,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).backgroundColor,
                        width: 0.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: _height * 0.018,
                    letterSpacing: 1.2,
                  ),
                  onChanged: (value) {
                    _email = value;
                  },
                  onSaved: (value) {
                    _email = value;
                  },
                ),
                SizedBox(height: _height * 0.02),
                if (isLoading)
                  Container(
                    color: Theme.of(context).backgroundColor,
                    height: _height * 0.030,
                    width: _height * 0.030,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.green.shade800,
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                if (!isLoading)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade500,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: _trySubmit,
                      child: Text(
                        'Request Change',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: _height * 0.02,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                TextButton(
                  child: Text(
                    'Remember your password?',
                    style: TextStyle(
                      fontSize: _height * 0.017,
                      fontFamily: 'Montserrat-ExtraLight',
                      color: Theme.of(context).primaryColorDark,
                      letterSpacing: 1,
                    ),
                  ),
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
    );
  }
}
