import 'dart:convert';
import 'dart:io';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:dio/dio.dart';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/widget/app_lable_widget.dart';
import 'package:acoustic/widget/card_textfield.dart';
import 'package:acoustic/widget/rounded_corner_app_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ReportProblemScreen extends StatefulWidget {
  final int? userId;

  ReportProblemScreen({Key? key, this.userId}) : super(key: key);

  @override
  _ReportProblemScreen createState() => _ReportProblemScreen();
}

class _ReportProblemScreen extends State<ReportProblemScreen> {
  int currentSelectedIndex = -1;
  var rating = 4.0;
  bool showSpinner = false;
  File? _proImage;
  final picker = ImagePicker();
  String image = "";

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _textReason = TextEditingController();
  final _textIssue = TextEditingController();
  final _textEmail = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _textEmail.text = PreferenceUtils.getString(Constants.email);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new SafeArea(
        child: Scaffold(

            resizeToAvoidBottomInset: true,
            key: _scaffoldKey,
            backgroundColor: Color(Constants.bgblack),
            appBar: AppBar(
              title: Container(
                  margin: EdgeInsets.only(left: 0),
                  child: Text("Report a Problem")),
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
              child: new Stack(
                children: <Widget>[
                  new SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(left: 0, right: 20, top: 10),
                            child: AppLableWidget(
                              title: 'Reason of Report',
                            ),
                          ),
                          CardTextFieldWidget(
                            focus: (v) {
                              FocusScope.of(context).nextFocus();
                            },
                            textInputAction: TextInputAction.next,
                            hintText: 'Enter Reason of Report',
                            textInputType: TextInputType.name,
                            textEditingController: _textReason,
                            validator: Constants.kvalidateReason,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(left: 0, right: 20, top: 10),
                            child: AppLableWidget(
                              title: 'Tell Us Your Problem',
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              "Add Your Issue",
                              style: TextStyle(
                                  color: Color(Constants.whitetext),
                                  fontFamily: Constants.appFont,
                                  fontSize: 16),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: Constants.kvalidateIssue,
                              keyboardType: TextInputType.name,
                              controller: _textIssue,
                              maxLines: 8,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: Constants.appFont),
                              decoration: Constants.kTextFieldInputDecoration
                                  .copyWith(hintText: "Enter Issue"),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(left: 0, right: 20, top: 10),
                            child: AppLableWidget(
                              title: 'Email Address',
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: TextFormField(
                              controller: _textEmail,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                  fontFamily: Constants.appFontBold),
                              readOnly: true,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(left: 0, right: 20, top: 10),
                            child: AppLableWidget(
                              title: 'Add Screenshots',
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(left: 0, right: 20, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _chooseProfileImage();
                                  },
                                  child: _proImage != null
                                      ? Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            child: Image.file(
                                              _proImage!,
                                              width: ScreenUtil().setWidth(65),
                                              height:
                                                  ScreenUtil().setHeight(65),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: SvgPicture.asset(
                                            "images/add_reason.svg",
                                            width: ScreenUtil().setWidth(65),
                                            height: ScreenUtil().setHeight(65),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 30, bottom: 30, left: 30, right: 30),
                            child: RoundedCornerAppButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (_proImage != null) {
                                    callApiForReportProblem();
                                  } else {
                                    Constants.toastMessage(
                                        "Please provide an image");
                                  }
                                }
                              },
                              btnLabel: 'Submit Report',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            )),
      ),
    );
  }

  void _chooseProfileImage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      "From Gallery",
                      style: TextStyle(fontFamily: Constants.appFont),
                    ),
                    onTap: () {
                      _proImgFromGallery();
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Get from gallery
  void _proImgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _proImage = File(pickedFile.path);
        List<int> imageBytes = _proImage!.readAsBytesSync();
        image = base64Encode(imageBytes);
        print("_Proimage:$_proImage");
      } else {
        Constants.toastMessage("No image selected.");

      }
    });
  }

  void callApiForReportProblem() {
    setState(() {
      showSpinner = true;
    });
    List<String> passImage = [];
    if (_proImage != null) {
      List<int> liimageBytes = _proImage!.readAsBytesSync();
      String proimageB64 = base64Encode(liimageBytes);
      passImage.add(proimageB64);
    }
    Map<String, dynamic> body;
    if (_proImage != null) {
      body = {
        "subject": _textReason.text,
        "issue": _textIssue.text,
        "email": _textEmail.text,
        "imgs": json.encode(passImage),
        "user_id": widget.userId,
      };
    } else {
      body = {
        "subject": _textReason.text,
        "issue": _textIssue.text,
        "email": _textEmail.text,
        "user_id": widget.userId,
      };
    }
    RestClient(ApiHeader().dioData()).reportProblem(body).then((response) {
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

  Future<bool> _onWillPop() async {
    return true;
  }
}
