// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class HouseImagePicker extends StatefulWidget {
  const HouseImagePicker({key}) : super(key: key);

  @override
  _HouseImagePickerState createState() => _HouseImagePickerState();
}

class _HouseImagePickerState extends State<HouseImagePicker> {
  List<dynamic> images;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Pick Some Images'),
      onPressed: () => MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "HomeHunt image",
        ),
      ),
    );
  }
}
