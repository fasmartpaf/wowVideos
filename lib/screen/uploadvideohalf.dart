import 'dart:async';
import 'dart:io';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:acoustic/util/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:acoustic/screen/uploadvideo.dart';
import 'package:acoustic/screen/uploadstatus.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'homescreen.dart';

class UploadVideoHalfScreen extends StatefulWidget {
  final String? videoPath;
  String? musicPath;
  final int videoLength;
  final bool isSong;
  final String songId;
  final String fromWhere;
  final String customMusic;

  UploadVideoHalfScreen({
    Key? key,
    required this.videoPath,
    required this.musicPath,
    required this.videoLength,
    required this.isSong,
    required this.songId,
    required this.fromWhere,
    required this.customMusic,
  }) : super(key: key);

  @override
  _UploadVideoHalfScreen createState() => _UploadVideoHalfScreen();
}

class _UploadVideoHalfScreen extends State<UploadVideoHalfScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? videoController;
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  String videoPath = '';
  String videoFileName = '';
  String thumbPath = '';
  bool showSpinner = false;
  bool show = true;
  String cutAudio = '';
  final assetsAudioPlayer = AssetsAudioPlayer();


  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    videoController = VideoPlayerController.file(File(widget.videoPath!))
      ..initialize().then((value) => setState(() {}));
    videoController!.setLooping(true);
    videoController!.setVolume(1);

    if (widget.musicPath != null && widget.musicPath != "") {
      assetsAudioPlayer.open(
        Audio.network(widget.customMusic),
        autoStart: false,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoController!.dispose();
    assetsAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPressBackButton,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: CustomLoader(),
            child: Container(
              margin: EdgeInsets.only(bottom: 0),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        color: Color(Constants.bgblack),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SizedBox(
                          child: Container(
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  videoController!.value.isPlaying
                                      ? setState(() {
                                          videoController!.pause();
                                        })
                                      : setState(() {
                                          videoController!.play();
                                        });
                                  if (widget.musicPath != null &&
                                      widget.musicPath != "") {
                                    videoController!.value.isPlaying
                                        ? setState(() {
                                            assetsAudioPlayer.play();
                                          })
                                        : setState(() {
                                            assetsAudioPlayer.pause();
                                          });
                                  }
                                },
                                child: AspectRatio(
                                  aspectRatio:
                                      videoController!.value.size != null
                                          ? videoController!.value.aspectRatio
                                          : 1.0,
                                  child:



                                      VideoPlayer(videoController!),
                                ),
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {


                        setState(() {
                          videoController!.value.isPlaying
                              ? videoController!.pause()
                              : videoController!.play();
                        });
                        if (widget.musicPath != null &&
                            widget.musicPath != "") {
                          videoController!.value.isPlaying
                              ? setState(() {
                                  assetsAudioPlayer.play();
                                })
                              : setState(() {
                                  assetsAudioPlayer.pause();
                                });
                        }
                      },
                      child: Visibility(
                        visible: show,
                        child: Align(
                          alignment: Alignment.center,
                          child: videoController!.value.isPlaying
                              ? Icon(
                                  Icons.motion_photos_pause_outlined,
                                  color: Colors.white,
                                  size: 90,
                                )
                              : SvgPicture.asset(
                                  "images/small_play_button.svg",
                                  width: 70,
                                  height: 70,
                                  alignment: Alignment.center,
                                ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  show = false;
                                });
                                await callApiForThumb();
                                await mergeVideo().then((value) {
                                  if (value == true) {
                                    videoController!.pause();
                                    if (widget.fromWhere == "gallery") {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UploadStatusScreen(
                                            videoPath: videoPath,
                                            thumbPath: thumbPath,
                                            videoFileName: videoFileName,
                                            songId: widget.songId,
                                            duration: widget.videoLength,
                                            fromWhere: widget.fromWhere,
                                            sound: widget.musicPath,
                                            cutAudio: cutAudio,
                                          ),
                                        ),
                                      );
                                    } else {
                                      if (widget.musicPath != null &&
                                          widget.musicPath != "") {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UploadStatusScreen(
                                              videoPath: videoPath,
                                              thumbPath: thumbPath,
                                              videoFileName: videoFileName,
                                              songId: widget.songId,
                                              duration: widget.videoLength,
                                              fromWhere: widget.fromWhere,
                                              sound: widget.musicPath,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UploadStatusScreen(
                                              videoPath: videoPath,
                                              thumbPath: thumbPath,
                                              videoFileName: videoFileName,
                                              songId: widget.songId,
                                              duration: widget.videoLength,
                                              fromWhere: widget.fromWhere,
                                              sound: widget.musicPath,
                                              cutAudio: cutAudio,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }else{
                                    showDialog(
                                      context: context,
                                      builder: (context) => new AlertDialog(
                                        title: new Text('Video Convert Error!'),
                                        content: new Text('Please go back and recapture video.'),
                                        actions: <Widget>[
                                          IconButton(onPressed: (){
                                            videoController?.pause();
                                            assetsAudioPlayer.dispose();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => UploadVideoScreen()));
                                          }, icon:Text("OK") )
                                        ],
                                      ),
                                    );
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 20, top: 0),
                                child: SvgPicture.asset("images/back12.svg"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 50, left: 20),
                        child: InkWell(
                          onTap: () {
                            videoController!.pause();
                            assetsAudioPlayer.pause();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UploadVideoScreen()));
                          },
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Container(
                                child: SvgPicture.asset("images/re_record.svg"),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Cancel & Re-Record",
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontFamily: Constants.appFont,
                                      fontSize: 14),
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
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> mergeVideo() async {
    bool isVideoConvert = true;
    setState(() {
      showSpinner = true;
    });
    late String outputDirectory;
    if (Platform.isAndroid) {
      final Directory? appDirectory = await (getExternalStorageDirectory());
      outputDirectory = '${appDirectory!.path}/outputVideos';
    } else {
      final Directory? appDirectory =
          await (getApplicationDocumentsDirectory());
      outputDirectory = '${appDirectory!.path}/outputVideos';
    }

    await Directory(outputDirectory).create(recursive: true);

    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();

    late String outputDirectorys;
    if (Platform.isAndroid) {
      final Directory? appDirectorys = await (getExternalStorageDirectory());
      outputDirectorys = '${appDirectorys!.path}/mergeVideo';
    } else {
      final Directory? appDirectorys =
          await (getApplicationDocumentsDirectory());
      outputDirectorys = '${appDirectorys!.path}/mergeVideo';
    }
    await Directory(outputDirectorys).create(recursive: true);
    if (widget.musicPath != null && widget.musicPath != "") {


      print("Merge Audio");
      await trimSong();

      await _flutterFFmpeg
          .execute(
              "-i ${widget.musicPath} -i ${widget.videoPath} -i ${PreferenceUtils.getString(Constants.waterMarkPath)} -c:v mpeg4 -filter_complex 'overlay=20:20' $outputDirectorys/$currentTime-merge.mp4")
          .then((rc) {
        if (rc == 1) {
          isVideoConvert = false;
          Constants.toastMessage('something went wrong in VC');
        }
        assert(rc != 1);
        print("FFmpeg process exited with rc $rc");
      });

      setState(() {
        videoPath = '$outputDirectorys/';

        videoFileName = "$currentTime-merge.mp4";
      });
    } else {
      await _flutterFFmpeg
          .execute(
              "-i ${widget.videoPath} -i ${PreferenceUtils.getString(Constants.waterMarkPath)} -c:v mpeg4 -filter_complex 'overlay=20:20' $outputDirectorys/$currentTime-merge.mp4")
          .then((rc) {
        if (rc == 1) {
          isVideoConvert = false;
          Constants.toastMessage('something went wrong in VC');
        }
        assert(rc != 1);
        print("FFmpeg process exited with rc $rc");
      });

      late String outputDirectorysCutAudio;
      if (Platform.isAndroid) {
        final Directory? appDirectorys = await (getExternalStorageDirectory());
        outputDirectorysCutAudio = '${appDirectorys!.path}/cutAudioFromVideo';
      } else {
        final Directory? appDirectorys =
            await (getApplicationDocumentsDirectory());
        outputDirectorysCutAudio = '${appDirectorys!.path}/cutAudioFromVideo';
      }

      await Directory(outputDirectorysCutAudio).create(recursive: true);
      final String currentTimeCutAudio =
          DateTime.now().millisecondsSinceEpoch.toString();
      await _flutterFFmpeg
          .execute(
              "-i ${widget.videoPath} -vn -acodec copy $outputDirectorysCutAudio/$currentTimeCutAudio-merge.aac")
          .then((rc) {
        if (rc == 1) {
          isVideoConvert = false;
          Constants.toastMessage('something went wrong in VC');
        }
        assert(rc != 1);
        print("from gallery FFmpeg process exited with rc $rc");
      });
      setState(() {
        videoPath = '$outputDirectorys/';
        videoFileName = "$currentTime-merge.mp4";
        cutAudio = "$outputDirectorysCutAudio/$currentTimeCutAudio-merge.aac";
      });
    }

    ///cut video

    if (widget.fromWhere == "gallery") {
      late String outputDirectorys;
      if (Platform.isAndroid) {
        final Directory? appDirectorys = await (getExternalStorageDirectory());
        outputDirectorys = '${appDirectorys!.path}/cutAudioFromVideo';
      } else {
        final Directory? appDirectorys =
            await (getApplicationDocumentsDirectory());
        outputDirectorys = '${appDirectorys!.path}/cutAudioFromVideo';
      }
      await Directory(outputDirectorys).create(recursive: true);
      final String currentTime =
          DateTime.now().millisecondsSinceEpoch.toString();
      await _flutterFFmpeg
          .execute(
              "-i ${widget.videoPath} -vn -acodec copy $outputDirectorys/$currentTime-merge.aac")
          .then((rc) {
        if (rc == 1) {
          isVideoConvert = false;
          Constants.toastMessage('something went wrong in VC');
        }
        assert(rc != 1);
        print("from gallery FFmpeg process exited with rc $rc");
      });
      cutAudio = "$outputDirectorys/$currentTime-merge.aac";
    }

    setState(() {
      showSpinner = false;
    });
    return isVideoConvert;
  }

  Future<void> callApiForThumb() async {
    final thumbnailFile =
        await VideoCompress.getFileThumbnail(widget.videoPath!,
            quality: 50, // default(100)
            position: -1 // default(-1)
            );
    thumbPath = thumbnailFile.path;
    print(thumbnailFile.path);
  }

  Future<void> trimSong() async {
    late String outputDirectory;
    if (Platform.isAndroid) {
      final Directory? appDirectory = await (getExternalStorageDirectory());
      outputDirectory = '${appDirectory!.path}/outputCutSongs';
    } else {
      final Directory? appDirectory =
          await (getApplicationDocumentsDirectory());
      outputDirectory = '${appDirectory!.path}/outputCutSongs';
    }
    await Directory(outputDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    await _flutterFFmpeg
        .execute(
            "-i ${widget.musicPath} -ss 00:00:00 -t ${widget.videoLength}.0 -c copy $outputDirectory/$currentTime-cut.mp3")
        .then((rc) {
      if (rc == 1) {
        Constants.toastMessage('something went wrong in VC');
      }
      assert(rc != 1);
      widget.musicPath = "$outputDirectory/$currentTime-cut.mp3";
      print("FFmpeg process exited with rc $rc");
    });
  }

  Future<bool> _onPressBackButton() async {


    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to go back'),
            actions: <Widget>[
              IconButton(onPressed: (){Navigator.of(context).pop(false);}, icon: Text("NO")),
              SizedBox(
                width: 10.0,
              ),
              IconButton(onPressed: (){videoController?.pause();
              videoController?.pause();
              assetsAudioPlayer.dispose();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreen(0)));}, icon: Text("YES"))
            ],
          ),
        ) as FutureOr<bool>? ??
        false;
  }
}
