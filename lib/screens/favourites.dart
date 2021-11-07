import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/model/house.dart';
import 'package:homehunt/widgets/HomeScreen/housecarousel.dart';

import 'house/house_details.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final _font = _height * _width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'Favourites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _font * 0.00008,
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.bottom,
            // color: Colors.green,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('favourites/jJf5PtV8pts0A2fGEa8j/' +
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
                    padding: EdgeInsets.only(top: _height * 0.01),
                    itemCount: chatDocs.length,
                    itemBuilder: (ctx, index) => Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _width * 0.025,
                            vertical: _height * 0.005),
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            var res;
                            print(chatDocs[index]['houseid']);

                            await FirebaseFirestore.instance
                                .collection('houses')
                                .doc(chatDocs[index]['houseid'])
                                .get()
                                .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                res = documentSnapshot;
                                print('Document exists on the database');
                              }
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

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => HouseDetail(
                                  res['name'],
                                  res['type'],
                                  res['apartmentType'],
                                  res['price'],
                                  res['location'],
                                  res['bedroom'],
                                  res['bathrooms'],
                                  res['phoneNumber'],
                                  res.id,
                                  res['uid'],
                                  res['username'],
                                  photoURL,
                                  true,
                                  chatDocs[index]['uid'],
                                  res['imageUrl'],
                                ),
                              ),
                            );

                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: HouseCarousel(
                            House(
                              chatDocs[index]['housename'],
                              chatDocs[index]['type'],
                              '',
                              chatDocs[index]['price'],
                              chatDocs[index]['location'],
                              chatDocs[index]['imageUrl'],
                              null,
                              null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
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
      ),
    );
  }
}
