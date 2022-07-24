import 'package:acoustic/apiservice/Api_Header.dart';
import 'package:acoustic/apiservice/Apiservice.dart';
import 'package:acoustic/custom/loader_custom_widget.dart';
import 'package:acoustic/screen/homescreen.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:acoustic/util/constants.dart';
import 'package:acoustic/widget/app_lable_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:dio/dio.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreen createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<EditProfileScreen> {
  int currentSelectedIndex = -1;
  var rating = 4.0;
  int maxcounter = 250;
  bool showSpinner = false;
  bool emailVerified = false;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController userNameLoad = TextEditingController();
  TextEditingController nameLoad = TextEditingController();
  TextEditingController bioLoad = TextEditingController();
  TextEditingController phoneLoad = TextEditingController();
  TextEditingController emailLoad = TextEditingController();
  TextEditingController birthdate = TextEditingController();










  String? dropdownValue = 'Select Gender';

  File? _proImage;
  final picker = ImagePicker();

/*  List monthlist = [
    {"January","February","March","April","May","June","July" ,"August","September","October","November","December"},
  ];*/

  String name = "name";
  String username = "username";
  String bio = "bio";
  String phone = "phone";
  String email = "email";
  String bDate = "bdaye";
  String image = "";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    callApiForMyProfileInfo();
    PreferenceUtils.init();
































































































    if (PreferenceUtils.getString(Constants.bDate).isNotEmpty) {
      birthdate.text  = PreferenceUtils.getString(Constants.bDate);
      name = PreferenceUtils.getString(Constants.name);
      username = PreferenceUtils.getString(Constants.userId);
      phone = PreferenceUtils.getString(Constants.phone);
      bio = PreferenceUtils.getString(Constants.bio);
      email = PreferenceUtils.getString(Constants.email);
      image = PreferenceUtils.getString(Constants.image);





























    }
  }

  /// Get from gallery
  void proImgFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _proImage = File(pickedFile.path);

        List<int> imageBytes = _proImage!.readAsBytesSync();
        image = base64Encode(imageBytes);
        print("_Proimage:$_proImage");
      } else {
        print('No image selected.');
      }
    });
  }
  /// Get from Camera
  void proImgFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _proImage = File(pickedFile.path);
        List<int> imageBytes = _proImage!.readAsBytesSync();
        image = base64Encode(imageBytes);
        print("_Proimage:$_proImage");
      } else {
        print('No image selected.');
      }
    });
  }

  void chooseProfileImage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      "From Gallery",
                      style: TextStyle(fontFamily: Constants.appFont),
                    ),
                    onTap: () {
                      proImgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    "From Camera",
                    style: TextStyle(fontFamily: Constants.appFont),
                  ),
                  onTap: () {
                    proImgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1975),
        lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        print(picked);
        var inputFormat = DateFormat('yyyy-MM-dd');
        var inputDate = inputFormat.parse(picked.toString().split(' ')[0]);
        var outputFormat = DateFormat('dd-MM-yyyy');

        birthdate.text = outputFormat.format(inputDate).toString();
      });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          backgroundColor: Color(Constants.bgblack),
          appBar: AppBar(
            title: Container(
                margin: EdgeInsets.only(left: 0), child: Text("Edit Profile")),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            actions: <Widget>[
              InkWell(
                onTap: () {
                  callApiForEditProfile();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 5, right: 20),
                  child: SvgPicture.asset("images/right.svg"),
                ),
              ),
            ],
          ),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: CustomLoader(),
            child: new Stack(
              children: <Widget>[
                new SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ///profile pic
                      Container(
                        margin: EdgeInsets.only(bottom: 5, left: 20),
                        alignment: Alignment.centerLeft,


                        child: _proImage != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                                _proImage!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                            : CachedNetworkImage(
                                alignment: Alignment.centerLeft,
                                imageUrl: image,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Color(0xFF36446b),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: imageProvider,
                                  ),
                                ),
                                placeholder: (context, url) => CustomLoader(),
                                errorWidget: (context, url, error) =>
                                    Image.asset("images/no_image.png"),
                              ),
                      ),
                      InkWell(
                        onTap: () {
                          chooseProfileImage();
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Text(
                            "Change Profile Picture",
                            style: TextStyle(
                                color: Color(Constants.lightbluecolor),
                                fontSize: 16,
                                fontFamily: Constants.appFont),
                          ),
                        ),
                      ),
                      ///username
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 0, right: 20, top: 10),
                        child: AppLableWidget(
                          title: 'Username',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 0, right: 20),
                        child: TextFormField(
                          controller: userNameLoad,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          validator: Constants.kvalidateUserName,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your UserName"),
                        ),
                      ),
                      ///name
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 0, right: 20, top: 10),
                        child: AppLableWidget(
                          title: 'Name',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 0, right: 20),
                        child: TextFormField(
                          controller: nameLoad,
                          textInputAction: TextInputAction.next,
                          validator: Constants.kvalidateName,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your Name"),
                        ),
                      ),
                      ///bio
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Text(
                          "Bio",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(Constants.greytext),
                              fontFamily: Constants.appFont),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 0, right: 20),
                        child: TextFormField(
                          controller: bioLoad,
                          textInputAction: TextInputAction.next,

                          validator: Constants.kvalidatedata,
                          keyboardType: TextInputType.multiline,



                          maxLines: null,

                          maxLength: 250,
                          buildCounter: (
                            BuildContext context, {
                            required int currentLength,
                            int? maxLength = 250,
                            bool? isFocused,
                          }) {
                            return Text(
                              "${maxLength! - currentLength}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Color(Constants.greytext),
                                  fontFamily: Constants.appFont),
                            );
                          },

                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your Bio"),
                        ),
                      ),
                      ///contact number
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Text(
                          "Contact Number",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(Constants.greytext),
                              fontFamily: Constants.appFont),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 0, right: 20),
                        child: TextFormField(
                          controller: phoneLoad,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          validator: Constants.kvalidateCotactNum,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your Contact Number "),
                        ),
                      ),
                      /// email
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Text(
                                "Email Address",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Color(Constants.greytext),
                                    fontFamily: Constants.appFont),
                              ),
                            ),
                            Visibility(
                              visible: emailVerified,
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textScaleFactor: 1,
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                            left: 20, right: 0, top: 20),
                                        child: Text(
                                          "Verify Email Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                              color: Color(Constants.redtext),
                                              fontFamily: Constants.appFont),
                                        ),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                            left: 5, right: 20, top: 20),
                                        child: SvgPicture.asset(
                                            "images/email_verify.svg"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 0, right: 20),
                        child: TextFormField(
                          controller: emailLoad,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          validator: Constants.kvalidateEmail,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your Email Address"),
                        ),
                      ),
                      ///bdate
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Text(
                          "Birth Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(Constants.greytext),
                              fontFamily: Constants.appFont),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 20, top: 0, right: 0, bottom: 20),
                        child: TextFormField(
                          controller: birthdate,
                          textInputAction: TextInputAction.next,

                          onTap: (){
                            _selectDate(context);
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your Birthdate"),
                        ),
                      ),







                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Text(
                          "Gender",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(Constants.greytext),
                              fontFamily: Constants.appFont),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(right: 20, left: 20, bottom: 50),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Color(Constants.bgblack1),
                          ),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            isExpanded: true,
                            icon: Container(
                              margin: EdgeInsets.only(left: 5),
                              child:
                                  SvgPicture.asset("images/profile_down.svg"),
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Color(Constants.whitetext)),
                            underline: Container(
                              height: 1,
                              color: Color(Constants.whitetext),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>[
                              'Select Gender',
                              'Male',
                              'Female',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.toString(),
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                ),
                              );
                            }).toList(),
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
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  Future<void> callApiForMyProfileInfo() async {
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData()).myProfileInfo().then((response) {
      if (response.success == true) {
        setState(() {
          image = response.data!.imagePath! + response.data!.image!;
          showSpinner = false;
          userNameLoad.text = response.data!.userId!;
          nameLoad.text = response.data!.name!;
          phoneLoad.text = (response.data?.code ?? "") + (response.data?.phone ?? "");
          emailLoad.text = response.data!.email!;




          birthdate.text = response.data?.bdate ?? "";
          if (response.data!.bio != null) {
            bioLoad.text = response.data!.bio!;
          }
          if (response.data!.isVerify == 0) {
            emailVerified = true;
          }
          if (response.data!.gender != null) {
            dropdownValue = response.data!.gender;
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

  void callApiForEditProfile() {
    setState(() {
      showSpinner = true;
    });
    var passImage;
    if (_proImage != null) {
      List<int> liimageBytes = _proImage!.readAsBytesSync();
      String proimageB64 = base64Encode(liimageBytes);
      passImage = proimageB64;
    }

    Map<String, dynamic> body;
    if (passImage != null) {
      body = {
        "name": nameLoad.text,
        "gender": dropdownValue,
        "bdate": birthdate.text,
        "bio": bioLoad.text,
        "image": passImage,
      };
    } else {
      body = {
        "name": nameLoad.text,
        "gender": dropdownValue,
        "bdate": birthdate.text,
        "bio": bioLoad.text,
      };
    }
    RestClient(ApiHeader().dioData()).editprofile(body).then((response) {
      var body = json.decode(response!);
      Constants.toastMessage(body["msg"].toString());
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(4),
          ));
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
}
