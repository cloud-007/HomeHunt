// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/widgets/chat/message_bubbles.dart';

class Messages extends StatefulWidget {
  final String chatid;
  final String userid;
  final String username;
  const Messages(this.chatid, this.userid, this.username, {key})
      : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
              'messages/j5I2HhrBL63eSI6BiSlh/' + widget.chatid.toString())
          .orderBy('createdAt')
          .snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final dataDocs = streamSnapshot.data.docs;
        return ListView.builder(
          itemCount: dataDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            dataDocs[index]['text'],
            dataDocs[index]['user'] == FirebaseAuth.instance.currentUser.uid,
            widget.username,
            DateTime.fromMicrosecondsSinceEpoch(
                    dataDocs[index]['createdAt'].microsecondsSinceEpoch)
                .hour
                .toString(),
            DateTime.fromMicrosecondsSinceEpoch(
                    dataDocs[index]['createdAt'].microsecondsSinceEpoch)
                .minute
                .toString(),
          ),
        );
      },
    );
  }
}
