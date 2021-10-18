// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.isMe, this.username, this.hour, this.minute,
      {key})
      : super(key: key);

  final String message;
  final bool isMe;
  final String username;
  String hour;
  String minute;
  String ampm;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    if (hour.length == 1) {
      hour = '0' + hour;
      ampm = 'AM';
    } else if (hour == '11') {
      ampm = 'AM';
    } else {
      ampm = 'PM';
    }
    if (minute.length == 1) {
      minute = '0' + minute;
    }
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: _width * 0.7,
          decoration: BoxDecoration(
            color:
                isMe ? Colors.green.shade700 : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft:
                  isMe ? Radius.circular(_height * 0.015) : Radius.circular(0),
              topLeft:
                  isMe ? Radius.circular(_height * 0.015) : Radius.circular(0),
              bottomRight:
                  isMe ? Radius.circular(0) : Radius.circular(_height * 0.015),
              topRight:
                  isMe ? Radius.circular(0) : Radius.circular(_height * 0.015),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _width * 0.02,
            vertical: _height * 0.01,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.transparent,
                width: _width * 0.5,
                child: Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontSize: _height * 0.019,
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                width: _width * 0.125,
                child: Text(
                  hour + ':' + minute + ' ' + ampm,
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontSize: _height * 0.015,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
