// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/screens/chat/chat_screen.dart';
import 'package:homehunt/widgets/circular_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

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
  final String userid;
  final String username;
  final String imageUrl;
  const HouseDetail(
      this.homeName,
      this.type,
      this.apartmentType,
      this.price,
      this.location,
      this.bedroom,
      this.bathroom,
      this.phoneNumber,
      this.uid,
      this.userid,
      this.username,
      this.imageUrl,
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

  bool isLoading = false;


  bool deleted = false;

  void _deleteHouse() async {
    CollectionReference house = FirebaseFirestore.instance.collection('houses');
    // FirebaseFirestore.instance.collection('houses').doc(widget.uid).delete();
    await house
        .doc(widget.uid)
        .delete()
        .then((value) => deleted = true)
        .catchError((error) => deleted = false);
    setState(
      () {
        isLoading = false;
        if (deleted == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('House has been deleted successfully.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to do this task.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: _height * 0.06,
        title: Text(widget.homeName),
        backgroundColor: Theme.of(context).hoverColor,
        foregroundColor: Theme.of(context).canvasColor,
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
          if (widget.userid ==
              FirebaseAuth.instance.currentUser.uid.toString().trim())
            GestureDetector(
              onTap: () {
                setState(() {
                  isLoading = true;
                  _deleteHouse();
                });
              },
              child: Center(
                child: Text(
                  'Delete    ',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: _height * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: _width,
            child: Padding(
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
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                final chatDocs = chatSnapshot.data.docs;
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  //padding: EdgeInsets.zero,
                                  itemCount: chatDocs.length,
                                  itemBuilder: (ctx, index) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
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
                                            color: Theme.of(context).hoverColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              chatDocs[index]['imageUrl'],
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace stackTrace) {
                                                return Image(
                                                  image: AssetImage(
                                                      'assets/images/networkerror.jpg'),
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                        SingleChildScrollView(
                          child: Container(
                            height: _height * 0.42,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.apartmentType,
                                      style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontSize: _height * 0.03,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Tk' + widget.price + '/month',
                                      style: TextStyle(
                                        fontSize: _height * 0.03,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 108, 0, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: _height * 0.01),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Theme.of(context).canvasColor,
                                    ),
                                    SizedBox(width: _width * 0.02),
                                    Text(
                                      widget.location,
                                      style: TextStyle(
                                        fontSize: _height * 0.02,
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: _height * 0.01),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.bed_outlined,
                                          color: Theme.of(context).canvasColor,
                                        ),
                                        SizedBox(width: _width * 0.02),
                                        Text(
                                          widget.bedroom.toString() + ' Beds',
                                          style: TextStyle(
                                            fontSize: _height * 0.02,
                                            color:
                                                Theme.of(context).canvasColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: _width * 0.1),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.bathtub_outlined,
                                          color: Theme.of(context).canvasColor,
                                        ),
                                        SizedBox(width: _width * 0.02),
                                        Text(
                                          widget.bathroom.toString() + ' Baths',
                                          style: TextStyle(
                                            fontSize: _height * 0.02,
                                            color:
                                                Theme.of(context).canvasColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: _width * 0.1),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.house_outlined,
                                          color: Theme.of(context).canvasColor,
                                        ),
                                        SizedBox(width: _width * 0.02),
                                        Text(
                                          widget.type + ' House',
                                          style: TextStyle(
                                            fontSize: _height * 0.02,
                                            color:
                                                Theme.of(context).canvasColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: _height * 0.02),
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: _height * 0.025,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ),
                                SizedBox(height: _height * 0.01),
                                SingleChildScrollView(
                                  child: Container(
                                    height: _height * 0.22,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                          _height * 0.015),
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
                                          color: Theme.of(context).canvasColor,
                                          //overflow: TextOverflow.,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: _height * 0.025),
                    Container(
                      height: _height * 0.08,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hoverColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).backgroundColor,
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(1, 1), // changes position of shadow
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
                              Hero(
                                tag: 'chat',
                                child: GestureDetector(
                                  onTap: () async {
                                    if (widget.userid ==
                                        FirebaseAuth.instance.currentUser.uid
                                            .toString()
                                            .trim()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'You cannot chat with yourself'),
                                          backgroundColor:
                                              Theme.of(context).errorColor,
                                        ),
                                      );
                                    } else {
                                      String chatid;
                                      String userImageUrl;
                                      final chatres = await FirebaseFirestore
                                          .instance
                                          .collection('chatuid')
                                          .where('userId', arrayContainsAny: [
                                        FirebaseAuth.instance.currentUser.uid
                                                .toString()
                                                .trim() +
                                            widget.userid.toString().trim(),
                                        widget.userid.toString().trim() +
                                            FirebaseAuth
                                                .instance.currentUser.uid
                                                .toString()
                                                .trim()
                                      ]).get();
                                      if (chatres.docs.isNotEmpty) {
                                        chatid = chatres.docs[0]['chatId'];
                                        print('Found ' + chatid);
                                      } else {
                                        chatid = Uuid().v1();
                                        await FirebaseFirestore.instance
                                            .collection('chatuid')
                                            .doc(chatid)
                                            .set({
                                          'user': [
                                            widget.userid.toString().trim(),
                                            FirebaseAuth
                                                .instance.currentUser.uid
                                                .toString()
                                                .trim()
                                          ],
                                          'username': [
                                            widget.username.toString().trim(),
                                            FirebaseAuth.instance.currentUser
                                                .displayName
                                                .toString()
                                                .trim()
                                          ],
                                          'chatId': chatid.trim(),
                                          'userUrl': [
                                            FirebaseAuth
                                                .instance.currentUser.photoURL
                                                .toString(),
                                            widget.imageUrl,
                                          ],
                                        });
                                      }
                                      print(chatid);

                                      final userimageres =
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .where('uid',
                                                  isEqualTo: widget.userid
                                                      .toString()
                                                      .trim())
                                              .get();
                                      userImageUrl =
                                          userimageres.docs[0]['imageUrl'];
                                      print(userImageUrl);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ChatScreen(
                                                    chatid,
                                                    widget.userid,
                                                    widget.username,
                                                    userImageUrl)),
                                      );
                                      print(widget.username);
                                      print(FirebaseAuth
                                              .instance.currentUser.uid +
                                          widget.userid);
                                      print('Chatting with owner');
                                    }
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.chat_outlined,
                                          size: _height * 0.025,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: _width * 0.01),
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
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (widget.userid ==
                                      FirebaseAuth.instance.currentUser.uid
                                          .toString()
                                          .trim()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('You cannot call yourself'),
                                        backgroundColor:
                                            Theme.of(context).errorColor,
                                      ),
                                    );
                                  } else {
                                    print('Calling owner');
                                    print(
                                        FirebaseAuth.instance.currentUser.uid);
                                    setState(() {
                                      _makePhoneCall(
                                          'tel:' + widget.phoneNumber);
                                    });
                                  }
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.call_outlined,
                                        size: _height * 0.025,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: _width * 0.01),
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
          ),
          isLoading
              ? Center(child: CircularIndicator())
              : Container() // true or false conditions  according loader show or hide
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
