// ignore_for_file: prefer_const_constructors, avoid_print, prefer_final_fields
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/screens/house/image_picker.dart';
import 'package:homehunt/widgets/circular_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddHouse extends StatefulWidget {
  static int totalImage = 0;
  static List<String> _imageUrl;
  const AddHouse({key}) : super(key: key);
  @override
  _AddHouseState createState() => _AddHouseState();
}

class _AddHouseState extends State<AddHouse> {
  final _formKey = GlobalKey<FormState>();
  double _height;
  double _width;
  String homeName;
  String type;
  String apartmentType;
  String price;
  String location;
  String imageUrl;
  String phoneNumber;
  int bedroom;
  int bathrooms;
  List<File> detailedImages;
  //detailedImages = HouseImagePicker.

  TextEditingController _priceController;
  TextEditingController _nameController;
  TextEditingController _phoneController;
  bool hintType = false;
  bool hintLocation = false;
  bool hintBedroom = false;
  bool hintBathroom = false;
  bool hintApartment = false;

  Widget _createDropDown(String name, List<String> _list) {
    return Container(
      width: double.infinity,
      height: _height * 0.025,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(_height * 0.015),
        border: Border.all(
          color: Theme.of(context).primaryColorDark,
          width: 0.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.03),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(_height * 0.015),
            hint: Text(
              name == 'House Type'
                  ? (hintType == false ? "Select " + name : type)
                  : name == 'Location'
                      ? (hintLocation == false ? "Select " + name : location)
                      : name == 'No of bedrooms'
                          ? (hintBedroom == false
                              ? "Select " + name
                              : bedroom.toString())
                          : name == 'No of bathrooms'
                              ? (hintBathroom == false
                                  ? "Select " + name
                                  : bathrooms.toString())
                              : (hintApartment == false
                                  ? "Select " + name
                                  : apartmentType),
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: _height * 0.015,
                letterSpacing: 1.2,
                fontFamily: 'Crete_Round',
              ),
            ),
            key: ValueKey(name),
            items: _list.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (name == 'House Type') {
                setState(() {
                  type = value;
                  hintType = true;
                });
              } else if (name == 'No of bedrooms') {
                setState(() {
                  bedroom = int.parse(value);
                  hintBedroom = true;
                });
                print(bedroom);
              } else if (name == 'Location') {
                setState(() {
                  location = value;
                  hintLocation = true;
                });
                print(location);
              } else if (name == 'No of bathrooms') {
                setState(() {
                  bathrooms = int.parse(value);
                  hintBathroom = true;
                });
                print('Bathrooms = ' + bathrooms.toString());
              } else {
                setState(() {
                  apartmentType = value;
                  hintApartment = true;
                });
              }
            },
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: _height * 0.015,
              letterSpacing: 1.2,
              fontFamily: 'Crete_Round',
            ),
          ),
        ),
      ),
    );
  }

  Widget _createTextField(String name) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColorDark,
        cursorHeight: _height * 0.025,
        controller: name == 'House Name'
            ? _nameController
            : name == 'Price'
                ? _priceController
                : _phoneController,
        key: ValueKey(name),
        validator: (value) {
          if (value.isEmpty) {
            return name + ' cannot be empty';
          } else {
            return null;
          }
        },
        keyboardType:
            name == 'House Name' ? TextInputType.name : TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).primaryColor,
          labelText: name,
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: _height * 0.015,
            letterSpacing: 1.2,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColorDark,
              width: 0.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.green,
              width: 0.0,
            ),
          ),
        ),
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontSize: _height * 0.015,
          letterSpacing: 1.2,
        ),
        onChanged: (value) {
          if (name == 'House Name') {
            homeName = value;
          } else if (name == 'Price') {
            price = value;
          } else if (name == 'Phone Number') {
            phoneNumber = value;
          }
        },
        onSaved: (value) {
          if (name == 'House Name') {
            homeName = value;
          } else if (name == 'Price') {
            price = value;
          } else if (name == 'Phone Number') {
            phoneNumber = value;
          }
        },
      ),
    );
  }

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

  bool _tryValidate() {
    if (homeName == null ||
        type == null ||
        price == null ||
        location == null ||
        bedroom == null ||
        bathrooms == null ||
        phoneNumber == null ||
        apartmentType == null ||
        _imageTotal.length <= 1) {
      return false;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    return true;
  }

  bool isLoading = false;

  Future<void> _trySubmit() async {
    setState(() {
      isLoading = true;
    });
    if (_tryValidate() == false) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Every field is required'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('houses')
        .where('name', isEqualTo: homeName)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A house with this name exists!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      print('Error Found');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please wait a few second before we proceed.'),
          backgroundColor: Colors.blue,
        ),
      );
      print('No error');
      var uid = Uuid().v1();

      for (int i = 0; i < _imageTotal.length; i++) {
        if (i == 0) continue;
        var uuid = Uuid().v1();
        final ref = FirebaseStorage.instance
            .ref()
            .child('house_image')
            .child(uid)
            .child(uuid + '.jpg');
        await ref.putFile(_imageTotal[i]);
        final url = await ref.getDownloadURL();
        imageUrl ??= url;
        await Future.delayed(const Duration(seconds: 2), () {});

        await FirebaseFirestore.instance
            .collection('house_images')
            .doc(uid)
            .collection('all_images')
            .doc(uuid)
            .set({
          'imageUrl': url,
        });
        await Future.delayed(const Duration(seconds: 2), () {});
      }

      await FirebaseFirestore.instance.collection('houses').doc(uid).set({
        'name': homeName,
        'type': type,
        'apartmentType': apartmentType,
        'price': price,
        'location': location,
        'bedroom': bedroom,
        'bathrooms': bathrooms,
        'imageUrl': imageUrl,
        'phoneNumber': phoneNumber,
        'uid': FirebaseAuth.instance.currentUser.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your listing has been added successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }

    print('Every Field is Provided');
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _height * 0.07,
        title: Text(
          'Add your house info',
          style: TextStyle(
            fontSize: _height * 0.023,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: _height * 0.023, color: Theme.of(context).primaryColorDark),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: _width * 0.025, vertical: _height * 0.02),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Please provide some information about your house!',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: _height * 0.02,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: _height * 0.02),
                SizedBox(
                  height: _height * 0.06,
                  child: _createTextField('House Name'),
                ),
                SizedBox(height: _height * 0.01),
                Container(
                  height: _height * 0.06,
                  color: Colors.transparent,
                  child: _createDropDown(
                      'House Type', <String>['Family', 'Bachelor']),
                ),
                SizedBox(height: _height * 0.01),
                Container(
                  height: _height * 0.06,
                  color: Colors.transparent,
                  child: _createDropDown('Apartment Type', <String>[
                    'Studio',
                    'Alcove studio',
                    'Micro apartment',
                    'Loft',
                    'Duplex',
                    'Co-op',
                  ]),
                ),
                SizedBox(height: _height * 0.01),
                SizedBox(
                  height: _height * 0.06,
                  child: _createTextField('Price'),
                ),
                SizedBox(height: _height * 0.01),
                Container(
                  height: _height * 0.06,
                  color: Colors.transparent,
                  child: _createDropDown('Location', <String>[
                    'Upashahar',
                    'Shibganj',
                    'Tilagor',
                    'Naiyorpool',
                    'Mirabazar',
                    'Subidbazar',
                    'Eidgah',
                    'Lamabazar'
                  ]),
                ),
                SizedBox(height: _height * 0.01),
                Container(
                  height: _height * 0.06,
                  color: Colors.transparent,
                  child: _createDropDown('No of bedrooms',
                      <String>['1', '2', '3', '4', '5', '6', '7', '8']),
                ),
                SizedBox(height: _height * 0.01),
                Container(
                  height: _height * 0.06,
                  color: Colors.transparent,
                  child: _createDropDown(
                      'No of bathrooms', <String>['1', '2', '3', '4', '5']),
                ),
                SizedBox(height: _height * 0.01),
                // HouseImagePicker(),
                SizedBox(
                  height: _height * 0.06,
                  child: _createTextField('Phone Number'),
                ),
                //SizedBox(height: _height * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(
                        Icons.add_photo_alternate,
                        size: _height * 0.025,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      label: Text(
                        'Click here to add Some images',
                        style: TextStyle(
                          fontSize: _height * 0.017,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                    Container(
                      height: _height * 0.12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _imageTotal.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.transparent,
                            height: index == 0 ? 0 : _height * 0.035,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (index != 0)
                                  SizedBox(
                                    //height: _height * 0.025,
                                    width: _width * 0.7,
                                    child: Text(
                                      _imageTotal[index].toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                // SizedBox(width: _width * 0.02),
                                if (index != 0)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _imageTotal.remove(_imageTotal[index]);
                                      });
                                    },
                                    child: SizedBox(
                                      //height: _height * 0.025,
                                      width: _width * 0.2,
                                      child: Text(
                                        'Remove',
                                      ),
                                    ),
                                  ),
                                /* TextButton(
                                  child: Text('Remove'),
                                  onPressed: () {
                                    setState(() {
                                      _imageTotal.remove(_imageTotal[index]);
                                    });
                                  },
                                ),*/
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _height * 0.02),
                if (isLoading) Center(child: CircularIndicator()),
                if (!isLoading)
                  Container(
                    width: double.infinity,
                    height: _height * 0.05,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      child: Text(
                        'Add House',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: _height * 0.02,
                        ),
                      ),
                      onPressed: _trySubmit,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}