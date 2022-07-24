import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/model/single_audio.dart';
import 'package:acoustic/model/single_song_modal.dart';
import 'package:acoustic/screen/uploadvideo.dart';
import 'package:acoustic/util/constants.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:acoustic/screen/addmusic.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:dio/dio.dart';

class UsedSoundScreen extends StatefulWidget {
  final String? songId;
  final bool isSongIdAvailable;
  UsedSoundScreen(
      {Key? key, required this.songId, required this.isSongIdAvailable})
      : super(key: key);
  @override
  _UsedSoundScreen createState() => _UsedSoundScreen();
}

class _UsedSoundScreen extends State<UsedSoundScreen> {
  bool isRememberMe = false;
  bool showSpinner = false;
  bool showRed = false;
  bool showWhite = true;
  bool audioPlaying = false;

  String deviceToken = "";
  int songId = 0;
  String? songTitle = '';
  String? songArtist = '';
  String songProfilePic = '';
  String totalPosts = '0';
  List<Videos> songVideos = [];
  List<AllVideos> audioVideos = [];
  String shareMusic = '';
  bool isFavorite = false;
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool isBookmarkAvailable = false;
  String passFilePath = '';
  String? customStorageSong = '';

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    if (widget.songId != null) {
      songId = int.parse(widget.songId.toString());
      if (widget.isSongIdAvailable == true) {
        Constants.checkNetwork()
            .whenComplete(() => callApiForSongRequest(songId));
      } else {
        Constants.checkNetwork()
            .whenComplete(() => callApiForAudioRequest(songId));
      }
    }
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
          appBar: AppBar(
            title: Text(
              " ",
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            actions: <Widget>[
              isBookmarkAvailable == true
                  ? InkWell(
                      onTap: () {
                        callApiForFavoriteSongRequest(songId);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 20, top: 5),
                        child: isFavorite == false
                            ? SvgPicture.asset(
                                "images/save_music.svg",

                              )
                            : Icon(
                                Icons.bookmark,
                                color: Colors.white,
                                size: 30,
                              ),
                      ),
                    )
                  : Container(),
              InkWell(
                onTap: () {
                  Share.share('$shareMusic');
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20, top: 5),
                  child: SvgPicture.asset("images/music_share.svg"),
                ),
              ),
            ],
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
                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(


                        children: [
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                            child: Container(

                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      splashColor: Colors.black,
                                      onTap: () {
                                        setState(() {
                                          audioPlaying == true
                                              ? assetsAudioPlayer.pause()
                                              : assetsAudioPlayer
                                                  .play()
                                                  .onError((dynamic error,
                                                          stackTrace) =>
                                                      Constants.toastMessage(
                                                          "Can't play song"));
                                          audioPlaying = !audioPlaying;
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 10, left: 20),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CachedNetworkImage(
                                              alignment: Alignment.center,
                                              imageUrl: songProfilePic,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width:
                                                    ScreenUtil().setWidth(120),
                                                height:
                                                    ScreenUtil().setHeight(120),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                    alignment: Alignment.center,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) => CustomLoader(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      "images/no_image.png"),
                                            ),
                                            audioPlaying == true
                                                ? Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Icon(
                                                      Icons
                                                          .motion_photos_pause_outlined,
                                                      color: Colors.white,
                                                      size: 48,
                                                    ))
                                                : Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: SvgPicture.asset(
                                                      "images/small_play_button.svg",
                                                      width: 40,
                                                      height: 40,
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(
                                          right: 20, top: 10, left: 20),
                                      child: ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Original Sound - $songTitle",
                                              style: TextStyle(
                                                  color: Color(
                                                      Constants.whitetext),
                                                  fontSize: 18,
                                                  fontFamily:
                                                      Constants.appFont),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 0, top: 5, left: 0),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "$songArtist",
                                              style: TextStyle(
                                                  color:
                                                      Color(Constants.greytext),
                                                  fontSize: 16,
                                                  fontFamily:
                                                      Constants.appFont),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 0, top: 5, left: 0),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              () {
                                                if (1 <
                                                    int.parse(totalPosts
                                                        .toString())) {
                                                  return "$totalPosts Posts";
                                                } else {
                                                  return "$totalPosts Post";
                                                }
                                              }(),
                                              style: TextStyle(
                                                  color:
                                                      Color(Constants.greytext),
                                                  fontSize: 16,
                                                  fontFamily:
                                                      Constants.appFont),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 0, top: 18, left: 0),
                                            alignment: Alignment.topLeft,
                                            child: InkWell(
                                              onTap: () async {
                                                String url = shareMusic;
                                                String? fileName =
                                                    customStorageSong;
                                                late String videoDirectory;
                                                if (Platform.isAndroid) {
                                                  final Directory?
                                                      appDirectory =
                                                      await (getExternalStorageDirectory());
                                                  videoDirectory =
                                                      '${appDirectory!.path}/Audio';
                                                } else {
                                                  final Directory?
                                                      appDirectory =
                                                      await (getApplicationDocumentsDirectory());
                                                  videoDirectory =
                                                      '${appDirectory!.path}/Audio';
                                                }
                                                await Directory(videoDirectory)
                                                    .create(recursive: true);
                                                if (io.File("$videoDirectory/$fileName")
                                                        .existsSync() ==
                                                    false) {
                                                  await downloadFile(url,
                                                      fileName, videoDirectory);
                                                } else {
                                                  passFilePath =
                                                      "$videoDirectory/$fileName";
                                                }
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UploadVideoScreen(
                                                      addMusicId: songId,
                                                      musicPath: passFilePath,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: SvgPicture.asset(
                                                        "images/music_icon.svg"),
                                                  ),
                                                  Text(
                                                    "Use This Sound",
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .lightbluecolor),
                                                        fontSize: 16,
                                                        fontFamily:
                                                            Constants.appFont),
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
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                            child: widget.isSongIdAvailable == true
                                ? 0 < songVideos.length
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            bottom: 0,
                                            left: 15,
                                            right: 15,
                                            top: 10),
                                        child: StaggeredGridView.countBuilder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          crossAxisCount: 3,
                                          itemCount: songVideos.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              new Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: new Container(
                                              child: Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: songVideos[index]
                                                            .imagePath! +
                                                        songVideos[index]
                                                            .screenshot!,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.fill,
                                                          alignment: Alignment
                                                              .topCenter,
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) => CustomLoader(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Image.asset(
                                                            "images/no_image.png"),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: SvgPicture.asset(
                                                      "images/play_button.svg",
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 0,
                                                        bottom: 5),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                              () {
                                                                if (1 <
                                                                    int.parse(songVideos[
                                                                            index]
                                                                        .viewCount!)) {
                                                                  return "${songVideos[index].viewCount} Views";
                                                                } else {
                                                                  return "${songVideos[index].viewCount} View";
                                                                }
                                                              }(),
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
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child: ListView(
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    NeverScrollableScrollPhysics(),
                                                                children: [
                                                                  Container(
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          Constants.checkNetwork().whenComplete(() => callApiForLikedVideo(
                                                                              songVideos[index].id,
                                                                              context));
                                                                        });
                                                                      },
                                                                      child: songVideos[index].isLike ==
                                                                              true
                                                                          ? SvgPicture
                                                                              .asset(
                                                                              "images/red_heart.svg",
                                                                              width: 15,
                                                                              height: 15,
                                                                            )
                                                                          : SvgPicture
                                                                              .asset(
                                                                              "images/white_heart.svg",
                                                                              width: 15,
                                                                              height: 15,
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          staggeredTileBuilder: (int index) =>
                                              new StaggeredTile.count(
                                                  1, index.isEven ? 1.5 : 1.5),
                                          mainAxisSpacing: 1.0,
                                          crossAxisSpacing: 1.0,
                                        ),
                                      )
                                    : Center(
                                        child: Container(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              height:
                                                  ScreenUtil().setHeight(80),
                                              margin: const EdgeInsets.only(
                                                  top: 10.0,
                                                  left: 15.0,
                                                  right: 15,
                                                  bottom: 0),
                                              child: Text(
                                                "No Post Available !",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        Constants.appFont,
                                                    fontSize: 20),
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                : 0 < audioVideos.length
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            bottom: 0,
                                            left: 15,
                                            right: 15,
                                            top: 10),
                                        child: StaggeredGridView.countBuilder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          crossAxisCount: 3,
                                          itemCount: audioVideos.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              new Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: new Container(
                                                    child: Stack(
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl: audioVideos[
                                                                      index]
                                                                  .imagePath! +
                                                              audioVideos[index]
                                                                  .screenshot!,
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
                                                                fit:
                                                                    BoxFit.fill,
                                                                alignment:
                                                                    Alignment
                                                                        .topCenter,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) => CustomLoader(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                                  "images/no_image.png"),
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              SvgPicture.asset(
                                                            "images/play_button.svg",
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 0,
                                                                  bottom: 5),
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child: Text(
                                                                    () {
                                                                      if (1 <
                                                                          int.parse(
                                                                              audioVideos[index].viewCount!)) {
                                                                        return "${audioVideos[index].viewCount} Views";
                                                                      } else {
                                                                        return "${audioVideos[index].viewCount} View";
                                                                      }
                                                                    }(),
                                                                    style: TextStyle(
                                                                        color: Color(Constants
                                                                            .whitetext),
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            Constants.appFont),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomRight,
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomRight,
                                                                    child:
                                                                        ListView(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                Constants.checkNetwork().whenComplete(() => callApiForLikedVideo(audioVideos[index].id, context));
                                                                              });
                                                                            },
                                                                            child: audioVideos[index].isLike == true
                                                                                ? SvgPicture.asset(
                                                                                    "images/red_heart.svg",
                                                                                    width: 15,
                                                                                    height: 15,
                                                                                  )
                                                                                : SvgPicture.asset(
                                                                                    "images/white_heart.svg",
                                                                                    width: 15,
                                                                                    height: 15,
                                                                                  ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                          staggeredTileBuilder: (int index) =>
                                              new StaggeredTile.count(
                                                  1, index.isEven ? 1.5 : 1.5),
                                          mainAxisSpacing: 1.0,
                                          crossAxisSpacing: 1.0,
                                        ),
                                      )
                                    : Center(
                                        child: Container(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              height:
                                                  ScreenUtil().setHeight(80),
                                              margin: const EdgeInsets.only(
                                                  top: 10.0,
                                                  left: 15.0,
                                                  right: 15,
                                                  bottom: 0),
                                              child: Text(
                                                "No Post Available !",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        Constants.appFont,
                                                    fontSize: 20),
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                          ),
                        ],
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

  void callApiForSongRequest(int songId) {
    songVideos.clear();
    audioVideos.clear();
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .singleMusicRequest(songId)
        .then((response) async {
      setState(() {
        showSpinner = false;
      });
      if (response.success!) {
        if (mounted)
          setState(() {
            isBookmarkAvailable = true;
            songTitle = response.data!.title;
            songArtist = response.data!.artist;
            songProfilePic = response.data!.imagePath! + response.data!.image!;
            totalPosts = response.data!.videos!.length.toString();
            songVideos.addAll(response.data!.videos!);
            audioVideos.clear();
            shareMusic = response.data!.imagePath! + response.data!.audio!;
            customStorageSong = response.data!.audio;
          });
        assetsAudioPlayer.open(
          Audio.network(response.data!.imagePath! + response.data!.audio!),
          autoStart: false,
        );
        if (response.data!.isFavorite == 1) {
          isFavorite = true;
        } else {
          isFavorite = false;
        }
      }
    }).catchError((Object obj) {
      print(obj.toString());
      Constants.toastMessage(obj.toString());
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

  void callApiForAudioRequest(int songId) {
    songVideos.clear();
    audioVideos.clear();
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .singleAudioRequest(songId)
        .then((response) async {
      setState(() {
        showSpinner = false;
      });
      if (response.success!) {
        setState(() {
          isBookmarkAvailable = false;
          songTitle = "Original";
          songArtist = response.data!.user!.name;
          songProfilePic =
              response.data!.user!.imagePath! + response.data!.user!.image!;
          totalPosts = response.data!.allVideos!.length.toString();
          audioVideos.addAll(response.data!.allVideos!);
          shareMusic = response.data!.imagePath! + response.data!.audio!;
          songVideos.clear();
        });
        assetsAudioPlayer.open(
          Audio.network(response.data!.imagePath! + response.data!.audio!),
          autoStart: false,
        );
      }
    }).catchError((Object obj) {
      print(obj.toString());
      Constants.toastMessage(obj.toString());
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

  void callApiForLikedVideo(int? id, BuildContext context) {
    print("likeid:$id");
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).likevideo(id).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      print("likevideosucees:$success");

      if (success == true) {
        setState(() {
          showSpinner = false;


          print("likevidmsg:${body['msg']}");




          widget.isSongIdAvailable == true
              ? callApiForSongRequest(songId)
              : callApiForAudioRequest(songId);



        });
      } else {
        setState(() {
          showSpinner = false;





        });
      }
    }).catchError((Object obj) {
      Constants.createSnackBar(
          "Server Error", context, Color(Constants.lightbluecolor));


      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  void callApiForFavoriteSongRequest(int id) {
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
          if (body['data'] == 1) {
            Constants.checkNetwork().whenComplete(() => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddMusicScreen(
                            fromVideoUpload: false,
                          )),
                ));
          } else {
            if (widget.songId != null) {
              songId = int.parse(widget.songId.toString());
              if (widget.isSongIdAvailable == true) {
                Constants.checkNetwork()
                    .whenComplete(() => callApiForSongRequest(songId));
              } else {
                Constants.checkNetwork()
                    .whenComplete(() => callApiForAudioRequest(songId));
              }
            }
          }
        });
      } else {
        setState(() {
          showSpinner = false;
          var msg = body['msg'];
          Constants.toastMessage(msg);
          if (body['data'] == 1) {
            Constants.checkNetwork().whenComplete(() => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddMusicScreen(
                            fromVideoUpload: false,
                          )),
                ));
          } else {
            if (widget.songId != null) {
              songId = int.parse(widget.songId.toString());
              if (widget.isSongIdAvailable == true) {
                Constants.checkNetwork()
                    .whenComplete(() => callApiForSongRequest(songId));
              } else {
                Constants.checkNetwork()
                    .whenComplete(() => callApiForAudioRequest(songId));
              }
            }
          }
        });
      }
    }).catchError((Object obj) {
      print(obj.toString());
      Constants.toastMessage(obj.toString());
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

  Future<bool> _onWillPop() async {
    assetsAudioPlayer.stop();
    return true;
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
