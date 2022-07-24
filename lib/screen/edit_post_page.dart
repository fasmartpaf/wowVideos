import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:dio/dio.dart';

class EditPost extends StatefulWidget {
  final int? videoId;
  EditPost({Key? key, required this.videoId}) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  bool showSpinner = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController statusController = TextEditingController();
  bool isAdvanceOpen = false;
  int? _radioValue = 0;
  int showComment = 0;
  String seeProfile = 'public';
  bool isComment = true;

  void _handleRadioValueChange(int? value) {
    setState(
      () {
        _radioValue = value;
        switch (_radioValue) {
          case 0:
            seeProfile = "public";
            break;
          case 1:
            seeProfile = "followers";
            break;
          case 2:
            seeProfile = "private";
            break;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    callApiForGetEditDataVideo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Container(
                margin: EdgeInsets.only(left: 0), child: Text("Edit Video")),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Constants.checkNetwork()
                      .whenComplete(() => callApiForEditPost());
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20, top: 5),
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
                return new Stack(
                  children: <Widget>[
                    new SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 0, right: 10),
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Edit Status",
                                  style: TextStyle(
                                      color: Color(Constants.greytext),
                                      fontSize: 14,
                                      fontFamily: Constants.appFont),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  controller: statusController,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Edit Status Here",
                                    hintStyle: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontSize: 16,
                                        fontFamily: Constants.appFont),
                                  ),
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                ),
                              ),
                              Container(
                                child: Divider(
                                  color: Color(Constants.greytext),
                                  thickness: 1,
                                ),
                              ),
                              Container(
                                height: ScreenUtil().setHeight(55),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isAdvanceOpen = !isAdvanceOpen;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "Advance Settings",
                                          style: TextStyle(
                                              color: Color(Constants.greytext),
                                              fontSize: 14,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 0, top: 2),
                                        child: isAdvanceOpen == false
                                            ? SvgPicture.asset(
                                                "images/advanced_status-down.svg")
                                            : SvgPicture.asset(
                                                "images/advanced_status.svg"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isAdvanceOpen,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Like & Comments",
                                    style: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontSize: 16,
                                        fontFamily: Constants.appFont),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isAdvanceOpen,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isComment = !isComment;
                                        if (isComment == true) {
                                          showComment = 1;
                                        } else {
                                          showComment = 0;
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Comments",
                                            style: TextStyle(
                                                color:
                                                    Color(Constants.whitetext),
                                                fontSize: 16,
                                                fontFamily: Constants.appFont),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: Transform.scale(
                                              scale: 1.1,
                                              child: FlutterSwitch(
                                                height: 25,
                                                width: 45,
                                                borderRadius: 30,
                                                padding: 5.5,
                                                duration:
                                                    Duration(milliseconds: 400),
                                                activeColor: Color(
                                                    Constants.lightbluecolor),
                                                activeToggleColor:
                                                    Color(Constants.bgblack),
                                                inactiveToggleColor:
                                                    Color(Constants.bgblack),
                                                inactiveColor:
                                                    Color(Constants.greytext),
                                                toggleSize: 15,
                                                value: isComment,
                                                onToggle: (val) {
                                                  setState(() {
                                                    isComment = val;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Divider(
                                  color: Color(Constants.greytext),
                                  thickness: 1,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Who can see your profile",
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                ),
                              ),
                              Container(
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor:
                                        Color(Constants.whitetext),
                                  ),
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    value: 0,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                    title: Text(
                                      "Everyone",
                                      style: TextStyle(
                                          color: Color(Constants.whitetext),
                                          fontFamily: Constants.appFont,
                                          fontSize: 16),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    activeColor: Color(Constants.whitetext),
                                  ),
                                ),
                              ),
                              Container(
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor:
                                        Color(Constants.whitetext),
                                  ),
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: Color(Constants.whitetext),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: 1,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                    title: Text(
                                      "Only People Who Follow You",
                                      style: TextStyle(
                                          color: Color(Constants.whitetext),
                                          fontFamily: Constants.appFont,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor:
                                        Color(Constants.whitetext),
                                  ),
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: Color(Constants.whitetext),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: 2,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                    title: Text(
                                      "Only Me",
                                      style: TextStyle(
                                          color: Color(Constants.whitetext),
                                          fontFamily: Constants.appFont,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Divider(
                                  color: Color(Constants.greytext),
                                  thickness: 1,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Language",
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                ),
                              ),
                              Container(
                                height: ScreenUtil().setHeight(55),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 0),
                                      child: Text(
                                        "English",
                                        style: TextStyle(
                                            color: Color(Constants.greytext),
                                            fontSize: 14,
                                            fontFamily: Constants.appFont),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 0, top: 2),


                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )),
    );
  }

  void callApiForGetEditDataVideo() {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .getsinglevideo(widget.videoId)
        .then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
          statusController.text = response.data!.description!;
          if (response.data!.isComment == 1) {
            isComment = true;
            showComment = 1;
          } else {
            isComment = false;
            showComment = 0;
          }
          if (response.data!.view == "public") {
            _radioValue = 0;
          } else if (response.data!.view == "followers") {
            _radioValue = 1;
          } else if (response.data!.view == "private") {
            _radioValue = 2;
          }
        });
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

  void callApiForEditPost() {
    Map<String, dynamic> body = {
      "description": statusController.text,
      "view": seeProfile,
      "is_comment": showComment,
      "video_id": widget.videoId
    };
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).editVideo(body).then((response) {
      setState(() {
        showSpinner = false;
      });
      if (response.success!) {
        Constants.toastMessage(response.msg!);
        Navigator.pop(context);
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
}
