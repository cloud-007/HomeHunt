import 'package:flutter/material.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: MediaQuery.of(context).size.height * 0.030,
      width: MediaQuery.of(context).size.height * 0.030,
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).backgroundColor,
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
