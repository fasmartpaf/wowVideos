import 'package:flutter/material.dart';
import 'package:acoustic/util/constants.dart';

class ApplicationToolbar extends StatelessWidget with PreferredSizeWidget {
  ApplicationToolbar({required this.appbarTitle});
  final String appbarTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(
        appbarTitle,
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: Constants.appFont),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
