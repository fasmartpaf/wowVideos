import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeroImage extends StatelessWidget {
  const HeroImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: Hero(
        tag: 'App_logo',
        child: Center(
            child: SvgPicture.asset('images/white_logo.svg',
            width: 100.0,
            height: 80,),
        ),
      ),
    );
  }
}
