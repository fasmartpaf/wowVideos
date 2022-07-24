import 'package:flutter/material.dart';
import 'package:acoustic/util/constants.dart';

class CardTextFieldWidget extends StatelessWidget {
  CardTextFieldWidget(
      {required this.hintText,
      required this.textInputType,
      required this.textInputAction,
      required this.textEditingController,
      this.validator,
      required this.focus});
  final String? hintText;
  Function? validator, focus;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: TextFormField(
        textInputAction: textInputAction,
        onFieldSubmitted: focus as void Function(String)?,
        validator: validator as String? Function(String?)?,
        keyboardType: textInputType,
        controller: textEditingController,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: Constants.appFontBold),
        decoration: Constants.kTextFieldInputDecoration.copyWith(
          hintText: hintText,
        ),
      ),
    );
  }
}
