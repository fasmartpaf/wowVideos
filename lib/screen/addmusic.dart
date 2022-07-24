import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'dart:io' show Platform;
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:dio/dio.dart';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/model/add_music_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:acoustic/util/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:acoustic/util/inndicator.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'uploadvideo.dart';
import 'usedsoundlist.dart';

class AddMusicScreen extends StatefulWidget {
  final bool fromVideoUpload;

  AddMusicScreen({Key? key, required this.fromVideoUpload}) : super(key: key);

  @override
  _AddMusicScreen createState() => _AddMusicScreen();
}

class _AddMusicScreen extends State<AddMusicScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;

  TextEditingController comController = new TextEditingController();
  TextEditingController canController = new TextEditingController();

  TabController? _controller;

  List<All> allMusic = [];
  List<Popular> popularMusic = [];
  List<Playlist> playlistMusic = [];
  List<Favorite> favoriteMusic = [];
  String passFilePath = '';
  int? selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _controller = TabController(length: 5, vsync: this);
    callApiForGetMusicData();
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
          appBar: AppBar(
            title: Text(
              "Add Music",
              maxLines: 1,
              style: TextStyle(
                color: Color(Constants.whitetext),
                fontFamily: Constants.appFontBold,
                fontSize: 18,
              ),
            ),
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
            child: new Stack(
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
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
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
                                    child: TextField(
                                      autofocus: false,
                                      style: TextStyle(
                                          color: Color(Constants.whitetext),
                                          fontSize: 14,
                                          fontFamily: Constants.appFont),
                                      decoration: InputDecoration.collapsed(
                                        hintText: "Search Music",
                                        hintStyle: TextStyle(
                                            color: Color(Constants.hinttext),
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
                          margin: EdgeInsets.only(top: 10),
                          height: ScreenUtil().setHeight(50),
                          color: Colors.transparent,
                          child: Container(
                            height: ScreenUtil().setHeight(35),
                            color: Colors.transparent,
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(1),
                              child: TabBar(
                                controller: _controller,
                                labelPadding:  EdgeInsets.symmetric(horizontal: 8.0),
                                tabs: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 70,
                                    ),
                                    child: Tab(
                                      text: 'All',
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 70,
                                    ),
                                    child: Tab(
                                      text: 'Popular',
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 70,
                                    ),
                                    child: Tab(
                                      text: 'Favorites',
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 70,
                                    ),
                                    child: Tab(
                                      text: 'Playlist',
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 70,
                                    ),
                                    child: Tab(
                                      text: 'Local',
                                    ),
                                  ),
                                ],
                                labelColor: Color(Constants.lightbluecolor),
                                unselectedLabelColor: Colors.white,
                                labelStyle: TextStyle(
                                    fontSize: 13,
                                    fontFamily: Constants.appFontBold),
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorPadding: EdgeInsets.all(0.0),
                                indicatorColor: Color(Constants.lightbluecolor),
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
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 10, right: 5, bottom: 90, left: 5),
                            child: TabBarView(
                                controller: _controller,
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  /// all
                                  Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(8)),
                                    child: 0 < allMusic.length
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                bottom: 10,
                                                left: 10,
                                                right: 10,
                                                top: 0),
                                            child:
                                                StaggeredGridView.countBuilder(
                                              physics:
                                                  AlwaysScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              crossAxisCount: 3,
                                              itemCount: allMusic.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      ListView(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      if (widget
                                                              .fromVideoUpload ==
                                                          true) {
                                                        PreferenceUtils.setInt(
                                                            Constants
                                                                .addMusicId,
                                                            allMusic[index]
                                                                .id!);
                                                        String url = allMusic[
                                                                    index]
                                                                .imagePath! +
                                                            allMusic[index]
                                                                .audio!;
                                                        String? fileName =
                                                            allMusic[index]
                                                                .audio;
                                                        final Directory?
                                                            appDirectory =
                                                            await (getExternalStorageDirectory());
                                                        final String
                                                            videoDirectory =
                                                            '${appDirectory!.path}/Audio';
                                                        await Directory(
                                                                videoDirectory)
                                                            .create(
                                                                recursive:
                                                                    true);
                                                        if (io.File("$videoDirectory/$fileName")
                                                                .existsSync() ==
                                                            false) {
                                                          await downloadFile(
                                                              url,
                                                              fileName,
                                                              videoDirectory);
                                                        } else {
                                                          passFilePath =
                                                              "$videoDirectory/$fileName";
                                                        }
                                                        Navigator
                                                            .pushReplacement(
                                                          this.context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UploadVideoScreen(
                                                              addMusicId:
                                                                  allMusic[
                                                                          index]
                                                                      .id,
                                                              musicPath:
                                                                  passFilePath,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UsedSoundScreen(
                                                              songId: allMusic[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              isSongIdAvailable:
                                                                  true,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        height: ScreenUtil()
                                                            .setHeight(100),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: new Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: allMusic[
                                                                        index]
                                                                    .imagePath! +
                                                                allMusic[index]
                                                                    .image!,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                CustomLoader(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Image.asset(
                                                                    "images/no_image.png"),
                                                          ),
                                                        )),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      left: 10,
                                                      top: 0,


                                                    ),
                                                    height: ScreenUtil()
                                                        .setHeight(30),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Container(
                                                            child: ListView(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                    allMusic[
                                                                            index]
                                                                        .title!,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .visible,
                                                                    style: TextStyle(
                                                                        color: Color(Constants
                                                                            .whitetext),
                                                                        fontFamily:
                                                                            Constants
                                                                                .appFont,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    allMusic[
                                                                            index]
                                                                        .artist!,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .visible,
                                                                    style: TextStyle(
                                                                        color: Color(Constants
                                                                            .hinttext),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            Constants.appFont),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        allMusic[index]
                                                                    .isFavorite ==
                                                                0
                                                            ? Expanded(
                                                                flex: 1,
                                                                child:
                                                                    PopupMenuButton<
                                                                        String>(
                                                                  color: Color(
                                                                      Constants
                                                                          .conbg),
                                                                  icon:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/more_menu.svg",
                                                                    width: 20,
                                                                    height: 20,
                                                                  ),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(18.0))),
                                                                  offset:
                                                                      Offset(20,
                                                                          20),
                                                                  onSelected:
                                                                      handleClick,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                          context) {
                                                                    selectedIndex =
                                                                        allMusic[index]
                                                                            .id;
                                                                    return {
                                                                      "+ Add To Favorites"
                                                                    }.map((String
                                                                        choice) {
                                                                      return PopupMenuItem<
                                                                          String>(
                                                                        value:
                                                                            "+Add To Favorites",
                                                                        child:
                                                                            Text(
                                                                          "+Add To Favorites",
                                                                          style: TextStyle(
                                                                              color: Color(Constants.whitetext),
                                                                              fontSize: 14,
                                                                              fontFamily: Constants.appFontBold),
                                                                        ),
                                                                      );
                                                                    }).toList();
                                                                  },
                                                                ),
                                                              )
                                                            : Expanded(
                                                                flex: 1,
                                                                child:
                                                                    PopupMenuButton<
                                                                        String>(
                                                                  color: Color(
                                                                      Constants
                                                                          .conbg),
                                                                  icon:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/more_menu.svg",
                                                                    width: 20,
                                                                    height: 20,
                                                                  ),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(18.0))),
                                                                  offset:
                                                                      Offset(20,
                                                                          20),
                                                                  onSelected:
                                                                      handleClick,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                          context) {
                                                                    selectedIndex =
                                                                        allMusic[index]
                                                                            .id;
                                                                    return {
                                                                      "- Remove From Favorites"
                                                                    }.map((String
                                                                        choice) {
                                                                      return PopupMenuItem<
                                                                          String>(
                                                                        value:
                                                                            "- Remove From Favorites",
                                                                        child:
                                                                            Text(
                                                                          "- Remove From Favorites",
                                                                          style: TextStyle(
                                                                              color: Color(Constants.whitetext),
                                                                              fontSize: 14,
                                                                              fontFamily: Constants.appFontBold),
                                                                        ),
                                                                      );
                                                                    }).toList();
                                                                  },
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              staggeredTileBuilder:
                                                  (int index) =>
                                                      new StaggeredTile.count(
                                                          1,
                                                          index.isEven
                                                              ? 1.4
                                                              : 1.4),


                                            ),
                                          )
                                        : Container(
                                            child: Center(
                                                child: Text(
                                            "Music is not available",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                                  ),
                                  /// Popular list
                                  Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(8)),
                                    child: 0 < popularMusic.length
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                bottom: 10,
                                                left: 10,
                                                right: 10,
                                                top: 0),
                                            child:
                                                StaggeredGridView.countBuilder(
                                              physics:
                                                  AlwaysScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              crossAxisCount: 3,
                                              itemCount: popularMusic.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      ListView(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      if (widget
                                                              .fromVideoUpload ==
                                                          true) {
                                                        PreferenceUtils.setInt(
                                                            Constants
                                                                .addMusicId,
                                                            popularMusic[index]
                                                                .id!);
                                                        String url =
                                                            popularMusic[index]
                                                                    .imagePath! +
                                                                popularMusic[
                                                                        index]
                                                                    .audio!;
                                                        String? fileName =
                                                            popularMusic[index]
                                                                .audio;
                                                        late String
                                                            videoDirectory;
                                                        if (Platform
                                                            .isAndroid) {
                                                          final Directory?
                                                              appDirectory =
                                                              await getExternalStorageDirectory();
                                                          videoDirectory =
                                                              '${appDirectory!.path}/Audio';
                                                          await Directory(
                                                                  videoDirectory)
                                                              .create(
                                                                  recursive:
                                                                      true);
                                                        } else {
                                                          final Directory?
                                                              appDirectory =
                                                              await getApplicationDocumentsDirectory();
                                                          videoDirectory =
                                                              '${appDirectory!.path}/Audio';
                                                          await Directory(
                                                                  videoDirectory)
                                                              .create(
                                                                  recursive:
                                                                      true);
                                                        }
                                                        if (io.File("$videoDirectory/$fileName")
                                                                .existsSync() ==
                                                            false) {
                                                          await downloadFile(
                                                              url,
                                                              fileName,
                                                              videoDirectory);
                                                        } else {
                                                          passFilePath =
                                                              "$videoDirectory/$fileName";
                                                        }
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UploadVideoScreen(
                                                              addMusicId:
                                                                  popularMusic[
                                                                          index]
                                                                      .id,
                                                              musicPath:
                                                                  passFilePath,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UsedSoundScreen(
                                                              songId: allMusic[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              isSongIdAvailable:
                                                                  true,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        height: ScreenUtil()
                                                            .setHeight(100),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: new Container(
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: popularMusic[
                                                                        index]
                                                                    .imagePath! +
                                                                popularMusic[
                                                                        index]
                                                                    .image!,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                CustomLoader(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Image.asset(
                                                                    "images/no_image.png"),
                                                          ),
                                                        )),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15,
                                                        right: 10,
                                                        top: 0,
                                                        bottom: 10),
                                                    height: ScreenUtil()
                                                        .setHeight(40),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Container(
                                                            child: ListView(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                    popularMusic[
                                                                            index]
                                                                        .title!,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .visible,
                                                                    style: TextStyle(
                                                                        color: Color(Constants
                                                                            .whitetext),
                                                                        fontFamily:
                                                                            Constants
                                                                                .appFont,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    popularMusic[
                                                                            index]
                                                                        .artist!,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .visible,
                                                                    style: TextStyle(
                                                                        color: Color(Constants
                                                                            .hinttext),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            Constants.appFont),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        popularMusic[index]
                                                                    .isFavorite ==
                                                                0
                                                            ? Expanded(
                                                                flex: 1,
                                                                child:
                                                                    PopupMenuButton<
                                                                        String>(
                                                                  color: Color(
                                                                      Constants
                                                                          .conbg),
                                                                  icon:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/more_menu.svg",
                                                                    width: 20,
                                                                    height: 20,
                                                                  ),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(18.0))),
                                                                  offset:
                                                                      Offset(20,
                                                                          45),
                                                                  onSelected:
                                                                      handleClick,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                          context) {
                                                                    selectedIndex =
                                                                        popularMusic[index]
                                                                            .id;
                                                                    return {
                                                                      "+ Add To Favorites"
                                                                    }.map((String
                                                                        choice) {
                                                                      return PopupMenuItem<
                                                                          String>(
                                                                        value:
                                                                            "+Add To Favorites",
                                                                        child:
                                                                            Text(
                                                                          "+Add To Favorites",
                                                                          style: TextStyle(
                                                                              color: Color(Constants.whitetext),
                                                                              fontSize: 14,
                                                                              fontFamily: Constants.appFontBold),
                                                                        ),
                                                                      );
                                                                    }).toList();
                                                                  },
                                                                ),
                                                              )
                                                            : Expanded(
                                                                flex: 1,
                                                                child:
                                                                    PopupMenuButton<
                                                                        String>(
                                                                  color: Color(
                                                                      Constants
                                                                          .conbg),
                                                                  icon:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/more_menu.svg",
                                                                    width: 20,
                                                                    height: 20,
                                                                  ),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(18.0))),
                                                                  offset:
                                                                      Offset(20,
                                                                          45),
                                                                  onSelected:
                                                                      handleClick,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                          context) {
                                                                    selectedIndex =
                                                                        popularMusic[index]
                                                                            .id;
                                                                    return {
                                                                      "- Remove From Favorites"
                                                                    }.map((String
                                                                        choice) {
                                                                      return PopupMenuItem<
                                                                          String>(
                                                                        value:
                                                                            "- Remove From Favorites",
                                                                        child:
                                                                            Text(
                                                                          "- Remove From Favorites",
                                                                          style: TextStyle(
                                                                              color: Color(Constants.whitetext),
                                                                              fontSize: 14,
                                                                              fontFamily: Constants.appFontBold),
                                                                        ),
                                                                      );
                                                                    }).toList();
                                                                  },
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              staggeredTileBuilder:
                                                  (int index) =>
                                                      new StaggeredTile.count(
                                                          1,
                                                          index.isEven
                                                              ? 1.4
                                                              : 1.4),
                                              mainAxisSpacing: 1.0,
                                              crossAxisSpacing: 1.0,
                                            ),
                                          )
                                        : Container(
                                            child: Center(
                                                child: Text(
                                            "Music is not available",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                                  ),
                                  /// Favorite list
                                  Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(8)),
                                    child: 0 < favoriteMusic.length
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                bottom: 10,
                                                left: 10,
                                                right: 10,
                                                top: 0),
                                            child:
                                                StaggeredGridView.countBuilder(
                                              physics:
                                                  AlwaysScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              crossAxisCount: 3,
                                              itemCount: favoriteMusic.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      ListView(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      if (widget
                                                              .fromVideoUpload ==
                                                          true) {
                                                        PreferenceUtils.setInt(
                                                            Constants
                                                                .addMusicId,
                                                            favoriteMusic[index]
                                                                .id!);
                                                        String url =
                                                            favoriteMusic[index]
                                                                    .song!
                                                                    .imagePath! +
                                                                favoriteMusic[
                                                                        index]
                                                                    .song!
                                                                    .audio!;
                                                        String? fileName =
                                                            favoriteMusic[index]
                                                                .song!
                                                                .audio;

                                                        late String
                                                            videoDirectory;
                                                        if (Platform
                                                            .isAndroid) {
                                                          final Directory?
                                                              appDirectory =
                                                              await getExternalStorageDirectory();
                                                          videoDirectory =
                                                              '${appDirectory!.path}/Audio';
                                                          await Directory(
                                                                  videoDirectory)
                                                              .create(
                                                                  recursive:
                                                                      true);
                                                        } else {
                                                          final Directory?
                                                              appDirectory =
                                                              await getApplicationDocumentsDirectory();
                                                          videoDirectory =
                                                              '${appDirectory!.path}/Audio';
                                                          await Directory(
                                                                  videoDirectory)
                                                              .create(
                                                                  recursive:
                                                                      true);
                                                        }
                                                        if (io.File("$videoDirectory/$fileName")
                                                                .existsSync() ==
                                                            false) {
                                                          await downloadFile(
                                                              url,
                                                              fileName,
                                                              videoDirectory);
                                                        } else {
                                                          passFilePath =
                                                              "$videoDirectory/$fileName";
                                                        }
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UploadVideoScreen(
                                                              addMusicId:
                                                                  favoriteMusic[
                                                                          index]
                                                                      .id,
                                                              musicPath:
                                                                  passFilePath,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UsedSoundScreen(
                                                              songId: allMusic[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              isSongIdAvailable:
                                                                  true,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        height: ScreenUtil()
                                                            .setHeight(100),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Container(
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: favoriteMusic[
                                                                        index]
                                                                    .song!
                                                                    .imagePath! +
                                                                favoriteMusic[
                                                                        index]
                                                                    .song!
                                                                    .image!,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                CustomLoader(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Image.asset(
                                                                    "images/no_image.png"),
                                                          ),
                                                        )),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15,
                                                        right: 10,
                                                        top: 0,
                                                        bottom: 10),
                                                    height: ScreenUtil()
                                                        .setHeight(40),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Container(
                                                            child: ListView(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                    favoriteMusic[
                                                                            index]
                                                                        .song!
                                                                        .title!,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .visible,
                                                                    style: TextStyle(
                                                                        color: Color(Constants
                                                                            .whitetext),
                                                                        fontFamily:
                                                                            Constants
                                                                                .appFont,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    favoriteMusic[
                                                                            index]
                                                                        .song!
                                                                        .artist!,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .visible,
                                                                    style: TextStyle(
                                                                        color: Color(Constants
                                                                            .hinttext),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            Constants.appFont),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child:
                                                              PopupMenuButton<
                                                                  String>(
                                                            color: Color(
                                                                Constants
                                                                    .conbg),
                                                            icon: SvgPicture
                                                                .asset(
                                                              "images/more_menu.svg",
                                                              width: 20,
                                                              height: 20,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            18.0))),
                                                            offset:
                                                                Offset(20, 45),
                                                            onSelected:
                                                                handleClick,
                                                            itemBuilder:
                                                                (BuildContext
                                                                    context) {
                                                              selectedIndex =
                                                                  favoriteMusic[
                                                                          index]
                                                                      .song!
                                                                      .id;
                                                              return {
                                                                "- Remove From Favorites"
                                                              }.map((String
                                                                  choice) {
                                                                return PopupMenuItem<
                                                                    String>(
                                                                  value:
                                                                      "- Remove From Favorites",
                                                                  child: Text(
                                                                    "- Remove From Favorites",
                                                                    style: TextStyle(
                                                                        color: Color(Constants
                                                                            .whitetext),
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            Constants.appFontBold),
                                                                  ),
                                                                );
                                                              }).toList();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              staggeredTileBuilder:
                                                  (int index) =>
                                                      new StaggeredTile.count(
                                                          1,
                                                          index.isEven
                                                              ? 1.4
                                                              : 1.4),
                                              mainAxisSpacing: 1.0,
                                              crossAxisSpacing: 1.0,
                                            ),
                                          )
                                        : Container(
                                            child: Center(
                                                child: Text(
                                            "Music is not available",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                                  ),
                                  /// Playlist list
                                  Container(
                                    child: Center(
                                        child: Text(
                                      "Coming soon",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                  /// Local list
                                  Container(
                                      child: Center(
                                          child: Text(
                                    "Coming soon",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                                ]),
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
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  handleClick(String value) {
    print("menu click $selectedIndex");
    callApiForFavoriteSongRequest(selectedIndex);
  }

  Future<void> callApiForGetMusicData() async {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).addMusicRequest().then((response) {
      allMusic.clear();
      favoriteMusic.clear();
      playlistMusic.clear();
      popularMusic.clear();
      if (response.success!) {
        setState(() {
          showSpinner = false;
          allMusic.addAll(response.data!.all!);
          favoriteMusic.addAll(response.data!.favorite!);
          playlistMusic.addAll(response.data!.playlist!);
          popularMusic.addAll(response.data!.popular!);
        });
      } else {
        Constants.toastMessage('InternalServerError');
      }
    }).catchError((Object obj) {
      print(obj.toString());

      if (mounted)
        setState(() {
          showSpinner = false;
        });
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responsecode = res.statusCode;
          if (responsecode == 401) {
            Constants.toastMessage('$responsecode');
            print(responsecode);
            print(res.statusMessage);
          } else if (responsecode == 422) {
            print("code:$responsecode");
            print("msg:$msg");
            Constants.toastMessage('$responsecode');
          } else if (responsecode == 500) {
            print("code:$responsecode");
            print("msg:$msg");
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  void callApiForFavoriteSongRequest(int? id) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .addMusicFavoriteRequest(id)
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (success == true) {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callApiForGetMusicData());
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          Constants.checkNetwork().whenComplete(() => callApiForGetMusicData());
        });
      }
    }).catchError((Object obj) {
      print(obj.toString());

      if (mounted)
        setState(() {
          showSpinner = false;
        });
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responsecode = res.statusCode;
          if (responsecode == 401) {
            Constants.toastMessage('$responsecode');
            print(responsecode);
            print(res.statusMessage);
          } else if (responsecode == 422) {
            print("code:$responsecode");
            print("msg:$msg");
            Constants.toastMessage('$responsecode');
          } else if (responsecode == 500) {
            print("code:$responsecode");
            print("msg:$msg");
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  Future<String> downloadFile(String url, String? fileName, String dir) async {
    setState(() {
      showSpinner = true;
    });
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
    setState(() {
      showSpinner = false;
    });
    Constants.toastMessage('Download music successfully');
    passFilePath = filePath;
    return filePath;
  }
}
