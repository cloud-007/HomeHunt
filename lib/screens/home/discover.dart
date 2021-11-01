// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unused_local_variable, prefer_typing_uninitialized_variables, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  int _selectedIndex = 0;

  final List<String> _buildList = [
    'All',
    'Family',
    'Bachelor',
  ];

  List<HouseCarousel> list;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              user.displayName,
                              style: TextStyle(
                                color: Theme.of(context).canvasColor,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: _height * 0.00),
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
                      padding: EdgeInsets.symmetric(horizontal: _width * 0.05),
                      decoration: BoxDecoration(
                        //color: Colors.red,
                        color: Theme.of(context).hoverColor,
                        borderRadius: BorderRadius.circular(_height * 0.012),
                      ),
                      child: Center(
                        child: TextField(
                          cursorColor: Theme.of(context).canvasColor,
                          key: ValueKey('search'),
                          controller: _controller,
                          decoration: InputDecoration(
                            //filled: true,
                            // fillColor: Theme.of(context).hoverColor,
                            hintText: 'Search Location',
                            hintStyle: TextStyle(
                              letterSpacing: 1.2,
                              color: Theme.of(context).canvasColor,
                              fontSize: _height * 0.017,
                            ),
                            prefixIcon: Icon(
                              Icons.search_sharp,
                              size: _height * 0.017,
                              color: Theme.of(context).canvasColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(44, 130, 201, 0.0),
                                width: 5.0,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontSize: _height * 0.017,
                            letterSpacing: 1.2,
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    SizedBox(height: _height * 0.02),
                    Container(
                      height: _height * 0.04,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(_height * 0.012),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _buildList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
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
                                  borderRadius:
                                      BorderRadius.circular(_height * 0.012),
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
                height: _height * 0.65,
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
