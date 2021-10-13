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
        fontFamily: 'Crete_Round',
        letterSpacing: 1.5,
        /* shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 15,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
           BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 15,
            blurRadius: 10,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],*/
      ),
    );
  }
}
