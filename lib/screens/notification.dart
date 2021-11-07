import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/widgets/circular_indicator.dart';
import 'package:homehunt/widgets/notification_bubble.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool notLoaded = false;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Hero(
      tag: 'Notification',
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            'Notifications',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height *
                  MediaQuery.of(context).size.width *
                  0.00008,
            ),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back)),
          actions: [
            InkWell(
              onTap: () {
                setState(() async {
                  CollectionReference deletenotification = FirebaseFirestore
                      .instance
                      .collection('notification/3CxlzQHlP2BkxLIBDIur/' +
                          FirebaseAuth.instance.currentUser.uid
                              .toString()
                              .trim());
                  var snapshots = await deletenotification.get();
                  for (var doc in snapshots.docs) {
                    await doc.reference.delete();
                  }
                });
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _width * 0.02,
            vertical: _height * 0.02,
          ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('notification/3CxlzQHlP2BkxLIBDIur/' +
                    FirebaseAuth.instance.currentUser.uid.toString().trim())
                .where('touid',
                    isEqualTo:
                        FirebaseAuth.instance.currentUser.uid.toString().trim())
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (notLoaded == false)
                Future.delayed(const Duration(seconds: 1), () {
                  setState(
                    () {},
                  );
                });
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularIndicator());
              } else {
                notLoaded = true;
                final chatDocs = chatSnapshot.data.docs;
                if (chatDocs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No New Notification',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                print('Data Found' + chatDocs.length.toString());
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) =>
                      NoificationBubble(chatDocs[index]),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
