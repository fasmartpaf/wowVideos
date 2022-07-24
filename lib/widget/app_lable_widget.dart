import 'package:flutter/material.dart';
import 'package:acoustic/util/constants.dart';

class AppLableWidget extends StatelessWidget {
  AppLableWidget({required this.title});
  final title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
      child: Text(
        title,
        style: Constants.kAppLabelWidget,
      ),
    );
  }
}
