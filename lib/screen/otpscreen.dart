import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/services.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/widget/app_lable_widget.dart';
import 'package:acoustic/widget/card_textfield.dart';
import 'package:acoustic/widget/rounded_corner_app_button.dart';
import 'package:acoustic/widget/app_toolbar.dart';
import 'dart:ui';
import 'package:acoustic/widget/transitions.dart';
import 'package:acoustic/screen/loginscreen.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/util/preferenceutils.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreen createState() => _OtpScreen();
}

class _OtpScreen extends State<OtpScreen> {
  bool isRememberMe = false;

  final _textOtp = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  bool _autoValidate = false;
  bool showSpinner = false;
  String deviceToken = "";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
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
          appBar: ApplicationToolbar(appbarTitle: 'Set OTP'),
          backgroundColor: Color(Constants.bgblack),
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
                    SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppLableWidget(
                                title: 'One Time Password',
                              ),
                              CardTextFieldWidget(
                                focus: (v) {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                                hintText: 'Set Your OTP Here',
                                textInputType: TextInputType.number,
                                textEditingController: _textOtp,
                                validator: Constants.kvalidateotp,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 20, right: 10),
                                child: AppLableWidget(
                                  title:
                                      'Set your OTP(One Time Password) here which one mention on your mail.',
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 20),
                                alignment: Alignment.center,
                                child: InkWell(
                                    onTap: () {
                                      Constants.checkNetwork().whenComplete(
                                          () => callApiForResendOtp(context));
                                    },
                                    child: Text(
                                      "Resend OTP!!!",
                                      style: TextStyle(
                                          color: Color(Constants.whitetext),
                                          fontSize: 18,
                                          fontFamily: Constants.appFontBold),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: RoundedCornerAppButton(
                            onPressed: () {







                              String otp = _textOtp.text.toString();
                              Constants.checkNetwork().whenComplete(
                                  () => callApiForCheckOtp(otp, context));
                            },
                            btnLabel: 'Continue',
                          ),
                        ),
                      ),
                    )
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

  void callApiForCheckOtp(String otp, BuildContext context) {
    String userid = PreferenceUtils.getString(Constants.id);
    print("userid:$userid");

    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).checkOtp(otp, userid).then((response) {
      print(response.toString());
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);

      if (sucess == true) {
        setState(() {
          showSpinner = false;
        });

        var token = body['data']['token'];
        Constants.toastMessage("OTP Match");

        PreferenceUtils.setString(Constants.headerToken, token);
        print(token);

        PreferenceUtils.setString(Constants.id, body['data']['id'].toString());
        PreferenceUtils.setString(Constants.name, body['data']['name']);
        PreferenceUtils.setString(Constants.userId, body['data']['user_id']);
        PreferenceUtils.setverify(Constants.isverified, true);
        Navigator.of(this.context).push(Transitions(
            transitionType: TransitionType.slideUp,
            curve: Curves.bounceInOut,
            reverseCurve: Curves.fastLinearToSlowEaseIn,
            widget: LoginScreen()));
      } else if (sucess == false) {
        setState(() {
          showSpinner = false;
        });
        var msg = body['msg'];
        Constants.toastMessage(body['msg'].toString());
        print(msg);

      }
    }).catchError((Object obj) {
      setState(() {
        showSpinner = false;
      });

      print("error:$obj.");
      print(obj.runtimeType);

      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          print(res);

          var responsecode = res.statusCode;

          if (responsecode == 401) {
            print("Got error : ${res.statusCode} -> ${res.statusMessage}");
            setState(() {
              showSpinner = false;
            });
          } else if (responsecode == 422) {
            print("Invalid Data");
            setState(() {
              showSpinner = false;
            });
          }

          break;
        default:
          setState(() {
            showSpinner = false;
          });
      }
    });
  }

  void callApiForResendOtp(BuildContext context) {
    String userEmail = PreferenceUtils.getString(Constants.email);
    print("userid:$userEmail");

    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).sendotp(userEmail).then((response) {
      print(response.toString());
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);

      if (sucess == true) {
        setState(() {
          showSpinner = false;
        });

        Constants.toastMessage("OTP sended");
        Constants.createSnackBar(
            "OTP sended", context, Color(Constants.lightbluecolor));
      } else if (sucess == false) {
        setState(() {
          showSpinner = false;
        });
        var msg = body['msg'];
        print(msg);
        Constants.createSnackBar(msg, context, Color(Constants.redtext));
      }
    }).catchError((Object obj) {
      setState(() {
        showSpinner = false;
      });

      print("error:$obj.");
      print(obj.runtimeType);

      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          print(res);

          var responsecode = res.statusCode;

          if (responsecode == 401) {
            print("Got error : ${res.statusCode} -> ${res.statusMessage}");
            setState(() {
              showSpinner = false;
            });
          } else if (responsecode == 422) {
            print("Invalid Data");
            setState(() {
              showSpinner = false;
            });
          }

          break;
        default:
          setState(() {
            showSpinner = false;
          });
      }
    });
  }
}
