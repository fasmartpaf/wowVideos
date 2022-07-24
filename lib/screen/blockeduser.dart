import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/model/userblocklist.dart';
import 'package:acoustic/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:convert';

class BlockedUserScreen extends StatefulWidget {
  @override
  _BlockedUserScreen createState() => _BlockedUserScreen();
}

class _BlockedUserScreen extends State<BlockedUserScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  bool isOnline = true;
  bool nodata = true;
  bool showdata = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<UserBlockListData> blockuserlist = <UserBlockListData>[];

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    if (mounted) {
      Constants.checkNetwork().whenComplete(() => callApiForBlockUserList());
    }
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
                  child: Text("Blocked Users")),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: true,
            ),
            backgroundColor: Color(Constants.bgblack),
            resizeToAvoidBottomInset: true,
            key: _scaffoldKey,
            body: RefreshIndicator(
              color: Color(Constants.lightbluecolor),
              backgroundColor: Colors.transparent,
              onRefresh: callApiForBlockUserList,
              key: _refreshIndicatorKey,
              child: ModalProgressHUD(
                inAsyncCall: showSpinner,
                opacity: 1.0,
                color: Colors.transparent.withOpacity(0.2),
                progressIndicator:CustomLoader(),
                child: LayoutBuilder(
                  builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
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
                                                  color: Color(
                                                      Constants.whitetext),
                                                  fontSize: 14,
                                                  fontFamily:
                                                      Constants.appFont),
                                              decoration:
                                                  InputDecoration.collapsed(
                                                hintText: "Search Profile",
                                                hintStyle: TextStyle(
                                                    color: Color(
                                                        Constants.hinttext),
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
                                    "You can not see the profile of which user you blocked, and you will be can't receive any kind of updates from these users. If you want to receive all notifications and posts from users just UNBLOCK the user. ",
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
                                    "Blocked Users",
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontFamily: Constants.appFont,
                                        fontSize: 16),
                                  ),
                                ),
                                Visibility(
                                  visible: showdata,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, top: 25),
                                    child: ListView.separated(
                                      itemCount: blockuserlist.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: 10,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(






                                              child: CachedNetworkImage(
                                                alignment: Alignment.center,
                                                imageUrl: blockuserlist[index]
                                                        .imagePath! +
                                                    blockuserlist[index].image!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF36446b),
                                                    borderRadius:
                                                        new BorderRadius.all(
                                                            new Radius.circular(
                                                                50)),
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
                                                placeholder: (context, url) => CustomLoader(),
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
                                                    left: 10,
                                                    top: 0,
                                                    bottom: 5),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        blockuserlist[index]
                                                            .name!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .whitetext),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                Constants
                                                                    .appFont),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          top: 0),
                                                      child: Text(
                                                        blockuserlist[index]
                                                            .userId!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greytext),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                Constants
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
                                                  margin: EdgeInsets.only(
                                                      bottom: 15),
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5, right: 10),
                                                      alignment:
                                                          Alignment.center,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Constants
                                                                  .checkNetwork()
                                                              .whenComplete(() =>
                                                                  callApiForUnBlockUser(
                                                                      blockuserlist[
                                                                              index]
                                                                          .id));
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 2),
                                                          child: Text(
                                                            "Unblock",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .lightbluecolor),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    Constants
                                                                        .appFont),
                                                          ),
                                                        ),
                                                      ))),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: nodata,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: ScreenUtil().setHeight(80),
                                            margin: const EdgeInsets.only(
                                                top: 100.0,
                                                left: 15.0,
                                                right: 15,
                                                bottom: 0),
                                            child: Text(
                                              "No Data Available !",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: Constants.appFont,
                                                  fontSize: 20),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
              ),
            )),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  Future<void> callApiForBlockUserList() async {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).getblockuser().then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
        });
        setState(() {
          blockuserlist.clear();
          if (response.data!.length != 0) {
            blockuserlist.clear();
            blockuserlist.addAll(response.data!);
            nodata = false;
            showdata = true;
          }
        });
      } else {
        setState(() {
          showSpinner = false;
          nodata = true;
          showdata = false;
        });
      }
    }).catchError((Object obj) {
      final snackBar = SnackBar(
        content: Text('Server Error'),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(this.context).showSnackBar(snackBar);

      setState(() {
        showSpinner = false;
        nodata = true;
        showdata = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  callApiForUnBlockUser(int? id) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).unblockuser(id.toString(), "User")
        .then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      print(sucess);

      if (sucess == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          final snackBar = SnackBar(
            content: Text(msg),
            backgroundColor: Color(Constants.lightbluecolor),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          Constants.checkNetwork()
              .whenComplete(() => callApiForBlockUserList());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          final snackBar = SnackBar(
            content: Text(msg),
            backgroundColor: Color(Constants.redtext),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

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
