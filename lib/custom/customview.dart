import 'package:acoustic/screen/homescreen.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'loader_custom_widget.dart';

class CustomView extends StatefulWidget {
  int index;

  CustomView(this.index);

  @override
  _CustomView createState() => _CustomView();
}

class _CustomView extends State<CustomView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Color(Constants.bgblack),
          alignment: FractionalOffset.center,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (widget.index != 0){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen(0)));
                    }
                  },
                  child: Container(
                      child: new SvgPicture.asset("images/tab_home.svg",
                          color: widget.index == 0
                              ? Color(Constants.lightbluecolor)
                              : Color(Constants.whitetext))),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.index != 1){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(1)));
                    }
                  },
                  child: Container(
                      child: new SvgPicture.asset("images/tab_search.svg",
                          color: widget.index == 1
                              ? Color(Constants.lightbluecolor)
                              : Color(Constants.whitetext))),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.index != 2) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen(2)));
                    }
                  },
                  child: Container(
                      child: new SvgPicture.asset(
                    "images/tab_add_new.svg",
                  )),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.index != 3){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen(3)));
                    }
                  },
                  child: Container(
                      child: new SvgPicture.asset("images/tab_notification.svg",
                          color: widget.index == 3
                              ? Color(Constants.lightbluecolor)
                              : Color(Constants.whitetext))),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.index != 4){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen(4)));
                    }
                  },
                  child: Container(
                    child: PreferenceUtils.getString(Constants.image).isEmpty
                        ? CircleAvatar(
                            radius: 17,
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                child:
                                    Image.asset("images/profilepicDemo.jpg")))
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
                            placeholder: (context, url) => CustomLoader(),
                            errorWidget: (context, url, error) =>
                                Image.asset("images/no_image.png"),
                          ),
                  ),
                ),
            ],
          ),
        ));
  }
}
