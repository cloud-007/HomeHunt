import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({key}) : super(key: key);

  @override
  _AllChatScreenState createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: _height * 0.07,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: _height * 0.025,
          fontFamily: 'Crete_Round',
          letterSpacing: _height * 0.001,
        ),
        title: const Text(
          'CHATS',
        ),
      ),
    );
  }
}
