import 'package:acoustic/custom/customview.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/screen/searchcreator.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SearchHistoryScreen extends StatefulWidget {
  @override
  _SearchHistoryScreen createState() => _SearchHistoryScreen();
}

class _SearchHistoryScreen extends State<SearchHistoryScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;

  List<String> recentData = [];
  List<String> tempRecentData = [];
  List<String> addDataToLocal = [];

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    if (getStringList(Constants.recentSearch).isNotEmpty) {
      tempRecentData = getStringList(Constants.recentSearch);
    } else {
      tempRecentData = [];
    }
    recentData = tempRecentData.reversed.toList();
  }

  static Future<bool>? putStringList(String key, List<String> value) {
    if (PreferenceUtils == null) return null;
    return PreferenceUtils.setStringList(key, value);
  }

  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (PreferenceUtils == null) return defValue;
    return PreferenceUtils.getStringList(key) ?? defValue;
  }

  @override
  Widget build(BuildContext context) {
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
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 70),
                          color: Colors.transparent,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Color(Constants.conbg),

                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(left: 10),
                                        child: SvgPicture.asset(
                                            "images/greay_search.svg"),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        color: Colors.transparent,
                                        child: TextFormField(
                                          autofocus: true,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
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
                                            setState(() {
                                              if (value.isNotEmpty) {
                                                for (int i = 0;
                                                    i < recentData.length;
                                                    i++) {
                                                  addDataToLocal
                                                      .add(recentData[i]);
                                                }
                                                addDataToLocal.add(value);
                                                putStringList(
                                                    Constants.recentSearch,
                                                    addDataToLocal);


                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SearchCreatorScreen(
                                                      searched: value,
                                                    ),
                                                  ),
                                                );
                                              }  else {
                                                Constants.toastMessage(
                                                    "Please enter any character");
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /// recent search list
                              Visibility(
                                visible: 0 < recentData.length,
                                child: ListView.builder(
                                        itemCount: 6 <= recentData.length
                                            ? 6
                                            : recentData.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {



                                          return Container(
                                            margin: EdgeInsets.only(
                                                top: 15,
                                                right: 20,
                                                bottom: 0,
                                                left: 20),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchCreatorScreen(searched: recentData[index],)));
                                              },
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: SvgPicture.asset(
                                                          "images/white_search.svg"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Container(
                                                      child: Container(
                                                        child: Text(
                                                          recentData[index],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  Constants
                                                                      .whitetext),
                                                              fontFamily:
                                                                  Constants
                                                                      .appFont,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          recentData
                                                              .removeAt(index);
                                                          for (int i = 0;
                                                              i <
                                                                  recentData
                                                                      .length;
                                                              i++) {
                                                            addDataToLocal.add(
                                                                recentData[i]);
                                                          }
                                                          putStringList(
                                                              Constants
                                                                  .recentSearch,
                                                              addDataToLocal);
                                                        });
                                                        tempRecentData.clear();
                                                        recentData.clear();
                                                        if (getStringList(Constants
                                                                .recentSearch) !=
                                                            null) {
                                                          tempRecentData =
                                                              getStringList(
                                                                  Constants
                                                                      .recentSearch);
                                                        } else {
                                                          tempRecentData = [];
                                                        }
                                                        recentData =
                                                            tempRecentData
                                                                .reversed
                                                                .toList();
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: SvgPicture.asset(
                                                            "images/close.svg"),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              /// clear search history
                              Visibility(
                                visible: 0 < recentData.length,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      PreferenceUtils.setStringList(Constants.recentSearch, <String>[]);
                                      recentData = getStringList(Constants.recentSearch);
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(
                                        left: 25, right: 20, top: 25),
                                    child: Text(
                                      "Clear Search History",
                                      style: TextStyle(
                                          color:
                                              Color(Constants.lightbluecolor),
                                          fontSize: 16,
                                          fontFamily: Constants.appFont),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(bottom: 10), child: Body()),
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

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomView(1),
    );
  }
}
