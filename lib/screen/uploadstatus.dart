import 'dart:convert';
import 'dart:io';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:acoustic/screen/homescreen.dart';
import 'package:acoustic/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UploadStatusScreen extends StatefulWidget {
  final String videoPath;
  final String thumbPath;
  final String videoFileName;
  final String songId;
  final int duration;
  final String fromWhere;
  final String? sound;
  final String? cutAudio;
  UploadStatusScreen(
      {Key? key,
      required this.videoPath,
      required this.thumbPath,
      required this.videoFileName,
      required this.songId,
      required this.duration,
      required this.fromWhere,
      required this.sound,
      this.cutAudio})
      : super(key: key);
  @override
  _UploadStatusScreen createState() => _UploadStatusScreen();
}

class _UploadStatusScreen extends State<UploadStatusScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  bool isComment = true;
  bool isAdvanceOpen = false;
  int? _radioValue = 0;
  int showComment = 0;
  String seeProfile = 'public';
  String? passScreenshotImage;
  String? passCutAudio;
  String? passVideoInBase64;
  TextEditingController statusController = TextEditingController();
  late LocationData _locationData;
  Location location = new Location();

  void _handleRadioValueChange(int? value) {
    setState(() {
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
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          opacity: 1.0,
          color: Colors.transparent.withOpacity(0.2),
          progressIndicator: CustomLoader(),
          child: Scaffold(
              appBar: AppBar(
                title: Container(
                    margin: EdgeInsets.only(left: 0),
                    child: Text("Upload Status")),
                centerTitle: false,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                automaticallyImplyLeading: true,
                actions: <Widget>[
                  InkWell(
                    onTap: () {


                      setState(() {
                        showSpinner = true;
                      });
                      Constants.checkNetwork()
                          .whenComplete(() => postDataWithToken());


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
              body: LayoutBuilder(
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
                                    "Add Status",
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
                                      hintText: "Add Status Here",
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
                                                color:
                                                    Color(Constants.greytext),
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
                                          children: [
                                            Text(
                                              "Comments",
                                              style: TextStyle(
                                                  color: Color(
                                                      Constants.whitetext),
                                                  fontSize: 16,
                                                  fontFamily:
                                                      Constants.appFont),
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
                                                  duration: Duration(
                                                      milliseconds: 400),
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
                                        margin:
                                            EdgeInsets.only(left: 0, top: 2),
                                        child: SvgPicture.asset(
                                            "images/language_down.svg"),
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
              )),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to go back'),
            actions: <Widget>[
              IconButton(onPressed: (){Navigator.of(context).pop(false);}, icon: Text("NO")),







              SizedBox(
                width: 10.0,
              ),
              IconButton(onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen(0)));
              }, icon: Text("YES"))









            ],
          ),
        )) ??
        false as Future<bool>;
  }













  var fullUrl = Uri.parse("${Constants.baseUrl}upload_video");

  Future postDataWithToken() async {
    // convert in base 64 image
    File file = File(widget.thumbPath);
    try {
      List<int> liimageBytes = file.readAsBytesSync();
      String proimageB64 = base64Encode(liimageBytes);
      passScreenshotImage = proimageB64;

      if (widget.fromWhere == 'gallery') {
        File file2 = File(widget.cutAudio!);
        List<int> liimageBytesForMusic = file2.readAsBytesSync();
        String forMusic = base64Encode(liimageBytesForMusic);
        passCutAudio = forMusic;
      }
    } catch (e) {
      print("error is ${e.toString()}");
    }

    var token = PreferenceUtils.getString(Constants.headerToken);

    var request = http.MultipartRequest("POST", fullUrl);
    request.headers['authorization'] = "Bearer $token";
    request.headers['Content-Type'] = "multipart/form-data";
    request.headers['Accept'] = "application/json";

    try {
      request.files.add(
        await http.MultipartFile.fromPath(
          'video',
          widget.videoPath + widget.videoFileName,
          contentType: MediaType('video', 'mp4'),

        ),
      );
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      Constants.toastMessage(e.toString());
      print(e.toString());
    }

    if (widget.fromWhere == "camera") {
      if (widget.songId.isNotEmpty && widget.songId != "") {
        request.fields["song_id"] = widget.songId.toString();
        request.fields["description"] = statusController.text;
        request.fields["screenshot"] = passScreenshotImage!;
        request.fields["view"] = seeProfile;
        request.fields["is_comment"] = showComment.toString();
        request.fields["lat"] = _locationData.latitude.toString();
        request.fields["lang"] = _locationData.longitude.toString();
        request.fields["language"] = "English";
      } else {
        request.fields["audio"] = widget.cutAudio!;
        request.fields["description"] = statusController.text;
        request.fields["screenshot"] = passScreenshotImage!;
        request.fields["view"] = seeProfile;
        request.fields["is_comment"] = showComment.toString();
        request.fields["lat"] = _locationData.latitude.toString();
        request.fields["lang"] = _locationData.longitude.toString();
        request.fields["language"] = "English";
        request.fields["duration"] = widget.duration.toString();
      }
    } else {
      request.fields["description"] = statusController.text;
      request.fields["screenshot"] = passScreenshotImage!;
      request.fields["view"] = seeProfile;
      request.fields["is_comment"] = showComment.toString();
      request.fields["lat"] = _locationData.latitude.toString();
      request.fields["lang"] = _locationData.longitude.toString();
      request.fields["audio"] = passCutAudio!;
      request.fields["language"] = "English";
      request.fields["duration"] = widget.duration.toString();
    }

    try {
      request.send().then((value) {
        setState(() {
          showSpinner = false;
        });
        if (value.statusCode == 200) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomeScreen(0),
              ),
              (Route<dynamic> route) => false);
          Constants.toastMessage('Video Uploaded Successfully');
        } else {
          Constants.toastMessage(
              'Something Went Wrong StatusCode ${value.statusCode}');
          print("success value is ${value.toString()}");
        }
      }).catchError((error) {
        setState(() {
          showSpinner = false;
        });
        Constants.toastMessage(error.toString());
        print('uploading error is ${error.toString()}');
      });
    } catch (error) {
      setState(() {
        showSpinner = false;
      });
      Constants.toastMessage(error.toString());
      print('uploading error is ${error.toString()}');
    }
  }

  Future<void> getLocation() async {
    _locationData = await location.getLocation();
  }
}
