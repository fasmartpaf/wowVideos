import 'dart:convert';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:acoustic/screen/followandinvite.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:acoustic/screen/blockeduser.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreen createState() => _PrivacyScreen();
}

class _PrivacyScreen extends State<PrivacyScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  bool isPrivate = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    callApiForGetprivacy();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Container(
                  margin: EdgeInsets.only(left: 10), child: Text("Privacy")),
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
                  return Container(
                    margin: EdgeInsets.only(bottom: 0, right: 10),
                    color: Colors.transparent,
                    child: Column(


                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            setState(() {
                              isPrivate = !isPrivate;
                              Constants.checkNetwork().whenComplete(() =>
                                  callApiForSetPrivacy(isPrivate, context));
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Set Account as Private",
                                style: TextStyle(
                                    color: Color(Constants.whitetext),
                                    fontSize: 16,
                                    fontFamily: Constants.appFont),
                              ),
                              FlutterSwitch(
                                height: 25,
                                width: 45,
                                borderRadius: 30,
                                padding: 5.5,
                                duration: Duration(milliseconds: 400),
                                activeColor: Color(Constants.lightbluecolor),
                                activeToggleColor: Color(Constants.bgblack),
                                inactiveToggleColor: Color(Constants.bgblack),
                                inactiveColor: Color(Constants.greytext),
                                toggleSize: 15,
                                value: isPrivate,
                                onToggle: (val) {
                                  setState(() {
                                    isPrivate = !isPrivate;
                                    Constants.checkNetwork().whenComplete(() =>
                                        callApiForSetPrivacy(isPrivate, context));
                                  });
                                },
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "Your profile will be set as private profile",
                            style: TextStyle(
                                color: Color(Constants.greytext),
                                fontSize: 14,
                                fontFamily: Constants.appFont),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 25),
                          child: Divider(

                            color: Color(Constants.greytext),
                            thickness: 1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                          height: ScreenUtil().setHeight(45),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BlockedUserScreen()));
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: SvgPicture.asset("images/block.svg"),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "Blocked Users",
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
                          margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                          height: ScreenUtil().setHeight(45),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      FollowandInviteScreen()));
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: SvgPicture.asset("images/follow.svg"),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "Follow and Invite Friends",
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

  void callApiForSetPrivacy(bool isPrivate, BuildContext context) {
    String followRequest = "0";
    print("isOnline12345:$isPrivate");
    if (isPrivate == true) {
      setState(() {
        followRequest = "1";
      });
    } else if (isPrivate == false) {
      setState(() {
        followRequest = "0";
      });
    }
    print("follow_request345:$followRequest");

    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .privacysetting(followRequest)
        .then((response) {

      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);
      if (sucess == true) {
        var msg = body['msg'];
        Constants.toastMessage(msg);


        setState(() {
          showSpinner = false;
        });
      }
    }).catchError((Object obj) {
      Constants.toastMessage('Server Error');






      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);

    });
  }

  void callApiForGetprivacy() {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).myProfileInfo().then((response) {
      print(response.toString());
      if (response.success == true) {
        setState(() {
          showSpinner = false;
          if (response.data!.followerRequest == 1) {
            isPrivate = true;
          } else {
            isPrivate = false;
          }
        });
      }
    }).catchError((Object obj) {
      final snackBar = SnackBar(
        content: Text('Server Error'),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);

    });
  }
}
