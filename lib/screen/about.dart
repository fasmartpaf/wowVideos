import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acoustic/util/constants.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreen createState() => _AboutScreen();
}

class _AboutScreen extends State<AboutScreen> {
  int currentSelectedIndex = -1;
  var rating = 4.0;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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
            resizeToAvoidBottomInset: true,
            key: _scaffoldKey,
            backgroundColor: Color(Constants.bgblack),
            appBar: AppBar(
              title: Container(
                  margin: EdgeInsets.only(left: 0), child: Text("About")),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: true,
            ),
            body: new Stack(
              children: <Widget>[
                new SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 15, right: 15, top: 0, bottom: 60),
                    child: Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height:
                              MediaQuery.of(context).size.height * 0.75,
                          alignment: Alignment.center,
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              Container(
                                margin:
                                    EdgeInsets.only(top: 10, bottom: 10),
                                child: SvgPicture.asset(
                                  "images/main_logo.png",
                                  width: ScreenUtil().setWidth(80),
                                  height: ScreenUtil().setHeight(80),
                                ),
                              ),
                              // Align(
                              //   alignment: Alignment.center,
                              //   child: Container(
                              //     margin: EdgeInsets.only(
                              //         top: 10, bottom: 10),
                              //     child: SvgPicture.asset(
                              //       "images/app_name_text.svg",
                              //       width: ScreenUtil().setWidth(30),
                              //       height: ScreenUtil().setHeight(30),
                              //     ),
                              //   ),
                              // ),
                              Align(
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  "App Version 2.0.0",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Color(Constants.greytext),
                                      fontFamily: Constants.appFont,
                                      fontSize: 14),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Copyright © 2021 Acoustic. All Rights Reserved",
                                    style: TextStyle(
                                        color: Color(Constants.greytext),
                                        fontFamily: Constants.appFont,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
