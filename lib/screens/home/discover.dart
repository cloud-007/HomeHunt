// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unused_local_variable, prefer_typing_uninitialized_variables, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/screens/house/add_house.dart';
import 'package:homehunt/widgets/HomeScreen/list_view.dart';
import 'package:homehunt/widgets/HomeScreen/housecarousel.dart';

class HomeScreen extends StatefulWidget {
  static String pageRoute = '/home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  int _selectedIndex = 0;

  final List<String> _buildList = [
    'All',
    'Family',
    'Bachelor',
  ];

  List<HouseCarousel> list;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add_outlined,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddHouse(),
            ),
          );
        },
      ),
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              user.displayName,
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
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: _height * 0.01),
                    Container(
                      height: _height * 0.055,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(_height * 0.012),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: _width * 0.05),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            cursorHeight: _height * 0.035,
                            key: ValueKey('search'),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                letterSpacing: 1.2,
                                color: Colors.grey,
                                fontSize: _height * 0.023,
                              ),
                              prefixIcon: Icon(
                                Icons.search_sharp,
                                size: _height * 0.023,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: _height * 0.023,
                              letterSpacing: 1.2,
                            ),
                          ),
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
                          return Padding(
                            padding: EdgeInsets.only(right: _width * 0.04),
                            child: Container(
                              decoration: BoxDecoration(
                                color: index == _selectedIndex
                                    ? Theme.of(context).primaryColorDark
                                    : Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.circular(_height * 0.012),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: _width * 0.04,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = index;
                                        print(_selectedIndex);
                                      });
                                    },
                                    child: Text(
                                      _buildList[index],
                                      style: TextStyle(
                                        color: index == _selectedIndex
                                            ? Colors.white
                                            : Colors.black54,
                                        fontFamily: "Crete_Round",
                                        fontWeight: FontWeight.w100,
                                        fontSize: _height * 0.02,
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
                  child: HomeScreenListView(_selectedIndex),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
