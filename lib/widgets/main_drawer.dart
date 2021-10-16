// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(
      String title, IconData icon, BuildContext context, Widget route) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => route),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            //    foregroundImage: Database.getImage(),
          ),
          SizedBox(height: 20),
          // buildListTile('Meals', Icons.restaurant, context, HomeScreen(widget.imageUrl)),
          //  buildListTile('Filters', Icons.settings, context, HomeScreen()),
        ],
      ),
    );
  }
}
