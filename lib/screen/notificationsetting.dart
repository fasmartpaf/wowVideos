import 'dart:convert';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:dio/dio.dart';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class NotificationSettingScreen extends StatefulWidget {
  @override
  _NotificationSettingScreen createState() => _NotificationSettingScreen();
}

class _NotificationSettingScreen extends State<NotificationSettingScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  bool muteAllNotification = false;
  bool postAndComment = false;
  bool likeToggle = false;
  bool commentToggle = false;
  bool followingAndFollowers = false;
  bool followingRequest = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    callApiForGetNotificationData();
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
                  child: Text("Notification")),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: true,
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    callApiForSaveNotification();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 25),
                    child: SvgPicture.asset("images/right.svg"),
                  ),
                )
              ],
            ),
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
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),

                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                muteAllNotification = !muteAllNotification;
                                print(muteAllNotification);
                                if (muteAllNotification == true) {
                                  postAndComment = false;
                                  likeToggle = false;
                                  commentToggle = false;
                                  followingAndFollowers = false;
                                  followingRequest = false;
                                }
                              });
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Mute All Notifications",
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                ),
                                FlutterSwitch(
                                  height: 25,
                                  width: 45,
                                  borderRadius: 30,
                                  padding: 5.5,
                                  duration: Duration(milliseconds: 400),
                                  activeColor: Color(Constants.lightbluecolor),
                                  activeToggleColor: Color(Constants.bgblack),
                                  inactiveToggleColor: Color(Constants.bgblack),
                                  inactiveColor: Color(Constants.greytext),
                                  toggleSize: 15,
                                  value: muteAllNotification,
                                  onToggle: (val) {
                                    setState(() {
                                      muteAllNotification =
                                          !muteAllNotification;
                                      print(muteAllNotification);
                                      if (muteAllNotification == true) {
                                        postAndComment = false;
                                        likeToggle = false;
                                        commentToggle = false;
                                        followingAndFollowers = false;
                                        followingRequest = false;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            subtitle: Text(
                              "You want receive any kind of\nnotification from the app.",
                              style: TextStyle(
                                  color: Color(Constants.greytext),
                                  fontSize: 14,
                                  fontFamily: Constants.appFont),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(
                            color: Color(Constants.greytext),
                            thickness: 1,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              postAndComment = !postAndComment;
                              if (muteAllNotification == true) {
                                muteAllNotification = false;
                              }
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Posts & Comments",
                                style: TextStyle(
                                    color: Color(Constants.whitetext),
                                    fontSize: 16,
                                    fontFamily: Constants.appFont),
                              ),
                              FlutterSwitch(
                                height: 25,
                                width: 45,
                                borderRadius: 30,
                                padding: 5.5,
                                duration: Duration(milliseconds: 400),
                                activeColor: Color(Constants.lightbluecolor),
                                activeToggleColor: Color(Constants.bgblack),
                                inactiveToggleColor: Color(Constants.bgblack),
                                inactiveColor: Color(Constants.greytext),
                                toggleSize: 15,
                                value: postAndComment,
                                onToggle: (val) {
                                  setState(() {
                                    postAndComment = !postAndComment;
                                    if (muteAllNotification == true) {
                                      muteAllNotification = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "You want receive posts or comments\nrelated notification from the app",
                            style: TextStyle(
                                color: Color(Constants.greytext),
                                fontSize: 14,
                                fontFamily: Constants.appFont),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              likeToggle = !likeToggle;
                              if (muteAllNotification == true) {
                                muteAllNotification = false;
                              }
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Likes",
                                style: TextStyle(
                                    color: Color(Constants.whitetext),
                                    fontSize: 16,
                                    fontFamily: Constants.appFont),
                              ),
                              FlutterSwitch(
                                height: 25,
                                width: 45,
                                borderRadius: 30,
                                padding: 5.5,
                                duration: Duration(milliseconds: 400),
                                activeColor: Color(Constants.lightbluecolor),
                                activeToggleColor: Color(Constants.bgblack),
                                inactiveToggleColor: Color(Constants.bgblack),
                                inactiveColor: Color(Constants.greytext),
                                toggleSize: 15,
                                value: likeToggle,
                                onToggle: (val) {
                                  setState(() {
                                    likeToggle = !likeToggle;
                                    if (muteAllNotification == true) {
                                      muteAllNotification = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              commentToggle = !commentToggle;
                              if (muteAllNotification == true) {
                                muteAllNotification = false;
                              }
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Comments",
                                style: TextStyle(
                                    color: Color(Constants.whitetext),
                                    fontSize: 16,
                                    fontFamily: Constants.appFont),
                              ),
                              FlutterSwitch(
                                height: 25,
                                width: 45,
                                borderRadius: 30,
                                padding: 5.5,
                                duration: Duration(milliseconds: 400),
                                activeColor: Color(Constants.lightbluecolor),
                                activeToggleColor: Color(Constants.bgblack),
                                inactiveToggleColor: Color(Constants.bgblack),
                                inactiveColor: Color(Constants.greytext),
                                toggleSize: 15,
                                value: commentToggle,
                                onToggle: (val) {
                                  setState(() {
                                    commentToggle = !commentToggle;
                                    if (muteAllNotification == true) {
                                      muteAllNotification = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(
                            color: Color(Constants.greytext),
                            thickness: 1,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              followingAndFollowers = !followingAndFollowers;
                              if (muteAllNotification == true) {
                                muteAllNotification = false;
                              }
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 0),
                                child: Text(
                                  "Following & Followers",
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                ),
                              ),
                              FlutterSwitch(
                                height: 25,
                                width: 45,
                                borderRadius: 30,
                                padding: 5.5,
                                duration: Duration(milliseconds: 400),
                                activeColor: Color(Constants.lightbluecolor),
                                activeToggleColor: Color(Constants.bgblack),
                                inactiveToggleColor: Color(Constants.bgblack),
                                inactiveColor: Color(Constants.greytext),
                                toggleSize: 15,
                                value: followingAndFollowers,
                                onToggle: (val) {
                                  setState(() {
                                    followingAndFollowers =
                                        !followingAndFollowers;
                                    if (muteAllNotification == true) {
                                      muteAllNotification = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "You want receive following & followers\nrelated notification from the app.",
                            style: TextStyle(
                                color: Color(Constants.greytext),
                                fontSize: 14,
                                fontFamily: Constants.appFont),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              followingRequest = !followingRequest;
                              if (muteAllNotification == true) {
                                muteAllNotification = false;
                              }
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Following Request",
                                style: TextStyle(
                                    color: Color(Constants.whitetext),
                                    fontSize: 16,
                                    fontFamily: Constants.appFont),
                              ),
                              FlutterSwitch(
                                height: 25,
                                width: 45,
                                borderRadius: 30,
                                padding: 5.5,
                                duration: Duration(milliseconds: 400),
                                activeColor: Color(Constants.lightbluecolor),
                                activeToggleColor: Color(Constants.bgblack),
                                inactiveToggleColor: Color(Constants.bgblack),
                                inactiveColor: Color(Constants.greytext),
                                toggleSize: 15,
                                value: followingRequest,
                                onToggle: (val) {
                                  setState(() {
                                    followingRequest = !followingRequest;
                                    if (muteAllNotification == true) {
                                      muteAllNotification = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }

  void callApiForSaveNotification() {
    setState(() {
      showSpinner = true;
    });
    Map<String, dynamic> body;
    if (muteAllNotification == true) {
      body = {
        "mention_not": 0,
        "like_not": 0,
        "comment_not": 0,
        "follow_not": 0,
        "request_not": 0,
      };
    } else {
      int mentionNot;
      int like;
      int comment;
      int follow;
      int request;
      if (postAndComment == true) {
        mentionNot = 1;
      } else {
        mentionNot = 0;
      }
      if (likeToggle == true) {
        like = 1;
      } else {
        like = 0;
      }
      if (commentToggle == true) {
        comment = 1;
      } else {
        comment = 0;
      }
      if (followingAndFollowers == true) {
        follow = 1;
      } else {
        follow = 0;
      }
      if (followingRequest == true) {
        request = 1;
      } else {
        request = 0;
      }
      body = {
        "mention_not": mentionNot,
        "like_not": like,
        "comment_not": comment,
        "follow_not": follow,
        "request_not": request,
      };
    }
    RestClient(ApiHeader().dioData()).notificationSave(body).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Navigator.pop(context);
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Navigator.pop(context);
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

  void callApiForGetNotificationData() {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).notificationGetSetting().then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
          if (response.data!.mentionNot == 0 &&
              response.data!.followerRequest == 0 &&
              response.data!.likeNot == 0 &&
              response.data!.commentNot == 0 &&
              response.data!.followNot == 0 &&
              response.data!.requestNot == 0) {
            muteAllNotification = true;
            postAndComment = false;
            likeToggle = false;
            commentToggle = false;
            followingAndFollowers = false;
            followingRequest = false;
          } else {
            muteAllNotification = false;
            response.data!.mentionNot == 1
                ? postAndComment = true
                : postAndComment = false;
            response.data!.likeNot == 1
                ? likeToggle = true
                : likeToggle = false;
            response.data!.commentNot == 1
                ? commentToggle = true
                : commentToggle = false;
            response.data!.followNot == 1
                ? followingAndFollowers = true
                : followingAndFollowers = false;
            response.data!.requestNot == 1
                ? followingRequest = true
                : followingRequest = false;
          }
        });
      } else {
        setState(() {
          showSpinner = false;
          Constants.toastMessage("${response.msg}");
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
