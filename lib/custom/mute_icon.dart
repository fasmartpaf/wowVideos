import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MuteIconWidget extends StatelessWidget {
  final bool isMute;
  const MuteIconWidget({
    Key? key,required this.isMute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: ClipRRect(
          borderRadius:
          BorderRadius.all(
            Radius.circular(100),
          ),
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white
                  .withOpacity(0.1),
            ),
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              child: BackdropFilter(
                filter:
                ImageFilter.blur(
                  sigmaX: 10.0,
                  sigmaY: 10.0,
                ),
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    isMute ? 'images/ic_volume.svg' : 'images/ic_mute.svg',
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAlias,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
