import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
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
import 'package:acoustic/screen/forgototp.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  bool isRememberMe = false;

  final textEmail = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
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
          appBar: ApplicationToolbar(appbarTitle: 'Forgot Password'),
          backgroundColor: Color(Constants.bgblack),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator:
            CustomLoader(),
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
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppLableWidget(
                                title: 'Email Address',
                              ),
                              CardTextFieldWidget(
                                focus: (v) {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                                hintText: 'Email Address',
                                textInputType: TextInputType.emailAddress,
                                textEditingController: textEmail,
                                validator: Constants.kvalidateEmail,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 20, right: 10),
                                child: AppLableWidget(
                                  title:
                                      'Check your mail ID we will share with you a one OTP password in your email account as you above.',
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 20,
                              ),
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
                              //set the form field in all tabs
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                Constants.checkNetwork()
                                    .then((value) => callApiForForgotEmail());
                              }
                            },
                            btnLabel: 'Submit',
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

  void callApiForForgotEmail() {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).sendotp(textEmail.text).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      print(success);

      if (success == true) {
        setState(() {
          showSpinner = false;
        });
        textEmail.clear();
        var msg = body['msg'];
        Constants.toastMessage(msg);
        var userId = body['data']['id'];
        Navigator.of(context).push(Transitions(
            transitionType: TransitionType.slideLeft,
            curve: Curves.bounceInOut,
            reverseCurve: Curves.fastLinearToSlowEaseIn,
            widget: ForgotOtpScreen(
              userId: userId,
            )));
      } else if (success == false) {
        setState(() {
          showSpinner = false;
        });
        var msg = body['msg'];
        print(msg);
        Constants.toastMessage(msg);
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
