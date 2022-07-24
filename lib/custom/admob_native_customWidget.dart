import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class AdMobNativeCustom extends StatelessWidget {
  const AdMobNativeCustom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NativeAd(
      // controller: nativeAdController,
      height: 320,
      unitId:
      MobileAds.nativeAdVideoTestUnitId,
      builder: (context, child) {
        return Material(
          elevation: 8,
          child: child,
        );
      },
      buildLayout:
      mediumAdTemplateLayoutBuilder,
      // buildLayout: fullBuilder,
      loading: Text(
        'loading',
        style:
        TextStyle(color: Colors.white),
      ),
      error: Text(
        'error',
        style:
        TextStyle(color: Colors.white),
      ),
      icon: AdImageView(size: 40),
      headline: AdTextView(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        maxLines: 1,
      ),
      body: AdTextView(
          style: TextStyle(
              color: Colors.black),
          maxLines: 1),
      media: AdMediaView(
        height: 170,
        width: MATCH_PARENT,
      ),
      attribution: AdTextView(
        width: WRAP_CONTENT,
        text: 'Ad',
        decoration: AdDecoration(
          border: BorderSide(
              color: Colors.green,
              width: 2),
          borderRadius:
          AdBorderRadius.all(16.0),
        ),
        style:
        TextStyle(color: Colors.green),
        padding: EdgeInsets.symmetric(
            horizontal: 4.0, vertical: 1.0),
      ),
      button: AdButtonView(
        elevation: 18,
        decoration: AdDecoration(
            backgroundColor: Colors.blue),
        height: MATCH_PARENT,
        textStyle:
        TextStyle(color: Colors.white),
      ),
    );
  }
}