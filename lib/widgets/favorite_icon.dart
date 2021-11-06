import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FavoriteIcon extends StatefulWidget {
  String houseId;
  bool favorite;
  String uuid;
  String userid;
  String housename;
  String location;
  String price;
  String type;
  String imageUrl;
  FavoriteIcon(this.houseId, this.favorite, this.uuid, this.userid,
      this.housename, this.location, this.price, this.type, this.imageUrl,
      {key})
      : super(key: key);

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  void _deleteFavourite() async {
    bool deleted;
    CollectionReference favorite = FirebaseFirestore.instance.collection(
        'favourites/jJf5PtV8pts0A2fGEa8j/' +
            FirebaseAuth.instance.currentUser.uid.toString().trim());
    // FirebaseFirestore.instance.collection('houses').doc(widget.uid).delete();
    await favorite
        .doc(widget.uuid)
        .delete()
        .then((value) => deleted = true)
        .catchError((error) => deleted = false);
    setState(
      () {
        if (deleted == true) {
          widget.favorite = false;
        } else {
          widget.favorite = true;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(widget.favorite ? Icons.favorite : Icons.favorite_border),
      onPressed: () {
        if (widget.userid == FirebaseAuth.instance.currentUser.uid) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
              content: Text('You can\'t add your house to favourite'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          setState(() {
            if (widget.favorite == false) {
              var uuid = Uuid().v1();
              widget.favorite = true;
              widget.uuid = uuid;
              FirebaseFirestore.instance
                  .collection('favourites')
                  .doc('jJf5PtV8pts0A2fGEa8j')
                  .collection(
                      FirebaseAuth.instance.currentUser.uid.toString().trim())
                  .doc(uuid)
                  .set({
                'houseid': widget.houseId,
                'user': FirebaseAuth.instance.currentUser.uid.toString().trim(),
                'uid': uuid,
                'housename': widget.housename,
                'location': widget.location,
                'price': widget.price,
                'type': widget.type,
                'imageUrl': widget.imageUrl,
              });
            } else {
              print('favourites/jJf5PtV8pts0A2fGEa8j/' +
                  FirebaseAuth.instance.currentUser.uid.toString().trim() +
                  '/' +
                  widget.houseId);
              _deleteFavourite();
            }
          });
        }
      },
    );
  }
}
