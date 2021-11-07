// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unused_local_variable, prefer_typing_uninitialized_variables, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/screens/notification.dart';
import 'package:homehunt/widgets/HomeScreen/list_view.dart';
import 'package:homehunt/widgets/HomeScreen/housecarousel.dart';

class HomeScreen extends StatefulWidget {
  static String pageRoute = '/home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String searchText;
  final _controller = TextEditingController();
  var _height;
  var _width;

  int _selectedIndex = 0;

  bool drawer = false;

  final List<String> _buildList = [
    'All',
    'Family',
    'Bachelor',
  ];

  List<HouseCarousel> list;

  Widget _createDropDown(String name, List<String> _list) {
    return Container(
      width: _width * 0.8,
      height: _height * 0.025,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_height * 0.012),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.03),
        child: DropdownButtonHideUnderline(
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.lightBlue.shade900,
            ),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(_height * 0.012),
              hint: Text(
                searchText == null ? 'Search Location' : searchText,
                style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: _height * _width * 0.00004,
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
                      color: Colors.white60,
                      fontSize: _height * 0.015,
                      fontFamily: 'Montserrat-ExtraLight',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  if (value == 'Search Location')
                    searchText = null;
                  else
                    searchText = value;
                  print(searchText);
                });
              },
              style: TextStyle(
                color: Colors.grey.shade100,
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

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;
    _width = MediaQuery.of(context).size.width;
    final _font = _height * _width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      //floatingActionButton: Icon(Icons.add, ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: _width * 0.03, vertical: _height * 0.01),
        child: SingleChildScrollView(
          //physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: _height * 0.3,
                //color: Colors.red,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: _height * 0.028),
                    Container(
                      height: _height * 0.06,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.cover,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(user.photoURL),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              SizedBox(width: _width * 0.03),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Hello, ',
                                  style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontWeight: FontWeight.bold,
                                    // fontSize: _font * 0.00005,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  user.displayName,
                                  style: TextStyle(
                                    // fontSize: _font * 0.00005,
                                    color: Theme.of(context).canvasColor,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              print(FirebaseAuth.instance.currentUser.uid);
                              print('Hello there! No new notifications!');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(),
                                ),
                              );
                            },

                            ///Notification Icon
                            child: Hero(
                              tag: 'Notification',
                              child: Icon(
                                Icons.notifications,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(height: _height * 0.00),
                    SizedBox(
                      height: _height * 0.07,
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Discover',
                          style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: _height * 0.01),
                    Container(
                      height: _height * 0.055,
                      padding: EdgeInsets.only(left: _width * 0.05),
                      decoration: BoxDecoration(
                        //color: Colors.red,
                        color: Theme.of(context).hoverColor,
                        borderRadius: BorderRadius.circular(_height * 0.012),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.grey.shade200,
                              size: _height * 0.02,
                            ),
                            _createDropDown('Location', <String>[
                              'Search Location',
                              'Upashahar',
                              'Shibganj',
                              'Tilagor',
                              'Naiyorpool',
                              'Mirabazar',
                              'Subidbazar',
                              'Eidgah',
                              'Lamabazar',
                            ]),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: _height * 0.02),
                    Container(
                      height: _height * 0.04,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _buildList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                                print(_selectedIndex);
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: _width * 0.04),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: index == _selectedIndex
                                      ? Theme.of(context).canvasColor
                                      : Theme.of(context).hoverColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: _width * 0.04,
                                    ),
                                    child: Text(
                                      _buildList[index],
                                      style: TextStyle(
                                        color: index == _selectedIndex
                                            ? Theme.of(context).backgroundColor
                                            : Theme.of(context).canvasColor,
                                        fontWeight: FontWeight.w900,
                                        fontSize: _height * 0.015,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              ///ListView_Builder Home
              Container(
                height: _height * 0.64,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(_height * 0.012),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: _height * 0.03),
                  child: HomeScreenListView(_selectedIndex, searchText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
