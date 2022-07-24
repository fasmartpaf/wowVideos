import 'dart:io' show Platform;
import 'dart:ui';
import 'package:acoustic/screen/homescreen.dart';
import 'package:acoustic/screen/uploadvideo.dart';
import 'package:acoustic/util/constants.dart';
import 'package:dio/dio.dart';
import 'package:camera/camera.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:location/location.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'apiservice/Api_Header.dart';
import 'apiservice/Apiservice.dart';

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

Future<void> _loadInterstitialAd() async {
  if (!interstitialAd.isLoaded)
    interstitialAd.load(
      unitId: Constants.getInterstitialAdUnitId(),
    );
  interstitialAd.onEvent.listen((e) {
    final event = e.keys.first;
    switch (event) {
      case FullScreenAdEvent.closed:
        _isInterstitialAdReady = false;
        break;
      default:
        break;
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PreferenceUtils.init();
  cameras = await availableCameras();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await FlutterDownloader.initialize();
  await MobileAds.initialize(
    nativeAdUnitId: nativeAdUnitId,
    bannerAdUnitId: bannerAdUnitId,
    interstitialAdUnitId: interstitialAdUnitId,
  );
  await _loadInterstitialAd();
  FacebookAudienceNetwork.init();
  runApp(
    ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late LocationData _locationData;
  Location location = Location();

  startTime() async {
    if (_isInterstitialAdReady) {
      if (interstitialAd.isAvailable) {
        await interstitialAd.show();
      }
    }
    var _duration = new Duration(seconds: 0);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(0)),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();
    if (Platform.isAndroid) {
      getPermission();
    }
    PreferenceUtils.setBool(Constants.adAvailable, false);
    PreferenceUtils.setBool(Constants.admobAvailable, false);
    Constants.checkNetwork().whenComplete(() => callApiForsetting());
    Constants.checkNetwork().whenComplete(() => callApiForAdManage());
    Future.delayed(Duration(seconds: 1), () {
      startTime();
    });

    if (PreferenceUtils.getBooll(Constants.isFirstOpenApp) == false) {
      callApiForGuestUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenheight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    return new SafeArea(
      child: Scaffold(
        body: new Container(
          width: screenwidth,
          height: screenheight,
          color: Color(Constants.bgblack),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }

  Future<void> getPermission() async {
    await Permission.camera.request();
    await Permission.location.request();
    await Permission.microphone.request();
    await Permission.storage.request();
    if (await Permission.camera.status.isDenied) {
      Permission.camera.request();
    }
    if (await Permission.location.isRestricted) {
      Permission.location.request();
    }
    if (await Permission.location.isDenied) {
      Permission.location.request();
    }
    if (await Permission.microphone.isDenied) {
      Permission.microphone.request();
    }
    if (await Permission.storage.isDenied) {
      Permission.storage.request();
    }
    if (await Permission.location.isGranted) {
      _locationData = await location.getLocation();
      print(_locationData.latitude);
      print(_locationData.longitude);
    } else {
      Permission.location.request();
    }
  }

  Future<void> callApiForGuestUser() async {
    RestClient(ApiHeader().dioData()).guestUser().then((response) {
      PreferenceUtils.setBool(Constants.isFirstOpenApp, true);
    }).catchError((Object obj) {
      print(obj.runtimeType);
    });
  }

  Future<void> callApiForAdManage() async {
    await RestClient(ApiHeader().dioData())
        .adManagement()
        .then((response) async {
      if (0 < response.data!.length) {
        PreferenceUtils.setBool(Constants.adAvailable, true);
      }
      List<String> adLocationList = [];
      List<String> adNetworkList = [];
      List<String> adTypeList = [];
      List<String> adIntervalList = [];
      List<String> adStatusList = [];
      for (int i = 0; i < response.data!.length; i++) {
        adLocationList.add(response.data![i].location.toString());
        adNetworkList.add(response.data![i].network.toString());
        adTypeList.add(response.data![i].type.toString());
        adIntervalList.add(response.data![i].interval.toString());
        adStatusList.add(response.data![i].status.toString());
        if (response.data![i].network == 'admob' &&
            response.data![i].status == 1) {
          PreferenceUtils.setBool(Constants.admobAvailable, true);
          PreferenceUtils.setBool(Constants.adAvailable, true);
        } else if (response.data![i].network == 'facebook' &&
            response.data![i].status == 1) {
          PreferenceUtils.setBool(Constants.admobAvailable, true);
          PreferenceUtils.setBool(Constants.adAvailable, true);
        }
      }
      PreferenceUtils.setStringList(Constants.adLocation, adLocationList);
      PreferenceUtils.setStringList(Constants.adNetwork, adNetworkList);
      PreferenceUtils.setStringList(Constants.adType, adTypeList);
      PreferenceUtils.setStringList(Constants.adInterval, adIntervalList);
      PreferenceUtils.setStringList(Constants.adStatus, adStatusList);
      await activeAdvertisement();
    }).catchError((Object obj) {
      print("error:$obj.");
      print(obj.runtimeType);
      switch (obj.runtimeType) {
        case DioError:
          // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response!;
          print(res);

          var responsecode = res.statusCode;

          if (responsecode == 401) {
            print(responsecode);
            print(res.statusMessage);
          } else if (responsecode == 422) {
            print("code:$responsecode");
          }

          break;
        default:
      }
    });
  }

  Future<void> activeAdvertisement() async {
    int setLoop = 0;
    setLoop = PreferenceUtils.getStringList(Constants.adNetwork)!.length;
    for (int i = 0; i < setLoop; i++) {
      if (PreferenceUtils.getStringList(Constants.adNetwork)![i] == "admob" &&
          PreferenceUtils.getStringList(Constants.adStatus)![i] == "1" &&
          PreferenceUtils.getStringList(Constants.adType)![i] ==
              "Interstitial") {
        _isInterstitialAdReady = true;
        adMob();
        break;
      } else if (PreferenceUtils.getStringList(Constants.adNetwork)![i] ==
              "facebook" &&
          PreferenceUtils.getStringList(Constants.adStatus)![i] == "1" &&
          PreferenceUtils.getStringList(Constants.adType)![i] == "Banner") {
        facebookAd();
        break;
      }
    }
  }

  Future<void> adMob() async {
    if (interstitialAd.isAvailable) {
      await interstitialAd.show();
    } else {
      interstitialAd.load(unitId: Constants.getInterstitialAdUnitId());
    }
  }

  void facebookAd() {
    FacebookAudienceNetwork.init(
      testingId: PreferenceUtils.getString(Constants.facebookInit),
    );
  }

  void callApiForsetting() {
    RestClient(ApiHeader().dioData()).settingRequest().then((response) {
      if (response.success == true) {
        print("Setting true");
        PreferenceUtils.setString(Constants.appName, 'WOW Video' ?? "");
        PreferenceUtils.setString(Constants.appId, response.data?.appId ?? "");
        PreferenceUtils.setString(
            Constants.appVersion, response.data?.appVersion ?? "");
        PreferenceUtils.setString(
            Constants.appFooter, response.data?.appFooter ?? "");
        PreferenceUtils.setString(
            Constants.termsOfUse, response.data?.termsOfUse ?? "");
        PreferenceUtils.setString(
            Constants.privacyPolicy, response.data?.privacyPolicy ?? "");
        PreferenceUtils.setString(
            Constants.imagePath, response.data?.imagePath ?? "");
        PreferenceUtils.setString(Constants.admobBannerAdUnitIdAndroid,
            response.data?.androidBanner ?? "");
        PreferenceUtils.setString(
            Constants.admobBannerAdUnitIdiOS, response.data?.iosBanner ?? "");
        PreferenceUtils.setString(Constants.admobInterstitialAdUnitIdAndroid,
            response.data?.androidInterstitial ?? "");
        PreferenceUtils.setString(Constants.admobInterstitialAdUnitIdiOS,
            response.data?.iosInterstitial ?? "");
        PreferenceUtils.setString(Constants.admobNativeAdUnitIdAndroid,
            response.data?.androidNative ?? "");
        PreferenceUtils.setString(
            Constants.admobNativeAdUnitIdiOS, response.data?.iosNative ?? "");
        PreferenceUtils.setString(
            Constants.facebookInit, response.data?.facebookInit ?? "");
        PreferenceUtils.setString(Constants.facebookPlaceIdForBanner,
            response.data?.facebookBanner ?? "");
        if (response.data!.appId != null && response.data!.appId!.isNotEmpty) {
          getDeviceToken(PreferenceUtils.getString((Constants.appId)));
        }
      } else {}
    }).catchError((Object obj) {
      print("error:$obj.");
      print(obj.runtimeType);
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          print(res);
          var responsecode = res.statusCode;

          if (responsecode == 401) {
            print(responsecode);
            print(res.statusMessage);
          } else if (responsecode == 422) {
            print("code:$responsecode");
          }
          break;
        default:
      }
    });
  }

  void getDeviceToken(String appId) async {
    if (!mounted) return;

    OneSignal.shared.consentGranted(true);
    await OneSignal.shared.setAppId(appId);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    OneSignal.shared.promptLocationPermission();

    await OneSignal.shared.getDeviceState().then((value) {
      if (value!.userId != null) {
        PreferenceUtils.setString(Constants.deviceToken, value.userId!);
      } else {
        PreferenceUtils.setString(Constants.deviceToken, "");
      }
    });
  }
}
