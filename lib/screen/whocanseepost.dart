import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class WhocanseePostScreen extends StatefulWidget {
  @override
  _WhocanseePostScreen createState() => _WhocanseePostScreen();
}

class _WhocanseePostScreen extends State<WhocanseePostScreen> {
  bool isRememberMe = false;
  bool showSpinner = false;

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
    dynamic screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(Constants.bgblack),
          appBar: AppBar(
            title: Text("Select Who Can See Your Post"),
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
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 55),
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: ScreenUtil().setHeight(55),
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 15, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Color(0xFF1d1d1d),
                                // color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(left: 20),
                                        child: SvgPicture.asset(
                                            "images/greay_search.svg")),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                        color: Colors.transparent,
                                        child: TextField(
                                          autofocus: false,
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 14,
                                              fontFamily: Constants.appFont),
                                          decoration: InputDecoration.collapsed(
                                            hintText: "Search Profile",
                                            hintStyle: TextStyle(
                                                color:
                                                    Color(Constants.hinttext),
                                                fontSize: 14,
                                                fontFamily: Constants.appFont),
                                            border: InputBorder.none,
                                          ),
                                          maxLines: 1,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 10, right: 20, bottom: 0, left: 20),
                              child: ListView.builder(
                                itemCount: 100,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int? index) {
                                  return InkWell(
                                    onTap: () {
                                      //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfileScreen()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          width: ScreenUtil().setWidth(50),
                                          height: ScreenUtil().setHeight(50),
                                          child: CachedNetworkImage(
                                            alignment: Alignment.center,
                                            imageUrl:
                                                "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50",
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF36446b),
                                                borderRadius: new BorderRadius
                                                        .all(
                                                    new Radius.circular(30)),
                                                border: new Border.all(
                                                  color: Color(
                                                      Constants.lightbluecolor),
                                                  width: 3.0,
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor:
                                                    Color(0xFF36446b),
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage:
                                                      imageProvider,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) => CustomLoader(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                                        "images/no_image.png"),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            color: Colors.transparent,
                                            margin: EdgeInsets.only(
                                                left: 10, top: 0, bottom: 5),
                                            child: ListView(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "Riders",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontSize: 14,
                                                        fontFamily:
                                                            Constants.appFont),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  margin:
                                                      EdgeInsets.only(top: 0),
                                                  child: Text(
                                                    "37.1K Followers",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Color(
                                                            Constants.greytext),
                                                        fontSize: 14,
                                                        fontFamily:
                                                            Constants.appFont),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 15),
                                              alignment: Alignment.center,
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 10),
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 2),
                                                      child: Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          unselectedWidgetColor:
                                                              Color(Constants
                                                                  .whitetext),
                                                          disabledColor: Color(
                                                              Constants
                                                                  .whitetext),
                                                        ),
                                                        child: Transform.scale(
                                                          scale: 1.2,
                                                          child: Radio<int>(
                                                            activeColor: Color(
                                                                Constants
                                                                    .whitetext),
                                                            value: index!,
                                                            groupValue: index,
                                                            onChanged:
                                                                (int? value) {
                                                              setState(() {
                                                                index = value;
                                                              });
                                                            },
                                                            // onChanged: _handleRadioValueChange,
                                                            // title: Text("Number $index"),
                                                          ),
                                                        ),
                                                      )))),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setHeight(50),
                        width: screenWidth,
                        color: Color(Constants.lightbluecolor),
                        child: Text(
                          "Done",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(Constants.whitetext),
                              fontFamily: Constants.appFont,
                              fontSize: 16),
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
    return true;
  }
}
