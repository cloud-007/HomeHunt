// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/screens/authentication/login_screen.dart';
import 'package:homehunt/screens/house/add_house.dart';
import 'package:homehunt/screens/house/my_listings.dart';
import 'package:homehunt/screens/profile/my_info.dart';

class ProfileSCreen extends StatefulWidget {
  const ProfileSCreen({key}) : super(key: key);

  @override
  _ProfileSCreenState createState() => _ProfileSCreenState();
}

class _ProfileSCreenState extends State<ProfileSCreen> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;
    final _width = MediaQuery.of(context).size.width;
    final _iconSize = _height * 0.02;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top * 2),
            Container(
              height: _height * 0.1,
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    height: _height * 0.1,
                    width: _height * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(_height * 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_height * 1),
                      child: Image.network(
                        FirebaseAuth.instance.currentUser.photoURL,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: _width * 0.05),
                  Text(
                    FirebaseAuth.instance.currentUser.displayName,
                    style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontSize: _height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: _height * 0.03),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MyInfo(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
                height: _height * 0.06,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(44, 130, 201, 0.2),
                  // color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(_height * 0.012),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.manage_accounts_outlined,
                          color: Theme.of(context).canvasColor,
                          size: _iconSize,
                        ),
                        SizedBox(width: _width * 0.04),
                        Text(
                          'My Info',
                          style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontSize: _iconSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.navigate_next,
                      color: Theme.of(context).canvasColor,
                      size: _iconSize,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: _height * 0.005),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddHouse(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
                height: _height * 0.06,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(44, 130, 201, 0.2),
                  // color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(_height * 0.012),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ImageIcon(
                          AssetImage('assets/icons/add.png'),
                          color: Theme.of(context).canvasColor,
                          size: _iconSize,
                        ),
                        SizedBox(width: _width * 0.04),
                        Text(
                          'Add House',
                          style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontSize: _iconSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.navigate_next,
                      color: Theme.of(context).canvasColor,
                      size: _iconSize,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: _height * 0.005),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MyListing(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
                height: _height * 0.06,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(44, 130, 201, 0.2),
                  // color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(_height * 0.012),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.house_outlined,
                          color: Theme.of(context).canvasColor,
                          size: _iconSize,
                        ),
                        SizedBox(width: _width * 0.04),
                        Text(
                          'My Listings',
                          style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontSize: _iconSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.navigate_next,
                      color: Theme.of(context).canvasColor,
                      size: _iconSize,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: _height * 0.005),
            Container(
              padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
              height: _height * 0.06,
              decoration: BoxDecoration(
                color: Color.fromRGBO(44, 130, 201, 0.2),
                // color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(_height * 0.012),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.help_center_outlined,
                        color: Theme.of(context).canvasColor,
                        size: _iconSize,
                      ),
                      SizedBox(width: _width * 0.04),
                      Text(
                        'About HomeHunt',
                        style: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontSize: _iconSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: Theme.of(context).canvasColor,
                    size: _iconSize,
                  ),
                ],
              ),
            ),
            SizedBox(height: _height * 0.01),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
                height: _height * 0.05,
                decoration: BoxDecoration(
                  color: Colors.red.shade400.withOpacity(0.9),
                  // color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(_height * 0.012),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.logout_outlined,
                          color: Colors.white,
                          size: _iconSize,
                        ),
                        SizedBox(width: _width * 0.04),
                        Text(
                          'LOGOUT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _iconSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                      size: _iconSize,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
