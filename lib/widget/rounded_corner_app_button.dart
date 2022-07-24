import 'package:flutter/material.dart';
import 'package:acoustic/util/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedCornerAppButton extends StatelessWidget {
  RoundedCornerAppButton({required this.btnLabel, required this.onPressed});
  final btnLabel;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 5.0,
      textColor: Colors.white,
      color: Color(Constants.buttonbg),
      child: Container(
        height: ScreenUtil().setHeight(50),
        alignment: Alignment.center,
        child: Text(
          btnLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: Constants.appFont,
              fontWeight: FontWeight.w900,
              fontSize: 16.0),
        ),
      ),
      onPressed: onPressed as void Function()?,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(12.0),
      ),
    );
  }
}
