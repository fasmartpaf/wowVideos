import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/customview.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/custom/no_post_available.dart';
import 'package:acoustic/screen/searchhashtagvideolist.dart';
import 'package:acoustic/screen/userprofile.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/inndicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SearchCreatorScreen extends StatefulWidget {
  final String searched;

  SearchCreatorScreen({Key? key, required this.searched}) : super(key: key);

  @override
  _SearchCreatorScreen createState() => _SearchCreatorScreen();
}

class _SearchCreatorScreen extends State<SearchCreatorScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  TextEditingController searchController = TextEditingController();
  TabController? _controller;
  List<dynamic> creator = [];
  List<dynamic> hashtag = [];
  late Future<int> _getSearchFeatureBuilder;




  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _controller = TabController(length: 2, vsync: this);
    searchController.text = widget.searched;
    _getSearchFeatureBuilder = getSearchItems(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenheight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new SafeArea(
        child: Scaffold(
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
                        physics: NeverScrollableScrollPhysics(),
                        child: Container(
                          height: screenheight,
                          margin: EdgeInsets.only(bottom: 00),
                          color: Color(Constants.bgblack),
                          child: Column(


                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Color(0xFF1d1d1d),

                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: SvgPicture.asset(
                                              "images/greay_search.svg")),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                          color: Colors.transparent,
                                          child: TextFormField(
                                            controller: searchController,
                                            autofocus: false,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9a-zA-Z]")),
                                            ],
                                            style: TextStyle(
                                                color:
                                                    Color(Constants.whitetext),
                                                fontSize: 14,
                                                fontFamily: Constants.appFont),
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText:
                                                  "Search Hashtags, Profile",
                                              hintStyle: TextStyle(
                                                  color:
                                                      Color(Constants.hinttext),
                                                  fontSize: 14,
                                                  fontFamily:
                                                      Constants.appFont),
                                              border: InputBorder.none,
                                            ),
                                            maxLines: 1,
                                            onFieldSubmitted: (String value) {
                                              if (value.isNotEmpty) {
                                                getSearchItems(value);
                                              } else {
                                                Constants.toastMessage(
                                                    "Please enter any character");
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              ///tabs
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: ScreenUtil().setHeight(40),
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  child: TabBar(
                                    controller: _controller,
                                    tabs: [
                                      new Tab(text: 'Creators'),
                                      new Tab(text: 'Hashtags'),
                                    ],
                                    labelColor: Color(Constants.lightbluecolor),
                                    unselectedLabelColor: Colors.white,
                                    labelStyle: TextStyle(
                                        fontSize: 14,
                                        fontFamily: Constants.appFontBold),
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicatorPadding: EdgeInsets.all(0.0),
                                    indicatorColor:
                                        Color(Constants.lightbluecolor),
                                    indicatorWeight: 5.0,
                                    indicator: MD2Indicator(
                                      indicatorSize: MD2IndicatorSize.full,
                                      indicatorHeight: 8.0,
                                      indicatorColor:
                                          Color(Constants.lightbluecolor),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FutureBuilder<int>(
                                  future: _getSearchFeatureBuilder,
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.done:
                                        return 0 < snapshot.data!.toInt()
                                            ? Container(
                                              margin: EdgeInsets.only(
                                                  top: 10,
                                                  right: 5,
                                                  bottom: 90,
                                                  left: 5),
                                              child: TabBarView(
                                                  controller: _controller,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: <Widget>[
                                                    ///Creator tab
                                                    0 < creator.length
                                                        ? ListView.builder(
                                                            itemCount: creator
                                                                .length,
                                                            physics:
                                                                AlwaysScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            20,
                                                                        left:
                                                                            20),
                                                                child:
                                                                    InkWell(
                                                                  onTap: () {
                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                        builder: (context) => UserProfileScreen(
                                                                              userId: creator[index].id,
                                                                            )));
                                                                  },
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                        flex:
                                                                            1,
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl: creator[index].imagePath + creator[index].image,
                                                                            imageBuilder: (context, imageProvider) => CircleAvatar(
                                                                              radius: 25,
                                                                              backgroundColor: Color(0xFF36446b),
                                                                              child: CircleAvatar(
                                                                                radius: 25,
                                                                                backgroundImage: imageProvider,
                                                                              ),
                                                                            ),
                                                                            placeholder: (context, url) => CustomLoader(),
                                                                            errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex:
                                                                            5,
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Colors.transparent,
                                                                          margin:
                                                                              EdgeInsets.only(top: 5, left: 5),
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          child:
                                                                              ListView(
                                                                            shrinkWrap: true,
                                                                            physics: NeverScrollableScrollPhysics(),
                                                                            children: <Widget>[
                                                                              Container(
                                                                                child: Text(
                                                                                  creator[index].name,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.visible,
                                                                                  style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 14),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                child: Text(
                                                                                  "${creator[index].followersCount} Followers",
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.visible,
                                                                                  style: TextStyle(color: Color(Constants.greytext), fontFamily: Constants.appFont, fontSize: 14),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex:
                                                                            3,
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              EdgeInsets.only(right: 20),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              ScreenUtil().setHeight(45),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(10),
                                                                            ),
                                                                            color: creator[index].isFollowing == 1 || creator[index].isRequested == 1 ? Colors.white : Color(Constants.buttonbg),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              creator[index].isFollowing == 1 || creator[index].isRequested == 1
                                                                                  ? Container()
                                                                                  : Container(
                                                                                      child: SvgPicture.asset("images/follow.svg"),
                                                                                    ),
                                                                              creator[index].isFollowing == 1 || creator[index].isRequested == 1
                                                                                  ? Container(
                                                                                      margin: EdgeInsets.only(left: 2),
                                                                                      child: Text(
                                                                                        () {
                                                                                          return creator[index].isFollowing == 1 ? "Following" : "Requested";
                                                                                        }(),
                                                                                        style: TextStyle(color: Color(Constants.bgblack1), fontSize: 14, fontFamily: Constants.appFont),
                                                                                      ),
                                                                                    )
                                                                                  : Container(
                                                                                      margin: EdgeInsets.only(left: 2),
                                                                                      child: Text(
                                                                                        "Follow",
                                                                                        style: TextStyle(color: Color(Constants.whitetext), fontSize: 14, fontFamily: Constants.appFont),
                                                                                      ),
                                                                                    ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : NoPostAvailable(
                                                            subject: "User",
                                                          ),
                                                    ///HashTag tab
                                                    0 < hashtag.length
                                                        ? ListView.builder(
                                                            itemCount: hashtag
                                                                .length,
                                                            physics:
                                                                AlwaysScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            20,
                                                                        left:
                                                                            20),
                                                                child:
                                                                    InkWell(
                                                                  onTap: () {
                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                        builder: (context) => HashTagVideoListScreen(
                                                                              hashtag: hashtag[index].tag,
                                                                              views: hashtag[index].use,
                                                                            )));
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex:
                                                                            1,
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              EdgeInsets.only(left: 0),
                                                                          child:
                                                                              SvgPicture.asset("images/hash_tag.svg"),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex:
                                                                            6,
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                          margin:
                                                                              EdgeInsets.only(left: 10, top: 5),
                                                                          child:
                                                                              ListView(
                                                                            shrinkWrap: true,
                                                                            physics: NeverScrollableScrollPhysics(),
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.topLeft,
                                                                                child: Text(
                                                                                  "\# ${hashtag[index].tag}",
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.visible,
                                                                                  style: (TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 16)),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(top: 2),
                                                                                alignment: Alignment.topLeft,
                                                                                child: Text(
                                                                                  () {
                                                                                    if (1 < int.parse(hashtag[index].use.toString())) {
                                                                                      return "${hashtag[index].use} Videos";
                                                                                    } else {
                                                                                      return "${hashtag[index].use} Video";
                                                                                    }
                                                                                  }(),
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.visible,
                                                                                  style: (TextStyle(color: Color(Constants.greytext), fontFamily: Constants.appFont, fontSize: 16)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex:
                                                                            1,
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              EdgeInsets.only(right: 20),
                                                                          alignment:
                                                                              Alignment.centerRight,
                                                                          child:
                                                                              InkWell(
                                                                            onTap: () {

                                                                            },
                                                                            child: Container(
                                                                              margin: EdgeInsets.only(left: 5, right: 5),
                                                                              child: SvgPicture.asset(
                                                                                "images/right_arrow.svg",
                                                                                width: ScreenUtil().setWidth(20),
                                                                                height: ScreenUtil().setHeight(20),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : NoPostAvailable(
                                                            subject:
                                                                "Hashtag"),
                                                  ]),
                                            )
                                            : NoPostAvailable(
                                              subject: "User",
                                            );
                                      case ConnectionState.none:
                                        return Container();
                                      case ConnectionState.waiting:
                                        return Container();
                                      case ConnectionState.active:
                                        return Container();
                                      default:
                                        return Container();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                          padding: EdgeInsets.only(bottom: 10), child: Body()),
                    ],
                  );
                },
              ),
            )),
      ),
    );
  }

  Future<int> getSearchItems(String value) async {
    int tempPassData = 0;
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData()).getSearchData(value).then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
        });
        setState(() {
          creator.clear();
          creator.addAll(response.data!.creators!);
          hashtag.clear();
          hashtag.addAll(response.data!.hashtags!);
        });
      } else {
        setState(() {
          showSpinner = false;
        });
      }
    }).catchError((Object obj) {


      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
      Constants.toastMessage("Internal Server Error");
    });
    if (creator.isNotEmpty) {
      tempPassData = creator.length;
    }
    if (hashtag.isNotEmpty) {
      tempPassData += hashtag.length;
    }
    return tempPassData;
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomView(1),
    );
  }
}
