import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/model/languages.dart';

class AppLanguageScreen extends StatefulWidget {
  @override
  _AppLanguageScreen createState() => _AppLanguageScreen();
}

class _AppLanguageScreen extends State<AppLanguageScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  List<LanguageData> languagelist = <LanguageData>[];
  bool nodata = true;
  bool showdata = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Container(
                  margin: EdgeInsets.only(left: 0),
                  child: Text("App Language")),
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
              onRefresh: callApiForLanguageData,
              key: _refreshIndicatorKey,
              child: ModalProgressHUD(
                inAsyncCall: showSpinner,
                opacity: 1.0,
                color: Colors.transparent.withOpacity(0.2),
                progressIndicator:CustomLoader(),
                child: LayoutBuilder(
                  builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: ScreenUtil().setHeight(80),
                              margin: const EdgeInsets.only(
                                  top: 20.0, left: 15.0, right: 15, bottom: 0),
                              child: Text(
                                "Coming Soon...",
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

  Future<void> callApiForLanguageData() async {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).language().then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
        });
        setState(() {
          if (response.data!.length != 0) {
            languagelist.addAll(response.data!);
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
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        showSpinner = false;
        nodata = true;
        showdata = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }
}
