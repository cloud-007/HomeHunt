// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AppName extends StatelessWidget {
  const AppName({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'HomeHunt',
      style: TextStyle(
        color: Theme.of(context).primaryColorDark,
        fontSize: MediaQuery.of(context).size.height * 0.07,
        fontFamily: 'Montserrat-ExtraLight',
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
    );
  }
}
