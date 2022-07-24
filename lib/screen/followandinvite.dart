import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/model/followandinvtelist.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:acoustic/screen/userprofile.dart';
import 'package:share/share.dart';
import 'package:dio/dio.dart';

class FollowandInviteScreen extends StatefulWidget {
  @override
  _FollowandInviteScreen createState() => _FollowandInviteScreen();
}

class _FollowandInviteScreen extends State<FollowandInviteScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  bool isOnline = true;

  List<FollowInviteData> followinvitelist = <FollowInviteData>[];

  bool nodata = true;
  bool showdata = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  String? shareUrl = '';

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();
    if (mounted) {
      Constants.checkNetwork().whenComplete(() => callApiForFollowandInvite());
      Constants.checkNetwork().whenComplete(() => callApiForsetting());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("Follow & Invite Friends"),
              ),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: true,
            ),
            backgroundColor: Color(Constants.bgblack),
            resizeToAvoidBottomInset: true,
            key: _scaffoldKey,
            body: RefreshIndicator(
              color: Color(Constants.lightbluecolor),
              backgroundColor: Colors.transparent,
              onRefresh: callApiForFollowandInvite,
              key: _refreshIndicatorKey,
              child: ModalProgressHUD(
                inAsyncCall: showSpinner,
                opacity: 1.0,
                color: Colors.transparent.withOpacity(0.2),
                progressIndicator:
                CustomLoader(),
                child: LayoutBuilder(
                  builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return new Stack(
                      children: <Widget>[
                        new SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 0, right: 10),
                            color: Colors.transparent,
                            child: Column(
                              children: <Widget>[
                                Visibility(
                                  visible: showdata,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, top: 25),
                                    child: ListView.separated(
                                      itemCount: followinvitelist.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: 10.0,
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
                                                              followinvitelist[
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
                                                  imageUrl: followinvitelist[
                                                              index]
                                                          .imagePath! +
                                                      followinvitelist[index]
                                                          .image!,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF36446b),
                                                      borderRadius:
                                                          new BorderRadius.all(
                                                              new Radius
                                                                      .circular(
                                                                  50)),
                                                      border: new Border.all(
                                                        color: Color(Constants
                                                            .lightbluecolor),
                                                        width: 3.0,
                                                      ),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor:
                                                          Color(0xFF36446b),
                                                      child: CircleAvatar(
                                                        radius: 30,
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
                                                          followinvitelist[
                                                                  index]
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
                                                            top: 5),
                                                        child: Text(
                                                          followinvitelist[
                                                                      index]
                                                                  .followersCount
                                                                  .toString() +
                                                              " Followers",
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
                                                flex: 2,
                                                child: InkWell(
                                                  onTap: () {
                                                    Share.share('$shareUrl');
                                                  },
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 15),
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 0,
                                                                  right: 10),
                                                          alignment:
                                                              Alignment.center,
                                                          height: ScreenUtil()
                                                              .setHeight(35),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  8),
                                                            ),
                                                            color: Color(
                                                                Constants
                                                                    .buttonbg),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5,
                                                                    right: 5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "images/follow.svg"),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              2),
                                                                  child: Text(
                                                                    "Follow",
                                                                    style: TextStyle(
                                                                        color: Color(Constants
                                                                            .whitetext),
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            Constants.appFont),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: nodata,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: ScreenUtil().setHeight(80),
                                        margin: const EdgeInsets.only(
                                            top: 20.0,
                                            left: 15.0,
                                            right: 15,
                                            bottom: 0),
                                        child: Text(
                                          "No Data Available !",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: Constants.appFont,
                                              fontSize: 20),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )),
      ),
    );
  }

  void sharePost(int index) {
    setState(() {
      showSpinner = true;
    });
    Share.share("").whenComplete(() {
      setState(() {
        showSpinner = false;
      });
    });
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  Future<void> callApiForFollowandInvite() async {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).getfollowlist().then((response) {
      if (response.success == true) {
        followinvitelist.clear();
        setState(() {
          showSpinner = false;
        });
        setState(() {
          if (response.data!.length != 0) {
            followinvitelist.addAll(response.data!);
            nodata = false;
            showdata = true;
          }
        });
      } else {
        setState(() {
          showSpinner = false;
          nodata = true;
          showdata = false;
        });
      }
    }).catchError((Object obj) {
      final snackBar = SnackBar(
        content: Text('Server Error'),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        showSpinner = false;
        nodata = true;
        showdata = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  void callApiForsetting() {
    RestClient(ApiHeader().dioData()).settingRequest().then((response) {
      if (response.success == true) {
        print("Setting true");
        shareUrl = response.data!.shareUrl;
      }
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
}
