import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/model/house.dart';
import 'package:homehunt/screens/house/house_details.dart';
import 'package:homehunt/widgets/HomeScreen/housecarousel.dart';

class MyListing extends StatefulWidget {
  const MyListing({key}) : super(key: key);

  @override
  _MyListingState createState() => _MyListingState();
}

class _MyListingState extends State<MyListing> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        toolbarHeight: MediaQuery.of(context).size.height * 0.06,
        shadowColor: Theme.of(context).backgroundColor,
        title: const Text('My Listings'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.bottom,
        color: Colors.transparent,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('houses')
              .where('uid',
                  isEqualTo:
                      FirebaseAuth.instance.currentUser.uid.toString().trim())
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = streamSnapshot.data.docs;
            if (chatDocs.isEmpty) {
              return const Center(
                child: Text(
                  'Nothing added',
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
                          '',
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
        ),
      ),
    );
  }
}
