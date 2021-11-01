// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class HouseImagePicker extends StatefulWidget {
  @override
  _HouseImagePickerState createState() => _HouseImagePickerState();
}

class _HouseImagePickerState extends State<HouseImagePicker> {
  List<File> _imageTotal = [File('assets/images/defaultProfile.jpg')];

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      if (_imageTotal.length < 6) {
        _imageTotal.add(pickedImageFile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You are allowed up to provide 5 images'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(
            Icons.image,
            color: Theme.of(context).primaryColorDark,
          ),
          label: Text(
            'Add Some images',
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
        Container(
          height: _height * 0.18,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).hoverColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _imageTotal.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: _height * 0.035,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (index != 0)
                      SizedBox(
                        height: _height * 0.025,
                        width: _width * 0.7,
                        child: Text(
                          _imageTotal[index].toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (index != 0)
                      TextButton(
                        child: Text('Remove'),
                        onPressed: () {
                          setState(() {
                            _imageTotal.remove(_imageTotal[index]);
                          });
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
