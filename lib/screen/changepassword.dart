import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/widget/app_lable_widget.dart';
import 'package:acoustic/widget/card_password_textfield.dart';
import 'package:acoustic/widget/rounded_corner_app_button.dart';
import 'package:acoustic/widget/app_toolbar.dart';
import 'dart:ui';
import 'package:acoustic/widget/transitions.dart';
import 'package:acoustic/screen/loginscreen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final userId;

  ChangePasswordScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ChangePasswordScreen createState() => _ChangePasswordScreen();
}

class _ChangePasswordScreen extends State<ChangePasswordScreen> {
  bool isRememberMe = false;

  final textNewPassword = TextEditingController();
  final textConfirmPassword = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  bool showSpinner = false;
  String deviceToken = "";
  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  String? validateConfPassword(String? value) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern as String);
    if (value!.length == 0) {
      return "Password is Required";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    } else if (textNewPassword.text != textConfirmPassword.text)
      return 'Password and Confirm Password does not match.';
    else if (!regex.hasMatch(value))
      return 'Password required';
    else
      return null;
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
          appBar: ApplicationToolbar(appbarTitle: 'Set New Password'),
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
                                title: 'New Password',
                              ),
                              CardPasswordTextFieldWidget(
                                  textEditingController: textNewPassword,
                                  validator: Constants.kvalidatePassword,
                                  hintText: 'New Password',
                                  isPasswordVisible: _passwordVisible),
                              AppLableWidget(
                                title: 'Confirm Password',
                              ),
                              CardPasswordTextFieldWidget(
                                  textEditingController: textConfirmPassword,
                                  validator: validateConfPassword,
                                  hintText: 'Confirm Password',
                                  isPasswordVisible: _confirmPasswordVisible),
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
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                callApiForChangePassword();
                              }
                            },
                            btnLabel: 'Change Password',
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

  void callApiForChangePassword() {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .changePassword(widget.userId.toString(), textNewPassword.text,
            textConfirmPassword.text)
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      print(success);

      if (success == true) {
        setState(() {
          showSpinner = false;
        });
        textNewPassword.clear();
        textConfirmPassword.clear();
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Navigator.of(context).push(Transitions(
            transitionType: TransitionType.slideRight,
            curve: Curves.bounceInOut,
            reverseCurve: Curves.fastLinearToSlowEaseIn,
            widget: LoginScreen()));
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
