import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/customview.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/custom/no_post_available.dart';
import 'package:acoustic/model/hashtag_video.dart';
import 'package:acoustic/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:dio/dio.dart';
import 'ownpost.dart';

class HashTagVideoListScreen extends StatefulWidget {
  final String? hashtag;
  final String? views;

  HashTagVideoListScreen({Key? key, required this.hashtag, required this.views})
      : super(key: key);

  @override
  _HashTagVideoListScreen createState() => _HashTagVideoListScreen();
}

class _HashTagVideoListScreen extends State<HashTagVideoListScreen> {
  bool isRememberMe = false;
  bool showSpinner = false;
  bool showRed = false;
  bool showWhite = true;
  late Future<List<HashtagVideoData>> _getHashtagVideoFeatureBuilder;
  List<HashtagVideoData> hashtagVideos = <HashtagVideoData>[];

  String deviceToken = "";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _getHashtagVideoFeatureBuilder = callApiForHashTagVideos();
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
                return Container(
                  margin: EdgeInsets.only(bottom: 0),
                  child: Stack(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight),
                        child: Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: ScreenUtil().setHeight(55),
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              alignment: Alignment.centerLeft,
                                              child: SvgPicture.asset(
                                                  "images/back.svg"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: ListView(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "#${widget.hashtag}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(
                                                          Constants.whitetext),
                                                      fontFamily:
                                                          Constants.appFontBold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  () {
                                                    if (1 <
                                                        int.parse(widget.views
                                                            .toString())) {
                                                      return "${widget.views} Views";
                                                    } else {
                                                      return "${widget.views} View";
                                                    }
                                                  }(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(
                                                          Constants.greytext),
                                                      fontFamily:
                                                          Constants.appFont,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 20),
                                          alignment: Alignment.centerRight,


                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: FutureBuilder<List<HashtagVideoData>>(
                                  future: _getHashtagVideoFeatureBuilder,
                                  builder: (context, snapshot) {
                                    switch(snapshot.connectionState){
                                      case ConnectionState.done:
                                        return (snapshot.data?.length ?? 0) > 0 ?Container(
                                          margin: EdgeInsets.only(
                                              bottom: 50, left: 20, right: 20),
                                          child: StaggeredGridView.countBuilder(
                                            physics:
                                            AlwaysScrollableScrollPhysics(),
                                            itemCount: hashtagVideos.length,
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) =>
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OwnPostScreen(hashtagVideos[index].id)));
                                                  },
                                                  child: Container(
                                                      padding:
                                                      EdgeInsets.all(5),
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10.0),
                                                      ),
                                                      child: new Container(
                                                        child: Stack(
                                                          children: [
                                                            /// screenshots
                                                            CachedNetworkImage(
                                                              imageUrl: hashtagVideos[
                                                              index]
                                                                  .imagePath! +
                                                                  hashtagVideos[
                                                                  index]
                                                                      .screenshot!,
                                                              imageBuilder:
                                                                  (context,
                                                                  imageProvider) =>
                                                                  Container(
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
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
                                                            /// play button
                                                            Container(
                                                              alignment:
                                                              Alignment
                                                                  .center,
                                                              child: SvgPicture
                                                                  .asset(
                                                                  "images/play_button.svg"),
                                                            ),
                                                            /// user name and profile pic
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  left:
                                                                  10,
                                                                  bottom:
                                                                  30),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  /// userprofile
                                                                  Align(
                                                                    alignment: Alignment
                                                                        .bottomCenter,
                                                                    child: CachedNetworkImage(
                                                                      imageUrl:
                                                                      hashtagVideos[index].user!.imagePath! + hashtagVideos[index].user!.image!,
                                                                      imageBuilder: (context, imageProvider) =>
                                                                          CircleAvatar(
                                                                            radius:
                                                                            15,
                                                                            backgroundColor:
                                                                            Color(0xFF36446b),
                                                                            child:
                                                                            CircleAvatar(
                                                                              radius: 15,
                                                                              backgroundImage: imageProvider,
                                                                            ),
                                                                          ),
                                                                      placeholder: (context, url) =>
                                                                          CustomLoader(),
                                                                      errorWidget: (context, url, error) =>
                                                                          Image.asset("images/no_image.png"),
                                                                    ),
                                                                  ),
                                                                  /// username
                                                                  Container(
                                                                    alignment: Alignment.bottomCenter,
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                        5,
                                                                        bottom:
                                                                        5),
                                                                    child:
                                                                    Text(
                                                                      hashtagVideos[index]
                                                                          .user!
                                                                          .name!,
                                                                      maxLines:
                                                                      1,
                                                                      overflow:
                                                                      TextOverflow.ellipsis,
                                                                      style:
                                                                      TextStyle(
                                                                        color:
                                                                        Color(Constants.whitetext),
                                                                        fontSize:
                                                                        14,
                                                                        fontFamily:
                                                                        Constants.appFont,
                                                                        fontWeight:
                                                                        FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            /// views
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(left: 10, right: 0, bottom:5),
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Text(
                                                                    () {
                                                                  if (1 <
                                                                      int.parse(hashtagVideos[index].viewCount.toString())) {
                                                                    return "${hashtagVideos[index].viewCount} Views";
                                                                  } else {
                                                                    return "${hashtagVideos[index].viewCount} View";
                                                                  }
                                                                }(),
                                                                style: TextStyle(
                                                                    color: Color(Constants.whitetext),
                                                                    fontSize: 16,
                                                                    fontFamily: Constants.appFont),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                            staggeredTileBuilder: (int index) =>
                                                StaggeredTile.count(2,
                                                    index.isEven ? 2.7 : 2.7),
                                            mainAxisSpacing: 2.0,
                                            crossAxisSpacing: 1.0,
                                            crossAxisCount: 4,
                                          ),
                                        ) : Align(
                                          alignment: Alignment.center,
                                          child: NoPostAvailable(subject: 'Posts',),
                                        );
                                      case ConnectionState.none:
                                        return CustomLoader();
                                      case ConnectionState.waiting:
                                        return CustomLoader();
                                      case ConnectionState.active:
                                        return CustomLoader();
                                      default:
                                        return CustomLoader();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                       Container(
                          padding: EdgeInsets.only(bottom: 10), child: Body()),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<List<HashtagVideoData>> callApiForHashTagVideos() async {



    await RestClient(ApiHeader().dioData())
        .hashtagVideo(widget.hashtag)
        .then((response) {




      if (mounted)
        setState(() {
          hashtagVideos.clear();
          hashtagVideos.addAll(response.data!);
        });
    }).catchError((Object obj) {
      print(obj.toString());
      Constants.toastMessage(obj.toString());




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
    return hashtagVideos;
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
