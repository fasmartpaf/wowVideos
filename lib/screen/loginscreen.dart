import 'dart:async';
import 'dart:convert';
import 'dart:io' show Directory, File, HttpClient, Platform, exit;
import 'dart:ui';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/screen/forgotpasswords.dart';
import 'package:acoustic/screen/homescreen.dart';
import 'package:acoustic/screen/otpscreen.dart';
import 'package:acoustic/screen/registerscreen.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:acoustic/widget/app_lable_widget.dart';
import 'package:acoustic/widget/card_password_textfield.dart';
import 'package:acoustic/widget/card_textfield.dart';
import 'package:acoustic/widget/hero_image_app_logo.dart';
import 'package:acoustic/widget/rounded_corner_app_button.dart';
import 'package:acoustic/widget/transitions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRememberMe = false;
  bool _passwordVisible = true;

  TextEditingController _textEmail = TextEditingController();
  TextEditingController _textPassword = TextEditingController();
  FocusNode email = FocusNode();
  FocusNode password = FocusNode();
  final _formKey = new GlobalKey<FormState>();
  bool _autoValidate = false;
  bool showSpinner = false;
  String deviceToken = "";

  String googleProToken = "";
  String googleName = "";
  String googleEmail = "";
  String googleImageUrl = "";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();
    if (mounted) {
      setState(() {
        deviceToken = PreferenceUtils.getString(Constants.deviceToken);

        Constants.checkNetwork().whenComplete(() => callApiForSetting());
      });
    }
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
                    new Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: new BackdropFilter(
                        filter: new ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                        child: new Container(
                          decoration: new BoxDecoration(color: Colors.black45),
                        ),
                      ),
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: ExactAssetImage('images/login_bg_image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
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
                              HeroImage(),
                              SizedBox(height: 50.0),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      AppLableWidget(
                                        title: 'Email',
                                      ),
                                      CardTextFieldWidget(
                                        focus: (v) {
                                          FocusScope.of(context).nextFocus();
                                        },
                                        textInputAction: TextInputAction.next,
                                        hintText: 'Email',
                                        textInputType:
                                            TextInputType.emailAddress,
                                        textEditingController: _textEmail,
                                        validator: Constants.kvalidateEmail,
                                      ),
                                      AppLableWidget(
                                        title: 'Password',
                                      ),
                                      CardPasswordTextFieldWidget(
                                          textEditingController: _textPassword,
                                          validator:
                                              Constants.kvalidatePassword,
                                          hintText: 'Password',
                                          isPasswordVisible: _passwordVisible),
                                      Container(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 10.0, top: 10),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                Transitions(
                                                  transitionType:
                                                      TransitionType.slideLeft,
                                                  curve: Curves.bounceInOut,
                                                  reverseCurve: Curves
                                                      .fastLinearToSlowEaseIn,
                                                  widget:
                                                      ForgotPasswordScreen(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Forgot Password?",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0,
                                                  color: Color(
                                                      Constants.whitetext),
                                                  fontFamily:
                                                      Constants.appFont),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 10, left: 10, right: 10),
                                          child: RoundedCornerAppButton(
                                            onPressed: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                                if (deviceToken == "" &&
                                                    deviceToken.isEmpty) {
                                                  getDeviceToken(
                                                      PreferenceUtils.getString(
                                                          Constants.appId),
                                                      context);
                                                } else {
                                                  String email = _textEmail.text
                                                      .toString();
                                                  String password =
                                                      _textPassword.text
                                                          .toString();

                                                  Constants.checkNetwork()
                                                      .whenComplete(() =>
                                                          callApiForLogin(
                                                              email,
                                                              password,
                                                              context,
                                                              deviceToken));
                                                }
                                              } else {
                                                setState(() {
                                                  _autoValidate = true;
                                                });
                                              }
                                            },
                                            btnLabel: 'Login',
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              Transitions(
                                                  transitionType:
                                                      TransitionType.slideUp,
                                                  curve: Curves.bounceInOut,
                                                  reverseCurve: Curves
                                                      .fastLinearToSlowEaseIn,
                                                  widget: RegisterScreen()));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Don\'t have an account ? ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                      Constants.appFont),
                                            ),
                                            Text(
                                              'Register ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      Constants.appFont),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              Transitions(
                                                  transitionType:
                                                      TransitionType.slideUp,
                                                  curve: Curves.bounceInOut,
                                                  reverseCurve: Curves
                                                      .fastLinearToSlowEaseIn,
                                                  widget: HomeScreen(0)));
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'skip login',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontFamily: Constants.appFont,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20)
                                    ],
                                  ),
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
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: Text("NO")),
              SizedBox(height: 16),
              IconButton(
                  onPressed: () {
                    exit(0);
                  },
                  icon: Text("YES")),
            ],
          ),
        )) ??
        false as Future<bool>;
  }

  void callApiForSetting() {
    RestClient(ApiHeader().dioData()).settingRequest().then((response) async {
      if (response.success == true) {
        print("Setting true");

        PreferenceUtils.setString(Constants.appName, response.data!.appName!);
        PreferenceUtils.setString(Constants.appId, response.data!.appId!);
        PreferenceUtils.setString(
            Constants.appVersion, response.data!.appVersion!);
        PreferenceUtils.setString(
            Constants.appFooter, response.data!.appFooter!);
        PreferenceUtils.setString(
            Constants.termsOfUse, response.data!.termsOfUse!);
        PreferenceUtils.setString(
            Constants.privacyPolicy, response.data!.privacyPolicy!);
        PreferenceUtils.setString(
            Constants.imagePath, response.data!.imagePath!);
        if (response.data!.isWatermark == 0) {
          PreferenceUtils.setBool(Constants.isWaterMark, false);
        } else if (response.data!.isWatermark == 1) {
          PreferenceUtils.setBool(Constants.isWaterMark, true);
        }

        late String videoDirectory;
        if (Platform.isAndroid) {
          final Directory? appDirectory = await (getExternalStorageDirectory());
          videoDirectory = '${appDirectory!.path}/Watermark';
        } else {
          final Directory? appDirectory =
              await (getApplicationDocumentsDirectory());
          videoDirectory = '${appDirectory!.path}/Watermark';
        }

        await Directory(videoDirectory).create(recursive: true);
        String url = response.data!.imagePath! + response.data!.watermark!;
        String? fileName = response.data!.watermark;
        await downloadFile(url, fileName, videoDirectory);
      }
    }).catchError((Object obj) {
      print("error:$obj.");
      print(obj.runtimeType);

      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          print(res);

          var responsecode = res.statusCode;

          if (responsecode == 401) {
            print(responsecode);
            print(res.statusMessage);
          } else if (responsecode == 422) {
            print("code:$responsecode");
          }

          break;
        default:
      }
    });
  }

  Future<String> downloadFile(String url, String? fileName, String dir) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = url;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    PreferenceUtils.setString(Constants.waterMarkPath, filePath);
    return filePath;
  }

  void callApiForLogin(String email, String password, BuildContext context,
      String? devicetoken) {
    setState(() {
      showSpinner = true;
    });

    String platform = "android";
    String provider = "local";
    String provider_token = " ";
    String name = " ";
    String image = " ";

    if (Platform.isAndroid) {
      platform = "android";
    } else if (Platform.isIOS) {
      platform = "ios";
    }

    print("Login_Email:$email");
    print("Login_Password:$password");
    print("Login_Token:$devicetoken");
    RestClient(ApiHeader().dioData())
        .login(email, password, devicetoken, provider, provider_token, name,
            image, platform)
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
        Constants.toastMessage("Login Successfully...");

        PreferenceUtils.setString(Constants.headerToken, token);

        print(token);

        PreferenceUtils.setlogin(Constants.isLoggedIn, true);
        if (body['data']['id'] != null) {
          PreferenceUtils.setString(
              Constants.id, body['data']['id'].toString());
        } else {
          PreferenceUtils.setString(Constants.id, "");
        }
        if (body['data']['name'] != null) {
          PreferenceUtils.setString(Constants.name, body['data']['name']);
        } else {
          PreferenceUtils.setString(Constants.name, "");
        }
        if (body['data']['email'] != null) {
          PreferenceUtils.setString(Constants.email, body['data']['email']);
        } else {
          PreferenceUtils.setString(Constants.email, "");
        }
        if (body['data']['code'] != null) {
          PreferenceUtils.setString(Constants.code, body['data']['code']);
        } else {
          PreferenceUtils.setString(Constants.code, "");
        }
        if (body['data']['phone'] != null) {
          PreferenceUtils.setString(Constants.phone, body['data']['phone']);
        } else {
          PreferenceUtils.setString(Constants.phone, "");
        }
        if (body['data']['user_id'] != null) {
          PreferenceUtils.setString(Constants.userId, body['data']['user_id']);
        } else {
          PreferenceUtils.setString(Constants.userId, "");
        }
        if (body['data']['is_verify'] != null) {
          PreferenceUtils.setString(
              Constants.isverified, body['data']['is_verify'].toString());
        } else {
          PreferenceUtils.setString(Constants.isverified, "");
        }
        if (body['data']['imagePath'] != null &&
            body['data']['image'] != null) {
          PreferenceUtils.setString(
              Constants.image,
              body['data']['imagePath'].toString() +
                  body['data']['image'].toString());
        } else {
          PreferenceUtils.setString(Constants.image, "");
        }
        if (body['data']['is_verify'] == 1) {
          PreferenceUtils.setverify(Constants.isverified, true);
        } else {
          PreferenceUtils.setverify(Constants.isverified, false);
        }

        if (body['data']['is_verify'] == 1) {
          Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => HomeScreen(0)),
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
        var msg = body['msg'];
        print(msg);

        if (body['data']['id'] != null) {
          PreferenceUtils.setString(
              Constants.id, body['data']['id'].toString());
        } else {
          PreferenceUtils.setString(Constants.id, "");
        }

        if (msg == "Verify your account") {
          Navigator.of(this.context).push(Transitions(
              transitionType: TransitionType.slideUp,
              curve: Curves.bounceInOut,
              reverseCurve: Curves.fastLinearToSlowEaseIn,
              widget: OtpScreen()));
        }
        Constants.toastMessage(msg);
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

          var responseCode = res.statusCode;

          if (responseCode == 401) {
            print("Got error : ${res.statusCode} -> ${res.statusMessage}");
            setState(() {
              showSpinner = false;
            });
            Constants.toastMessage("Invalid email or password");
          } else if (responseCode == 422) {
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

  void getDeviceToken(String appId, BuildContext context) async {
    if (!mounted) return;

    OneSignal.shared.consentGranted(true);
    await OneSignal.shared.setAppId(appId);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    OneSignal.shared.promptLocationPermission();

    await OneSignal.shared.getDeviceState().then((value) {
      Constants.checkNetwork().whenComplete(() => callApiForLogin(
          _textEmail.text.toString(),
          _textPassword.text.toString(),
          context,
          value!.userId));
      return PreferenceUtils.setString(Constants.deviceToken, value!.userId!);
    });
  }

  Future<void> getDeviceToken1(String appId, BuildContext context) async {
    if (!mounted) return;

    OneSignal.shared.consentGranted(true);
    await OneSignal.shared.setAppId(appId);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    OneSignal.shared.promptLocationPermission();

    await OneSignal.shared.getDeviceState().then((value) =>
        PreferenceUtils.setString(Constants.deviceToken, value!.userId!));
  }
}
