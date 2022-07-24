import 'dart:convert';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/custom/no_post_available.dart';
import 'package:dio/dio.dart';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/model/myprofilemodel.dart';
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
import 'package:acoustic/screen/ownpost.dart';
import 'package:acoustic/screen/setting.dart';
import 'package:acoustic/screen/editprofile.dart';
import 'package:acoustic/screen/uploadvideo.dart';
import 'package:acoustic/screen/followerslist.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:share/share.dart';
import 'package:acoustic/screen/edit_post_page.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreen createState() => _MyProfileScreen();
}

class _MyProfileScreen extends State<MyProfileScreen>
    with SingleTickerProviderStateMixin {
  bool isRememberMe = false;
  bool showSpinner = false;
  String deviceToken = "";
  TabController? _controller;
  String? name = "name";
  String? username = "username";
  String? bio = "bio";
  String? phone = "phone";
  String? email = "email";
  String? bDate = "bdate";
  String image = "bdate";
  String followers = "0";
  String following = "0";
  String totalPost = "0";
  int? userId = 0;

  List<Posts> postList = <Posts>[];
  List<Saved> savedList = <Saved>[];
  List<Liked> likedList = <Liked>[];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<MyProfileData> profileDataList = <MyProfileData>[];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<int>? _profileFuture;

  @override
  void initState() {
    super.initState();
    if (PreferenceUtils.getlogin(Constants.isLoggedIn) == true) {
      _profileFuture = callApiForGetProfile();
    }
    WidgetsFlutterBinding.ensureInitialized();
    _controller = TabController(length: 3, vsync: this);
    PreferenceUtils.init();
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
          key: _scaffoldKey,
          backgroundColor: Color(Constants.bgblack),
          appBar: AppBar(
            title: Text(username!),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UploadVideoScreen()));
                      },
                      child: SvgPicture.asset("images/pluse.svg")),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditProfileScreen()));
                    },
                    child: SvgPicture.asset("images/edit_profile.svg")),
              ),
              Container(
                margin: EdgeInsets.only(left: 0, right: 10),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                                userId: userId,
                              )));
                    },
                    child: SvgPicture.asset("images/settings.svg")),
              ),
            ],
          ),
          body: RefreshIndicator(
            color: Color(Constants.lightbluecolor),
            backgroundColor: Colors.transparent,
            onRefresh: callApiForGetProfile,
            key: _refreshIndicatorKey,
            child: ModalProgressHUD(
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
                                    margin:
                                        EdgeInsets.only(bottom: 10, left: 10),
                                    child: CachedNetworkImage(
                                      alignment: Alignment.center,
                                      imageUrl: image,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Color(0xFF36446b),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: imageProvider,
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          CustomLoader(),
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
                                          margin: EdgeInsets.only(right: 30),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            name!,
                                            maxLines: 5,
                                            style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 16,
                                              fontFamily: Constants.appFont,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: 0, top: 20, left: 0),
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FollowersListScreen(
                                                            index: 0,
                                                            followers:
                                                                followers,
                                                            following:
                                                                following,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            followers,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .whitetext),
                                                                fontFamily:
                                                                    Constants
                                                                        .appFontBold,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            "Followers",
                                                            textAlign: TextAlign
                                                                .center,
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
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FollowersListScreen(
                                                                    index: 1,
                                                                    followers:
                                                                        followers,
                                                                    following:
                                                                        following,
                                                                  )));
                                                    },
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      children: <Widget>[
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            following,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .whitetext),
                                                                fontFamily:
                                                                    Constants
                                                                        .appFontBold,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "Following",
                                                            textAlign: TextAlign
                                                                .center,
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
                                                          totalPost,
                                                          textAlign:
                                                              TextAlign.center,
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
                                                          textAlign:
                                                              TextAlign.center,
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
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.only(bottom: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              bio!,
                              maxLines: 3,
                              style: TextStyle(
                                color: Color(Constants.whitetext),
                                fontSize: 16,
                                fontFamily: Constants.appFont,
                              ),
                            ),
                          ),
                          Container(

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
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 10, right: 5, bottom: 0, left: 5),
                              child: FutureBuilder<int>(
                                future: _profileFuture,
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.done:
                                      return 0 < snapshot.data!.toInt()
                                          ? TabBarView(
                                              controller: _controller,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: <Widget>[
                                                  /// posts
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 5,
                                                        left: 10,
                                                        right: 10,
                                                        top: 0),
                                                    child: postList.length > 0
                                                        ? StaggeredGridView
                                                            .countBuilder(
                                                            physics:
                                                                AlwaysScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            crossAxisCount: 3,
                                                            itemCount:
                                                                postList.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              if (postList[
                                                                          index]
                                                                      .isLike ==
                                                                  true) {
                                                                postList[index]
                                                                        .showred =
                                                                    true;
                                                                postList[index]
                                                                        .showwhite =
                                                                    false;
                                                              } else {
                                                                postList[index]
                                                                        .showred =
                                                                    false;
                                                                postList[index]
                                                                        .showwhite =
                                                                    true;
                                                              }
                                                              return InkWell(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) => OwnPostScreen(
                                                                              postList[index].id)))
                                                                      .then((value) {
                                                                    callApiForGetProfile();
                                                                    _controller!
                                                                        .animateTo(
                                                                            0);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  child: Stack(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                            postList[index].imagePath! +
                                                                                postList[index].screenshot!,
                                                                        imageBuilder:
                                                                            (context, imageProvider) =>
                                                                                Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20.0),
                                                                            image:
                                                                                DecorationImage(
                                                                              image: imageProvider,
                                                                              fit: BoxFit.fill,
                                                                              alignment: Alignment.topCenter,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                CustomLoader(),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Image.asset("images/no_image.png"),
                                                                      ),
                                                                      Container(
                                                                        margin:
                                                                            EdgeInsets.only(
                                                                          top:
                                                                              10,
                                                                        ),
                                                                        alignment:
                                                                            Alignment.topRight,
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              _openPostBottomSheet(postList[index].id, postList[index].imagePath! + postList[index].video!);
                                                                            },
                                                                            child: Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                              child: SvgPicture.asset(
                                                                                "images/more_menu.svg",
                                                                                width: ScreenUtil().setWidth(20),
                                                                                height: ScreenUtil().setHeight(20),
                                                                              ),
                                                                            )),
                                                                      ),
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          "images/play_button.svg",
                                                                          width:
                                                                              50,
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
                                                                            Alignment.bottomCenter,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Container(
                                                                                alignment: Alignment.bottomLeft,
                                                                                padding: EdgeInsets.all(4),
                                                                                child: Text(
                                                                                  () {
                                                                                    if (1 < int.parse(postList[index].viewCount.toString())) {
                                                                                      return "${postList[index].viewCount.toString()} Views";
                                                                                    } else {
                                                                                      return "${postList[index].viewCount.toString()} View";
                                                                                    }
                                                                                  }(),
                                                                                  style: TextStyle(color: Color(Constants.whitetext), fontSize: 14, fontFamily: Constants.appFont),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Align(
                                                                                alignment: Alignment.bottomRight,
                                                                                child: Container(
                                                                                  alignment: Alignment.bottomRight,
                                                                                  child: ListView(
                                                                                    shrinkWrap: true,
                                                                                    physics: NeverScrollableScrollPhysics(),
                                                                                    children: [
                                                                                      Visibility(
                                                                                        visible: postList[index].showwhite,
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.all(4),
                                                                                          child: InkWell(
                                                                                            onTap: () {
                                                                                              callApiForLikedVideo(postList[index].id, context);
                                                                                            },
                                                                                            child: SvgPicture.asset(
                                                                                              "images/white_heart.svg",
                                                                                              width: 15,
                                                                                              height: 15,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Visibility(
                                                                                        visible: postList[index].showred,
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.all(4),
                                                                                          child: InkWell(
                                                                                            onTap: () {
                                                                                              callApiForLikedVideo(postList[index].id, context);
                                                                                            },
                                                                                            child: SvgPicture.asset(
                                                                                              "images/red_heart.svg",
                                                                                              width: 15,
                                                                                              height: 15,
                                                                                            ),
                                                                                          ),
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
                                                                ),
                                                              );
                                                            },
                                                            staggeredTileBuilder: (int
                                                                    index) =>
                                                                new StaggeredTile
                                                                        .count(
                                                                    1,
                                                                    index.isEven
                                                                        ? 1.5
                                                                        : 1.5),
                                                            mainAxisSpacing:
                                                                1.0,
                                                            crossAxisSpacing:
                                                                1.0,
                                                          )
                                                        : NoPostAvailable(
                                                            subject: "Post"),
                                                  ),

                                                  /// saved
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 5,
                                                        left: 10,
                                                        right: 10,
                                                        top: 0),
                                                    child: savedList.length > 0
                                                        ? StaggeredGridView
                                                            .countBuilder(
                                                            physics:
                                                                AlwaysScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            crossAxisCount: 3,
                                                            itemCount: savedList
                                                                .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              if (savedList[
                                                                          index]
                                                                      .video!
                                                                      .isLike ==
                                                                  true) {
                                                                savedList[index]
                                                                        .video!
                                                                        .showred =
                                                                    true;
                                                                savedList[index]
                                                                        .video!
                                                                        .showwhite =
                                                                    false;
                                                              } else {
                                                                savedList[index]
                                                                        .video!
                                                                        .showred =
                                                                    false;
                                                                savedList[index]
                                                                        .video!
                                                                        .showwhite =
                                                                    true;
                                                              }

                                                              return InkWell(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) => OwnPostScreen(
                                                                              savedList[index].video?.id ??
                                                                                  0)))
                                                                      .then(
                                                                          (value) {
                                                                    callApiForGetProfile();
                                                                    _controller!
                                                                        .animateTo(
                                                                            1);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                5),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                        ),
                                                                        child:
                                                                            new Container(
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              CachedNetworkImage(
                                                                                imageUrl: savedList[index].video!.imagePath! + savedList[index].video!.screenshot!,
                                                                                imageBuilder: (context, imageProvider) => Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                    image: DecorationImage(
                                                                                      image: imageProvider,
                                                                                      fit: BoxFit.fill,
                                                                                      alignment: Alignment.topCenter,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                placeholder: (context, url) => CustomLoader(),
                                                                                errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(
                                                                                  top: 10,
                                                                                ),
                                                                                alignment: Alignment.topRight,
                                                                                child: InkWell(
                                                                                    onTap: () {
                                                                                      _openSavedBottomSheet(savedList[index].video!.id, savedList[index].video!.user!.id, savedList[index].video!.imagePath! + savedList[index].video!.video!);
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.symmetric(
                                                                                        horizontal: 10.0,
                                                                                        vertical: 5.0,
                                                                                      ),
                                                                                      child: SvgPicture.asset(
                                                                                        "images/more_menu.svg",
                                                                                        width: ScreenUtil().setWidth(20),
                                                                                        height: ScreenUtil().setHeight(20),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                child: SvgPicture.asset(
                                                                                  "images/play_button.svg",
                                                                                  width: 50,
                                                                                  height: 50,
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(left: 10, right: 0, bottom: 5),
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: Container(
                                                                                        alignment: Alignment.bottomLeft,
                                                                                        child: Text(
                                                                                          () {
                                                                                            if (1 < int.parse(savedList[index].video!.viewCount.toString())) {
                                                                                              return "${savedList[index].video!.viewCount.toString()} Views";
                                                                                            } else {
                                                                                              return "${savedList[index].video!.viewCount.toString()} View";
                                                                                            }
                                                                                          }(),
                                                                                          style: TextStyle(color: Color(Constants.whitetext), fontSize: 14, fontFamily: Constants.appFont),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: Align(
                                                                                        alignment: Alignment.bottomRight,
                                                                                        child: Container(
                                                                                          alignment: Alignment.bottomRight,
                                                                                          child: ListView(
                                                                                            shrinkWrap: true,
                                                                                            physics: NeverScrollableScrollPhysics(),
                                                                                            children: [
                                                                                              Visibility(
                                                                                                visible: savedList[index].video!.showwhite,
                                                                                                child: Container(
                                                                                                  child: InkWell(
                                                                                                      onTap: () {
                                                                                                        setState(() {
                                                                                                          Constants.checkNetwork().whenComplete(() => callApiForLikedVideo(savedList[index].video!.id, context));
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
                                                                                                visible: savedList[index].video!.showred,
                                                                                                child: Container(
                                                                                                  child: InkWell(
                                                                                                      onTap: () {
                                                                                                        setState(() {
                                                                                                          Constants.checkNetwork().whenComplete(() => callApiForLikedVideo(savedList[index].video!.id, context));
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
                                                              );
                                                            },
                                                            staggeredTileBuilder: (int
                                                                    index) =>
                                                                new StaggeredTile
                                                                        .count(
                                                                    1,
                                                                    index.isEven
                                                                        ? 1.5
                                                                        : 1.5),
                                                            mainAxisSpacing:
                                                                1.0,
                                                            crossAxisSpacing:
                                                                1.0,
                                                          )
                                                        : NoPostAvailable(
                                                            subject:
                                                                "Saved Post"),
                                                  ),

                                                  /// liked
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 5,
                                                        left: 10,
                                                        right: 10,
                                                        top: 0),
                                                    child: likedList.length > 0
                                                        ? StaggeredGridView
                                                            .countBuilder(
                                                            physics:
                                                                AlwaysScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            crossAxisCount: 3,
                                                            itemCount: likedList
                                                                .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              if (likedList[
                                                                          index]
                                                                      .video!
                                                                      .isLike ==
                                                                  true) {
                                                                likedList[index]
                                                                        .video!
                                                                        .showred =
                                                                    true;
                                                                likedList[index]
                                                                        .video!
                                                                        .showwhite =
                                                                    false;
                                                              } else {
                                                                likedList[index]
                                                                        .video!
                                                                        .showred =
                                                                    false;
                                                                likedList[index]
                                                                        .video!
                                                                        .showwhite =
                                                                    true;
                                                              }
                                                              return InkWell(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) => OwnPostScreen(
                                                                              likedList[index].video!.id)))
                                                                      .then((value) {
                                                                    callApiForGetProfile();
                                                                    _controller!
                                                                        .animateTo(
                                                                            2);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                5),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                        ),
                                                                        child:
                                                                            new Container(
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              CachedNetworkImage(
                                                                                imageUrl: likedList[index].video!.imagePath! + likedList[index].video!.screenshot!,
                                                                                imageBuilder: (context, imageProvider) => Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                    image: DecorationImage(
                                                                                      image: imageProvider,
                                                                                      fit: BoxFit.fill,
                                                                                      alignment: Alignment.topCenter,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                placeholder: (context, url) => CustomLoader(),
                                                                                errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                child: SvgPicture.asset(
                                                                                  "images/play_button.svg",
                                                                                  width: 50,
                                                                                  height: 50,
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(left: 10, right: 0, bottom: 5),
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: Container(
                                                                                        alignment: Alignment.bottomLeft,
                                                                                        child: Text(
                                                                                          () {
                                                                                            if (1 < int.parse(likedList[index].video!.viewCount.toString())) {
                                                                                              return "${likedList[index].video!.viewCount.toString()} Views";
                                                                                            } else {
                                                                                              return "${likedList[index].video!.viewCount.toString()} View";
                                                                                            }
                                                                                          }(),
                                                                                          style: TextStyle(color: Color(Constants.whitetext), fontSize: 14, fontFamily: Constants.appFont),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: Align(
                                                                                        alignment: Alignment.bottomRight,
                                                                                        child: Container(
                                                                                          alignment: Alignment.bottomRight,
                                                                                          child: ListView(
                                                                                            shrinkWrap: true,
                                                                                            physics: NeverScrollableScrollPhysics(),
                                                                                            children: [
                                                                                              Visibility(
                                                                                                visible: true,
                                                                                                child: Container(
                                                                                                  child: InkWell(
                                                                                                      onTap: () {
                                                                                                        setState(() {
                                                                                                          Constants.checkNetwork().whenComplete(() => callApiForLikedVideo(savedList[index].video!.id, context));
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
                                                              );
                                                            },
                                                            staggeredTileBuilder: (int
                                                                    index) =>
                                                                new StaggeredTile
                                                                        .count(
                                                                    1,
                                                                    index.isEven
                                                                        ? 1.5
                                                                        : 1.5),
                                                            mainAxisSpacing:
                                                                1.0,
                                                            crossAxisSpacing:
                                                                1.0,
                                                          )
                                                        : NoPostAvailable(
                                                            subject:
                                                                "Liked Post"),
                                                  ),
                                                ])
                                          : Align(
                                              alignment: Alignment.center,
                                              child: NoPostAvailable(
                                                subject: "Post",
                                              ),
                                            );
                                    case ConnectionState.none:
                                      return Container();
                                    case ConnectionState.waiting:
                                      return Container();
                                    case ConnectionState.active:
                                      return Container();
                                    default:
                                      return Container();
                                  }
                                },
                              ),
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
      ),
    );
  }

  Future<int> callApiForGetProfile() async {
    int tempPassData = 0;

    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData()).getmyprofiledata().then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
        });
        setState(() {
          print("sucessprofile");
          if (response.data!.mainUser!.name != null) {
            PreferenceUtils.setString(
                Constants.name, response.data!.mainUser!.name!);
          } else {
            PreferenceUtils.setString(Constants.name, "");
          }
          if (response.data!.mainUser!.userId != null) {
            PreferenceUtils.setString(
                Constants.userId, response.data!.mainUser!.userId!);
          } else {
            PreferenceUtils.setString(Constants.userId, "");
          }
          if (response.data!.mainUser!.email != null) {
            PreferenceUtils.setString(
                Constants.email, response.data!.mainUser!.email!);
          } else {
            PreferenceUtils.setString(Constants.email, "");
          }
          if (response.data!.mainUser!.phone != null) {
            PreferenceUtils.setString(
                Constants.phone, response.data!.mainUser!.phone!);
          } else {
            PreferenceUtils.setString(Constants.phone, "");
          }
          if (response.data!.mainUser!.bio != null) {
            PreferenceUtils.setString(
                Constants.bio, response.data!.mainUser!.bio!);
          } else {
            PreferenceUtils.setString(Constants.bio, "");
          }
          if (response.data!.mainUser!.bdate != null) {
            PreferenceUtils.setString(
                Constants.bDate, response.data!.mainUser!.bdate!);
          } else {
            PreferenceUtils.setString(Constants.bDate, "");
          }
          if (response.data!.mainUser!.gender != null) {
            PreferenceUtils.setString(
                Constants.gender, response.data!.mainUser!.gender!);
          } else {
            PreferenceUtils.setString(Constants.gender, "");
          }
          if (response.data!.mainUser!.imagePath != null &&
              response.data!.mainUser!.image != null) {
            PreferenceUtils.setString(
                Constants.image,
                (response.data!.mainUser!.imagePath! +
                    response.data!.mainUser!.image!));
          } else {
            PreferenceUtils.setString(Constants.image, "");
          }

          if (response.data!.mainUser!.bio != null &&
              response.data!.mainUser!.bio!.isNotEmpty) {
            bio = response.data!.mainUser!.bio;
          }

          bDate = response.data!.mainUser!.bdate;
          name = response.data!.mainUser!.name;
          username = response.data!.mainUser!.userId;
          phone = response.data!.mainUser!.phone;
          email = response.data!.mainUser!.email;

          image = response.data!.mainUser!.imagePath! +
              response.data!.mainUser!.image!;
          followers = response.data!.mainUser!.followersCount.toString();
          following = response.data!.mainUser!.followingCount.toString();
          totalPost = response.data!.posts!.length.toString();
          userId = response.data!.mainUser!.id;
          likedList.clear();
          postList.clear();
          savedList.clear();

          if (response.data!.posts!.length != 0) {
            postList.clear();
            postList.addAll(response.data!.posts!);
          }
          if (response.data!.liked!.length != 0) {
            likedList.clear();
            likedList.addAll(response.data!.liked!);
          }
          if (response.data!.saved!.length != 0) {
            savedList.clear();
            savedList.addAll(response.data!.saved!);
          }
        });
      } else {
        setState(() {
          showSpinner = false;
        });
      }
    }).catchError((Object obj) {






      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          print(res);
          var responsecode = res.statusCode;
          if (responsecode == 401) {
            print(responsecode);
            print(res.statusMessage);
            Constants.toastMessage("Login Please");
          } else if (responsecode == 422) {
            Constants.toastMessage("Internal server error");
            print("code:$responsecode");
          }

          break;
        default:
      }
      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
    if (postList.isNotEmpty) {
      tempPassData = postList.length;
    }
    if (likedList.isNotEmpty) {
      tempPassData += likedList.length;
    }
    if (savedList.isNotEmpty) {
      tempPassData += savedList.length;
    }
    return tempPassData;
  }

  void _openPostBottomSheet(int? videoId, String video) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Constants.checkNetwork().whenComplete(
                          () => callApiForDeleteVideo(videoId, context));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Delete Post",
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 16,
                            fontFamily: Constants.appFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPost(
                              videoId: videoId,
                            ),
                          )).whenComplete(() => Navigator.pop(context));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Edit Post",
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 16,
                            fontFamily: Constants.appFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Share.share("$video")
                          .whenComplete(() => Navigator.pop(context));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Share to...",
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 16,
                            fontFamily: Constants.appFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  void _openSavedBottomSheet(int? id, int? userid, String video) {
    print("savedid123:$id");
    print("saveduserid123:$userid");
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Constants.checkNetwork()
                          .whenComplete(() => callApiForSaveVideo(id, context));
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Remove From The Save List",
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 16,
                            fontFamily: Constants.appFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  //ToDo: Implement in next update with deeplink
                  // Container(
                  //   alignment: Alignment.center,
                  //   margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                  //   height: ScreenUtil().setHeight(50),
                  //   child: Text(
                  //     "Copy Link",
                  //     style: TextStyle(
                  //         color: Color(Constants.whitetext),
                  //         fontSize: 16,
                  //         fontFamily: Constants.app_font),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      Constants.checkNetwork().whenComplete(
                          () => callApiForBlockUser(userid, context));
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Block This User",
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 16,
                            fontFamily: Constants.appFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Share.share("$video")
                          .whenComplete(() => Navigator.pop(context));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Share to...",
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 16,
                            fontFamily: Constants.appFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  Future<void> callApiForLikedVideo(int? id, BuildContext context) async {
    print("likeid:$id");
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData()).likevideo(id).then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);
      if (sucess == true) {
        setState(() {
          showSpinner = false;


          Constants.checkNetwork().whenComplete(() => callApiForGetProfile());
        });
      } else {
        setState(() {
          showSpinner = false;


        });
      }
    }).catchError((Object obj) {
      Constants.toastMessage("Server Error");
      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  void callApiForDeleteVideo(int? id, BuildContext context) {
    print("likeid:$id");

    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).deleteVideo(id).then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);

      if (sucess == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Navigator.pop(context);

          Constants.checkNetwork().whenComplete(() => callApiForGetProfile());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Navigator.pop(context);
          Constants.toastMessage(msg);
        });
      }
    }).catchError((Object obj) {
      Constants.toastMessage("Server Error");

      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  void callApiForSaveVideo(int? id, BuildContext context) {
    print("likeid:$id");

    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).savevideo(id).then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);

      if (sucess == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);

          Constants.checkNetwork().whenComplete(() => callApiForGetProfile());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
        });
      }
    }).catchError((Object obj) {
      Constants.toastMessage("Server Error");

      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  callApiForBlockUser(int? userid, BuildContext context) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .blockuser(userid.toString(), "User")
        .then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);
      if (sucess == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);

          Constants.checkNetwork().whenComplete(() => callApiForGetProfile());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);

          final snackBar = SnackBar(
            content: Text(msg),
            backgroundColor: Color(Constants.redtext),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        });
      }
    }).catchError((Object obj) {
      Constants.toastMessage("Server Error");

      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
