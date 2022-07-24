import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:acoustic/util/constants.dart';

class CardPasswordTextFieldWidget extends StatefulWidget {
  CardPasswordTextFieldWidget(
      {required this.hintText,
      required this.isPasswordVisible,
      this.textEditingController,
      this.validator});
  String hintText;
  bool isPasswordVisible;
  Function? validator;
  final TextEditingController? textEditingController;

  @override
  _CardTextFieldWidgetState createState() => _CardTextFieldWidgetState();
}

class _CardTextFieldWidgetState extends State<CardPasswordTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: TextFormField(
        validator: widget.validator as String? Function(String?)?,
        controller: widget.textEditingController,
        obscureText: widget.isPasswordVisible,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: Constants.appFontBold,
        ),
        decoration: InputDecoration(
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintStyle: TextStyle(
              color: Color(Constants.hinttext),
              fontFamily: Constants.appFont,
              fontSize: 14),
          hintText: widget.hintText,
          suffixIcon: IconButton(
              icon: SvgPicture.asset(
                // Based on passwordVisible state choose the icon
                widget.isPasswordVisible
                    ? 'images/ic_eye_hide.svg'
                    : 'images/ic_eye.svg',
                height: 15,
                width: 15,
                color: Color(Constants.hinttext),
              ),
              onPressed: () {
                setState(() {
                  widget.isPasswordVisible = !widget.isPasswordVisible;
                });
              }),
        ),
      ),
    );
  }
}
