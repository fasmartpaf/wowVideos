import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BlockedCommentScreen extends StatefulWidget {
  @override
  _BlockedCommentScreen createState() => _BlockedCommentScreen();
}

class _BlockedCommentScreen extends State<BlockedCommentScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  bool isOnline = true;

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
                  margin: EdgeInsets.only(left: 10),
                  child: Text("Blocked Comments")),
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
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: 10, left: 10, bottom: 0, right: 10),
                                height: ScreenUtil().setHeight(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Color(0xFF1d1d1d),
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
                                                color:
                                                    Color(Constants.whitetext),
                                                fontSize: 14,
                                                fontFamily: Constants.appFont),
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: "Search Profile",
                                              hintStyle: TextStyle(
                                                  color:
                                                      Color(Constants.hinttext),
                                                  fontSize: 14,
                                                  fontFamily:
                                                      Constants.appFont),
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
                                    left: 20, right: 20, top: 20),
                                child: Text(
                                  "These users can not be comments on your future posts, if you add any user to the block list, If you wish to come comments from these users so, you can unblock this user anytime.",
                                  maxLines: 8,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Color(Constants.greytext),
                                      fontFamily: Constants.appFont,
                                      fontSize: 14),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 25),
                                child: Text(
                                  "Blocked Comments From This User",
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontFamily: Constants.appFont,
                                      fontSize: 16),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 25),
                                child: ListView.builder(
                                  itemCount: 5,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {},
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
                                                  color:
                                                      const Color(0xFF36446b),
                                                  borderRadius: new BorderRadius
                                                          .all(
                                                      new Radius.circular(30)),
                                                  border: new Border.all(
                                                    color: Color(Constants
                                                        .lightbluecolor),
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
                                              placeholder: (context, url) =>
                                                  CustomLoader(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      "images/no_image.png"),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
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
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "Jessica_Martin",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Color(Constants
                                                              .whitetext),
                                                          fontSize: 14,
                                                          fontFamily: Constants
                                                              .appFont),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    margin:
                                                        EdgeInsets.only(top: 0),
                                                    child: Text(
                                                      "Jessi",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Color(Constants
                                                              .greytext),
                                                          fontSize: 14,
                                                          fontFamily: Constants
                                                              .appFont),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 15),
                                                alignment: Alignment.topCenter,
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5, right: 10),
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 2),
                                                      child: Text(
                                                        "Unblock",
                                                        style: TextStyle(
                                                            color: Color(Constants
                                                                .lightbluecolor),
                                                            fontSize: 16,
                                                            fontFamily:
                                                                Constants
                                                                    .appFont),
                                                      ),
                                                    ))),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
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
