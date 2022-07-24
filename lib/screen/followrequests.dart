import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:acoustic/screen/profilerequest.dart';

class FollowRequestScreen extends StatefulWidget {
  @override
  _FollowRequestScreen createState() => _FollowRequestScreen();
}

class _FollowRequestScreen extends State<FollowRequestScreen> {
  bool isRememberMe = false;
  bool showSpinner = false;
  bool showred = false;
  bool showwhite = true;

  String devicetoken = "";
  int requestcount = 3;

  bool showmore = true;
  bool showless = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop as Future<bool> Function()?,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(Constants.bgblack),
          appBar: AppBar(
            title: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("Follow Requests")),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
          ),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator:
            CustomLoader(),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                            child: ListView.builder(
                              itemCount: requestcount,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(
                                        bottom: 0, left: 15, right: 15, top: 5),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileRequestScreen()));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: CachedNetworkImage(
                                              alignment: Alignment.center,
                                              imageUrl:
                                                  "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50",
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width:
                                                    ScreenUtil().setWidth(45),
                                                height:
                                                    ScreenUtil().setHeight(45),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF36446b),
                                                  borderRadius: new BorderRadius
                                                          .all(
                                                      new Radius.circular(25)),
                                                  border: new Border.all(
                                                    color: Color(Constants
                                                        .lightbluecolor),
                                                    width: 3.0,
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      Color(0xFF36446b),
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage:
                                                        imageProvider,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) => CustomLoader(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      "images/no_image.png"),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              color: Colors.transparent,
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 5),
                                              child: ListView(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "Joe_Wills want to follow you",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Color(Constants
                                                              .whitetext),
                                                          fontSize: 14,
                                                          fontFamily: Constants
                                                              .appFont),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      "29 Nov, 2020",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Color(Constants
                                                              .greytext),
                                                          fontSize: 14,
                                                          fontFamily: Constants
                                                              .appFont),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 15, left: 5),
                                              alignment: Alignment.topCenter,
                                              color: Colors.transparent,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: ScreenUtil()
                                                        .setHeight(30),
                                                    width: ScreenUtil()
                                                        .setWidth(55),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8)),
                                                      color: Color(Constants
                                                          .lightbluecolor),
                                                    ),
                                                    child: Text(
                                                      "Confirm",
                                                      style: TextStyle(
                                                          color: Color(Constants
                                                              .whitetext),
                                                          fontFamily:
                                                              Constants.appFont,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10, right: 5),
                                                    alignment: Alignment.center,
                                                    height: ScreenUtil()
                                                        .setHeight(30),
                                                    width: ScreenUtil()
                                                        .setWidth(55),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8)),
                                                      color: Color(
                                                          Constants.greytext),
                                                    ),
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Color(Constants
                                                              .whitetext),
                                                          fontFamily:
                                                              Constants.appFont,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ),
                          Visibility(
                            visible: showmore,
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    requestcount = 15;
                                    showmore = !showmore;
                                    showless = !showless;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: ScreenUtil().setHeight(55),
                                  color: Color(Constants.conbg),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "See All",
                                        style: TextStyle(
                                            color:
                                                Color(Constants.lightbluecolor),
                                            fontSize: 16,
                                            fontFamily: Constants.appFontBold),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: SvgPicture.asset(
                                          "images/request_down_arrow.svg",
                                          width: ScreenUtil().setHeight(10),
                                          height: ScreenUtil().setWidth(10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: showless,
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    requestcount = 3;
                                    showless = !showless;
                                    showmore = !showmore;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: ScreenUtil().setHeight(55),
                                  color: Color(Constants.conbg),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "See less",
                                        style: TextStyle(
                                            color:
                                                Color(Constants.lightbluecolor),
                                            fontSize: 16,
                                            fontFamily: Constants.appFontBold),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Image.asset(
                                          "images/request_up_arrow.png",
                                          width: ScreenUtil().setHeight(25),
                                          height: ScreenUtil().setWidth(25),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(0)),
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  bottom: 0, left: 28, right: 15, top: 15),
                              child: Text(
                                "Suggesions",
                                style: TextStyle(
                                    color: Color(Constants.whitetext),
                                    fontFamily: Constants.appFont,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                            child: ListView.builder(
                              itemCount: requestcount,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      bottom: 0, left: 15, right: 15, top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        width: ScreenUtil().setWidth(45),
                                        height: ScreenUtil().setHeight(45),
                                        child: CachedNetworkImage(
                                          alignment: Alignment.center,
                                          imageUrl:
                                              "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF36446b),
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      new Radius.circular(25)),
                                              border: new Border.all(
                                                color: Color(
                                                    Constants.lightbluecolor),
                                                width: 3.0,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                                  Color(0xFF36446b),
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundImage: imageProvider,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => CustomLoader(),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  "images/no_image.png"),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          color: Colors.transparent,
                                          margin:
                                              EdgeInsets.only(left: 10, top: 5),
                                          child: ListView(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Jessica_Martin",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(
                                                          Constants.whitetext),
                                                      fontSize: 14,
                                                      fontFamily:
                                                          Constants.appFont),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                margin: EdgeInsets.only(top: 5),
                                                child: Text(
                                                  "Jessi",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(
                                                          Constants.greytext),
                                                      fontSize: 14,
                                                      fontFamily:
                                                          Constants.appFont),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: EdgeInsets.only(bottom: 15),
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 0, right: 10),
                                                alignment: Alignment.center,
                                                height:
                                                    ScreenUtil().setHeight(35),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                  color:
                                                      Color(Constants.buttonbg),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, right: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        child: SvgPicture.asset(
                                                            "images/follow.svg"),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 2),
                                                        child: Text(
                                                          "Follow",
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
                                                    ],
                                                  ),
                                                ))),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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

  Future<bool>? _onWillPop() {
    Navigator.pop(context);
    return null;
  }
}
