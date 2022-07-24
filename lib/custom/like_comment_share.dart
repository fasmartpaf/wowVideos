import 'dart:convert';

import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/model/report_reason.dart';
import 'package:acoustic/model/videocomment.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';

import 'loader_custom_widget.dart';

class CustomLikeComment extends StatefulWidget {
  int index;
  String shareLink;
  String commentCount;


  bool? isLike;
  List listOfAll;


  CustomLikeComment({
    required this.index,
    required this.shareLink,
    required this.commentCount,

    required this.isLike,
    required this.listOfAll,

  });

  @override
  _CustomLikeCommentState createState() => _CustomLikeCommentState();
}

class _CustomLikeCommentState extends State<CustomLikeComment> {
  List trendingVidList = [];
  List<CommentData> commentList = <CommentData>[];
  bool deleteOptionAvailable = false;
  static const List<String> choices = <String>[
    "Delete Comment",
    "Report Comment"
  ];
  static const List<String> choicesReportOnly = <String>["Report Comment"];
  int? selectedCommentId = 0;
  int? removeVideoIndex;

  final _textCommentController = TextEditingController();

  String likeCount = '';

  List<ReportReasonData> reportReasonData = [];

  @override
  void initState() {
    super.initState();
    trendingVidList = widget.listOfAll;
    likeCount = trendingVidList[widget.index].likeCount.toString();
  }

  void sharePost() {
    setState(() {

    });
    Share.share(widget.shareLink).whenComplete(() {
      setState(() {

      });
    });
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
          child:
              Text(title, style: TextStyle(fontSize: 14, color: Colors.white)),
        ),
      ]),
    );
  }

  Widget _getSingleAction({required String icon}) {
    return Container(
        margin: EdgeInsets.only(top: 15.0, bottom: 20),
        width: 25.0,
        height: 25.0,
        child: SvgPicture.asset(icon));
  }

  void choiceAction(String choice) {
    if (choice == "Delete Comment") {
      print('delete comment');
      callApiForDeleteComment(selectedCommentId, context);
      removeCommentsCount(videoId: removeVideoIndex);
    } else if (choice == "Report Comment") {
      print('Report Comment');
      callApiForReportCommentReason(selectedCommentId);
    }
  }

  void choiceActionOnlyReport(String choice) {
    if (choice == "Report Comment") {
      print('Report Comment');
      callApiForReportCommentReason(selectedCommentId);
    }
  }










  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(left: 10, bottom: 10),
      width: 100.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          InkWell(
            onTap: () {
              sharePost();
            },
            child: _getSocialAction(
              icon: "images/share.svg",
              title: 'Share',
            ),
          ),
          ///comment
          trendingVidList[widget.index].isComment == 1
              ? InkWell(
                  onTap: () {
                    if (PreferenceUtils.getlogin(Constants.isLoggedIn) ==
                        true) {
                      if (mounted) {
                        Constants.checkNetwork()
                            .whenComplete(() => callApiForGetComment());
                      }
                    } else {
                      Constants.toastMessage('Please Login First To Comment');
                    }

                  },
                  child: _getSocialAction(
                    icon: "images/comments.svg",
                    title:
                        trendingVidList[widget.index].commentCount.toString(),
                  ),
                )
              : Container(),
          ///like
          InkWell(
            onTap: () async {
              if (PreferenceUtils.getlogin(Constants.isLoggedIn) == true) {



                int likeCountConvert = int.parse(this.likeCount.toString());
                if (trendingVidList[widget.index].isLike == true) {
                  likeCountConvert -= 1;
                } else {
                  likeCountConvert += 1;
                }
                likeCount = likeCountConvert.toString();
                updateLike(
                  videoId: trendingVidList[widget.index].id,
                  totalLikes: likeCount,
                  videoLike: !trendingVidList[widget.index].isLike!,
                );
                print('converted like  $likeCount');
                Constants.checkNetwork().whenComplete(
                  () => callApiForLikedVideo(
                      trendingVidList[widget.index].id, context),
                );
              } else {
                Constants.toastMessage('Please login first to like video');
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 15.0),
              width: 60.0,
              height: 60.0,
              child: Column(
                children: [
                  SvgPicture.asset(
                    "images/red_heart.svg",
                    color: trendingVidList[widget.index].isLike == true
                        ? Color(
                            Constants.redtext,
                          )
                        : Color(
                            Constants.whitetext,
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      trendingVidList[widget.index].likeCount.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ///more options
          trendingVidList[widget.index].isYou == false
              ? InkWell(
                  onTap: () {
                    if (PreferenceUtils.getlogin(Constants.isLoggedIn) ==
                        true) {
                      _openSavedBottomSheet(
                          trendingVidList[widget.index].id,
                          trendingVidList[widget.index].isSaved,
                          trendingVidList[widget.index].user!.id);
                    } else {
                      Constants.toastMessage(
                          'Login please to access this option');
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: _getSingleAction(icon: "images/more_menu.svg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void updateLike({int? videoId, String? totalLikes, bool? videoLike}) {
    final tile = widget.listOfAll.firstWhere((item) => item.id == videoId);
    setState(() {
      tile.likeCount = totalLikes;
      tile.isLike = videoLike;
    });
  }

  removeCommentsCount({int? videoId}) {
    final tile = widget.listOfAll.firstWhere((item) => item.id == videoId);
    setState(() {
      int commentCount = int.parse(tile.commentCount.toString());
      commentCount -= 1;
      tile.commentCount = commentCount.toString();
    });
  }

  void callApiForLikedVideo(int? id, BuildContext context) {
    print("likeid:$id");

    setState(() {

    });
    RestClient(ApiHeader().dioData()).likevideo(id).then(
      (response) {
        final body = json.decode(response!);
        bool? sucess = body['success'];
        print("likevideosucees:$sucess");

        if (sucess == true) {
          setState(
            () {



              print("likevidmsg:${body['msg']}");







            },
          );
        } else {
          setState(
            () {

              var msg = body['msg'];
              Constants.toastMessage(msg);





            },
          );
        }
      },
    ).catchError((Object obj) {
      Constants.toastMessage("Server Error");




      setState(() {

      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  callApiForGetComment() {
    setState(() {

    });
    RestClient(ApiHeader().dioData())
        .getvideocomment(widget.listOfAll[widget.index].id)
        .then((response) {
      if (response.success == true) {
        setState(() {

          commentList.clear();

          _openCommentLayout(widget.index, widget.listOfAll[widget.index].id);
        });
        setState(() {
          if (response.data!.length != 0) {
            commentList.addAll(response.data!);
          }
        });
      } else {
        setState(() {

          _openCommentLayout(widget.index, widget.listOfAll[widget.index].id);
        });
      }
    }).catchError((Object obj) {


      Constants.toastMessage(obj.toString());


      setState(() {

      });
      print("error:$obj");
      print(obj.runtimeType);

    });
  }

  callApiForReportVideoReason(int? videoId) {
    reportReasonData.clear();
    setState(() {

    });
    RestClient(ApiHeader().dioData()).reportReason("Video").then((response) {
      if (response.success == true) {
        setState(() {

          reportReasonData.addAll(response.data!);
          openReportBottomSheet(videoId);
        });
      } else {
        setState(() {

          Constants.toastMessage(response.msg!);
        });
      }
    }).catchError((Object obj) {
      print(obj.toString());
      Constants.toastMessage(obj.toString());
      if (mounted)
        setState(() {

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

    });
    RestClient(ApiHeader().dioData())
        .blockuser(userid.toString(), "User")
        .then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);

      if (sucess == true) {
        setState(() {

          var msg = body['msg'];

          Constants.toastMessage(msg);




        });
      } else {
        setState(() {

          var msg = body['msg'];
          Constants.toastMessage(msg);



        });
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());




      setState(() {

      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  callApiForReportCommentReason(int? commentId) {
    reportReasonData.clear();
    setState(() {

    });
    RestClient(ApiHeader().dioData()).reportReason("Comment").then((response) {
      if (response.success == true) {
        setState(() {

          reportReasonData.addAll(response.data!);
          openReportBottomSheetComment(commentId);
        });
      } else {
        setState(() {

          Constants.toastMessage(response.msg!);
        });
      }
    }).catchError((Object obj) {
      print(obj.toString());
      Constants.toastMessage(obj.toString());
      if (mounted)
        setState(() {

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

  void callApiForNotInterestedVideo(int? videoId) {
    setState(() {

    });
    RestClient(ApiHeader().dioData()).notInterested(videoId).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          Navigator.pop(context);

          var msg = body['msg'];
          Constants.toastMessageLongTime(msg);
        });
      } else {
        setState(() {
          Navigator.pop(context);

          var msg = body['msg'];
          Constants.toastMessageLongTime(msg);
        });
      }
    }).catchError((Object obj) {
      print(obj.toString());
      Constants.toastMessage(obj.toString());
      if (mounted)
        setState(() {

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

  void callApiForSaveVideo(int? id) {
    print("likeid:$id");
    setState(() {

    });
    RestClient(ApiHeader().dioData()).savevideo(id).then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);
      if (sucess == true) {
        setState(() {

          var msg = body['msg'];
          Constants.toastMessage(msg);





        });
      } else {
        setState(() {

          var msg = body['msg'];
          Constants.toastMessage(msg);

        });
      }
    }).catchError((Object obj) {


      Constants.toastMessage(obj.toString());
      setState(() {

      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  updateCommentsCount({int? videoId}) {
    final tile = widget.listOfAll.firstWhere((item) => item.id == videoId);
    setState(() {
      int commentCount = int.parse(tile.commentCount.toString());
      commentCount += 1;
      tile.commentCount = commentCount.toString();
    });
  }

  void callApiForDeleteComment(int? id, BuildContext context) {
    setState(() {

    });
    RestClient(ApiHeader().dioData()).deleteComment(id).then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);
      if (sucess == true) {
        if (mounted) {
          setState(() {

            var msg = body['msg'];
            Constants.toastMessage(msg);
            Navigator.of(context).pop();



          });
        } else {

          var msg = body['msg'];
          Constants.toastMessage(msg);
          Navigator.of(context).pop();


        }
      } else {
        if (mounted) {
          setState(() {

            var msg = body['msg'];
            Constants.toastMessage(msg);
            Navigator.of(context).pop();
          });
        } else {

          var msg = body['msg'];
          Constants.toastMessage(msg);
          Navigator.of(context).pop();
        }
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());


      setState(() {

      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  callApiForReport(videoId, reportId) {
    setState(() {

    });
    RestClient(ApiHeader().dioData())
        .reportVideo(videoId.toString(), reportId.toString())
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {

          var msg = body['msg'];


          Constants.toastMessage('$msg');
          Navigator.pop(context);
        });
      } else {
        setState(() {

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

  void _openSavedBottomSheet(int? id, int? isSaved, int? userid) {
    print("savedid123:$id");
    print("isSaved123:$isSaved");

    String save = "Save";

    if (isSaved == 1) {
      save = "UnSave";
    } else if (isSaved == 0) {
      save = "Save";
    }

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
                      Navigator.pop(context);
                      if (PreferenceUtils.getlogin(Constants.isLoggedIn) ==
                          true) {
                        Constants.checkNetwork().whenComplete(
                            () => callApiForReportVideoReason(id));
                      } else {
                        Constants.toastMessage('Please Login First To Report');
                      }


                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "Report",
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
                      Constants.checkNetwork()
                          .whenComplete(() => callApiForBlockUser(userid));
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
                      Constants.checkNetwork()
                          .whenComplete(() => callApiForNotInterestedVideo(id));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        "I'm Not Interested",
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
                      Constants.checkNetwork()
                          .whenComplete(() => callApiForSaveVideo(id));
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      height: ScreenUtil().setHeight(50),
                      child: Text(
                        save,
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

  void callApiForlikeComment(int? id, BuildContext context, int index) {
    print("likeid:$id");
    setState(() {

    });
    RestClient(ApiHeader().dioData()).likecomment(id).then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);
      if (sucess == true) {
        setState(() {

          var msg = body['msg'];
          Navigator.pop(context);
          Constants.toastMessage(msg);





        });
      } else {
        setState(() {

          var msg = body['msg'];
          Constants.toastMessage(msg);


        });
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());





      setState(() {

      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  callApiForPostComment(
      String comment, BuildContext context, int? id, int index) {
    print("likeid:$id");
    setState(() {

    });
    RestClient(ApiHeader().dioData())
        .postcomment(id.toString(), comment)
        .then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);
      if (sucess == true) {
        setState(() {
          _textCommentController.clear();
          updateCommentsCount(videoId: widget.listOfAll[index].id);

          var msg = body['msg'];
          Navigator.pop(context);
          Constants.toastMessage('$msg');
        });
      } else {
        setState(() {

          var msg = body['msg'];
          Constants.toastMessage('$msg');


        });
      }
    }).catchError((Object obj) {
      Constants.toastMessage(obj.toString());


      setState(() {

      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  callApiForReportComment(commentId, reportId) {
    setState(() {

    });
    RestClient(ApiHeader().dioData())
        .reportComment(commentId.toString(), reportId.toString())
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {

          var msg = body['msg'];
          Constants.toastMessage('$msg');
          Navigator.pop(context);
        });
      } else {
        setState(() {

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

  void _openCommentLayout(int index1, videoIndex) {
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
                          child: Text(
                              widget.listOfAll[index1].commentCount.toString() +
                                  " comments",
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
                    child: commentList.length > 0
                        ? ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: commentList.length,
                            itemBuilder: (context, index) {
                              if (commentList[index].isLike == 1) {
                                commentList[index].showwhite = false;
                                commentList[index].showred = true;
                              } else {
                                commentList[index].showwhite = true;
                                commentList[index].showred = false;
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
                                          imageUrl: commentList[index]
                                                  .user!
                                                  .imagePath! +
                                              commentList[index].user!.image!,
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
                                          placeholder: (context, url) =>CustomLoader(),
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
                                                    commentList[index]
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
                                                  commentList[index].comment!,
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
                                                    commentList[index]
                                                        .showwhite = true;
                                                    commentList[index].showred =
                                                        false;
                                                    Constants.checkNetwork()
                                                        .whenComplete(() =>
                                                            callApiForlikeComment(
                                                                commentList[
                                                                        index]
                                                                    .id,
                                                                context,
                                                                index));
                                                  });
                                                },
                                                child: Visibility(
                                                  visible: commentList[index]
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
                                                    commentList[index]
                                                        .showwhite = false;
                                                    commentList[index].showred =
                                                        true;
                                                    Constants.checkNetwork()
                                                        .whenComplete(() =>
                                                            callApiForlikeComment(
                                                                commentList[
                                                                        index]
                                                                    .id,
                                                                context,
                                                                index));
                                                  });
                                                },
                                                child: Visibility(
                                                  visible: commentList[index]
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
                                                  commentList[index]
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
                                          onSelected:
                                              commentList[index].canDelete == 1
                                                  ? choiceAction
                                                  : choiceActionOnlyReport,
                                          itemBuilder: (BuildContext context) {
                                            selectedCommentId =
                                                commentList[index].id;
                                            removeVideoIndex = videoIndex;
                                            if (commentList[index].canDelete ==
                                                1) {
                                              return choices
                                                  .map((String choice) {
                                                return PopupMenuItem<String>(
                                                  value: choice,
                                                  child: Text(
                                                    choice,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontSize: 14,
                                                        fontFamily: Constants
                                                            .appFontBold),
                                                  ),
                                                );
                                              }).toList();
                                            } else {
                                              return choicesReportOnly
                                                  .map((String choice) {
                                                return PopupMenuItem<String>(
                                                  value: choice,
                                                  child: Text(
                                                    choice,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontSize: 14,
                                                        fontFamily: Constants
                                                            .appFontBold),
                                                  ),
                                                );
                                              }).toList();
                                            }
                                          },
                                        )








                                        ),
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
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  if (trendingVidList[index1]
                                          .user
                                          .isCommentBlock ==
                                      0) {
                                    if (_textCommentController.text.length >
                                        0) {
                                      Constants.checkNetwork().whenComplete(
                                        () => callApiForPostComment(
                                            _textCommentController.text,
                                            context,
                                            widget.listOfAll[index1].id,
                                            index1),
                                      );
                                    }
                                  } else {
                                    Constants.toastMessage(
                                        "${trendingVidList[index1].user.name} Blocked Comment");
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

  void openReportBottomSheet(int? videoId) {
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
                                () => callApiForReport(videoId, reasonId));
                          },
                    child: Container(
                      height: ScreenUtil().setHeight(50),
                      color: Color(0xff36446B),
                      alignment: Alignment.center,
                      child: Text(
                        'Submit Report',
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

  void openReportBottomSheetComment(int? commentId) {
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
                            Constants.checkNetwork().whenComplete(() =>
                                callApiForReportComment(commentId, reasonId));
                          },
                    child: Container(
                      height: ScreenUtil().setHeight(50),
                      color: Color(0xff36446B),
                      alignment: Alignment.center,
                      child: Text(
                        'Submit Report',
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
