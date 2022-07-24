import 'dart:convert';
import 'dart:ui';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/admob_native_customWidget.dart';
import 'package:acoustic/custom/like_comment_share.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/custom/mute_icon.dart';
import 'package:acoustic/custom/no_post_available.dart';
import 'package:acoustic/model/trendingvideo.dart';
import 'package:dio/dio.dart';
import 'package:acoustic/screen/loginscreen.dart';
import 'package:acoustic/screen/usedsoundlist.dart';
import 'package:acoustic/screen/userprofile.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'homescreen.dart';

class TrendingScreen extends StatefulWidget {
  @override
  _TrendingScreen createState() => _TrendingScreen();
}

class _TrendingScreen extends State<TrendingScreen> {
  bool halfStatus = true;
  bool fullStatus = false;
  bool showMore = true;
  PageController? trendingPageController;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  List<TrendingData> trendingVidList = <TrendingData>[];
  late Future<List<TrendingData>> _getVideoFeatureBuilder;
  bool noData = true;
  bool showData = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool adMobNative = false;
  List<String> storeAdNetworkData = [];
  int setLoop = 0;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();
    _getVideoFeatureBuilder = callApiForTrendingVideo();
    if (PreferenceUtils.getBooll(Constants.adAvailable) == true) {
      setLoop = PreferenceUtils.getStringList(Constants.adNetwork)!.length;
      for (int i = 0; i < setLoop; i++) {
        storeAdNetworkData
            .add(PreferenceUtils.getStringList(Constants.adNetwork)![i]);
      }
    }
    storeAdNetworkData.sort();
    for (int i = 0; i < setLoop; i++) {
      if (storeAdNetworkData[i] == "admob" &&
          PreferenceUtils.getStringList(Constants.adStatus)![i] == "1" &&
          PreferenceUtils.getStringList(Constants.adType)![i] == "Native") {
        adMobNative = true;
        break;
      } else {
        adMobNative = false;
      }
    }









  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        body: RefreshIndicator(
          color: Color(Constants.lightbluecolor),
          backgroundColor: Colors.transparent,
          onRefresh: callApiForTrendingVideo,
          key: _refreshIndicatorKey,
          child: Container(
            margin: PreferenceUtils.getBooll(Constants.adAvailable) == true
                ? EdgeInsets.only(bottom: 150)
                : EdgeInsets.only(bottom: 90),
            child: ModalProgressHUD(
                inAsyncCall: showSpinner,
                opacity: 1.0,
                color: Colors.transparent.withOpacity(0.2),
                progressIndicator: CustomLoader(),
                child: FutureBuilder<List<TrendingData>>(
                  future: _getVideoFeatureBuilder,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return (snapshot.data?.length ?? 0) > 0
                            ? PageView.builder(
                                controller: trendingPageController,
                                itemCount: trendingVidList.length,
                                scrollDirection: Axis.vertical,
                                physics: AlwaysScrollableScrollPhysics(),
                                onPageChanged: (value) {
                                  setState(() {
                                    if (fullStatus == true || showMore == false) {
                                      halfStatus = true;
                                      fullStatus = false;
                                      showMore = true;
                                    }
                                  });
                                },
                                itemBuilder: (context, index) {
                                  if (adMobNative == true) {
                                    if (index != 0 && index % 5 == 0) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: AdMobNativeCustom(),
                                      );
                                    }
                                  }
                                  return Container(
                                    child: Stack(
                                      children: <Widget>[
                                        ///videoPlayer
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.transparent,
                                            child: VideoPlayerItem(
                                              videoId:
                                                  trendingVidList[index].id,
                                              videoUrl: trendingVidList[index]
                                                      .imagePath! +
                                                  trendingVidList[index].video!,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 4,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15.0, bottom: 20),
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          ///user profile pic and name

                                                          InkWell(

                                                            onTap: () {
                                                              if (PreferenceUtils
                                                                      .getlogin(
                                                                          Constants
                                                                              .isLoggedIn) ==
                                                                  true) {
                                                                if (trendingVidList[
                                                                            index]
                                                                        .isYou ==
                                                                    true) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              HomeScreen(4)));
                                                                } else {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              UserProfileScreen(
                                                                        userId: trendingVidList[index]
                                                                            .user!
                                                                            .id,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              } else {
                                                                Future.delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            0),
                                                                    () =>
                                                                        Navigator.of(context)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                              builder: (context) => LoginScreen()),
                                                                        ));
                                                              }
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              0,
                                                                          right:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                  width: ScreenUtil()
                                                                      .setWidth(
                                                                          36),
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          36),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    imageUrl: trendingVidList[index]
                                                                            .user!
                                                                            .imagePath! +
                                                                        trendingVidList[index]
                                                                            .user!
                                                                            .image!,
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            CircleAvatar(
                                                                      radius:
                                                                          15,

                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            15,
                                                                        backgroundImage:
                                                                            imageProvider,
                                                                      ),

                                                                    ),
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            CustomLoader(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image.asset(
                                                                            "images/no_image.png"),
                                                                  ),
                                                                ),
                                                                Container(
                                                                    margin: EdgeInsets.only(
                                                                        bottom:
                                                                            5),
                                                                    child: Text(
                                                                      trendingVidList[
                                                                              index]
                                                                          .user!
                                                                          .name!,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),

                                                          ///option threeDots
                                                          trendingVidList[index]
                                                                      .isYou ==
                                                                  false
                                                              ? Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              2,
                                                                          right:
                                                                              2,
                                                                          bottom:
                                                                              5),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/white_dot.svg",
                                                                    width: 5,
                                                                    height: 5,
                                                                  ),
                                                                )
                                                              : Container(),
                                                          trendingVidList[index]
                                                                      .isYou ==
                                                                  false
                                                              ? trendingVidList[
                                                                              index]
                                                                          .user!
                                                                          .isFollowing ==
                                                                      0

                                                                  /// follow portion
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (PreferenceUtils.getlogin(Constants.isLoggedIn) ==
                                                                            true) {
                                                                          callApiForFollowRequest(
                                                                              trendingVidList[index].user!.id,
                                                                              trendingVidList[index].id);
                                                                        } else {
                                                                          Constants.toastMessage(
                                                                              'Please Login First To Follow');
                                                                        }
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(
                                                                                left: 5,
                                                                                right: 2,
                                                                                bottom: 5),
                                                                            child:
                                                                                SvgPicture.asset(
                                                                              "images/follow.svg",
                                                                              width: 15,
                                                                              height: 15,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                              margin: EdgeInsets.only(bottom: 5),
                                                                              child: Text(
                                                                                'Follow',
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    )

                                                                  /// unfollow portion
                                                                  : InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (PreferenceUtils.getlogin(Constants.isLoggedIn) ==
                                                                            true) {
                                                                          callApiForUnFollowRequest(
                                                                              trendingVidList[index].user!.id,
                                                                              trendingVidList[index].id);
                                                                        } else {
                                                                          Constants.toastMessage(
                                                                              'Please Login First To unfollow');
                                                                        }
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(
                                                                                left: 5,
                                                                                right: 2,
                                                                                bottom: 5),
                                                                            child:
                                                                                SvgPicture.asset(
                                                                              "images/follow.svg",
                                                                              width: 15,
                                                                              height: 15,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                              margin: EdgeInsets.only(bottom: 5),
                                                                              child: Text(
                                                                                trendingVidList[index].user!.isRequested == 0 ? 'Unfollow' : 'Requested',
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    )
                                                              : Container(),
                                                        ],
                                                      ),

                                                      ///halfstatus
                                                      Visibility(
                                                        visible: halfStatus &&
                                                            trendingVidList[
                                                                        index]
                                                                    .description!
                                                                    .length >5,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 0,
                                                                  bottom: 5),
                                                          child: Text(
                                                            trendingVidList[
                                                                        index]
                                                                    .description ??
                                                                "",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .whitetext),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    Constants
                                                                        .appFont),
                                                          ),
                                                        ),
                                                      ),

                                                      ///fullstatus
                                                      Visibility(
                                                        visible: fullStatus &&
                                                            trendingVidList[
                                                                        index]
                                                                    .description!
                                                                    .length >
                                                                0,
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              halfStatus =
                                                                  !halfStatus;
                                                              fullStatus =
                                                                  !fullStatus;
                                                              showMore =
                                                                  !showMore;
                                                            });
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 0,
                                                                    bottom: 5),
                                                            child: Text(
                                                              trendingVidList[
                                                                          index]
                                                                      .description ??
                                                                  "",
                                                              maxLines: 20,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Constants
                                                                          .whitetext),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      Constants
                                                                          .appFont),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      ///showmore
                                                      Visibility(
                                                        visible: showMore &&
                                                            trendingVidList[
                                                                        index]
                                                                    .description!
                                                                    .length > 5,
                                                        child: Container(

                                                          alignment: Alignment
                                                              .topRight,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 20,
                                                                  bottom: 5),
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                halfStatus =
                                                                    !halfStatus;
                                                                fullStatus =
                                                                    !fullStatus;
                                                                showMore =
                                                                    !showMore;
                                                              });
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  "...more",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          Constants
                                                                              .whitetext),
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          Constants
                                                                              .appFont),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5,
                                                                          top:
                                                                              0),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/down_arrow.svg",
                                                                    width: 8,
                                                                    height: 8,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      ///audio
                                                      trendingVidList[index]
                                                                  .originalAudio !=
                                                              null
                                                          ? InkWell(
                                                              onTap: () {
                                                                String?
                                                                    passSongId =
                                                                    '';
                                                                bool
                                                                    isSongIdAvailable =
                                                                    true;
                                                                if (PreferenceUtils.getlogin(
                                                                        Constants
                                                                            .isLoggedIn) ==
                                                                    true) {
                                                                  if (trendingVidList[index]
                                                                              .songId !=
                                                                          '' &&
                                                                      trendingVidList[index]
                                                                              .songId !=
                                                                          null) {
                                                                    passSongId =
                                                                        trendingVidList[index]
                                                                            .songId;
                                                                    isSongIdAvailable =
                                                                        true;
                                                                  } else if (trendingVidList[index]
                                                                              .audioId !=
                                                                          '' &&
                                                                      trendingVidList[index]
                                                                              .audioId !=
                                                                          null) {
                                                                    passSongId =
                                                                        trendingVidList[index]
                                                                            .audioId;
                                                                    isSongIdAvailable =
                                                                        false;
                                                                  }
                                                                  if (trendingVidList[
                                                                              index]
                                                                          .originalAudio !=
                                                                      null) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              UsedSoundScreen(
                                                                                songId: passSongId,
                                                                                isSongIdAvailable: isSongIdAvailable,
                                                                              )),
                                                                    );
                                                                    print(
                                                                        "open sound");
                                                                  }
                                                                } else {
                                                                  Constants
                                                                      .toastMessage(
                                                                          'Please login to enter Music Gallery');
                                                                }
                                                              },
                                                              child: Row(
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              2),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "images/sound_waves.svg",
                                                                        width:
                                                                            15,
                                                                        height:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            20,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                2),
                                                                        child:
                                                                            Marquee(
                                                                          text: trendingVidList[index].originalAudio ??
                                                                              "UnKnown audio found ",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),

                                                                      ),
                                                                    ),
                                                                  ]),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CustomLikeComment(
                                                  index: index,
                                                  shareLink:
                                                      trendingVidList[index]
                                                              .imagePath! +
                                                          trendingVidList[index]
                                                              .video!,
                                                  commentCount:
                                                      trendingVidList[index]
                                                          .commentCount
                                                          .toString(),
                                                  isLike: trendingVidList[index]
                                                      .isLike,
                                                  listOfAll: trendingVidList,


                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: NoPostAvailable(subject: "Post",),
                              );
                      case ConnectionState.none:
                        return CustomLoader();
                      case ConnectionState.waiting:
                        return CustomLoader();
                      case ConnectionState.active:
                        return CustomLoader();
                      default:
                        return CustomLoader();
                    }
                  },
                )),
          ),
        ),
      ),
    );
  }

  void callApiForFollowRequest(int? userId, int? videoId) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).followRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          updateFollow(videoId: videoId);
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          updateFollow(videoId: videoId);
        });
      }
    }).catchError((Object obj) {
      print(obj.toString());
      Constants.toastMessage(obj.toString());
      if (mounted)
        setState(() {
          showSpinner = false;
        });
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responsecode = res.statusCode;
          if (responsecode == 401) {
            Constants.toastMessage('$responsecode');
            print(responsecode);
            print(res.statusMessage);
          } else if (responsecode == 422) {
            print("code:$responsecode");
            print("msg:$msg");
            Constants.toastMessage('$responsecode');
          } else if (responsecode == 500) {
            print("code:$responsecode");
            print("msg:$msg");
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  void callApiForUnFollowRequest(int? userId, int? videoId) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).unFollowRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          updateUnFollow(videoId: videoId);


        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          updateUnFollow(videoId: videoId);
        });
      }
    }).catchError((Object obj) {
      print(obj.toString());
      Constants.toastMessage(obj.toString());
      if (mounted)
        setState(() {
          showSpinner = false;
        });
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responsecode = res.statusCode;
          if (responsecode == 401) {
            Constants.toastMessage('$responsecode');
            print(responsecode);
            print(res.statusMessage);
          } else if (responsecode == 422) {
            print("code:$responsecode");
            print("msg:$msg");
            Constants.toastMessage('$responsecode');
          } else if (responsecode == 500) {
            print("code:$responsecode");
            print("msg:$msg");
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  Future<List<TrendingData>> callApiForTrendingVideo() async {
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData()).gettrendingvideo().then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
        });
        setState(() {
          print("lenght123456:${trendingVidList.length}");
          if (response.data!.length != 0) {
            trendingVidList.clear();
            trendingVidList.addAll(response.data!);
            print("trendingvidlist.length:${trendingVidList.length}");
            noData = false;
            showData = true;
          }
        });
      } else {
        setState(() {
          showSpinner = false;
          noData = true;
          showData = false;
        });
      }
    }).catchError((Object obj) {


      setState(() {
        showSpinner = false;
        noData = true;
        showData = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
      Constants.toastMessage("Internal Server Error");
    });
    return trendingVidList;
  }

  void updateFollow({int? videoId}) {
    final tile = this.trendingVidList.firstWhere((item) => item.id == videoId);
    setState(() {
      tile.user!.isFollowing = 1;
    });
  }

  void updateUnFollow({int? videoId}) {
    final tile = this.trendingVidList.firstWhere((item) => item.id == videoId);
    setState(() {
      tile.user!.isFollowing = 0;
    });
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String? videoUrl;
  final int? videoId;

  VideoPlayerItem({Key? key, this.videoUrl, this.videoId}) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoController;
  bool isShowPlaying = false;
  bool _visible = false;
  bool showLoading = true;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl!)
      ..initialize().then((value) => {
            setState(() {
              isShowPlaying = false;
              _videoController.play();
            })
          });
    _videoController.seekTo(Duration.zero);
    _videoController.setLooping(true);
    _videoController.play();
    callApiForViewVideo();
    _videoController.addListener(() {
      setState(() {
        _videoController.value.isBuffering
            ? showLoading = true
            : showLoading = false;
      });
    });
  }

  @override
  void didUpdateWidget(covariant VideoPlayerItem oldWidget) {
    _videoController.pause();
    super.didUpdateWidget(oldWidget);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _videoController.pause();
    }



  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  _hideBar() async {
    Timer(
      Duration(seconds: 2),
      () {
        setState(() {
          _visible = false;
        });
      },
    );
  }

  void callApiForViewVideo() {
    RestClient(ApiHeader().dioData())
        .viewVideo(widget.videoId)
        .then((response) {
      print(response);
    }).catchError((Object obj) {
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _visible = true;
          _hideBar();
          _videoController.value.isPlaying
              ? _videoController.pause()
              : _videoController.play();
        });
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.black12),
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fill,
                alignment: Alignment.center,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: showLoading
                      ? Center(child: CustomLoader())
                      : VideoPlayer(_videoController),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Center(
              child: Visibility(
                  visible: _visible,
                  child: _videoController.value.isPlaying
                      ? MuteIconWidget(isMute: true)
                      : MuteIconWidget(isMute: false)),
            ),
          )
        ],
      ),
    );
  }
}
