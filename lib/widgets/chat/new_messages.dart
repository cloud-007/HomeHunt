// ignore_for_file: prefer_const_constructors, avoid_print, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  String chatid;
  String userUid;
  NewMessages(this.chatid, this.userUid, {Key key}) : super(key: key);

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  String _enteredMessage = "";
  final _controller = TextEditingController();
  void _trySubmit() {
    FocusScope.of(context).unfocus();
    print(widget.chatid);

    Future.delayed(Duration(milliseconds: 100), () {
      FirebaseFirestore.instance
          .collection('messages/j5I2HhrBL63eSI6BiSlh/' + widget.chatid)
          .add({
        'text': _enteredMessage,
        'user': FirebaseAuth.instance.currentUser.uid.toString().trim(),
        'createdAt': Timestamp.now(),
      });

      setState(() {
        _enteredMessage = '';
        _controller.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a messages...',
                labelStyle: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontSize: MediaQuery.of(context).size.height * 0.023,
                ),
                // border: InputBorder.OutlineInputBorder,
              ),
              style: TextStyle(
                color: Theme.of(context).canvasColor,
                fontSize: MediaQuery.of(context).size.height * 0.023,
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Colors.blue,
            disabledColor: Colors.grey,
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _trySubmit,
          ),
        ],
      ),
    );
  }
}
