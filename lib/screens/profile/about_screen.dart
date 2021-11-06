import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({key}) : super(key: key);

  Widget _buildWidget(String designation, String name, String id,
      double _height, double _width, String _image, Color _color) {
    return Container(
      margin: EdgeInsets.only(top: _height * 0.015),
      height: _height * 0.17,
      width: _width * 0.9,
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(_height * 0.012),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: _height * 0.01,
              vertical: _height * 0.01,
            ),
            height: _height * 0.15,
            width: _height * 0.15,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(_height * 0.012),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_height * 0.012),
              child: Image(
                image: AssetImage(_image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: _width * 0.02),
          Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: _height * 0.02),
                Text(
                  designation,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  id,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Department of Computer Science\n' + ' & Engineering',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('About HomeHunt'),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: _height * 0.02),
                  Text(
                    'This is an android app thich will help you to find' +
                        'houses based on your requirements',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                  Text(
                    'This application has been develoved by: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildWidget(
                    'Project Supervisor',
                    'Syeda Tamanna Alam Monisha',
                    'Faculty',
                    _height,
                    _width,
                    'assets/images/user0.png',
                    Theme.of(context).hoverColor,
                  ),
                  _buildWidget(
                    'Team Leader',
                    'MD Mazharul Islam Emon',
                    'ID: 1832020014',
                    _height,
                    _width,
                    'assets/images/user1.jpg',
                    Theme.of(context).hoverColor,
                  ),
                  _buildWidget(
                    'Team Member 1',
                    'Sanzida Parvin Shorna',
                    'ID: 1832020015',
                    _height,
                    _width,
                    'assets/images/shorna.jpeg',
                    Theme.of(context).hoverColor,
                  ),
                  _buildWidget(
                    'Team Member 2',
                    'Afsana Begum',
                    'ID: 1832020001',
                    _height,
                    _width,
                    'assets/images/user0.png',
                    Theme.of(context).hoverColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
