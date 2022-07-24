import 'dart:convert';
import 'dart:ui';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/screen/loginscreen.dart';
import 'package:acoustic/screen/otpscreen.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:acoustic/widget/app_lable_widget.dart';
import 'package:acoustic/widget/app_toolbar.dart';
import 'package:acoustic/widget/card_password_textfield.dart';
import 'package:acoustic/widget/card_textfield.dart';
import 'package:acoustic/widget/rounded_corner_app_button.dart';
import 'package:acoustic/widget/transitions.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  bool isRememberMe = false;
  bool _passwordVisible = true;

  final _textUsername = TextEditingController();
  final _textName = TextEditingController();
  final _textEmail = TextEditingController();
  final _textContact = TextEditingController();
  final _textPassword = TextEditingController();
  final _textConfPassword = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  bool _autoValidate = false;
  bool showSpinner = false;
  String devicetoken = "";
  String? strCountryCode = "+91";

  bool _confirmpasswordVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

  }

  String? validateConfPassword(String? value) {


    if (value!.length == 0) {
      return "Confirm Password is Required";
    } else if (value.length < 6) {
      return "Confirm Password must be at least 6 characters";
    } else if (_textPassword.text != _textConfPassword.text)
      return 'Password and Confirm Password does not match.';


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
          appBar: ApplicationToolbar(appbarTitle: 'Create New Account'),
          backgroundColor: Color(Constants.bgblack),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: CustomLoader(),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppLableWidget(
                                    title: 'Username',
                                  ),
                                  CardTextFieldWidget(
                                    focus: (v) {
                                      FocusScope.of(context).nextFocus();
                                    },
                                    textInputAction: TextInputAction.next,
                                    hintText: 'Username',
                                    textInputType: TextInputType.name,
                                    textEditingController: _textUsername,
                                    validator: Constants.kvalidateUserName,
                                  ),
                                  AppLableWidget(
                                    title: 'Name',
                                  ),
                                  CardTextFieldWidget(
                                    focus: (v) {
                                      FocusScope.of(context).nextFocus();
                                    },
                                    textInputAction: TextInputAction.next,
                                    hintText: 'Name',
                                    textInputType: TextInputType.name,
                                    textEditingController: _textName,
                                    validator: Constants.kvalidateName,
                                  ),
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
                                    textEditingController: _textEmail,
                                    validator: Constants.kvalidateEmail,
                                  ),
                                  AppLableWidget(
                                    title: 'Contact Number',
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: ScreenUtil().setWidth(60),
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: CountryCodePicker(
                                            onChanged: (c) {
                                              setState(() {
                                                strCountryCode = c.dialCode;
                                                print(
                                                    "strCountryCode:$strCountryCode");
                                              });
                                            },
                                            textStyle: TextStyle(
                                              color: Color(Constants.whitetext),
                                            ),

                                            initialSelection: 'IN',
                                            favorite: ['+91', 'IN'],

                                            showCountryOnly: false,
                                            showFlag: false,

                                            showOnlyCountryWhenClosed: false,

                                            alignLeft: false,
                                          ),
                                        ),
                                        Container(
                                          width: ScreenUtil().setWidth(5),
                                          height: 15,
                                          margin: EdgeInsets.only(
                                              left: 5,
                                              right: 0,
                                              top: 0,
                                              bottom: 0),
                                          alignment: Alignment.center,
                                          child: VerticalDivider(
                                            color: Color(Constants.whitetext),
                                            width: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 9,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 0, right: 0),
                                            child: CardTextFieldWidget(
                                              focus: (v) {
                                                FocusScope.of(context)
                                                    .nextFocus();
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              hintText: 'Contact Number',
                                              textInputType:
                                                  TextInputType.number,
                                              textEditingController:
                                                  _textContact,
                                              validator:
                                                  Constants.kvalidateCotactNum,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AppLableWidget(
                                    title: 'Password',
                                  ),
                                  CardPasswordTextFieldWidget(
                                      textEditingController: _textPassword,
                                      validator: Constants.kvalidatePassword,
                                      hintText: 'Password',
                                      isPasswordVisible: _passwordVisible),
                                  AppLableWidget(
                                    title: 'Confirm Password',
                                  ),
                                  CardPasswordTextFieldWidget(
                                      textEditingController: _textConfPassword,
                                      validator: validateConfPassword,
                                      hintText: 'Confirm Password',
                                      isPasswordVisible:
                                          _confirmpasswordVisible),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      child: RoundedCornerAppButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();

                                            String name =
                                                _textName.text.toString();
                                            String user_id =
                                                _textUsername.text.toString();
                                            String email =
                                                _textEmail.text.toString();

                                            String phone =
                                                _textContact.text.toString();
                                            String password =
                                                _textPassword.text.toString();
                                            String confirm_password =
                                                _textConfPassword.text
                                                    .toString();

                                            if (strCountryCode != null ||
                                                strCountryCode!.isNotEmpty) {
                                              String? code = strCountryCode;

                                              Constants.checkNetwork()
                                                  .whenComplete(() =>
                                                      callApiForRegister(
                                                          name,
                                                          user_id.trim(),
                                                          email,
                                                          code,
                                                          phone,
                                                          password,
                                                          confirm_password,
                                                          context));
                                            }
                                          } else {
                                            setState(() {
                                              _autoValidate = true;
                                            });
                                          }
                                        },
                                        btnLabel: 'Create Account',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(Transitions(
                                          transitionType:
                                              TransitionType.slideDown,
                                          curve: Curves.bounceInOut,
                                          reverseCurve:
                                              Curves.fastLinearToSlowEaseIn,
                                          widget: LoginScreen()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Already an account ? ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: Constants.appFont),
                                        ),
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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

  callApiForRegister(
      String name,
      String user_id,
      String email,
      String? code,
      String phone,
      String password,
      String confirm_password,
      BuildContext context) {
    setState(() {
      showSpinner = true;
    });

    print("Login_Email:$email");
    print("Login_Password:$password");

    RestClient(ApiHeader().dioData())
        .register(name, user_id, email, code, phone, password, confirm_password)
        .then((response) {
      print(response.toString());
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);

      if (sucess == true) {
        setState(() {
          showSpinner = false;
        });
        var token = body['data']['token'];
        Constants.toastMessage("User created successfully!");








        PreferenceUtils.setString(Constants.id, body['data']['id'].toString());
        PreferenceUtils.setString(Constants.name, body['data']['name']);
        PreferenceUtils.setString(Constants.email, body['data']['email']);
        PreferenceUtils.setString(Constants.code, body['data']['code']);
        PreferenceUtils.setString(Constants.phone, body['data']['phone']);
        PreferenceUtils.setString(Constants.userId, body['data']['user_id']);
        PreferenceUtils.setString(
            Constants.isverified, body['data']['is_verify'].toString());


        if (body['data']['is_verify'] == 1) {
          Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          Navigator.of(this.context).push(Transitions(
              transitionType: TransitionType.slideUp,
              curve: Curves.bounceInOut,
              reverseCurve: Curves.fastLinearToSlowEaseIn,
              widget: OtpScreen()));
        }





      } else if (sucess == false) {
        setState(() {
          showSpinner = false;
        });
        var msg = body['message'];
        print(msg);

      }

    }).catchError((Object obj) {
      setState(() {
        showSpinner = false;
      });

      print("error:$obj.");
      print(obj.runtimeType);
      final res = (obj as DioError).response;


      var data = json.decode(res!.data);

      switch (obj.runtimeType) {
        case DioError:

          final res = (obj).response!;
          print(res);

          var responsecode = res.statusCode;


          if (responsecode == 401) {
            print("Got error : ${res.statusCode} -> ${res.statusMessage}");
            setState(() {
              showSpinner = false;
            });
          } else if (responsecode == 422) {
            print("Invalid Data");
            if (data["errors"]["email"] != null) {
              var error = data["errors"]["email"][0];
              Constants.toastMessage(error);
            } else if (data["errors"]["phone"] != null) {
              var error = data["errors"]["phone"][0];
              Constants.toastMessage(error);
            } else {
              Constants.createSnackBar("The given data was invalid.",
                  this.context, Color(Constants.redtext));
            }
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
