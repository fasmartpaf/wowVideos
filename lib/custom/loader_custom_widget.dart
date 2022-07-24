import 'package:acoustic/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitFadingCircle(
            color: Color(Constants.whitetext)));
  }
}