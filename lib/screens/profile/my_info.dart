import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyInfo extends StatefulWidget {
  const MyInfo({key}) : super(key: key);

  @override
  _MyInfoState createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  var _controller = new TextEditingController();
  bool isEditable = false;
  String text = "";

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;
    final _width = MediaQuery.of(context).size.width;
    final _iconSize = _height * 0.02;
    _controller.text = FirebaseAuth.instance.currentUser.displayName;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: _height * 0.06,
        title: Text('My Info'),
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Theme.of(context).canvasColor,
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top),
            Container(
              padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
              height: _height * 0.06,
              decoration: BoxDecoration(
                color: Color.fromRGBO(44, 130, 201, 0.2),
                // color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(_height * 0.012),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: _height * 0.06,
                    width: _width * 0.8,
                    color: Colors.transparent,
                    child: TextFormField(
                      readOnly: isEditable ? false : true,
                      controller: _controller,
                      cursorColor: Theme.of(context).canvasColor,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontSize: _height * 0.015,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: _height * 0.02,
                      ),
                      onChanged: (value) {
                        text = value;
                      },
                      onSaved: (value) {
                        setState(() {
                          _controller.text = text;
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditable = !isEditable;
                      });
                    },
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).canvasColor,
                      size: _iconSize,
                    ),
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
