// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/model/house.dart';
import 'package:homehunt/screens/house/house_details.dart';
import 'package:homehunt/widgets/circular_indicator.dart';
import 'package:homehunt/widgets/HomeScreen/housecarousel.dart';

class HomeScreenListView extends StatefulWidget {
  final int _selectedIndex;
  final String searchText;
  const HomeScreenListView(this._selectedIndex, this.searchText, {key})
      : super(key: key);

  @override
  State<HomeScreenListView> createState() => _HomeScreenListViewState();
}

class _HomeScreenListViewState extends State<HomeScreenListView> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _font =
        MediaQuery.of(context).size.height * MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Container(
          child: StreamBuilder(
            stream: widget._selectedIndex == 0
                ? FirebaseFirestore.instance
                    .collection('houses')
                    .where('location', isEqualTo: widget.searchText)
                    .snapshots()
                : widget._selectedIndex == 1
                    ? FirebaseFirestore.instance
                        .collection('houses')
                        .where('type', isEqualTo: 'Family')
                        .where('location', isEqualTo: widget.searchText)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('houses')
                        .where('type', isEqualTo: 'Bachelor')
                        .where('location', isEqualTo: widget.searchText)
                        .snapshots(),
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
                    itemBuilder: (ctx, index) => InkWell(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String photoURL;
                        bool favouriteStatus = false;
                        String favuid = '';
                        await FirebaseFirestore.instance
                            .collection('users')
                            .where('uid', isEqualTo: chatDocs[index]['uid'])
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) async {
                            print("Printing image url" + doc["imageUrl"]);
                            photoURL = doc["imageUrl"];
                          });
                        });

                        print('favourites/jJf5PtV8pts0A2fGEa8j/' +
                            FirebaseAuth.instance.currentUser.uid
                                .toString()
                                .trim());

                        await FirebaseFirestore.instance
                            .collection('favourites/jJf5PtV8pts0A2fGEa8j/' +
                                FirebaseAuth.instance.currentUser.uid
                                    .toString()
                                    .trim())
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) async {
                            if (doc["houseid"] == chatDocs[index].id) {
                              favouriteStatus = true;
                              favuid = doc["uid"];
                            }
                          });
                        });

                        print(favuid);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => HouseDetail(
                              chatDocs[index]['name'],
                              chatDocs[index]['type'],
                              chatDocs[index]['apartmentType'],
                              chatDocs[index]['price'],
                              chatDocs[index]['location'],
                              chatDocs[index]['bedroom'],
                              chatDocs[index]['bathrooms'],
                              chatDocs[index]['phoneNumber'],
                              chatDocs[index].id,
                              chatDocs[index]['uid'],
                              chatDocs[index]['username'],
                              photoURL,
                              favouriteStatus,
                              favuid,
                              chatDocs[index]['imageUrl'],
                            ),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.01),
                        child: HouseCarousel(
                          House(
                            chatDocs[index]['name'],
                            chatDocs[index]['type'],
                            chatDocs[index]['apartmentType'],
                            chatDocs[index]['price'],
                            chatDocs[index]['location'],
                            chatDocs[index]['imageUrl'],
                            chatDocs[index]['bedroom'],
                            chatDocs[index]['bathrooms'],
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
        isLoading
            ? Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hoverColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Container(
                      color: Theme.of(context).hoverColor,
                      height: MediaQuery.of(context).size.height * 0.030,
                      width: MediaQuery.of(context).size.height * 0.030,
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).backgroundColor,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
