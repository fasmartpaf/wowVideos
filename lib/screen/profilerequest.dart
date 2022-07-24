import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:acoustic/util/inndicator.dart';

class ProfileRequestScreen extends StatefulWidget {
  @override
  _ProfileRequestScreen createState() => _ProfileRequestScreen();
}

class _ProfileRequestScreen extends State<ProfileRequestScreen>
    with SingleTickerProviderStateMixin {
  bool isRememberMe = false;

  bool showSpinner = false;
  bool showred = false;
  bool showwhite = true;

  String devicetoken = "";

  TabController? _controller;

  bool showconfirm = true;
  bool showfollowback = false;
  bool showfollowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(Constants.bgblack),
          appBar: AppBar(
            title: Text(
              "Maxwell_Kingston",
            ),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(120),
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10, left: 10),
                                  child: CachedNetworkImage(
                                    alignment: Alignment.center,
                                    imageUrl:
                                        "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50",
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Color(0xFF36446b),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: imageProvider,
                                      ),
                                    ),
                                    placeholder: (context, url) => CustomLoader(),
                                    errorWidget: (context, url, error) =>
                                        Image.asset("images/no_image.png"),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      right: 20, top: 10, left: 20),
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "I'Creator 📸",
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 18,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 0, top: 15, left: 0),
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        "93K",
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .whitetext),
                                                            fontFamily: Constants
                                                                .appFontBold,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        "Followers",
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greytext),
                                                            fontFamily:
                                                                Constants
                                                                    .appFont,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: <Widget>[
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "100K",
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .whitetext),
                                                            fontFamily: Constants
                                                                .appFontBold,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Following",
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greytext),
                                                            fontFamily:
                                                                Constants
                                                                    .appFont,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        "108",
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .whitetext),
                                                            fontFamily: Constants
                                                                .appFontBold,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        "Posts",
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greytext),
                                                            fontFamily:
                                                                Constants
                                                                    .appFont,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: showconfirm,
                          child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            color: Colors.transparent,
                            height: ScreenUtil().setHeight(40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showconfirm = false;
                                        showfollowback = true;
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        color: Color(Constants.lightbluecolor),
                                      ),
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                            color: Color(Constants.whitetext),
                                            fontFamily: Constants.appFont,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 15, right: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: Color(Constants.greytext),
                                    ),
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                          color: Color(Constants.whitetext),
                                          fontFamily: Constants.appFont,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showfollowback,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                showfollowback = false;
                                showconfirm = false;
                                showfollowing = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Color(Constants.lightbluecolor),
                              ),
                              height: ScreenUtil().setHeight(40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      "images/follow.svg",
                                      width: ScreenUtil().setWidth(15),
                                      height: ScreenUtil().setHeight(15),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Follow Back",
                                      style: TextStyle(
                                          color: Color(Constants.whitetext),
                                          fontFamily: Constants.appFont,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showfollowing,
                          child: Container(
                              margin: EdgeInsets.only(right: 20, left: 20),
                              alignment: Alignment.center,
                              height: ScreenUtil().setHeight(40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Color(Constants.conbg),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text(
                                      "Following",
                                      style: TextStyle(
                                          color:
                                              Color(Constants.lightbluecolor),
                                          fontSize: 16,
                                          fontFamily: Constants.appFontBold),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5, top: 2),
                                    child: SvgPicture.asset(
                                        "images/blue_down.svg"),
                                  ),
                                ],
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: ScreenUtil().setHeight(50),
                          color: Colors.transparent,
                          child: Container(
                            height: ScreenUtil().setHeight(35),
                            color: Colors.transparent,
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(1),
                              child: TabBar(
                                controller: _controller,
                                tabs: [
                                  new Tab(
                                    text: 'Posts',
                                  ),
                                  new Tab(
                                    text: 'Saved',
                                  ),
                                  new Tab(
                                    text: 'Liked',
                                  ),
                                ],
                                labelColor: Color(Constants.lightbluecolor),
                                unselectedLabelColor: Colors.white,
                                labelStyle: TextStyle(
                                    fontSize: 13,
                                    fontFamily: Constants.appFontBold),
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorPadding: EdgeInsets.all(0.0),
                                indicatorColor: Color(Constants.lightbluecolor),
                                indicatorWeight: 5.0,
                                indicator: MD2Indicator(
                                  indicatorSize: MD2IndicatorSize.full,
                                  indicatorHeight: 8.0,
                                  indicatorColor:
                                      Color(Constants.lightbluecolor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 10, right: 5, bottom: 0, left: 5),
                            child: TabBarView(
                                controller: _controller,
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(8)),
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: 5,
                                            left: 10,
                                            right: 10,
                                            top: 0),
                                        child: showfollowing == true
                                            ? StaggeredGridView.countBuilder(
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                crossAxisCount: 3,
                                                itemCount: 15,
                                                itemBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        new Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            child:
                                                                new Container(
                                                              child: Stack(
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    imageUrl:
                                                                        "https://via.placeholder.com/600/555/000.png",
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20.0),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder: (context, url) => CustomLoader(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image.asset(
                                                                            "images/no_image.png"),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "images/play_button.svg",
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            5),
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.bottomLeft,
                                                                            child:
                                                                                Text(
                                                                              "1.1k Views",
                                                                              style: TextStyle(color: Color(Constants.whitetext), fontSize: 14, fontFamily: Constants.appFont),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.bottomRight,
                                                                              child: ListView(
                                                                                shrinkWrap: true,
                                                                                physics: NeverScrollableScrollPhysics(),
                                                                                children: [
                                                                                  Visibility(
                                                                                    visible: showwhite,
                                                                                    child: Container(
                                                                                      child: InkWell(
                                                                                          onTap: () {
                                                                                            setState(() {
                                                                                              showred = !showred;
                                                                                              showwhite = !showwhite;
                                                                                            });
                                                                                          },
                                                                                          child: SvgPicture.asset(
                                                                                            "images/white_heart.svg",
                                                                                            width: 15,
                                                                                            height: 15,
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                  Visibility(
                                                                                    visible: showred,
                                                                                    child: Container(
                                                                                      child: InkWell(
                                                                                          onTap: () {
                                                                                            setState(() {
                                                                                              showred = !showred;
                                                                                              showwhite = !showwhite;
                                                                                            });
                                                                                          },
                                                                                          child: SvgPicture.asset(
                                                                                            "images/red_heart.svg",
                                                                                            width: 15,
                                                                                            height: 15,
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                staggeredTileBuilder:
                                                    (int index) =>
                                                        new StaggeredTile.count(
                                                            1,
                                                            index.isEven
                                                                ? 1.5
                                                                : 1.5),
                                                mainAxisSpacing: 1.0,
                                                crossAxisSpacing: 1.0,
                                              )
                                            : Container(
                                                alignment: Alignment.center,
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            child: SvgPicture.asset(
                                                                "images/lock.svg"),
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                "This account is private",
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        Constants
                                                                            .greytext),
                                                                    fontFamily:
                                                                        Constants
                                                                            .appFont,
                                                                    fontSize:
                                                                        18),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 25,
                                                                  right: 15,
                                                                  top: 20),
                                                          child: Text(
                                                            "You can't see a post from this user until you follow them",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greytext),
                                                                fontFamily:
                                                                    Constants
                                                                        .appFont,
                                                                fontSize: 18),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(8)),
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: 5,
                                            left: 10,
                                            right: 10,
                                            top: 0),
                                        child: showfollowing == true
                                            ? StaggeredGridView.countBuilder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                crossAxisCount: 3,
                                                itemCount: 15,
                                                itemBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        new Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            child:
                                                                new Container(
                                                              child: Stack(
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    imageUrl:
                                                                        "https://via.placeholder.com/600/555/000.png",
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20.0),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder: (context,
                                                                            url) => CustomLoader(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image.asset(
                                                                            "images/no_image.png"),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "images/play_button.svg",
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            5),
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.bottomLeft,
                                                                            child:
                                                                                Text(
                                                                              "1.1k Views",
                                                                              style: TextStyle(color: Color(Constants.whitetext), fontSize: 14, fontFamily: Constants.appFont),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.bottomRight,
                                                                              child: ListView(
                                                                                shrinkWrap: true,
                                                                                physics: NeverScrollableScrollPhysics(),
                                                                                children: [
                                                                                  Visibility(
                                                                                    visible: showwhite,
                                                                                    child: Container(
                                                                                      child: InkWell(
                                                                                          onTap: () {
                                                                                            setState(() {
                                                                                              showred = !showred;
                                                                                              showwhite = !showwhite;
                                                                                            });
                                                                                          },
                                                                                          child: SvgPicture.asset(
                                                                                            "images/white_heart.svg",
                                                                                            width: 15,
                                                                                            height: 15,
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                  Visibility(
                                                                                    visible: showred,
                                                                                    child: Container(
                                                                                      child: InkWell(
                                                                                          onTap: () {
                                                                                            setState(() {
                                                                                              showred = !showred;
                                                                                              showwhite = !showwhite;
                                                                                            });
                                                                                          },
                                                                                          child: SvgPicture.asset(
                                                                                            "images/red_heart.svg",
                                                                                            width: 15,
                                                                                            height: 15,
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                staggeredTileBuilder:
                                                    (int index) =>
                                                        new StaggeredTile.count(
                                                            1,
                                                            index.isEven
                                                                ? 1.5
                                                                : 1.5),
                                                mainAxisSpacing: 1.0,
                                                crossAxisSpacing: 1.0,
                                              )
                                            : Container(
                                                alignment: Alignment.center,
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            child: SvgPicture.asset(
                                                                "images/lock.svg"),
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                "This account is private",
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        Constants
                                                                            .greytext),
                                                                    fontFamily:
                                                                        Constants
                                                                            .appFont,
                                                                    fontSize:
                                                                        18),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 25,
                                                                  right: 15,
                                                                  top: 20),
                                                          child: Text(
                                                            "You can't see a post from this user until you follow them",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greytext),
                                                                fontFamily:
                                                                    Constants
                                                                        .appFont,
                                                                fontSize: 18),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(8)),
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: 5,
                                            left: 10,
                                            right: 10,
                                            top: 0),
                                        child: showfollowing == true
                                            ? StaggeredGridView.countBuilder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                crossAxisCount: 3,
                                                itemCount: 15,
                                                itemBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        new Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            child:
                                                                new Container(
                                                              child: Stack(
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    imageUrl:
                                                                        "https://via.placeholder.com/600/555/000.png",
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20.0),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder: (context,
                                                                            url) => CustomLoader(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image.asset(
                                                                            "images/no_image.png"),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "images/play_button.svg",
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            5),
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.bottomLeft,
                                                                            child:
                                                                                Text(
                                                                              "1.1k Views",
                                                                              style: TextStyle(color: Color(Constants.whitetext), fontSize: 14, fontFamily: Constants.appFont),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.bottomRight,
                                                                              child: ListView(
                                                                                shrinkWrap: true,
                                                                                physics: NeverScrollableScrollPhysics(),
                                                                                children: [
                                                                                  Visibility(
                                                                                    visible: showwhite,
                                                                                    child: Container(
                                                                                      child: InkWell(
                                                                                          onTap: () {
                                                                                            setState(() {
                                                                                              showred = !showred;
                                                                                              showwhite = !showwhite;
                                                                                            });
                                                                                          },
                                                                                          child: SvgPicture.asset(
                                                                                            "images/white_heart.svg",
                                                                                            width: 15,
                                                                                            height: 15,
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                  Visibility(
                                                                                    visible: showred,
                                                                                    child: Container(
                                                                                      child: InkWell(
                                                                                          onTap: () {
                                                                                            setState(() {
                                                                                              showred = !showred;
                                                                                              showwhite = !showwhite;
                                                                                            });
                                                                                          },
                                                                                          child: SvgPicture.asset(
                                                                                            "images/red_heart.svg",
                                                                                            width: 15,
                                                                                            height: 15,
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                staggeredTileBuilder:
                                                    (int index) =>
                                                        new StaggeredTile.count(
                                                            1,
                                                            index.isEven
                                                                ? 1.5
                                                                : 1.5),
                                                mainAxisSpacing: 1.0,
                                                crossAxisSpacing: 1.0,
                                              )
                                            : Container(
                                                alignment: Alignment.center,
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            child: SvgPicture.asset(
                                                                "images/lock.svg"),
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                "This account is private",
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        Constants
                                                                            .greytext),
                                                                    fontFamily:
                                                                        Constants
                                                                            .appFont,
                                                                    fontSize:
                                                                        18),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 25,
                                                                  right: 15,
                                                                  top: 20),
                                                          child: Text(
                                                            "You can't see a post from this user until you follow them",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greytext),
                                                                fontFamily:
                                                                    Constants
                                                                        .appFont,
                                                                fontSize: 18),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                  ),
                                ]),
                          ),
                        ),
                      ],
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

  Future<bool> _onWillPop() async {
    return true;
  }
}
