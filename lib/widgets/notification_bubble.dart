import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NoificationBubble extends StatefulWidget {
  final chatDocs;
  const NoificationBubble(this.chatDocs, {key}) : super(key: key);

  @override
  _NoificationBubbleState createState() => _NoificationBubbleState();
}

class _NoificationBubbleState extends State<NoificationBubble> {
  bool isWarning = false;

  void _deleteNotification() async {
    CollectionReference delete =
        FirebaseFirestore.instance.collection('notification');
    await delete
        .doc('3CxlzQHlP2BkxLIBDIur')
        .collection(FirebaseAuth.instance.currentUser.uid.toString().trim())
        .doc(widget.chatDocs['houseid'])
        .delete()
        .then((value) => null)
        .catchError((error) => null);
  }

  void _updateNotification() async {
    print(widget.chatDocs['houseid']);
    print(widget.chatDocs['fromuid']);
    print(widget.chatDocs['requested']);

    await FirebaseFirestore.instance
        .collection('notification')
        .doc('3CxlzQHlP2BkxLIBDIur')
        .collection(widget.chatDocs['fromuid'])
        .doc(widget.chatDocs['houseid'])
        .set({
      'fromuid': FirebaseAuth.instance.currentUser.uid.toString().trim(),
      'touid': widget.chatDocs['fromuid'],
      'houseid': widget.chatDocs['houseid'],
      'housename': widget.chatDocs['housename'],
      'username':
          FirebaseAuth.instance.currentUser.displayName.toString().trim(),
      'time': Timestamp.now(),
      'requested': false,
    });

    _deleteNotification();

    /*await FirebaseFirestore.instance
        .collection('notification')
        .doc('3CxlzQHlP2BkxLIBDIur')
        .collection(FirebaseAuth.instance.currentUser.uid.toString().trim())
        .doc(widget.chatDocs['houseid'])
        .update({
      'fromuid': FirebaseAuth.instance.currentUser.uid.toString().trim(),
      'touid': widget.chatDocs['fromuid'],
      'username':
          FirebaseAuth.instance.currentUser.displayName.toString().trim(),
      'time': Timestamp.now(),
      'requested': false,
    });*/
    CollectionReference deleteHouse =
        FirebaseFirestore.instance.collection('houses');
    await deleteHouse
        .doc(widget.chatDocs['houseid'])
        .delete()
        .then((value) => null)
        .catchError((error) => null);
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        InkWell(
          onTap: () {
            if (widget.chatDocs['requested'])
              setState(() {
                isWarning = true;
              });
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.only(bottom: _height * 0.01),
            height: _height * 0.05,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).hoverColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.chatDocs['requested'] == true
                        ? widget.chatDocs['username'] +
                            ' has requested for ' +
                            widget.chatDocs['housename']
                        : widget.chatDocs['username'] +
                            ' has confirmed rent for ' +
                            widget.chatDocs['housename'],
                    style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: _width * 0.02),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _deleteNotification();
                        });
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: _height * _width * 0.00004,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        isWarning
            ? Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: _width * 0.02,
                    vertical: _height * 0.01,
                  ),
                  height: _height * 0.2,
                  width: _width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'WARNING!',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: _height * _width * 0.00006,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: _height * 0.005),
                      Text(
                        'Are you sure to rent this house to ' +
                            widget.chatDocs['username'] +
                            '?',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: _height * _width * 0.000045,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: _height * 0.01),
                      Container(
                        height: _height * 0.04,
                        width: _width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isWarning = false;
                            });
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: _height * 0.02,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: _height * 0.01),
                      Container(
                        height: _height * 0.04,
                        width: _width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            _updateNotification();
                            setState(
                              () {
                                isWarning = false;
                              },
                            );
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: _height * 0.02,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
