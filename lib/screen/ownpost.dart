import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/custom/mute_icon.dart';
import 'package:acoustic/model/report_reason.dart';
import 'package:dio/dio.dart';
import 'package:acoustic/model/videocomment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:acoustic/util/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:acoustic/screen/usedsoundlist.dart';
import 'package:share/share.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:marquee/marquee.dart';
import 'package:video_player/video_player.dart';

class OwnPostScreen extends StatefulWidget {
  int? id;
  OwnPostScreen(this.id);

  @override
  _OwnPostScreen createState() => _OwnPostScreen();
}

class _OwnPostScreen extends State<OwnPostScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  bool halfstatus = true;
  bool fullstatus = false;
  bool showmore = true;
  bool showless = false;
  bool showSpinner = false;
  List<CommentData> commentlist = <CommentData>[];

  int? videoId = 0;
  int? userId = 0;
  String videoLink = "link";
  String isComment = "0";
  String commentCount = "0";
  String likeCount = "0";
  String viewCount = "0";
  bool? isLike = false;
  String isSaved = "0";
  String isReported = "0";
  String? originalsound;
  String status = "The Status";
  String songId = "0";
  String audioId = "0";
  int? selectedCommentId = 0;
  String? username = "name";
  String userimage = "image";
  late VideoPlayerController _controller;
  bool showBuffering = false;
  bool _visible = false;
  final _textCommentController = TextEditingController();
  List<ReportReasonData> reportReasonData = [];

  static const List<String> choices = <String>[
    "Delete Comment",
    "Report Comment"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    userId = widget.id;
    PreferenceUtils.init();
        Constants.checkNetwork().whenComplete(() => callApiForSingleVideo());
    _controller = VideoPlayerController.network(videoLink)
      ..initialize().then((value) => {
            setState(() {
              _controller.play();
            })
          });

    _controller.play();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 125),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.75,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }







  _hideBar() {
    Timer(
      Duration(seconds: 2),
      () {
        setState(() {
          _visible = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (30 >= status.length) {
      showmore = false;
    }

    return SafeArea(

      child: Scaffold(
        backgroundColor: Color(Constants.bgblack),
        appBar: AppBar(
          title: Text("Posts"),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: Container(
          margin: EdgeInsets.only(bottom: 0),
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: CustomLoader(),
            child: Container(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _visible = true;
                            _hideBar();
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: !_controller.value.isBuffering
                            ? videoLink != ''
                                ? Container(
                                    child: SizedBox.expand(
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: _controller.value.size.width,
                                          height:
                                              _controller.value.size.height,
                                          child: VideoPlayer(_controller),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    child:CustomLoader()
                                  )
                            : Container(
                                child: CustomLoader(),
                              ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Visibility(
                          visible: _visible,
                          child: _controller.value.isPlaying
                              ? MuteIconWidget(isMute: true)
                              : MuteIconWidget(isMute: false)),
                    ),
                  ),

                  /// Middle expanded
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                              flex: 4,
                              child: Container(
                                  padding:
                                      EdgeInsets.only(left: 15.0, bottom: 20),
                                  child: ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 0,
                                                  right: 5,
                                                  bottom: 5),
                                              width:
                                                  ScreenUtil().setWidth(36),
                                              height:
                                                  ScreenUtil().setHeight(36),
                                              child: CachedNetworkImage(
                                                alignment: Alignment.center,
                                                imageUrl: userimage,
                                                imageBuilder: (context,
                                                        imageProvider) =>
                                                    CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundImage:
                                                        imageProvider,
                                                  ),
                                                ),
                                                placeholder: (context, url) => CustomLoader(),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        "images/no_image.png"),
                                              ),
                                            ),
                                            Text(
                                              username!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: halfstatus,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 10,
                                                right: 0,
                                                bottom: 5),
                                            child: Text(
                                              status,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(
                                                      Constants.whitetext),
                                                  fontSize: 14,
                                                  fontFamily:
                                                      Constants.appFont),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: fullstatus,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                halfstatus = !halfstatus;
                                                fullstatus = !fullstatus;
                                                showmore = !showmore;
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 0,
                                                  bottom: 5),
                                              child: Text(
                                                status,
                                                maxLines: 20,
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
                                          ),
                                        ),
                                        Visibility(
                                          visible: showmore,
                                          child: Container(
                                            alignment: Alignment.topRight,
                                            margin: EdgeInsets.only(
                                                left: 10,
                                                right: 20,
                                                bottom: 5),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  halfstatus = !halfstatus;
                                                  fullstatus = !fullstatus;
                                                  showmore = !showmore;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "...more",
                                                    textAlign:
                                                        TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontSize: 16,
                                                        fontFamily: Constants
                                                            .appFont),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5,
                                                        right: 5,
                                                        top: 0),
                                                    alignment:
                                                        Alignment.center,
                                                    child: SvgPicture.asset(
                                                      "images/down_arrow.svg",
                                                      width: 8,
                                                      height: 8,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        originalsound != null
                                            ? InkWell(
                                                onTap: () {
                                                  _controller.pause();
                                                  String passSongId = '0';
                                                  bool isSongIdAvailable =
                                                      true;
                                                  if (songId != '' &&
                                                      songId != null &&
                                                      songId != 'null') {
                                                    passSongId = songId;
                                                    isSongIdAvailable = true;
                                                  } else if (audioId != '' &&
                                                      audioId != null &&
                                                      audioId != 'null') {
                                                    passSongId = audioId;
                                                    isSongIdAvailable = false;
                                                  }
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UsedSoundScreen(
                                                              songId:
                                                                  passSongId,
                                                              isSongIdAvailable:
                                                                  isSongIdAvailable,
                                                            )),
                                                  );
                                                  print("open sound");
                                                },
                                                child: Row(children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10, right: 2),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: SvgPicture.asset(
                                                      "images/sound_waves.svg",
                                                      width: 15,
                                                      height: 15,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: 20,
                                                      margin: EdgeInsets.only(
                                                          left: 5, right: 2),
                                                      child: Marquee(
                                                        text: originalsound!,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              )
                                            : Container(),
                                      ]))),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(left: 10, bottom: 10),
                              width: 100.0,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            showSpinner = true;
                                          });
                                          _controller.pause();
                                          Share.share(videoLink)
                                              .then((value) {
                                            return setState(() {
                                              showSpinner = false;
                                            });
                                          });
                                        },
                                        child: _getSocialAction(
                                          icon: "images/share.svg",
                                          title: 'Share',
                                        )),
                                    InkWell(
                                        onTap: () {
                                          Constants.checkNetwork()
                                              .whenComplete(() =>
                                                  callApiForGetComment(
                                                      videoId));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: _getSocialAction(
                                              icon: "images/comments.svg",
                                              title: commentCount),
                                        )),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isLike = !isLike!;
                                        });
                                        if (isLike == true) {
                                          _iconAnimationController
                                              .forward()
                                              .then((value) {
                                            _iconAnimationController
                                                .reverse();
                                          });
                                        }
                                        callApiForLikedvideo(
                                            videoId, context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: _getSocialActionLike(
                                            icon: isLike == true
                                                ? "images/red_heart.svg"
                                                : "images/white_heart.svg",
                                            title: likeCount),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSocialAction({required String title, required String icon}) {
    return Container(
        margin: EdgeInsets.only(top: 15.0),
        width: 60.0,
        height: 60.0,
        child: Column(children: [
          SvgPicture.asset(icon),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(title,
                style: TextStyle(fontSize: 14, color: Colors.white)),
          )
        ]));
  }

  Widget _getSocialActionLike({required String title, required String icon}) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      width: 60.0,
      height: 60.0,
      child: Column(
        children: [
          ScaleTransition(
            scale: _iconAnimationController,
            child: SvgPicture.asset(
              icon,
              height: 27,
              width: 27,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(title,
                style: TextStyle(fontSize: 14, color: Colors.white)),
          )
        ],
      ),
    );
  }














  Future<void> callApiForSingleVideo() async {
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData()).getsinglevideo(userId).then((response) {
      callApiForViewVideo();
      if (response.success == true) {
        setState(() {
          showSpinner = false;
        });
        setState(() {
          videoId = response.data!.id;
          videoLink = response.data!.imagePath! + response.data!.video!;
          isComment = response.data!.isComment.toString();
          commentCount = response.data!.commentCount.toString();
          likeCount = response.data!.likeCount.toString();
          viewCount = response.data!.viewCount.toString();
          isLike = response.data!.isLike;
          isSaved = response.data!.isSaved.toString();
          isReported = response.data!.isReported.toString();
          username = response.data!.user!.name;
          userimage =
              response.data!.user!.imagePath! + response.data!.user!.image!;
          if (response.data!.originalAudio != null) {
            originalsound = response.data!.originalAudio;
          }
          if (response.data!.description != null) {
            status = response.data!.description.toString();
          } else {
            status = 'The Status is Empty';
          }
          songId = response.data!.songId.toString();
          audioId = response.data!.audioId.toString();
          print("videolink:$videoLink");
        });
        _controller = VideoPlayerController.network(videoLink)
          ..initialize().then((value) => {setState(() {})});
        _controller.setLooping(true);

        _controller.play();
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
    });
  }

  void callApiForViewVideo() {
    RestClient(ApiHeader().dioData()).viewVideo(userId).then((response) {
      print(response);
    }).catchError((Object obj) {
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  callApiForGetComment(int? id) {
    _controller.pause();
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).getvideocomment(id).then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
          commentlist.clear();
          _openCommentLayout();
        });
        setState(() {
          if (response.data!.length != 0) {
            commentlist.addAll(response.data!);
          }
        });
      } else {
        setState(() {
          showSpinner = false;
          _openCommentLayout();
        });
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());



      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  callApiForPostComment(String comment, BuildContext context, int? id) {
    print("likeid:$id");
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .postcomment(id.toString(), comment)
        .then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);
      if (sucess == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Navigator.pop(context);
          _textCommentController.clear();

          Constants.checkNetwork().whenComplete(() => callApiForSingleVideo());
        });
      } else {
        setState(() {
          showSpinner = false;

        });
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());


      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  void callApiForlikeComment(int? id, BuildContext context, int index) {
    print("likeid:$id");
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).likecomment(id).then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);
      if (sucess == true) {
        setState(() {
          showSpinner = false;

          Navigator.pop(context);
        });
      } else {
        setState(() {
          showSpinner = false;

        });
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());


      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  void callApiForLikedvideo(int? id, BuildContext context) {
    print("likeid:$id");
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).likevideo(id).then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print("likevideosucees:$sucess");
      if (sucess == true) {
        if (mounted) {
          setState(() {
            showSpinner = false;

            print("likevidmsg:${body['msg']}");

            Constants.checkNetwork()
                .whenComplete(() => callApiForSingleVideo());
          });
        } else {
          showSpinner = false;

          print("likevidmsg:${body['msg']}");

          Constants.checkNetwork().whenComplete(() => callApiForSingleVideo());
        }
      } else {
        if (mounted) {
          setState(() {
            showSpinner = false;
            var msg = body['msg'];
            Constants.toastMessage(msg);
          });
        } else {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
        }
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

  void choiceAction(String choice) {
    if (choice == "Delete Comment") {
      print('delete comment');
      callApiForDeleteComment(selectedCommentId, context);
    } else if (choice == "Report Comment") {
      print('Report Comment');
      callApiForReportReason(selectedCommentId);
    }
  }

  void callApiForDeleteComment(int? id, BuildContext context) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).deleteComment(id).then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);
      if (sucess == true) {
        if (mounted) {
          setState(() {
            showSpinner = false;
            var msg = body['msg'];
            Constants.toastMessage(msg);
            Navigator.of(context).pop();

            Constants.checkNetwork()
                .whenComplete(() => callApiForSingleVideo());
          });
        } else {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Navigator.of(context).pop();

          Constants.checkNetwork().whenComplete(() => callApiForSingleVideo());
        }
      } else {
        if (mounted) {
          setState(() {
            showSpinner = false;
            var msg = body['msg'];
            Constants.toastMessage(msg);
            Navigator.of(context).pop();

            Constants.checkNetwork()
                .whenComplete(() => callApiForSingleVideo());
          });
        } else {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Navigator.of(context).pop();

          Constants.checkNetwork().whenComplete(() => callApiForSingleVideo());
        }
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());


      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  callApiForReportReason(int? commentId) {
    reportReasonData.clear();
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).reportReason("Comment").then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
          reportReasonData.addAll(response.data!);
          openReportBottomSheet(commentId);
        });
      } else {
        setState(() {
          showSpinner = false;
          Constants.toastMessage(response.msg!);
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

  callApiForReport(commentId, reportId) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .reportComment(commentId.toString(), reportId.toString())
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];

          Constants.toastMessage('$msg');
          Navigator.pop(context);
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage('$msg');
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

  void _openCommentLayout() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            mystate(() {});
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 80, left: 0, bottom: 20),
                    height: ScreenUtil().setHeight(50),
                    color: Color(0xFF1d1d1d),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text("$commentCount comments",
                              style: TextStyle(
                                  color: Color(Constants.whitetext),
                                  fontFamily: Constants.appFont,
                                  fontSize: 16)),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              margin: EdgeInsets.only(right: 20),
                              child: SvgPicture.asset("images/close.svg")),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: commentlist.length > 0
                        ? ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: commentlist.length,
                            itemBuilder: (context, index) {
                              if (commentlist[index].isLike == 1) {
                                commentlist[index].showwhite = false;
                                commentlist[index].showred = true;
                              } else {
                                commentlist[index].showwhite = true;
                                commentlist[index].showred = false;
                              }

                              return Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, bottom: 10),
                                        child: CachedNetworkImage(
                                          alignment: Alignment.center,
                                          imageUrl: commentlist[index]
                                                  .user!
                                                  .imagePath! +
                                              commentlist[index].user!.image!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Color(0xFF36446b),
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundImage: imageProvider,
                                            ),
                                          ),
                                          placeholder: (context, url) => CustomLoader(),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  "images/no_image.png"),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: ListView(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, bottom: 0),
                                              color: Colors.transparent,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    commentlist[index]
                                                        .user!
                                                        .name!,
                                                    style: TextStyle(
                                                        color: Color(
                                                            Constants.greytext),
                                                        fontSize: 14,
                                                        fontFamily:
                                                            Constants.appFont),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                color: Colors.transparent,
                                                child: Text(
                                                  commentlist[index].comment!,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(
                                                          Constants.whitetext),
                                                      fontSize: 14,
                                                      fontFamily:
                                                          Constants.appFont),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: ListView(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  mystate(() {
                                                    commentlist[index]
                                                        .showwhite = true;
                                                    commentlist[index].showred =
                                                        false;
                                                    Constants.checkNetwork()
                                                        .whenComplete(() =>
                                                            callApiForlikeComment(
                                                                commentlist[
                                                                        index]
                                                                    .id,
                                                                context,
                                                                index));
                                                  });
                                                },
                                                child: Visibility(
                                                  visible: commentlist[index]
                                                      .showred,
                                                  child: Container(
                                                    child: SvgPicture.asset(
                                                      "images/red_heart.svg",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  mystate(() {
                                                    commentlist[index]
                                                        .showwhite = false;
                                                    commentlist[index].showred =
                                                        true;
                                                    Constants.checkNetwork()
                                                        .whenComplete(() =>
                                                            callApiForlikeComment(
                                                                commentlist[
                                                                        index]
                                                                    .id,
                                                                context,
                                                                index));
                                                  });
                                                },
                                                child: Visibility(
                                                  visible: commentlist[index]
                                                      .showwhite,
                                                  child: Container(
                                                    child: SvgPicture.asset(
                                                      "images/white_heart.svg",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  commentlist[index]
                                                      .likesCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Color(
                                                          Constants.whitetext),
                                                      fontFamily:
                                                          Constants.appFont,
                                                      fontSize: 14),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: PopupMenuButton<String>(
                                          color: Color(Constants.conbg),
                                          icon: SvgPicture.asset(
                                            "images/more_menu.svg",
                                            width: 20,
                                            height: 20,
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(18.0))),
                                          offset: Offset(20, 20),
                                          onSelected: choiceAction,
                                          itemBuilder: (BuildContext context) {
                                            selectedCommentId =
                                                commentlist[index].id;
                                            return choices.map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(
                                                  choice,
                                                  style: TextStyle(
                                                      color: Color(
                                                          Constants.whitetext),
                                                      fontSize: 14,
                                                      fontFamily: Constants
                                                          .appFontBold),
                                                ),
                                              );
                                            }).toList();
                                          },
                                        )),
                                  ],
                                ),
                              );
                            },
                          )
                        : Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: ScreenUtil().setHeight(80),
                                margin: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 15.0,
                                    right: 15,
                                    bottom: 0),
                                child: Text(
                                  "No Comments Available !",
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
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 0, bottom: 0),
                    height: ScreenUtil().setHeight(50),
                    color: Color(0xFF1d1d1d),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: SvgPicture.asset("images/emojis.svg")),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              autofocus: false,
                              controller: _textCommentController,
                              style: TextStyle(
                                  color: Color(Constants.whitetext),
                                  fontSize: 14,
                                  fontFamily: Constants.appFont),
                              decoration: InputDecoration.collapsed(
                                hintText: "Type Something...",
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
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  if (_textCommentController.text.length > 0) {
                                    Constants.checkNetwork().whenComplete(() =>
                                        callApiForPostComment(
                                            _textCommentController.text,
                                            context,
                                            videoId));
                                  }
                                },
                                child:
                                    SvgPicture.asset("images/post_comment.svg"),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  void openReportBottomSheet(int? commentId) {
    int? value;
    int? reasonId;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter mystate) {
              mystate(() {});
              return Container(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Scaffold(
                  backgroundColor: Color(Constants.bgblack1),
                  bottomNavigationBar: InkWell(
                    onTap: reasonId == null
                        ? null
                        : () {
                            Constants.checkNetwork().whenComplete(
                                () => callApiForReport(commentId, reasonId));
                          },
                    child: Container(
                      height: ScreenUtil().setHeight(50),
                      color: Color(0xff36446B),
                      alignment: Alignment.center,
                      child: Text(
                        'Submit Your Comment Report',
                        style: TextStyle(
                            color: Color(Constants.whitetext),
                            fontSize: 15,
                            fontFamily: Constants.appFont),
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: ScreenUtil().setHeight(50),
                            color: Color(Constants.bgblack1),
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Reason of Report',
                                    style: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontSize: 13,
                                        fontFamily: Constants.appFont),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.close,
                                          color: Colors.white))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.50,
                            child: ListView(


                              children: <Widget>[
                                SingleChildScrollView(
                                  child: ListView.builder(
                                    itemCount: reportReasonData.length,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor:
                                              Color(Constants.whitetext),
                                        ),
                                        child: RadioListTile(
                                          value: index,
                                          groupValue: value,
                                          onChanged: (dynamic val) =>
                                              mystate(() {
                                            reasonId =
                                                reportReasonData[index].id;
                                            value = val;
                                          }),
                                          title: Text(
                                            reportReasonData[index].reason!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color:
                                                    Color(Constants.whitetext),
                                                fontSize: 14,
                                                fontFamily: Constants.appFont),
                                          ),
                                          activeColor:
                                              Color(Constants.whitetext),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
