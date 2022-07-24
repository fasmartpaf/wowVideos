import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/screen/loginscreen.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:acoustic/screen/privacy.dart';
import 'package:acoustic/screen/notificationsetting.dart';
import 'package:acoustic/screen/applanguge.dart';
import 'package:acoustic/screen/termsofuse.dart';
import 'package:acoustic/screen/privacypolicy.dart';
import 'package:acoustic/screen/about.dart';
import 'package:acoustic/screen/reportproblem.dart';

class SettingsScreen extends StatefulWidget {
  final userId;

  SettingsScreen({Key? key, this.userId}) : super(key: key);
  @override
  _SettingsScreen createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Container(
                  margin: EdgeInsets.only(left: 10), child: Text("Settings")),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: true,
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
                          child: Column(


                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(45),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PrivacyScreen()));
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: SvgPicture.asset(
                                            "images/security.svg"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Privacy",
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 18,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(45),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationSettingScreen()));
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: SvgPicture.asset(
                                            "images/notification_white.svg"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Notification",
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 18,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(45),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AppLanguageScreen()));
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: SvgPicture.asset(
                                            "images/translation.svg"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "App Language",
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 18,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(45),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TermsOfUseScreen()));
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: SvgPicture.asset(
                                            "images/accept.svg"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Terms of Use",
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 18,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(45),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PrivacyPolicyScreen()));
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: SvgPicture.asset(
                                            "images/policy.svg"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Policy",
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 18,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(45),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AboutScreen()));
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: SvgPicture.asset(
                                            "images/about.svg"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "About",
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 18,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(45),
                                child: InkWell(
                                  onTap: () {
                                    if (PreferenceUtils.getlogin(
                                            Constants.isLoggedIn) ==
                                        true) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportProblemScreen(
                                                    userId: widget.userId,
                                                  )));
                                    } else {
                                      Constants.toastMessage(
                                          "Please! Login To Enter");
                                    }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: SvgPicture.asset(
                                            "images/report.svg"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Report a Problem",
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 18,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(45),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                        (route) => false);




                                    PreferenceUtils.setlogin(
                                        Constants.isLoggedIn, false);
                                    PreferenceUtils.clear();
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: SvgPicture.asset(
                                            "images/logout.svg"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Logout",
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 18,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  );
                },
              ),
            )),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
