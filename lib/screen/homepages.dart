import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/screen/trending.dart';
import 'package:acoustic/screen/following.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/inndicator.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:acoustic/screen/homescreen.dart';
import 'package:acoustic/screen/setting.dart';
import 'package:acoustic/screen/followandinvite.dart';

import 'loginscreen.dart';
import 'nearby.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  bool showMenu = false;
  bool menuIcon = true;
  bool closeIcon = true;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        _controller = new TabController(length: 3, vsync: this);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                margin: EdgeInsets.only(bottom: 00),
                color: Colors.transparent,
                height: screenheight,
                child: Column(children: <Widget>[
                  Container(
                    height: 50,
                    color: Colors.black,
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 20, top: 0),
                            child: InkWell(
                                onTap: () {
                                  print(showMenu);
                                  setState(() {
                                    showMenu = !showMenu;
                                  });
                                },
                                child: showMenu == false
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child:
                                            SvgPicture.asset("images/menu.svg"),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SvgPicture.asset(
                                            "images/menu_close.svg"),
                                      )),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 10, top: 0),
                            child: TabBar(
                              controller: _controller,
                              labelPadding: EdgeInsets.zero,
                              tabs: [
                                /// Trending
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 70,
                                  ),
                                  child: new Tab(
                                    text: 'Trending',
                                  ),
                                ),

                                /// Follow
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 70,
                                  ),
                                  child: new Tab(
                                    text: 'Follow',
                                  ),
                                ),

                                /// Nearby
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 70,
                                  ),
                                  child: new Tab(
                                    text: 'Nearby',
                                  ),
                                ),
                              ],
                              labelColor: Color(Constants.lightbluecolor),
                              unselectedLabelColor: Colors.white,
                              labelStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat'),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorPadding: EdgeInsets.all(0.0),
                              indicatorColor: Color(Constants.lightbluecolor),
                              indicatorWeight: 5.0,
                              indicator: MD2Indicator(
                                indicatorSize: MD2IndicatorSize.full,
                                indicatorHeight: 8.0,
                                indicatorColor: Color(Constants.lightbluecolor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: new TabBarView(
                        controller: _controller,
                        children: <Widget>[
                          TrendingScreen(),
                          FollowingScreen(),
                          NearByScreen(),
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            ),
            Visibility(
              visible: showMenu,
              child: Container(
                margin: EdgeInsets.only(top: 50),

                color: Color(Constants.bgblack),
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///view profile
                    Container(
                      height: 45,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(5),
                        onTap: () {
                          showMenu = !showMenu;
                          if (PreferenceUtils.getlogin(Constants.isLoggedIn) == true) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(4)));
                          } else {
                            Future.delayed(
                                Duration(seconds: 0),
                                () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                    ));
                          }
                        },
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: PreferenceUtils.getString(Constants.image).isEmpty
                              ? CircleAvatar(
                                  radius: 17,
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30.0)),
                                      child: Image.asset(
                                          "images/profilepicDemo.jpg")))
                              : CachedNetworkImage(
                                  alignment: Alignment.center,
                                  imageUrl:
                                      PreferenceUtils.getString(Constants.image),
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 17,
                                    backgroundColor: Color(0xFF36446b),
                                    child: CircleAvatar(
                                      radius: 17,
                                      backgroundImage: imageProvider,
                                    ),
                                  ),
                                  placeholder: (context, url) =>CustomLoader(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset("images/no_image.png"),
                                ),
                        ),
                        title: Text(
                          "View Profile",
                          style: TextStyle(
                              color: Color(Constants.whitetext),
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                        ),
                      ),
                    ),
                    ///settings
                    Container(
                      height: 45,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(5),
                        onTap: () {
                          showMenu = !showMenu;
                          if (PreferenceUtils.getlogin(Constants.isLoggedIn) ==
                              true) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SettingsScreen()));
                          } else {
                            Future.delayed(
                                Duration(seconds: 0),
                                () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                    ));
                          }
                        },
                        leading: Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 15),
                            child: SvgPicture.asset("images/settings.svg")),
                        title: Text(
                          "Settings",
                          style: TextStyle(
                              color: Color(Constants.whitetext),
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                        ),
                      ),
                    ),
                    ///discover people
                    Container(
                      height: 45,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(5),
                        onTap: () {
                          showMenu = !showMenu;
                          if (PreferenceUtils.getlogin(Constants.isLoggedIn) ==
                              true) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FollowandInviteScreen()));
                          } else {
                            Future.delayed(
                                Duration(seconds: 0),
                                () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                    ));
                          }
                        },
                        leading: Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 15),
                            child: SvgPicture.asset("images/follow.svg")),
                        title: Text(
                          "Discover People",
                          style: TextStyle(
                              color: Color(Constants.whitetext),
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                        ),
                      ),
                    ),
                    ///saved post
                    // Container(
                    //   height: 45,
                    //   child: ListTile(
                    //     contentPadding: EdgeInsets.all(5),
                    //     onTap: () {
                    //       showMenu = !showMenu;
                    //       if (PreferenceUtils.getlogin(Constants.isLoggedIn) ==
                    //           true) {
                    //         Navigator.of(context).push(MaterialPageRoute(
                    //             builder: (context) => HomeScreen(4)));
                    //       } else {
                    //         Future.delayed(
                    //             Duration(seconds: 0),
                    //             () => Navigator.of(context).push(
                    //                   MaterialPageRoute(
                    //                       builder: (context) => LoginScreen()),
                    //                 ));
                    //       }
                    //     },
                    //     leading: Container(
                    //         height: 50,
                    //         padding: EdgeInsets.only(left: 15),
                    //         child: SvgPicture.asset("images/bookmark.svg")),
                    //     title: Text(
                    //       "Saved Posts",
                    //       style: TextStyle(
                    //           color: Color(Constants.whitetext),
                    //           fontSize: 16,
                    //           fontFamily: Constants.appFontBold),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
