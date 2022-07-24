import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/screen/searchhashtagvideolist.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:acoustic/screen/searchhistory.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  int _current = 0;
  List<String> imgList = [];
  List<String?> hashTagForBanner = [];
  List<dynamic> mainHashtags = [];
  bool _isBannerAdReady = false;
  bool adMobNative = false;
  List<String> storeAdNetworkData = [];
  int setLoop = 0;
  List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    callApiForGetBanners();
    callApiForDefaultSearch();

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
          PreferenceUtils.getStringList(Constants.adType)![i] == "Native") {
        adMobNative = true;
        advertisementManage();
        break;
      }















      else {
        adMobNative = false;

      }
    }
  }

  void advertisementManage() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new SafeArea(
        child: Scaffold(
          backgroundColor: Color(Constants.bgblack),

          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: CustomLoader(),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return new Stack(
                  children: <Widget>[
                    new SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 0, right: 10),
                        color: Colors.transparent,
                        child: Column(


                          children: <Widget>[
                            ///search
                            Container(
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 10),
                              height: ScreenUtil().setHeight(50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Color(Constants.conbg),

                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          SearchHistoryScreen()));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(left: 10),
                                          child: SvgPicture.asset(
                                              "images/greay_search.svg")),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                          color: Colors.transparent,
                                          child: Text(
                                            "Search Hashtags, Profile",
                                            style: TextStyle(
                                                color:
                                                    Color(Constants.greytext),
                                                fontSize: 14,
                                                fontFamily: Constants.appFont),
                                            maxLines: 1,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ///banners
                            Container(
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 10),
                              alignment: Alignment.center,
                              height: ScreenUtil().setHeight(200),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.transparent,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: ScreenUtil().setHeight(200),
                                      viewportFraction: 1.0,
                                      onPageChanged: (index, index1) {
                                        setState(() {
                                          _current = index;
                                        });
                                      },
                                    ),

                                    items: imgList.map((it) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            alignment: Alignment.center,
                                            child: Stack(
                                              children: <Widget>[
                                                Material(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  elevation: 2.0,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  type:
                                                      MaterialType.transparency,
                                                  child: CachedNetworkImage(
                                                    imageUrl: it,
                                                    fit: BoxFit.fill,
                                                    height: ScreenUtil()
                                                        .setHeight(200),
                                                    width: ScreenUtil()
                                                        .setWidth(500),
                                                    placeholder: (context,
                                                            url) => CustomLoader(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Image.asset(
                                                            "images/no_image.png"),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: List.generate(
                                                        imgList.length,
                                                        (index) => Container(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              width: 9.0,
                                                              height: 9.0,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          2.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: _current ==
                                                                        index
                                                                    ? Color(Constants
                                                                        .lightbluecolor)
                                                                    : Color(
                                                                        0xFFffffff),
                                                              ),
                                                            )),

























                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            ///defaultHashtags
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: mainHashtags.length,
                              itemBuilder: (context, index) {
                                if (adMobNative == true) {
                                  if (index != 0 && index % 3 == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: NativeAd(

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
                                        ),
                                      ),
                                    );
                                  }
                                }
                                return InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HashTagVideoListScreen(
                                                  hashtag:
                                                  mainHashtags[index]
                                                      .title,
                                                  views:
                                                  mainHashtags[index]
                                                      .views
                                                      .toString(),
                                                )));
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      /// hastags row
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        height: ScreenUtil().setHeight(57),
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: SvgPicture.asset(
                                                    "images/hash_tag.svg"),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: mainHashtags[index]
                                                          .trending ==
                                                      1
                                                  ? Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      margin: EdgeInsets.only(
                                                          left: 10, top: 10),
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "\#${mainHashtags[index].title}",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              style: (TextStyle(
                                                                  color: Color(
                                                                      Constants
                                                                          .whitetext),
                                                                  fontFamily:
                                                                      Constants
                                                                          .appFont,
                                                                  fontSize:
                                                                      16)),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 2),
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "Trending",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              style: (TextStyle(
                                                                  color: Color(
                                                                      Constants
                                                                          .hinttext),
                                                                  fontFamily:
                                                                      Constants
                                                                          .appFont,
                                                                  fontSize:
                                                                      16)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                        left: 10,
                                                        top: 15,
                                                      ),
                                                      child: Text(
                                                        "\# ${mainHashtags[index].title}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .visible,
                                                        style: (TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .whitetext),
                                                            fontFamily:
                                                                Constants
                                                                    .appFont,
                                                            fontSize: 16)),
                                                      ),
                                                    ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        () {
                                                          if (1 <
                                                              int.parse(
                                                                  mainHashtags[
                                                                          index]
                                                                      .views
                                                                      .toString())) {
                                                            return "${mainHashtags[index].views} Views";
                                                          } else {
                                                            return "${mainHashtags[index].views} View";
                                                          }
                                                        }(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .visible,
                                                        style: TextStyle(
                                                            color: Color(Constants
                                                                .lightbluecolor),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                Constants
                                                                    .appFont),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5, right: 5),
                                                      child: SvgPicture.asset(
                                                        "images/right_arrow.svg",
                                                        width: ScreenUtil()
                                                            .setWidth(20),
                                                        height: ScreenUtil()
                                                            .setHeight(20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      ///hashtag videos
                                      0 < mainHashtags[index].videos.length
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              height: ScreenUtil().setHeight(170),
                                              child: ListView.builder(
                                                itemCount: mainHashtags[index]
                                                    .videos
                                                    .length,
                                                scrollDirection: Axis.horizontal,
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int subIndex) {
                                                  return Padding(
                                                    padding: EdgeInsets.all(
                                                        ScreenUtil().setWidth(5)),
                                                    child: Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl: mainHashtags[
                                                                      index]
                                                                  .videos[
                                                                      subIndex]
                                                                  .imagePath +
                                                              mainHashtags[index]
                                                                  .videos[
                                                                      subIndex]
                                                                  .screenshot,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: ScreenUtil()
                                                                .setWidth(100),
                                                            height: ScreenUtil()
                                                                .setHeight(150),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit.fill,
                                                                alignment:
                                                                    Alignment
                                                                        .topCenter,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context, url) => CustomLoader(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                                  "images/no_image.png"),
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: SvgPicture.asset(
                                                            "images/play_button.svg",
                                                            width: ScreenUtil()
                                                                .setWidth(50),
                                                            height: ScreenUtil()
                                                                .setHeight(50),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ///changed
  Future<void> callApiForGetBanners() async {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).getbanners().then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
        });
        setState(() {
          print("lenght123456:${imgList.length}");

          if (response.data!.length != 0) {
            imgList.clear();
            for (int i = 0; i < response.data!.length; i++) {
              imgList
                  .add(response.data![i].imagePath! + response.data![i].image!);
              hashTagForBanner.add(response.data![i].title);
            }
            print("imgList.length:${imgList.length}");
          }
        });
      } else {
        setState(() {
          showSpinner = false;
        });
      }
    }).catchError((Object obj) {


      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
      Constants.toastMessage("Internal Server Error");
    });
  }

  Future<void> callApiForDefaultSearch() async {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).getDefaultSearch().then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
        });
        setState(() {
          mainHashtags.addAll(response.data!);
        });
      } else {
        setState(() {
          showSpinner = false;
        });
      }
    }).catchError((Object obj) {


      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
      Constants.toastMessage("Internal Server Error");
    });
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
