import 'package:acoustic/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoPostAvailable extends StatelessWidget {
  String subject;
  NoPostAvailable({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(80),
      margin: const EdgeInsets.only(
          top: 10.0,
          left: 15.0,
          right: 15,
          bottom: 0),
      child: Text(
        "No $subject Available !",
        style: TextStyle(
            color: Colors.white,
            fontFamily: Constants.appFont,
            fontSize: 20),
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }
}