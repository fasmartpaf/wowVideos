import 'dart:io';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/screen/loginscreen.dart';
import 'package:acoustic/screen/searchscreen.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart'
    as facebookLib;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/screen/homepages.dart';
import 'package:acoustic/screen/notification.dart';
import 'package:acoustic/screen/myprofile.dart';
import 'package:acoustic/screen/uploadvideo.dart';
import 'package:location/location.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart' as googleAds;
import 'package:native_admob_flutter/native_admob_flutter.dart';

String get nativeAdUnitId {
  if (Constants.getBannerAdUnitId().isNotEmpty) {
    return Constants.getNativeAdUnitId();
  } else {
    return MobileAds.nativeAdTestUnitId;
  }
}

String get bannerAdUnitId {
  if (Constants.getBannerAdUnitId().isNotEmpty) {
    return Constants.getBannerAdUnitId();
  } else {
    return MobileAds.bannerAdTestUnitId;
  }
}

String get interstitialAdUnitId {
  if (Constants.getInterstitialAdUnitId().isNotEmpty) {
    return Constants.getInterstitialAdUnitId();
  } else {
    return MobileAds.interstitialAdTestUnitId;
  }
}

bool _isInterstitialAdReady = false;
final interstitialAd = InterstitialAd();

class HomeScreen extends StatefulWidget {
  int initialIndex;

  HomeScreen(this.initialIndex);

  @override
  _HomeScreen createState() => new _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String name = "User";
  late LocationData _locationData;
  Location location = Location();
  final GlobalKey<ScaffoldState> _drawerScaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new SafeArea(
        child: Container(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            key: _drawerScaffoldKey,
            bottomNavigationBar: widget.initialIndex != null
                ? BottomBar(widget.initialIndex)
                : BottomBar(0),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: Text("NO")),










              SizedBox(height: 16),
              IconButton(
                  onPressed: () {
                    exit(0);
                  },
                  icon: Text("YES")),







            ],
          ),
        )) ??
        false as Future<bool>;
  }

}

class BottomBar extends StatefulWidget {
  int _currentIndex;

  BottomBar(this._currentIndex);

  @override
  State<StatefulWidget> createState() {
    return BottomBar1();
  }
}

class BottomBar1 extends State<BottomBar> {



  final bannerController = googleAds.BannerAdController();

  double dynamicAdSize = 70;


  bool adMobAds = false;
  bool facebookAds = false;
  bool startAppAds = false;
  List<String> storeAdNetworkData = [];
  int setLoop = 0;

  final List<Widget> _children = [
    MyHomePage(),
    SearchScreen(),
    Container(color: Colors.black),
    NotificationScreen(),
    MyProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    if (PreferenceUtils.getBooll(Constants.adAvailable) == true) {
      setLoop = PreferenceUtils.getStringList(Constants.adNetwork)!.length;
    }
    for (int i = 0; i < setLoop; i++) {
      storeAdNetworkData
          .add(PreferenceUtils.getStringList(Constants.adNetwork)![i]);
    }
    storeAdNetworkData.sort();

    for (int i = 0; i < setLoop; i++) {
      if (storeAdNetworkData[i] == "admob" &&
          PreferenceUtils.getStringList(Constants.adStatus)![i] == "1" &&
          PreferenceUtils.getStringList(Constants.adType)![i] == "Banner") {
        adMobAds = true;
        facebookAds = false;
        startAppAds = false;
        PreferenceUtils.setBool(Constants.adAvailable, true);
        advertisementManage();
        break;
      } else if (storeAdNetworkData[i] == "facebook" &&
          PreferenceUtils.getStringList(Constants.adStatus)![i] == "1") {
        PreferenceUtils.setBool(Constants.adAvailable, true);
        facebookAds = true;
        adMobAds = false;
        startAppAds = false;
        advertisementManage();
        break;
      } else {
        PreferenceUtils.setBool(Constants.adAvailable, false);
        dynamicAdSize = 70;
        adMobAds = false;
        facebookAds = false;
        startAppAds = false;
      }
    }
  }

  @override
  void dispose() {

    bannerController.dispose();
    super.dispose();
  }

  void advertisementManage() {
    if (adMobAds)
      adMob();
    else if (facebookAds) facebookAd();

  }

  void adMob() {
    setState(() {
      dynamicAdSize = 130;
    });

    bannerController.onEvent.listen((e) {
      final event = e.keys.first;

      switch (event) {
        case googleAds.BannerAdEvent.loaded:

          break;
        default:
          break;
      }
    });
    bannerController.load();
  }

  void facebookAd() {
    setState(() {
      dynamicAdSize = 130;
    });
  }

  void startApp() {
    setState(() {
      dynamicAdSize = 130;
    });
  }

  void handleEventForFacebookAds(BannerAdResult result, value) {
    switch (result) {
      case BannerAdResult.ERROR:
        print("Error: $value");
        break;
      case BannerAdResult.LOADED:
        print("Loaded: $value");
        break;
      case BannerAdResult.CLICKED:
        print("Clicked: $value");
        break;
      case BannerAdResult.LOGGING_IMPRESSION:
        print("Logging Impression: $value");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          body: _children[widget._currentIndex],
          bottomNavigationBar: Container(




            color: Color(Constants.bgblack),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  onTap: onTabTapped,
                  selectedItemColor: Colors.green,
                  unselectedItemColor: Colors.white,
                  selectedLabelStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontFamily: Constants.appFont),
                  unselectedLabelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: Constants.appFont),
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Color(Constants.bgblack),
                  currentIndex: widget._currentIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset("images/tab_home.svg",
                          color: Color(Constants.whitetext)),
                      activeIcon: SvgPicture.asset("images/tab_home.svg",
                          color: Color(Constants.lightbluecolor)),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset("images/tab_search.svg",
                          color: Color(Constants.whitetext)),
                      activeIcon: SvgPicture.asset("images/tab_search.svg",
                          color: Color(Constants.lightbluecolor)),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        "images/tab_add_new.svg",
                      ),
                      activeIcon: SvgPicture.asset("images/tab_add_new.svg"),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset("images/tab_notification.svg",
                          color: Color(Constants.whitetext)),
                      activeIcon: SvgPicture.asset(
                          "images/tab_notification.svg",
                          color: Color(Constants.lightbluecolor)),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: PreferenceUtils.getString(Constants.image).isEmpty
                          ? CircleAvatar(
                              radius: 17,
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  child:
                                      Image.asset("images/profilepicDemo.jpg")))

                          : CachedNetworkImage(
                              alignment: Alignment.center,
                              imageUrl:
                                  PreferenceUtils.getString(Constants.image),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 17,
                                backgroundColor: Color(0xFF36446b),
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundImage: imageProvider,
                                ),
                              ),
                              placeholder: (context, url) => CustomLoader(),
                              errorWidget: (context, url, error) =>
                                  Image.asset("images/no_image.png"),
                            ),
                      activeIcon: PreferenceUtils.getString(Constants.image)
                              .isEmpty
                          ? CircleAvatar(
                              radius: 17,
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  child:
                                      Image.asset("images/profilepicDemo.jpg")))
                          : CachedNetworkImage(
                              alignment: Alignment.center,
                              imageUrl:
                                  PreferenceUtils.getString(Constants.image),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 17,
                                backgroundColor: Color(0xFF36446b),
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundImage: imageProvider,
                                ),
                              ),
                              placeholder: (context, url) => CustomLoader(),
                              errorWidget: (context, url, error) =>
                                  Image.asset("images/no_image.png"),
                            ),
                      label: "",
                    ),
                  ],
                ),
                if (adMobAds)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: googleAds.BannerAd(
                      controller: bannerController,
                      size: googleAds.BannerSize.BANNER,
                      builder: (context, child) {
                        return Container(
                          color: Colors.black,
                          child: child,
                        );
                      },
                    ),
                  ),
                /*facebook*/
                if (facebookAds)
                  Container(
                    alignment: Alignment(0.5, 1),
                    child: FacebookBannerAd(
                      placementId: Platform.isAndroid
                          ? PreferenceUtils.getString(
                              Constants.facebookPlaceIdForBanner)
                          : PreferenceUtils.getString(
                              Constants.facebookPlaceIdForBanner),
                      bannerSize: facebookLib.BannerSize.STANDARD,
                      listener: (result, value) {
                        handleEventForFacebookAds(result, value);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      if (index == 1) {
        if (PreferenceUtils.getlogin(Constants.isLoggedIn) == false ||
            PreferenceUtils.getlogin(Constants.isLoggedIn) == null) {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          });
        }
      }
      if (index == 2) {
        setState(() {
          if (PreferenceUtils.getlogin(Constants.isLoggedIn) == true) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadVideoScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }
        });
      }
      if (index == 3) {
        if (PreferenceUtils.getlogin(Constants.isLoggedIn) == false ||
            PreferenceUtils.getlogin(Constants.isLoggedIn) == null) {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          });
        }
      }
      if (index == 4) {
        if (PreferenceUtils.getlogin(Constants.isLoggedIn) == false ||
            PreferenceUtils.getlogin(Constants.isLoggedIn) == null) {
          setState(() {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          });
        }
      }
      if (PreferenceUtils.getlogin(Constants.isLoggedIn) != false) {
        widget._currentIndex = index;
      }
    });
  }
}


