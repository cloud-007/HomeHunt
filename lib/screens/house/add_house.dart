// ignore_for_file: prefer_const_constructors, avoid_print, prefer_final_fields
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/widgets/circular_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddHouse extends StatefulWidget {
  static int totalImage = 0;
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

  bool isLoading = false;

  Widget _createDropDown(String name, List<String> _list) {
    return Container(
      width: double.infinity,
      height: _height * 0.025,
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(_height * 0.012),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.03),
        child: DropdownButtonHideUnderline(
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Theme.of(context).primaryColor,
            ),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(_height * 0.012),
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
                  color: Theme.of(context).canvasColor,
                  fontSize: _height * 0.015,
                  letterSpacing: 1.2,
                  fontFamily: 'Montserrat-ExtraLight',
                ),
              ),
              key: ValueKey(name),
              items: _list.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: _height * 0.015,
                      fontFamily: 'Montserrat-ExtraLight',
                      letterSpacing: 1.2,
                    ),
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
                color: Theme.of(context).canvasColor,
                fontSize: _height * 0.015,
                letterSpacing: 1.2,
                fontFamily: 'Montserrat',
              ),
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
          fillColor: Theme.of(context).hoverColor,
          labelText: name,
          labelStyle: TextStyle(
            color: Theme.of(context).canvasColor,
            fontSize: _height * 0.015,
            letterSpacing: 1.2,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_height * 0.012),
            borderSide: BorderSide(
              color: Theme.of(context).backgroundColor,
              width: 0.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_height * 0.012),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_height * 0.012),
            borderSide: BorderSide(
              color: Theme.of(context).backgroundColor,
            ),
          ),
        ),
        style: TextStyle(
          color: Theme.of(context).canvasColor,
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

  bool isHouseUploading = false;

  Future<void> _trySubmit() async {
    setState(() {
      isHouseUploading = true;
      isLoading = true;
    });
    if (_tryValidate() == false) {
      setState(() {
        isLoading = false;
        isHouseUploading = false;
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

        await FirebaseFirestore.instance
            .collection('house_images')
            .doc(uid)
            .collection('all_images')
            .doc(uuid)
            .set({
          'imageUrl': url,
        });
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
        'username': FirebaseAuth.instance.currentUser.displayName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your listing has been added successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        isLoading = false;
        isHouseUploading = false;
      });
      Navigator.of(context).pop();
    }

    print('Every Field is Provided');
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;

    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: _height * 0.06,
        foregroundColor: Theme.of(context).canvasColor,
        backgroundColor: Theme.of(context).hoverColor,
        title: Text(
          'Add your house info',
          style: TextStyle(
            fontSize: _height * 0.023,
          ),
        ),
        centerTitle: true,
        leading: isHouseUploading
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: _height * 0.023,
                ),
                onPressed: Navigator.of(context).pop,
              )
            : null,
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
                    color: Theme.of(context).canvasColor,
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
                        color: Theme.of(context).canvasColor,
                      ),
                      label: Text(
                        'Click here to add Some images',
                        style: TextStyle(
                          fontSize: _height * 0.017,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ),
                    Container(
                      height: _height * 0.12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hoverColor,
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
                      color: Theme.of(context).hoverColor,
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
