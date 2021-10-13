// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HouseDetail extends StatefulWidget {
  final String homeName;
  final String type;
  final String apartmentType;
  final String price;
  final String location;
  final int bedroom;
  final int bathroom;
  final String phoneNumber;
  final String uid;
  const HouseDetail(this.homeName, this.type, this.apartmentType, this.price,
      this.location, this.bedroom, this.bathroom, this.phoneNumber, this.uid,
      {Key key})
      : super(key: key);

  @override
  _HouseDetailState createState() => _HouseDetailState();
}

class _HouseDetailState extends State<HouseDetail> {
  bool _checkFavorite() {
    FirebaseFirestore.instance
        .collection('favorites')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('all_favorites')
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(documentSnapshot[0]['isFavorite']);
        return documentSnapshot[0]['isFavorite'];
      } else {
        return false;
      }
    });
    return false;
  }

  bool favorite;

  @override
  void initState() {
    favorite = _checkFavorite();
    Future.delayed(Duration(seconds: 2));
    super.initState();
  }

  void _updateFavorite() {
    FirebaseFirestore.instance
        .collection('favorites')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('all_favorites')
        .doc(widget.uid)
        .set({
      'isFavorite': favorite == true ? false : true,
    });
    favorite = !favorite;
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: _height * 0.07,
        title: Text(widget.homeName),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorDark,
        actions: [
          IconButton(
            icon: Icon(favorite == null
                ? null
                : favorite
                    ? Icons.favorite
                    : Icons.favorite_border),
            onPressed: () {
              setState(() {
                _updateFavorite();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: _height * 0.01),
                  Container(
                    height: _height * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('house_images')
                          .doc(widget.uid)
                          .collection('all_images')
                          .snapshots(),
                      builder: (ctx, chatSnapshot) {
                        if (chatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          final chatDocs = chatSnapshot.data.docs;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            //padding: EdgeInsets.zero,
                            itemCount: chatDocs.length,
                            itemBuilder: (ctx, index) => Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height *
                                      0.01),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: index < chatDocs.length - 1
                                          ? _width * 0.05
                                          : 0),
                                  child: Container(
                                    height: _height * 0.33,
                                    width: _width * 0.8,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        chatDocs[index]['imageUrl'],
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                          );
                                        },
                                      ),
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
                  Container(
                    height: _height * 0.40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.apartmentType,
                              style: TextStyle(
                                fontSize: _height * 0.03,
                              ),
                            ),
                            Text(
                              'Tk' + widget.price + '/month',
                              style: TextStyle(
                                fontSize: _height * 0.03,
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: _height * 0.01),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.black54,
                            ),
                            SizedBox(width: _width * 0.02),
                            Text(
                              widget.location,
                              style: TextStyle(
                                fontSize: _height * 0.02,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: _height * 0.01),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.bed_outlined, color: Colors.black54),
                                SizedBox(width: _width * 0.02),
                                Text(
                                  widget.bedroom.toString() + ' Beds',
                                  style: TextStyle(
                                    fontSize: _height * 0.02,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: _width * 0.1),
                            Row(
                              children: [
                                Icon(Icons.bathtub_outlined,
                                    color: Colors.black54),
                                SizedBox(width: _width * 0.02),
                                Text(
                                  widget.bathroom.toString() + ' Baths',
                                  style: TextStyle(
                                    fontSize: _height * 0.02,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: _width * 0.1),
                            Row(
                              children: [
                                Icon(Icons.house_outlined,
                                    color: Colors.black54),
                                SizedBox(width: _width * 0.02),
                                Text(
                                  widget.type + ' House',
                                  style: TextStyle(
                                    fontSize: _height * 0.02,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: _height * 0.02),
                        Text(
                          'Description',
                          style: TextStyle(fontSize: _height * 0.025),
                        ),
                        SizedBox(height: _height * 0.01),
                        Container(
                          height: _height * 0.2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              'Lorem Ipsum is simply dummy text of '
                              'the printing and typesetting industry. Lorem Ipsum'
                              ' has been the industry\'s standard dummy text ever '
                              'since the 1500s, when an unknown printer took a galley'
                              ' of type and scrambled it to make a type specimen book.'
                              ' It has survived not only five centuries, but also the'
                              ' leap into electronic typesetting, remaining essentially '
                              'unchanged. It was popularised in the 1960s with the '
                              'release of Letraset sheets containing Lorem Ipsum '
                              'passages, and more recently with desktop publishing '
                              'software like Aldus PageMaker including versions of'
                              ' Lorem Ipsum. ',
                              style: TextStyle(
                                fontSize: _height * 0.02,
                                color: Colors.black54,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                ],
              ),
              Container(
                height: _height * 0.1,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: _width * 0.02,
                    horizontal: _height * 0.01,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: _height * 0.06,
                          width: _width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.green.shade900,
                            borderRadius: BorderRadius.circular(
                              _height * 0.015,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Rent Now!',
                              style: TextStyle(
                                fontSize: _height * 0.03,
                                color: Colors.white,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Chatting with owner');
                          },
                          child: Container(
                            height: _height * 0.06,
                            width: _width * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(
                                _height * 0.015,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.chat_outlined,
                                  size: _height * 0.025,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Chat',
                                  style: TextStyle(
                                    fontSize: _height * 0.025,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Calling owner');
                          },
                          child: Container(
                            height: _height * 0.06,
                            width: _width * 0.35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(
                                _height * 0.015,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.call_outlined,
                                  size: _height * 0.025,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Call Owner',
                                  style: TextStyle(
                                    fontSize: _height * 0.025,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}