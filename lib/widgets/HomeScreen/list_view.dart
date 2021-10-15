// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/model/house.dart';
import 'package:homehunt/screens/house/house_details.dart';
import 'package:homehunt/widgets/circular_indicator.dart';
import 'package:homehunt/widgets/HomeScreen/housecarousel.dart';

class HomeScreenListView extends StatefulWidget {
  final int _selectedIndex;
  const HomeScreenListView(this._selectedIndex, {key}) : super(key: key);

  @override
  State<HomeScreenListView> createState() => _HomeScreenListViewState();
}

class _HomeScreenListViewState extends State<HomeScreenListView> {
  String homeName;
  String type;
  String price;
  String location;
  String imageUrl;
  bool family;
  bool bachelor;
  int bedroom;
  int bathrooms;
  String phoneNumber;
  List<String> detailedImages;

  List<String> userId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget._selectedIndex == 0
          ? FirebaseFirestore.instance.collection('houses').snapshots()
          : widget._selectedIndex == 1
              ? FirebaseFirestore.instance
                  .collection('houses')
                  .where('type', isEqualTo: 'Family')
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('houses')
                  .where('type', isEqualTo: 'Bachelor')
                  .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularIndicator());
        } else {
          final chatDocs = chatSnapshot.data.docs;
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) => GestureDetector(
              onTap: () {
                // print(list[index].homeName);
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
                    ),
                  ),
                );
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
      },
    );
  }
}
