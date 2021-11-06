// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:homehunt/widgets/chat/messages.dart';
import 'package:homehunt/widgets/chat/new_messages.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  String chatid;
  String userUid;
  String username;
  String userImageUrl;
  ChatScreen(this.chatid, this.userUid, this.username, this.userImageUrl,
      {Key key})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;
    final _width = MediaQuery.of(context).size.width;
    return Hero(
      tag: 'chat',
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                height: _height * 0.1,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: _height * 0.032),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Theme.of(context).primaryColorDark,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: _width * 0.02),
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.userImageUrl),
                        radius: _height * 0.02,
                      ),
                      SizedBox(width: _width * 0.02),
                      Text(
                        widget.username,
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: _height * 0.025,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Messages(widget.chatid, widget.userUid, widget.username),
              ),
              NewMessages(widget.chatid, widget.userUid),
            ],
          ),
        ),
      ),
    );
  }
}
