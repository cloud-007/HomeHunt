import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/screens/chat/chat_screen.dart';
import 'package:homehunt/widgets/circular_indicator.dart';

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
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        //  centerTitle: true,
        backgroundColor: Theme.of(context).hoverColor,
        foregroundColor: Theme.of(context).canvasColor,
        shadowColor: Theme.of(context).primaryColor,
        elevation: 10,
        toolbarHeight: _height * 0.06,
        titleTextStyle: TextStyle(
          fontSize: _height * 0.025,
          letterSpacing: _height * 0.001,
        ),
        title: const Text(
          '    CHATS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _width * 0.02,
          vertical: _height * 0.02,
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chatuid').where('user',
              arrayContainsAny: [
                FirebaseAuth.instance.currentUser.uid.toString().trim()
              ]).snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularIndicator());
            } else {
              final chatDocs = chatSnapshot.data.docs;
              if (chatDocs.isEmpty) {
                return const Center(
                  child: Text(
                    'Nothing Found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) => GestureDetector(
                    onTap: () {
                      bool status = FirebaseAuth.instance.currentUser.uid
                              .toString()
                              .trim() ==
                          chatDocs[index]['user'][0];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatDocs[index]['chatId'],
                            status
                                ? chatDocs[index]['user'][1]
                                : chatDocs[index]['user'][0],
                            status
                                ? chatDocs[index]['username'][1]
                                : chatDocs[index]['username'][0],
                            status
                                ? chatDocs[index]['userUrl'][1]
                                : chatDocs[index]['userUrl'][0],
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: _height * 0.01),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: _height * 0.05,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).hoverColor,
                            borderRadius:
                                BorderRadius.circular(_height * 0.012),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: _width * 0.05),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(chatDocs[index]
                                              ['user'][0] ==
                                          FirebaseAuth.instance.currentUser.uid
                                              .toString()
                                      ? chatDocs[index]['userUrl'][0]
                                      : chatDocs[index]['userUrl'][1]),
                                ),
                                SizedBox(width: _width * 0.05),
                                Text(
                                  chatDocs[index]['user'][0] ==
                                          FirebaseAuth.instance.currentUser.uid
                                              .toString()
                                      ? chatDocs[index]['username'][1]
                                      : chatDocs[index]['username'][0],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: _height * 0.025,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
