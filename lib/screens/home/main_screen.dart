// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/screens/chat/all_chat.dart';
import 'package:homehunt/screens/chat/chat_screen.dart';
import 'package:homehunt/screens/home/discover.dart';
import 'package:homehunt/screens/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;
  List<Widget> pageList = <Widget>[
    HomeScreen(),
    AllChatScreen(),
    ProfileSCreen(),
    ProfileSCreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[pageIndex],
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.lightBlue.shade900,
          selectedItemColor: Theme.of(context).primaryColorDark,
          selectedFontSize: MediaQuery.of(context).size.height * 0.013,
          currentIndex: pageIndex,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedFontSize: MediaQuery.of(context).size.height * 0.011,
          unselectedItemColor: Colors.white54,
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 0 ? Icons.explore_sharp : Icons.explore_outlined,
                size: MediaQuery.of(context).size.height * 0.025,
              ),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 1
                    ? Icons.chat_bubble
                    : Icons.chat_bubble_outline_outlined,
                size: MediaQuery.of(context).size.height * 0.025,
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 2 ? Icons.favorite : Icons.favorite_border,
                size: MediaQuery.of(context).size.height * 0.025,
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundImage:
                    NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
                radius: MediaQuery.of(context).size.height * 0.015,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
