import 'dart:async';
import 'dart:io';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/trimmer_addition/trimmer_view.dart';
import 'package:acoustic/screen/addmusic.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:camera/camera.dart';
import 'package:acoustic/util/custom_countdown_progress_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:acoustic/util/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:acoustic/screen/uploadvideohalf.dart';
import 'package:acoustic/screen/homescreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:acoustic/widget/MarqueWidget.dart';


List<CameraDescription> cameras = [];

class UploadVideoScreen extends StatefulWidget {
  final addMusicId;
  String? musicPath;

  UploadVideoScreen({Key? key, this.addMusicId, this.musicPath})
      : super(key: key);

  @override
  _UploadVideoScreen createState() => _UploadVideoScreen();
}

IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
    default:
      throw ArgumentError('Unknown lens direction');
  }
}

void logError(String code, String? message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}

class _UploadVideoScreen extends State<UploadVideoScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;


  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  Animation<double>? _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  Animation<double>? _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  Animation<double>? _focusModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  bool showCamera = true;
  bool showVideo = false;
  bool showAllButton = true;
  bool toggleFlash = false;

  bool threeFour = false;
  bool fourThree = false;
  bool oneOne = false;
  bool sixNine = false;
  bool nineSix = false;

  bool showSpinner = false;
  String? musicName = '';
  String actualAudio = '';
  String songId = '';

  final assetsAudioPlayer = AssetsAudioPlayer();



  double videoProgressPercent = 0;
  String? videoPath;
  bool showProgressBar = false;
  bool videoRecorded = false;
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  double totalDurationOfAudio = 0;
  File? thumbnailFile;


  bool slower = false;
  bool Slow = false;
  bool Normal = false;
  bool Fast = false;
  bool Fastest = false;
  TabController? tabController;

  bool threesec = false;
  bool fivesec = false;
  bool eightsec = false;
  bool tensec = false;


  double _value = 50;

  late List<CameraDescription> _availableCameras;


  int _pointers = 0;
  Timer? _timer;
  int countdown = 0;
  int videoTime = 15;
  int? selectedCameraIdx;
  final countDown = CountDownController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });
        _onCameraSwitched(cameras[selectedCameraIdx!]).then((void v) {});
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });

    controller = CameraController(cameras[0], ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.yuv420);
    _getAvailableCameras();
    if (widget.addMusicId == null) {
    } else {
      callApiForSongRequest(widget.addMusicId);
      onAudioModeButtonPressed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    _timer!.cancel();
    videoController!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;


    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countdown == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            countdown--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;


    var deviceRatio = size.width / size.height;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.black54),
    );

    return SafeArea(
      child: WillPopScope(
        onWillPop: _onPressBackButton,
        child: Scaffold(
          key: _scaffoldKey,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: CustomLoader(),
            child: Stack(
              children: <Widget>[
                ///for camera
                Visibility(
                  visible: showCamera,
                  child: GestureDetector(
                    child: Center(
                      child: Transform.scale(
                        scale: (!controller!.value.isInitialized)
                            ? 1
                            : controller!.value.aspectRatio / deviceRatio,
                        child: new AspectRatio(
                          aspectRatio: (!controller!.value.isInitialized)
                              ? 1
                              : controller!.value.aspectRatio,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Center(
                                      child: (!controller!.value.isInitialized)
                                          ? CustomLoader()
                                          : _cameraPreviewWidget(),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onDoubleTap: () {
                      _onSwitchCamera();
                    },
                  ),
                ),

                Visibility(
                  visible: showAllButton,
                  child: Positioned(
                    top: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 30),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(enableAudio
                                  ? Icons.music_note
                                  : Icons.music_off),
                              color: Colors.blue,
                              onPressed: controller != null
                                  ? onAudioModeButtonPressed
                                  : null,
                            ),
                            MarqueeWidget(
                              direction: Axis.horizontal,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddMusicScreen(
                                        fromVideoUpload: true,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,


                                      padding: EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(
                                          "images/small_music_note.svg"),
                                    ),
                                    Text(
                                      () {
                                        if (musicName != '') {
                                          return musicName;
                                        } else {
                                          return "Add a Music";
                                        }
                                      }()!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          color: Color(Constants.whitetext),
                                          fontFamily: Constants.appFont),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => new AlertDialog(
                                    title: new Text('Are you sure?'),
                                    content: new Text('Do you want go back'),
                                    actions: <Widget>[
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          icon: Text("NO")),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      IconButton(
                                          onPressed: () {

                                            assetsAudioPlayer.pause();
                                            videoController?.pause();
                                            controller?.dispose();

                                            _timer?.cancel();
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen(0)));
                                          },
                                          icon: Text("YES"))
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                padding: EdgeInsets.all(5.0),
                                child: SvgPicture.asset("images/close.svg"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: showAllButton,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: ScreenUtil().setHeight(55),
                      color: Colors.transparent.withOpacity(0.3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                videoTime = 15;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: videoTime == 15
                                      ? Colors.white60
                                      : Colors.transparent.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Text(
                                "15s",
                                style: TextStyle(
                                    color: Color(Constants.whitetext),
                                    fontFamily: Constants.appFont,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 80, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///effects button
                        Visibility(
                          visible: showAllButton,
                          child: Expanded(
                            flex: 1,
                            child: Container(
                              child: InkWell(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [],
                                ),
                              ),
                            ),
                          ),
                        ),
                        ///record button
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              if (controller != null &&
                                  controller!.value.isInitialized &&
                                  !controller!.value.isRecordingVideo) {
                                setState(() {
                                  countDown.start();
                                  showAllButton = false;
                                });
                                onVideoRecordButtonPressed();
                                setState(() {
                                  Timer(Duration(seconds: videoTime.toInt()),
                                      () {
                                    onStopButtonPressed();
                                  });
                                });
                              } else {
                                onStopButtonPressed();
                              }
                            },
                            child: Container(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: CountDownProgressIndicator(
                                        controller: countDown,
                                        valueColor:
                                            Color(Constants.lightbluecolor),
                                        backgroundColor: Colors.white54,
                                        initialPosition: 0,
                                        duration: videoTime,
                                        onComplete: () => null,
                                        autostart: false,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color:
                                                Color(Constants.lightbluecolor),
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ),
                          ),
                        ),
                        /// upload button
                        Visibility(
                          visible: showAllButton,
                          child: Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                child: InkWell(
                                  onTap: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.video,
                                      allowCompression: false,
                                    );
                                    if (result != null) {
                                      File file =
                                          File(result.files.single.path!);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return TrimmerView(
                                            file: file,
                                            onVideoSave: (output) async {
                                              setState(() {
                                                print("outputPath $output");
                                                videoPath = output;
                                              });
                                              print("videoPath $videoPath");
                                              Navigator.pop(context);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UploadVideoHalfScreen(
                                                    videoPath: videoPath,
                                                    musicPath: widget.musicPath,
                                                    songId: songId,
                                                    isSong: false,
                                                    videoLength: videoTime,
                                                    fromWhere: 'gallery',
                                                    customMusic: actualAudio,
                                                  ),
                                                ),
                                              );
                                            },
                                            maxLength: double.parse(
                                                videoTime.toString()),
                                            sound: widget.musicPath,
                                          );
                                        }),
                                      );
                                    }
                                  },

                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                            "images/upload.svg"),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Upload",
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 14,
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ///old
                Visibility(
                  visible: showAllButton,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(left: 10, bottom: 10),
                            width: 100.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                    onTap: () {
                                      _openTimerBottomSheet();
                                    },
                                    child: _getSocialAction(
                                        icon: "images/timer.svg",
                                        title: "Timer")),
                                ///Flip
                                InkWell(
                                    onTap: () {

                                      _toggleCameraLens();

                                    },
                                    child: _getSocialAction(
                                        icon: "images/flip.svg",
                                        title: "Flip")),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      showVideo = false;
                      showAllButton = true;
                    });
                  },
                  child: Visibility(
                    visible: showVideo,
                    child: _thumbnailWidget(),
                  ),
                ),
                0 < countdown
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          '$countdown',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 80,
                          ),
                        ))
                    : Container(),
















              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onPressBackButton() async {


    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to go back'),
            actions: <Widget>[
              IconButton(onPressed: (){ Navigator.of(context).pop(false);}, icon: Text("NO")),
              SizedBox(
                width: 10.0
              ),
              IconButton(onPressed: (){
                assetsAudioPlayer.pause();
                videoController?.pause();
                controller?.dispose();

                _timer?.cancel();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen(0)));}, icon: Text("YES")),
            ],
          ),
        ) as FutureOr<bool>? ??
        false;
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return CameraPreview(controller!);
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {

    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);


  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    final VideoPlayerController? localVideoController = videoController;

    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          localVideoController == null
              ? Container()
              : SizedBox(
                  child: Container(
                    child: Center(
                      child: AspectRatio(
                          aspectRatio: localVideoController.value.size != null
                              ? localVideoController.value.aspectRatio
                              : 1.0,
                          child: VideoPlayer(localVideoController)),
                    ),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.pink)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
        ],
      ),
    );
  }

  void showInSnackBar(String message) {

    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {

    }
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (controller != null) {
      onNewCameraSelected(controller!.description);
    }
  }

  void onVideoRecordButtonPressed() {
    setState(() {
      videoRecorded = true;

    });
    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });






  }

  void onStopButtonPressed() {
    setState(() {
      showSpinner = false;
      videoRecorded = false;
    });
    stopVideoRecording().then((file) async {
      print("the file path is ${file!.path}");









      late String filePath;
      if (Platform.isAndroid) {
        final Directory? appDirectory = await (getExternalStorageDirectory());
        final String videoDirectory = '${appDirectory!.path}/Videos';
        await Directory(videoDirectory).create(recursive: true);
        /*final String currentTime =
        "$countVideos" + DateTime.now().millisecondsSinceEpoch.toString();*/
        final String currentTime =
            DateTime.now().millisecondsSinceEpoch.toString();
        filePath = '$videoDirectory/$currentTime.mp4';
      } else {
        final Directory? appDirectory =
            await (getApplicationDocumentsDirectory());
        final String videoDirectory = '${appDirectory!.path}/Videos';
        await Directory(videoDirectory).create(recursive: true);
        /*final String currentTime =
        "$countVideos" + DateTime.now().millisecondsSinceEpoch.toString();*/
        final String currentTime =
            DateTime.now().millisecondsSinceEpoch.toString();
        filePath = '$videoDirectory/$currentTime.mp4';
      }









      file.saveTo(filePath);
      videoPath = filePath;
      if (mounted)
        setState(() {
          showSpinner = false;
        });






      bool isSong = false;
      if (widget.musicPath == null && widget.musicPath == "") {
        widget.musicPath = "";
        isSong = true;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UploadVideoHalfScreen(
            videoPath: videoPath,
            musicPath: widget.musicPath,
            videoLength: videoTime,
            isSong: isSong,
            songId: songId,
            fromWhere: 'camera',
            customMusic: actualAudio,
          ),
        ),
      );
    });
    setState(() {
      showCamera = false;
      showVideo = true;
    });
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      /// prefer using rename as it is probably faster
      /// if same directory path
      return await sourceFile.rename(newPath);
    } catch (e) {
      /// if rename fails, copy the source file
      final newFile = await sourceFile.copy(newPath);
      return newFile;
    }
  }

  Future<void> startVideoRecording() async {
    setState(() {
      showProgressBar = true;
    });
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    if (enableAudio == false) {

      assetsAudioPlayer.play();
    }









    try {


      await controller!.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }

  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }


    assetsAudioPlayer.pause();









    try {
      return cameraController.stopVideoRecording();




    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    print("the video path is $videoPath");




  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Widget _getSocialAction({required String title, required String icon}) {
    return Container(
        margin: EdgeInsets.only(top: 5.0, right: 5),
        width: 60.0,
        height: 50.0,
        child: Column(children: [
          SvgPicture.asset(icon),
          Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Text(title,
                style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ]));
  }

  void _openTimerBottomSheet() {
    dynamic screenwidth = MediaQuery.of(context).size.width;
    dynamic screenheight = MediaQuery.of(context).size.height;


    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setHeight(50),
                    child: InkWell(
                      onTap: () {
                        mystate(() {
                          countdown = 3;
                          Navigator.pop(context);
                          startTimer();
                          Timer(Duration(milliseconds: 3000), () {
                            setState(() {
                              showAllButton = false;
                            });


                            countDown.start();
                            onVideoRecordButtonPressed();
                            threesec = !threesec;
                          });
                          threesec = !threesec;
                          fivesec = false;
                          eightsec = false;
                          tensec = false;
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "3 Seconds",
                            style: TextStyle(
                                color: threesec
                                    ? Color(Constants.whitetext)
                                    : Color(Constants.greytext),
                                fontSize: 16,
                                fontFamily: Constants.appFont),
                          )),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setHeight(50),
                    child: InkWell(
                      onTap: () {
                        mystate(() {
                          countdown = 5;
                          Navigator.pop(context);
                          startTimer();
                          Timer(Duration(milliseconds: 5000), () {
                            setState(() {
                              showAllButton = false;
                            });


                            countDown.start();
                            onVideoRecordButtonPressed();
                            fivesec = !fivesec;
                          });
                          fivesec = !fivesec;
                          threesec = false;
                          eightsec = false;
                          tensec = false;
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "5 Seconds",
                            style: TextStyle(
                                color: fivesec
                                    ? Color(Constants.whitetext)
                                    : Color(Constants.greytext),
                                fontSize: 16,
                                fontFamily: Constants.appFont),
                          )),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setHeight(50),
                    child: InkWell(
                      onTap: () {
                        mystate(() {
                          countdown = 8;
                          Navigator.pop(context);
                          startTimer();
                          Timer(Duration(milliseconds: 8000), () {
                            setState(() {
                              showAllButton = false;
                            });


                            countDown.start();
                            onVideoRecordButtonPressed();
                            eightsec = !eightsec;
                          });
                          eightsec = !eightsec;
                          threesec = false;
                          fivesec = false;
                          tensec = false;
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "8 Seconds",
                            style: TextStyle(
                                color: eightsec
                                    ? Color(Constants.whitetext)
                                    : Color(Constants.greytext),
                                fontSize: 16,
                                fontFamily: Constants.appFont),
                          )),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setHeight(50),
                    child: InkWell(
                      onTap: () {
                        mystate(() {
                          countdown = 10;
                          Navigator.pop(context);
                          startTimer();
                          Timer(Duration(milliseconds: 10000), () {
                            setState(() {
                              showAllButton = false;
                            });


                            countDown.start();
                            onVideoRecordButtonPressed();
                            tensec = !tensec;
                          });
                          tensec = !tensec;
                          threesec = false;
                          fivesec = false;
                          eightsec = false;
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "10 Seconds",
                            style: TextStyle(
                                color: tensec
                                    ? Color(Constants.whitetext)
                                    : Color(Constants.greytext),
                                fontSize: 16,
                                fontFamily: Constants.appFont),
                          )),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  void callApiForSongRequest(int? id) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .singleMusicRequest(id)
        .then((response) async {
      setState(() {
        showSpinner = false;
      });
      if (response.success!) {
        setState(() {
          musicName = response.data!.title;
          songId = response.data!.id.toString();
          actualAudio = response.data!.imagePath! + response.data!.audio!;
          totalDurationOfAudio =
              double.parse(response.data!.duration.toString());
        });


        assetsAudioPlayer.open(
          Audio.network(actualAudio),
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

  /// get available cameras
  Future<void> _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Future.delayed(Duration(milliseconds: 50));
    _availableCameras = await availableCameras();
    await Future.delayed(Duration(milliseconds: 200));
    _initCamera(_availableCameras.first);
  }

  /// init camera
  Future<void> _initCamera(CameraDescription description) async {
    final CameraController cameraController = CameraController(
      description,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.yuv420,

    );
    controller = cameraController;



    await Future.delayed(Duration(milliseconds: 200));
    try {
      await controller!.initialize();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = controller!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx! < cameras.length - 1 ? selectedCameraIdx! + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx!];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420);

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller!.value.hasError) {
        print('Camera error ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }
}
