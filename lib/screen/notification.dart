import 'dart:convert';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/custom/no_post_available.dart';
import 'package:acoustic/model/notification_model.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:acoustic/screen/followrequests.dart';
import 'package:dio/dio.dart';
import 'userprofile.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  bool isRememberMe = false;
  bool showSpinner = false;
  bool showRed = false;
  bool showWhite = true;
  String deviceToken = "";
  bool showFollowing = false;
  bool showFollow = true;
  bool isNotificationClicked = false;
  int? followRequestCount = 0;
  List<Current> currentList = <Current>[];
  List<LastSeven> lastSevenList = <LastSeven>[];

  // late Future<List<TrendingData>> _getVideoFeatureBuilder;
  late Future<int> _notificationFuture;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    if (PreferenceUtils.getlogin(Constants.isLoggedIn) == true) {
      _notificationFuture = callApiForNotification();

    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleClick(String value) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FollowRequestScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(Constants.bgblack),
          appBar: AppBar(
            title: Container(
                margin: EdgeInsets.only(left: 10), child: Text("Notification")),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: false,

          ),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: CustomLoader(),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: [
                    FutureBuilder<int>(
                      future: _notificationFuture,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            return RefreshIndicator(
                              color: Color(Constants.lightbluecolor),
                              backgroundColor: Colors.white,
                              onRefresh: callApiForNotification,
                              child: ListView(
                                children:  [
                                        0 < snapshot.data!.toInt()
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(0)),
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(
                                                  bottom: 0,
                                                  left: 28,
                                                  right: 15,
                                                  top: 15),
                                              child: Text(
                                                "N E W",
                                                style: TextStyle(
                                                    color: Color(
                                                        Constants.whitetext),
                                                    fontFamily: Constants.appFont,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(8)),
                                            child: 0 < currentList.length
                                                ? ListView.separated(
                                                    itemCount: currentList.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UserProfileScreen(
                                                                userId:
                                                                    currentList[
                                                                            index]
                                                                        .user!
                                                                        .id,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          margin: EdgeInsets.only(
                                                              bottom: 0,
                                                              left: 15,
                                                              right: 15,
                                                              top: 5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              ///userimage
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  imageUrl: currentList[
                                                                              index]
                                                                          .user!
                                                                          .imagePath! +
                                                                      currentList[
                                                                              index]
                                                                          .user!
                                                                          .image!,
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(




                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: const Color(
                                                                          0xFF36446b),
                                                                      borderRadius: new BorderRadius
                                                                          .all(new Radius
                                                                              .circular(
                                                                          25)),
                                                                      border:
                                                                          new Border
                                                                              .all(
                                                                        color: Color(
                                                                            Constants
                                                                                .lightbluecolor),
                                                                        width:
                                                                            3.0,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius: 20,
                                                                      backgroundColor:
                                                                          Color(
                                                                              0xFF36446b),
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundImage:
                                                                            imageProvider,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      CustomLoader(),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Image.asset(
                                                                          "images/no_image.png"),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: currentList[index]
                                                                                .reason ==
                                                                            "Request" ||
                                                                        currentList[index]
                                                                                .reason ==
                                                                            "Follow"
                                                                    ? 4
                                                                    : 5,
                                                                child: Container(
                                                                  color: Colors
                                                                      .transparent,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          top: 5),
                                                                  child: ListView(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    children: [
                                                                      Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .topLeft,
                                                                        child:
                                                                            Text(
                                                                          currentList[index]
                                                                              .msg!,
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              color: Color(Constants
                                                                                  .whitetext),
                                                                              fontSize:
                                                                                  14,
                                                                              fontFamily:
                                                                                  Constants.appFont),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .topLeft,
                                                                        margin: EdgeInsets
                                                                            .only(
                                                                                top: 5),
                                                                        child:
                                                                            Text(
                                                                          currentList[index]
                                                                              .time!,
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              color: Color(Constants
                                                                                  .greytext),
                                                                              fontSize:
                                                                                  14,
                                                                              fontFamily:
                                                                                  Constants.appFont),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              currentList[index].reason == "Request" ||
                                                                      currentList[index].reason == "Follow"
                                                                  ? currentList[index].reason == "Request"
                                                                      ? Expanded(
                                                                          flex: 3,
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.topCenter,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    Constants.checkNetwork().whenComplete(() => callApiForAcceptRequest(currentList[index].user!.id));
                                                                                  },
                                                                                  child: Container(
                                                                                    alignment: Alignment.center,
                                                                                    height: ScreenUtil().setHeight(30),
                                                                                    width: ScreenUtil().setWidth(50),
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                                      color: Color(Constants.lightbluecolor),
                                                                                    ),
                                                                                    child: Text(
                                                                                      "Confirm",
                                                                                      style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 12),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    Constants.checkNetwork().whenComplete(() => callApiForDeleteRequest(currentList[index].user!.id));
                                                                                  },
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(left: 10, right: 5),
                                                                                    alignment: Alignment.center,
                                                                                    height: ScreenUtil().setHeight(30),
                                                                                    width: ScreenUtil().setWidth(50),
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                                      color: Color(Constants.greytext),
                                                                                    ),
                                                                                    child: Text(
                                                                                      "Delete",
                                                                                      style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 12),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container()
                                                                  : Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Stack(
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        children: [
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            margin: EdgeInsets.only(
                                                                                left: 20,
                                                                                right: 5),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              alignment:
                                                                                  Alignment.center,
                                                                              imageUrl:
                                                                                  currentList[index].video!.imagePath! + currentList[index].video!.screenshot!,
                                                                              imageBuilder: (context, imageProvider) =>
                                                                                  Container(
                                                                                width: ScreenUtil().setWidth(50),
                                                                                height: ScreenUtil().setHeight(50),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                  color: Color(Constants.lightbluecolor),
                                                                                  border: new Border.all(color: Color(Constants.lightbluecolor), width: 3.0),
                                                                                  image: DecorationImage(
                                                                                    image: imageProvider,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              placeholder: (context, url) =>
                                                                                  CustomLoader(),
                                                                              errorWidget: (context, url, error) =>
                                                                                  Image.asset("images/no_image.png"),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            margin:
                                                                                EdgeInsets.only(left: 12),
                                                                            child:
                                                                                SvgPicture.asset(
                                                                              "images/small_play_button.svg",
                                                                              width:
                                                                                  18,
                                                                              height:
                                                                                  18,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : NoPostAvailable(subject: "Notification",),
                                          ),
                                          ///lastweek
                                          Padding(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(0)),
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(
                                                  bottom: 0,
                                                  left: 28,
                                                  right: 15,
                                                  top: 15),
                                              child: Text(
                                                "L A S T   W E E K",
                                                style: TextStyle(
                                                    color: Color(
                                                        Constants.whitetext),
                                                    fontFamily: Constants.appFont,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(8)),
                                            child: 0 < lastSevenList.length
                                                ? ListView.separated(
                                                    itemCount:
                                                        lastSevenList.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UserProfileScreen(
                                                                userId:
                                                                    lastSevenList[
                                                                            index]
                                                                        .user!
                                                                        .id,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                            alignment:
                                                                Alignment.topLeft,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 0,
                                                                    left: 15,
                                                                    right: 15,
                                                                    top: 5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Container(






                                                                  child:
                                                                      CachedNetworkImage(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    imageUrl: lastSevenList[
                                                                                index]
                                                                            .user!
                                                                            .imagePath! +
                                                                        lastSevenList[
                                                                                index]
                                                                            .user!
                                                                            .image!,
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFF36446b),
                                                                        borderRadius: new BorderRadius
                                                                            .all(new Radius
                                                                                .circular(
                                                                            25)),
                                                                        border:
                                                                            new Border
                                                                                .all(
                                                                          color: Color(
                                                                              Constants.lightbluecolor),
                                                                          width:
                                                                              3.0,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundColor:
                                                                            Color(
                                                                                0xFF36446b),
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              20,
                                                                          backgroundImage:
                                                                              imageProvider,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        CustomLoader(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image.asset(
                                                                            "images/no_image.png"),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                        .transparent,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10,
                                                                            top:
                                                                                5),
                                                                    child:
                                                                        ListView(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      children: [
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          child:
                                                                              Text(
                                                                            lastSevenList[index]
                                                                                .msg!,
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Color(Constants.whitetext),
                                                                                fontSize: 14,
                                                                                fontFamily: Constants.appFont),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          margin: EdgeInsets.only(
                                                                              top:
                                                                                  5),
                                                                          child:
                                                                              Text(
                                                                            () {
                                                                              final DateTime
                                                                                  now =
                                                                                  DateTime.parse(lastSevenList[index].createdAt!);
                                                                              final DateFormat
                                                                                  formatter =
                                                                                  DateFormat('dd-MMMM-yyyy');
                                                                              final String
                                                                                  formatted =
                                                                                  formatter.format(now);
                                                                              return formatted;
                                                                            }(),
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Color(Constants.greytext),
                                                                                fontSize: 14,
                                                                                fontFamily: Constants.appFont),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                lastSevenList[index]
                                                                                .reason ==
                                                                            "Request" ||
                                                                        lastSevenList[index]
                                                                                .reason ==
                                                                            "Follow"
                                                                    ? lastSevenList[index]
                                                                                .reason ==
                                                                            "Request"
                                                                        ? Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Container(
                                                                              alignment:
                                                                                  Alignment.topCenter,
                                                                              child:
                                                                                  Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      Constants.checkNetwork().whenComplete(() => callApiForAcceptRequest(lastSevenList[index].user!.id));
                                                                                    },
                                                                                    child: Container(
                                                                                      alignment: Alignment.center,
                                                                                      height: ScreenUtil().setHeight(30),
                                                                                      width: ScreenUtil().setWidth(55),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                                        color: Color(Constants.lightbluecolor),
                                                                                      ),
                                                                                      child: Text(
                                                                                        "Confirm",
                                                                                        style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 14),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      Constants.checkNetwork().whenComplete(() => callApiForDeleteRequest(lastSevenList[index].user!.id));
                                                                                    },
                                                                                    child: Container(
                                                                                      margin: EdgeInsets.only(left: 10, right: 5),
                                                                                      alignment: Alignment.center,
                                                                                      height: ScreenUtil().setHeight(30),
                                                                                      width: ScreenUtil().setWidth(55),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                                        color: Color(Constants.greytext),
                                                                                      ),
                                                                                      child: Text(
                                                                                        "Delete",
                                                                                        style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 14),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Container()
                                                                    : Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Stack(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          children: [
                                                                            Container(
                                                                              alignment:
                                                                                  Alignment.center,
                                                                              margin:
                                                                                  EdgeInsets.only(left: 20, right: 5),
                                                                              child:
                                                                                  CachedNetworkImage(
                                                                                alignment: Alignment.center,
                                                                                imageUrl: lastSevenList[index].video!.imagePath! + lastSevenList[index].video!.screenshot!,
                                                                                imageBuilder: (context, imageProvider) => Container(
                                                                                  width: ScreenUtil().setWidth(50),
                                                                                  height: ScreenUtil().setHeight(50),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                    color: Color(Constants.lightbluecolor),
                                                                                    border: new Border.all(color: Color(Constants.lightbluecolor), width: 3.0),
                                                                                    image: DecorationImage(
                                                                                      image: imageProvider,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                placeholder: (context, url) => CustomLoader(),
                                                                                errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              alignment:
                                                                                  Alignment.center,
                                                                              margin:
                                                                                  EdgeInsets.only(left: 12),
                                                                              child:
                                                                                  SvgPicture.asset(
                                                                                "images/small_play_button.svg",
                                                                                width: 18,
                                                                                height: 18,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                              ],
                                                            )),
                                                      );
                                                    },
                                                  )
                                                : NoPostAvailable(subject: "Notification",),
                                          ),
                                        ],
                                    )
                                    : Container(
                                          height: ScreenUtil().screenHeight,
                                          width: ScreenUtil().screenWidth,
                                      child: Align(
                                            alignment: Alignment.center,
                                            child: NoPostAvailable(subject: "Notification",),
                                          ),
                                    ),
                                      ],
                              ),
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

  Future<int> callApiForNotification() async {
    int tempPassData = 0;
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData())
        .notificationRequest()
        .then((response) {
      currentList.clear();
      lastSevenList.clear();
      if (response.success == true) {
        setState(() {
          showSpinner = false;
          followRequestCount = response.data!.requesteCount;
          currentList.addAll(response.data!.current!);
          lastSevenList.addAll(response.data!.lastSeven!);
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
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            print(responseCode);
            print(res.statusMessage);
          } else if (responseCode == 422) {
            print("code:$responseCode");
            print("msg:$msg");
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            print("code:$responseCode");
            print("msg:$msg");
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
    if (currentList.isNotEmpty) {
      tempPassData = currentList.length;
    }
    if (lastSevenList.isNotEmpty) {
      tempPassData += lastSevenList.length;
    }


    return tempPassData;
  }

  void callApiForConfirmRequest(int? userId) {
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
          Constants.checkNetwork().whenComplete(() => callApiForNotification());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callApiForNotification());
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
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            print(responseCode);
            print(res.statusMessage);
          } else if (responseCode == 422) {
            print("code:$responseCode");
            print("msg:$msg");
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            print("code:$responseCode");
            print("msg:$msg");
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  void callApiForDeleteRequest(int? userId) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).rejectRequest(userId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callApiForNotification());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callApiForNotification());
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

  void callApiForAcceptRequest(int? userId) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).acceptRequest(userId).then((response) {
      final body = json.decode(response);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          showSpinner = false;
          Constants.toastMessage(body['msg'].toString());
          Constants.checkNetwork().whenComplete(() => callApiForNotification());
        });
      } else {
        setState(() {
          showSpinner = false;
          Constants.toastMessage(body['msg'].toString());
          Constants.checkNetwork().whenComplete(() => callApiForNotification());
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

  Future<bool> _onWillPop() async {
    return true;
  }
}