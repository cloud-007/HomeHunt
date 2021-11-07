// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/screens/chat/chat_screen.dart';
import 'package:homehunt/widgets/favorite_icon.dart';
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
  final bool isFavorite;
  final String favuid;
  final String houseImageUrl;
  HouseDetail(
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
      this.isFavorite,
      this.favuid,
      this.houseImageUrl,
      {Key key})
      : super(key: key);

  @override
  _HouseDetailState createState() => _HouseDetailState();
}

class _HouseDetailState extends State<HouseDetail> {
  bool favorite = false;

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
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
              content: Text('House has been deleted successfully.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
              content: Text('Failed to do this task.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  bool isWarning = false;

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
          FavoriteIcon(
            widget.uid,
            widget.isFavorite,
            widget.favuid,
            widget.userid,
            widget.homeName,
            widget.location,
            widget.price,
            widget.type,
            widget.houseImageUrl,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: _width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      // height: _height * 0.78,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    final chatDocs = chatSnapshot.data.docs;
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      //padding: EdgeInsets.zero,
                                      itemCount: chatDocs.length,
                                      itemBuilder: (ctx, index) => Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right:
                                                    index < chatDocs.length - 1
                                                        ? _width * 0.05
                                                        : 0),
                                            child: Container(
                                              height: _height * 0.33,
                                              width: _width * 0.8,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .hoverColor,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Image.network(
                                                  chatDocs[index]['imageUrl'],
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (BuildContext
                                                          context,
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
                                                    if (loadingProgress ==
                                                        null) {
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        color: Theme.of(context).canvasColor,
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
                                        color: Theme.of(context).canvasColor,
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
                                        color: Theme.of(context).canvasColor,
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
                            Text(
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
                              'Lorem Ipsum is simply dummy text of '
                              'the printing and typesetting industry. Lorem Ipsum'
                              ' has been the industry\'s standard dummy text ever '
                              'since the 1500s, when an unknown printer took a galley'
                              ' of type and scrambled it to make a type specimen book.'
                              ' It has survived not only five centuries, but also the'
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
                              ' leap into electronic typesetting, remaining essentially '
                              'unchanged. It was popularised in the 1960s with the '
                              'software like Aldus PageMaker including versions of'
                              ' Lorem Ipsum. ',
                              style: TextStyle(
                                fontSize: _height * 0.02,
                                color: Theme.of(context).canvasColor,
                                //overflow: TextOverflow.,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: _height * 0.025),
                  widget.userid !=
                          FirebaseAuth.instance.currentUser.uid
                              .toString()
                              .trim()
                      ? Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: _height * 0.01),
                          child: Container(
                            height: _height * 0.08,
                            decoration: BoxDecoration(
                              //color: Colors.yellow,
                              color: Theme.of(context).hoverColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).backgroundColor,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(
                                      1, 1), // changes position of shadow
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        print('Owner has been notified');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                                'Owner has been notified!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        await FirebaseFirestore.instance
                                            .collection('notification')
                                            .doc('3CxlzQHlP2BkxLIBDIur')
                                            .collection(widget.userid)
                                            .doc(widget.uid)
                                            .set({
                                          'fromuid': FirebaseAuth
                                              .instance.currentUser.uid
                                              .toString()
                                              .trim(),
                                          'touid': widget.userid,
                                          'houseid': widget.uid,
                                          'housename': widget.homeName,
                                          'username': FirebaseAuth
                                              .instance.currentUser.displayName
                                              .toString()
                                              .trim(),
                                          'time': Timestamp.now(),
                                          'requested': true,
                                        });
                                      },
                                      child: Container(
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
                                    ),
                                    Hero(
                                      tag: 'chat',
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          if (widget.userid ==
                                              FirebaseAuth
                                                  .instance.currentUser.uid
                                                  .toString()
                                                  .trim()) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'You cannot chat with yourself'),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .errorColor,
                                              ),
                                            );
                                            setState(() {
                                              isLoading = false;
                                            });
                                          } else {
                                            String chatid;
                                            String userImageUrl;
                                            final chatres =
                                                await FirebaseFirestore.instance
                                                    .collection('chatuid')
                                                    .where('id',
                                                        arrayContainsAny: [
                                                  widget.userid
                                                          .toString()
                                                          .trim() +
                                                      FirebaseAuth.instance
                                                          .currentUser.uid
                                                          .toString()
                                                          .trim(),
                                                  FirebaseAuth.instance
                                                          .currentUser.uid
                                                          .toString()
                                                          .trim() +
                                                      widget.userid
                                                          .toString()
                                                          .trim()
                                                ]).get();
                                            if (chatres.docs.isNotEmpty) {
                                              chatid =
                                                  chatres.docs[0]['chatId'];
                                              print('Found ' + chatid);
                                            } else {
                                              chatid = Uuid().v1();
                                              await FirebaseFirestore.instance
                                                  .collection('chatuid')
                                                  .doc(chatid)
                                                  .set({
                                                'user': [
                                                  widget.userid
                                                      .toString()
                                                      .trim(),
                                                  FirebaseAuth
                                                      .instance.currentUser.uid
                                                      .toString()
                                                      .trim()
                                                ],
                                                'id': [
                                                  widget.userid
                                                          .toString()
                                                          .trim() +
                                                      FirebaseAuth.instance
                                                          .currentUser.uid
                                                          .toString()
                                                          .trim(),
                                                  FirebaseAuth.instance
                                                          .currentUser.uid
                                                          .toString()
                                                          .trim() +
                                                      widget.userid
                                                          .toString()
                                                          .trim()
                                                ],
                                                'username': [
                                                  widget.username
                                                      .toString()
                                                      .trim(),
                                                  FirebaseAuth.instance
                                                      .currentUser.displayName
                                                      .toString()
                                                      .trim()
                                                ],
                                                'chatId': chatid.trim(),
                                                'userUrl': [
                                                  widget.imageUrl,
                                                  FirebaseAuth.instance
                                                      .currentUser.photoURL
                                                      .toString(),
                                                ],
                                              });
                                            }
                                            print(widget.imageUrl);
                                            print(chatid);

                                            final userimageres =
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .where('uid',
                                                        isEqualTo: widget.userid
                                                            .toString()
                                                            .trim())
                                                    .get();
                                            userImageUrl = userimageres.docs[0]
                                                ['imageUrl'];
                                            print(userImageUrl);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
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
                                    InkWell(
                                      onTap: () {
                                        if (widget.userid ==
                                            FirebaseAuth
                                                .instance.currentUser.uid
                                                .toString()
                                                .trim()) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                  'You cannot call yourself'),
                                              backgroundColor:
                                                  Theme.of(context).errorColor,
                                            ),
                                          );
                                        } else {
                                          print('Calling owner');
                                          print(FirebaseAuth
                                              .instance.currentUser.uid);
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                        )
                      : Container(
                          margin:
                              EdgeInsets.symmetric(vertical: _height * 0.01),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
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
                                isWarning = true;
                              });
                            },
                            child: Text(
                              'Delete',
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
          ),
          isWarning
              ? Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _width * 0.02,
                      vertical: _height * 0.01,
                    ),
                    height: _height * 0.2,
                    width: _width * 0.7,
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
                          'Are you sure to delete this house?',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: _height * _width * 0.00005,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                                _deleteHouse();
                                isLoading = true;
                              });
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
              : isLoading
                  ? Center(
                      child: Container(
                        width: _width * 0.8,
                        height: _height * 0.1,
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
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                    )
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
