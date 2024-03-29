// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:homehunt/model/house.dart';

class HouseCarousel extends StatelessWidget {
  final House house;

  HouseCarousel(this.house, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final _font = _height * _width;
    return Container(
      height: _height * 0.17,
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: _width * 0.018),
            child: Container(
              width: _width * 0.42,
              height: _height * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  house.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Image(
                      image: AssetImage('assets/images/networkerror.jpg'),
                      fit: BoxFit.cover,
                    );
                  },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: _width * 0.03),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  house.homeName,
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    //color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold,
                    fontSize: _font * 0.00007,
                    overflow: TextOverflow.ellipsis,
                    letterSpacing: _height * 0.0015,
                  ),
                ),
                Text(
                  house.type,
                  style: TextStyle(
                    //color: Theme.of(context).primaryColorDark,
                    color: Theme.of(context).canvasColor,
                    fontSize: _font * 0.00005,
                    overflow: TextOverflow.ellipsis,
                    letterSpacing: _height * 0.0015,
                  ),
                ),
                Text(
                  house.price + ' Tk/m',
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontSize: _font * 0.00005,
                    overflow: TextOverflow.ellipsis,
                    letterSpacing: _height * 0.0015,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_pin,
                      color: Theme.of(context).canvasColor,
                      size: _font * 0.00005,
                    ),
                    SizedBox(width: _width * 0.01),
                    Text(
                      house.location,
                      style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: _font * 0.00005,
                        overflow: TextOverflow.ellipsis,
                        letterSpacing: _height * 0.0015,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
