// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 350,
    );
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage)
              : AssetImage('assets/images/defaultProfile.jpg'),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(
            Icons.image,
            color: Theme.of(context).primaryColorDark,
          ),
          label: Text(
            'Add Profile',
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
      ],
    );
  }
}
