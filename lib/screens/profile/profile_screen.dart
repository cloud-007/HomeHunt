// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/screens/authentication/login_screen.dart';
import 'package:homehunt/screens/house/add_house.dart';
import 'package:homehunt/screens/house/my_listings.dart';
import 'package:homehunt/screens/profile/about_screen.dart';

class ProfileSCreen extends StatefulWidget {
  const ProfileSCreen({key}) : super(key: key);

  @override
  _ProfileSCreenState createState() => _ProfileSCreenState();
}

class _ProfileSCreenState extends State<ProfileSCreen> {
  Widget _buildWidget(Icon _icon, String name, double _height, double _iconSize,
      double _width) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
      height: _height * 0.06,
      decoration: BoxDecoration(
        color: Color.fromRGBO(44, 130, 201, 0.2),
        borderRadius: BorderRadius.circular(_height * 0.012),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _icon,
              SizedBox(width: _width * 0.04),
              Text(
                name,
                style: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontSize: _iconSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (name == 'Add House' ||
              name == 'My Listings' ||
              name == 'About HomeHunt')
            Icon(
              Icons.navigate_next,
              color: Theme.of(context).canvasColor,
              size: _iconSize,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;
    final _width = MediaQuery.of(context).size.width;
    final _iconSize = _height * 0.02;
    final _font = _height * _width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).padding.top * 2),
              Container(
                height: _height * 0.15,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: _height * 0.15,
                      width: _height * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(_height * 15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_height * 15),
                        child: Image.network(
                          FirebaseAuth.instance.currentUser.photoURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: _height * 0.03),
              _buildWidget(
                Icon(
                  Icons.manage_accounts_outlined,
                  color: Theme.of(context).canvasColor,
                  size: _font * 0.00005,
                ),
                ///username
                FirebaseAuth.instance.currentUser.displayName,
                _height,
                _font * 0.00005,
                _width,
              ),
              SizedBox(height: _height * 0.005),
              _buildWidget(
                Icon(
                  Icons.email_outlined,
                  color: Theme.of(context).canvasColor,
                  size: _font * 0.00005,
                ),

                ///useremail
                FirebaseAuth.instance.currentUser.email,
                _height,
                _font * 0.00005,
                _width,
              ),
              SizedBox(height: _height * 0.005),
              InkWell(
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
                            size: _font * 0.00005,
                          ),
                          SizedBox(width: _width * 0.04),
                          Text(
                            'Add House',
                            style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: _font * 0.00005,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: Theme.of(context).canvasColor,
                        size: _font * 0.00005,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: _height * 0.005),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyListing(),
                    ),
                  );
                },
                child: _buildWidget(
                  Icon(
                    Icons.house_outlined,
                    color: Theme.of(context).canvasColor,
                    size: _font * 0.00005,
                  ),
                  'My Listings',
                  _height,
                  _font * 0.00005,
                  _width,
                ),
              ),
              SizedBox(height: _height * 0.005),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AboutScreen(),
                    ),
                  );
                },
                child: _buildWidget(
                  Icon(
                    Icons.help_center_outlined,
                    color: Theme.of(context).canvasColor,
                    size: _font * 0.00005,
                  ),
                  'About HomeHunt',
                  _height,
                  _font * 0.00005,
                  _width,
                ),
              ),
              SizedBox(height: _height * 0.01),
              InkWell(
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
                            size: _font * 0.00005,
                          ),
                          SizedBox(width: _width * 0.04),
                          Text(
                            'LOGOUT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _font * 0.00005,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                        size: _font * 0.00005,
                      ),
                    ],
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
