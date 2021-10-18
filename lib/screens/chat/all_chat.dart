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
        MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Theme.of(context).canvasColor,
        shadowColor: Theme.of(context).primaryColor,
        elevation: 10,
        toolbarHeight: _height * 0.06,
        titleTextStyle: TextStyle(
          fontSize: _height * 0.025,
          letterSpacing: _height * 0.001,
        ),
        title: const Text(
          'CHATS',
        ),
      ),
    );
  }
}
