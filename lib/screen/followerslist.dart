import 'dart:convert';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/screen/userprofile.dart';
import 'package:acoustic/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:acoustic/util/inndicator.dart';
import 'package:acoustic/model/own_following_followers.dart';

import 'homescreen.dart';

class FollowersListScreen extends StatefulWidget {
  final int index;
  final String followers;
  final String following;

  FollowersListScreen(
      {required this.index, required this.followers, required this.following});

  @override
  _FollowersListScreen createState() => _FollowersListScreen();
}

class _FollowersListScreen extends State<FollowersListScreen>
    with SingleTickerProviderStateMixin {
  bool isRememberMe = false;

  bool showSpinner = false;
  bool showred = false;
  bool showwhite = true;

  String devicetoken = "";

  TabController? _controller;
  TextEditingController _searchController = TextEditingController();
  int? initialIndex;

  int savedLength = 5;
  int postLength = 5;
  int likedLength = 5;
  String followers = '';
  String following = '';
  String followerPageTitle = '';

  List<Followers> ownFollowersList = [];
  List<Followings> ownFollowingList = [];
  List<Followers> tempOwnFollowersList = [];
  List<Followings> tempOwnFollowingList = [];

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _controller = TabController(length: 2, vsync: this);
    initialIndex = widget.index;
    _controller!.animateTo(initialIndex!);
    followers = widget.followers;
    following = widget.following;
    followerPageTitle = initialIndex == 0 ? "Followers" : "Following";
    Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
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
            title: Text(followerPageTitle),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
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
                          margin: EdgeInsets.only(top: 0),
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
                                onTap: (int value) {
                                  _searchController.clear();
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  _controller!.index == 0
                                      ? followerPageTitle = "Followers"
                                      : followerPageTitle = "Following";
                                  ownFollowersList = tempOwnFollowersList;
                                  ownFollowingList = tempOwnFollowingList;
                                  setState(() {});
                                },
                                tabs: [
                                  new Tab(
                                    text: 'Followers($followers)',
                                  ),
                                  new Tab(
                                    text: 'Following($following)',
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
                        Container(
                          height: ScreenUtil().setHeight(55),
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color(0xFF1d1d1d),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 20),
                                    child: SvgPicture.asset(
                                        "images/greay_search.svg")),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  color: Colors.transparent,
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: searchFollowerFollowing,
                                    autofocus: false,
                                    style: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontSize: 14,
                                        fontFamily: Constants.appFont),
                                    decoration: InputDecoration.collapsed(
                                      hintText: "Search Profile",
                                      hintStyle: TextStyle(
                                          color: Color(Constants.hinttext),
                                          fontSize: 14,
                                          fontFamily: Constants.appFont),
                                      border: InputBorder.none,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 10, right: 20, bottom: 0, left: 20),
                            child: TabBarView(
                                controller: _controller,
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  /*followers*/
                                  ListView.separated(
                                    itemCount: ownFollowersList.length,
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) => SizedBox(
                                      height: 10                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileScreen(
                                                        userId:
                                                            ownFollowersList[
                                                                    index]
                                                                .id,
                                                      )));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(





                                              child: CachedNetworkImage(
                                                alignment: Alignment.center,
                                                imageUrl:
                                                    ownFollowersList[index]
                                                            .imagePath! +
                                                        ownFollowersList[index]
                                                            .image!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF36446b),
                                                    borderRadius:
                                                        new BorderRadius.all(
                                                            new Radius.circular(
                                                                50)),
                                                    border: new Border.all(
                                                      color: Color(Constants
                                                          .lightbluecolor),
                                                      width: 3.0,
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        Color(0xFF36446b),
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      backgroundImage:
                                                          imageProvider,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CustomLoader(),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        "images/no_image.png"),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                color: Colors.transparent,
                                                margin: EdgeInsets.only(
                                                    left: 10,
                                                    top: 0,
                                                    bottom: 5),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        ownFollowersList[index]
                                                            .name!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
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
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          top: 0),
                                                      child: Text(
                                                        "${ownFollowersList[index].followersCount} Followers",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greytext),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                Constants
                                                                    .appFont),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: InkWell(
                                                onTap: () {
                                                  if (ownFollowersList[index]
                                                          .isFollowing ==
                                                      0) {
                                                    callApiForFollowBack(
                                                        ownFollowersList[index]
                                                            .id);
                                                  } else {
                                                    callApiForRemoveFromFollowers(
                                                        ownFollowersList[index]
                                                            .id);
                                                  }
                                                },
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 15),
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 5, right: 10),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                                color: Color(
                                                                    Constants
                                                                        .lightbluecolor),
                                                                width: 2.5),
                                                          ),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 2),
                                                          child: Text(
                                                            () {
                                                              if (ownFollowersList[
                                                                          index]
                                                                      .isFollowing ==
                                                                  0) {
                                                                return "Follow Back";
                                                              } else {
                                                                return "Remove";
                                                              }
                                                            }(),
                                                            style: TextStyle(
                                                              color: Color(Constants
                                                                  .lightbluecolor),
                                                              fontSize: 14,
                                                              fontFamily: Constants
                                                                  .appFontBold,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  /*following*/
                                  ListView.separated(
                                    itemCount: ownFollowingList.length,
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      height: 10,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileScreen(
                                                        userId:
                                                            ownFollowingList[
                                                                    index]
                                                                .id,
                                                      )));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(





                                              child: CachedNetworkImage(
                                                alignment: Alignment.center,
                                                imageUrl:
                                                    ownFollowingList[index]
                                                            .imagePath! +
                                                        ownFollowingList[index]
                                                            .image!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF36446b),
                                                    borderRadius:
                                                        new BorderRadius.all(
                                                            new Radius.circular(
                                                                30)),
                                                    border: new Border.all(
                                                      color: Color(Constants
                                                          .lightbluecolor),
                                                      width: 3.0,
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        Color(0xFF36446b),
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      backgroundImage:
                                                          imageProvider,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CustomLoader(),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        "images/no_image.png"),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                color: Colors.transparent,
                                                margin: EdgeInsets.only(
                                                    left: 10,
                                                    top: 0,
                                                    bottom: 5),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        ownFollowingList[index]
                                                            .name!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
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
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          top: 0),
                                                      child: Text(
                                                        "${ownFollowingList[index].followersCount} Followers",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greytext),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                Constants
                                                                    .appFont),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Constants.checkNetwork()
                                                          .whenComplete(() =>
                                                              callApiForUnFollowRequest(
                                                                  ownFollowingList[
                                                                          index]
                                                                      .id));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      margin: EdgeInsets.only(
                                                          left: 15,
                                                          right: 0,
                                                          bottom: 10),
                                                      alignment:
                                                          Alignment.centerRight,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            color: Color(Constants
                                                                .lightbluecolor),
                                                            width: 2.5),
                                                      ),
                                                      child: Text(
                                                        "Following",
                                                        style: TextStyle(
                                                          color: Color(Constants
                                                              .lightbluecolor),
                                                          fontSize: 14,
                                                          fontFamily: Constants
                                                              .appFontBold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: InkWell(
                                                        onTap: () {
                                                          _openFollowingMoreMenu(
                                                              ownFollowingList[
                                                                      index]
                                                                  .id);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom: 13,
                                                            left: 13,
                                                            right: 10,
                                                          ),
                                                          child:
                                                              SvgPicture.asset(
                                                            "images/more_menu.svg",
                                                            width: ScreenUtil()
                                                                .setWidth(20),
                                                            height: ScreenUtil()
                                                                .setHeight(20),
                                                            color: Color(
                                                                Constants
                                                                    .greytext),
                                                          ),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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

  void searchFollowerFollowing(String searchingValue) {
    switch (_controller!.index) {
      case 0:
        ownFollowersList.clear();
        tempOwnFollowersList.forEach((userDetail) {
          if (userDetail.name!
              .toLowerCase()
              .contains(searchingValue.toLowerCase())) {
            setState(() {
              ownFollowersList.add(userDetail);
            });
          }
        });
        break;
      case 1:
        ownFollowingList.clear();
        tempOwnFollowingList.forEach((userDetail) {
          if (userDetail.name!
              .toLowerCase()
              .contains(searchingValue.toLowerCase())) {
            setState(() {
              ownFollowingList.add(userDetail);
            });
          }
        });
        break;
      default:
        break;
    }
  }

  void callApiForOwnFollowers() {
    ownFollowingList.clear();
    ownFollowersList.clear();
    tempOwnFollowersList.clear();
    tempOwnFollowingList.clear();
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).ownFollowingFollowers().then((response) {
      setState(() {
        showSpinner = false;
        ownFollowersList.addAll(response.data!.followers!);
        ownFollowingList.addAll(response.data!.followings!);
        tempOwnFollowersList.addAll(response.data!.followers!);
        tempOwnFollowingList.addAll(response.data!.followings!);
        followers = tempOwnFollowersList.length.toString();
        following = tempOwnFollowingList.length.toString();
      });
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

  callApiForBlockUser(int? userid) {
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
          Constants.createSnackBar(msg, context, Color(Constants.redtext));

          Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.createSnackBar(msg, context, Color(Constants.redtext));
        });
      }
    }).catchError((Object obj) {
      Constants.createSnackBar(
          "Server Error", context, Color(Constants.redtext));

      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  void callApiForUnFollowRequest(int? userId) {
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
          Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
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

  void callApiForFollowBack(int? userId) {
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
          Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
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

  void callApiForRemoveFromFollowers(int? userId) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .removeFromFollowRequest(userId)
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callApiForOwnFollowers());
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
    return await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(4),));
  }

  void _openFollowingMoreMenu(int? userId) {
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
                    .whenComplete(() => callApiForBlockUser(userId));
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
            //ToDo: Implement in next update with deeplink

            //   alignment: Alignment.center,
            //   margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
            //   height: ScreenUtil().setHeight(50),
            //   child: Text(
            //     "Copy Profile URL",
            //     style: TextStyle(
            //         color: Color(Constants.whitetext),
            //         fontSize: 16,
            //         fontFamily: Constants.app_font),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
