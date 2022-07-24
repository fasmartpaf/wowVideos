import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'preferenceutils.dart';

class Constants {
  /*BaseUrl*/
  static final String baseUrl = "https://saasmonks.in/App-Demo/Acoustic-54251/public/api/";
 // static final String baseUrl = "https://goomza.fan/public/api/";
  //don't remove "/public/api/"

  /*Advertisement*/
  ///admob
  static final String admobBannerAdUnitIdAndroid = 'bannerAdUnitIdAndroid';
  // 'ca-app-pub-3940256099942544/6300978111';
  static final String admobBannerAdUnitIdiOS = 'bannerAdUnitIdiOS';
  // 'ca-app-pub-3940256099942544/2934735716';

  static final String admobInterstitialAdUnitIdAndroid =
      'interstitialAdUnitIdAndroid';
  // 'ca-app-pub-3940256099942544/1033173712';
  static final String admobInterstitialAdUnitIdiOS = 'interstitialAdUnitIdiOS';
  // 'ca-app-pub-3940256099942544/4411468910';

  static final String admobNativeAdUnitIdAndroid = 'nativeAdUnitIdAndroid';
  // 'ca-app-pub-3940256099942544/2247696110';
  static final String admobNativeAdUnitIdiOS = 'nativeAdUnitIdiOS';
  // 'ca-app-pub-3940256099942544/3986624511';

  static String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return PreferenceUtils.getString(Constants.admobBannerAdUnitIdAndroid);
    } else if (Platform.isIOS) {
      return PreferenceUtils.getString(Constants.admobBannerAdUnitIdiOS);
    }
    return "";
  }

  static String getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return PreferenceUtils.getString(
          Constants.admobInterstitialAdUnitIdAndroid);
    } else if (Platform.isIOS) {
      return PreferenceUtils.getString(Constants.admobInterstitialAdUnitIdiOS);
    }
    return "";
  }

  static String getNativeAdUnitId() {
    if (Platform.isAndroid) {
      return PreferenceUtils.getString(Constants.admobNativeAdUnitIdAndroid);
    } else if (Platform.isIOS) {
      return PreferenceUtils.getString(Constants.admobNativeAdUnitIdiOS);
    }
    return "";
  }

  ///facebook
  static final String facebookInit = 'facebookInit';
  // '37b1da9d-b48c-4103-a393-2e095e734bd6';
  static final String facebookPlaceIdForBanner = 'facebookPlaceIdForBanner';
  // 'IMG_16_9_LINK#349126746297760_349562716254163';

  static int bgblack = 0xFF121212;
  static int bgblack1 = 0xFF1d1d1d;
  static int buttonbg = 0xFF36446b;
  static int greytext = 0xFF666666;
  static int hinttext = 0xFFc2c2c2;
  static int whitetext = 0xFFffffff;
  static int lightbluecolor = 0xFF36446b;
  static int conbg = 0xFF1d1d1d;
  static int redtext = 0xFFff4343;

  /*User Data*/

  static final String isLoggedIn = "isLoggedIn";
  static final String isverified = "isverified";

  static final String deviceToken = "devicetoken";
  static final String headerToken = "headertoken";
  static final String id = "id";
  static final String name = "name";
  static final String userId = "user_id";
  static final String email = "email";
  static final String code = "code";
  static final String phone = "phone";
  static final String isVerify = "is_verify";
  static final String bio = "bio";
  static final String bDate = "bdate";
  static final String gender = "gender";
  static final String image = "image";

  /*Setting data*/

  static final String appName = "app_name";
  static final String appId = "app_id";
  static final String appVersion = "app_version";
  static final String appFooter = "app_footer";
  static final String termsOfUse = "terms_of_use";
  static final String privacyPolicy = "privacy_policy";
  static final String isWaterMark = "isWaterMark";
  static final String waterMarkPath = "waterMarkPath";
  static final String imagePath = "imagePath";
  static final String addMusicId = "addMusicId";
  static final String trendingVidPreviousIndex = "trendingVidPreviousIndex";

  /*search*/
  static final String recentSearch = "recentSearch";

  static final String isFirstOpenApp = "isFirstOpenApp";

  /*advertise setting*/
  static final String adLocation = "adLocation";
  static final String adNetwork = "adNetwork";
  static final String adType = "adType";
  static final String adInterval = "adInterval";
  static final String adStatus = "adStatus";
  static final String adAvailable = "adAvailable";
  static final String admobAvailable = "admobAvailable";

  /*fonts*/
  static String appFont = 'Proxima';
  static String appFontBold = 'ProximaBold';

  static var kAppLabelWidget = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14.0,
      color: Color(Constants.greytext),
      fontFamily: Constants.appFont);

  static var kTextFieldInputDecoration = InputDecoration(
    hintStyle: TextStyle(
        color: Color(Constants.hinttext),
        fontFamily: Constants.appFont,
        fontSize: 14),

    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(Constants.greytext)),
    ),

    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),

    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    // errorStyle: TextStyle(
    //     fontFamily: Constants.app_font, color: Colors.red)
  );

  static String? kvalidatedata(String? value) {
    if (value!.length == 0) {
      return 'Data is Required';
    } else
      return null;
  }

  static String? kvalidateUserName(String? value) {
    value!.trim();
    Pattern pattern = r'[a-zA-Z0-9]+$';
    RegExp regex = new RegExp(pattern as String);
    Pattern pattern2 = r'^\S*$';
    RegExp regex2 = new RegExp(pattern2 as String);
    if (value.length == 0) {
      return "Enter any character";
    } else if (value.length < 5 || value.length > 10) {
      return "UserName should be min. 5 letter and max. 10 letter";
    } else if (!regex.hasMatch(value)) {
      return 'Not Included any special characters(#, @, .)';
    } else if (!regex2.hasMatch(value)) {
      return 'Not Included a whitespace';
    } else
      return null;
  }

  static String? kvalidateotp(String? value) {
    // Pattern pattern = r'[0-9]';
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{4}$)';
    RegExp regex = new RegExp(pattern as String);
    if (value!.length == 0) {
      return 'OTP is Required';
    } else if (value.length > 4) {
      return 'Enter Valid OTP';
    } else if (!regex.hasMatch(value))
      return ' Enter Valid OTP';
    else
      return null;
  }

  static String? kvalidateName(String? value) {
    if (value!.length == 0) {
      return 'Name is Required';
    } else
      return null;
  }

  static String? kvalidateReason(String? value) {
    if (value!.trim().length == 0) {
      return 'Reason is Required';
    } else
      return null;
  }

  static String? kvalidateIssue(String? value) {
    if (value!.trim().length == 0) {
      return 'Issue is Required';
    } else
      return null;
  }

  static String? kvalidateCotactNum(String? value) {
    Pattern pattern = r'^[0-9]*$';
    RegExp regex = new RegExp(pattern as String);
    if (value!.length == 0) {
      return 'Contact Number is Required';
    } else if (value.length > 10) {
      return 'Contact Number should be 10 letter';
    } else if (!regex.hasMatch(value)) {
      return 'letter should be in numbers';
    } else
      return null;
  }

  static String? kvalidatePassword(String? value) {


    if (value!.length == 0) {
      return "Password is Required";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    else
      return null;
  }

  static String? kvalidateConfPassword(
      String? value,
      TextEditingController _text_Password,
      TextEditingController _text_confPassword) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern as String);
    if (value!.length == 0) {
      return "Password is Required";
    } else if (_text_Password.text != _text_confPassword.text)
      return 'Password and Confirm Password does not match.';
    else if (!regex.hasMatch(value))
      return 'Password required';
    else
      return null;
  }

  static String? kvalidateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    if (value!.length == 0) {
      return "Email is Required";
    } else if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  static void createSnackBar(
      String message, BuildContext scaffoldContext, Color color) {
    final snackBar = new SnackBar(
      content: new Text(
        message,
        style: TextStyle(
            color: Color(whitetext), fontFamily: appFont, fontSize: 16),
      ),
      backgroundColor: color,
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(snackBar);
    // Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }

  static Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      Constants.toastMessage("No Internet Connection");
      return false;
    }
  }

  static toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: "$msg.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static toastMessageLongTime(String msg) {
    Fluttertoast.showToast(
        msg: "$msg.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
