class Setting {
  String? msg;
  Data? data;
  bool? success;

  Setting({this.msg, this.data, this.success});

  Setting.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  String? appName;
  String? projectNo;
  String? appId;
  String? appVersion;
  String? appFooter;
  String? whiteLogo;
  String? colorLogo;
  String? termsOfUse;
  String? privacyPolicy;
  int? isWatermark;
  String? watermark;
  int? vidQty;
  String? shareUrl;
  int? admob;
  String? androidAdmobAppId;
  String? androidBanner;
  String? androidInterstitial;
  String? androidRewarded;
  String? androidNative;
  String? iosNative;
  String? iosAdmobAppId;
  String? iosBanner;
  String? iosInterstitial;
  String? iosRewarded;
  String? imagePath;
  String? facebookBanner;
  String? facebookInit;

  Data({
    this.appName,
    this.projectNo,
    this.appId,
    this.appVersion,
    this.appFooter,
    this.whiteLogo,
    this.colorLogo,
    this.termsOfUse,
    this.privacyPolicy,
    this.isWatermark,
    this.watermark,
    this.vidQty,
    this.shareUrl,
    this.admob,
    this.androidAdmobAppId,
    this.androidBanner,
    this.androidInterstitial,
    this.androidRewarded,
    this.iosAdmobAppId,
    this.iosBanner,
    this.iosInterstitial,
    this.iosRewarded,
    this.imagePath,
    this.androidNative,
    this.iosNative,
    this.facebookBanner,
    this.facebookInit,
  });

  Data.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    projectNo = json['project_no'];
    appId = json['app_id'];
    appVersion = json['app_version'];
    appFooter = json['app_footer'];
    whiteLogo = json['white_logo'];
    colorLogo = json['color_logo'];
    termsOfUse = json['terms_of_use'];
    privacyPolicy = json['privacy_policy'];
    isWatermark = json['is_watermark'];
    watermark = json['watermark'];
    vidQty = json['vid_qty'];
    shareUrl = json['share_url'];
    admob = json['admob'];
    androidAdmobAppId = json['android_admob_app_id'];
    androidBanner = json['android_banner'];
    androidInterstitial = json['android_interstitial'];
    androidRewarded = json['android_rewarded'];
    androidNative = json['android_native'];
    iosNative = json['ios_native'];
    iosAdmobAppId = json['ios_admob_app_id'];
    iosBanner = json['ios_banner'];
    iosInterstitial = json['ios_interstitial'];
    iosRewarded = json['ios_rewarded'];
    imagePath = json['imagePath'];
    facebookBanner = json['facebook_banner'];
    facebookInit = json['facebook_init'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['project_no'] = this.projectNo;
    data['app_id'] = this.appId;
    data['app_version'] = this.appVersion;
    data['app_footer'] = this.appFooter;
    data['white_logo'] = this.whiteLogo;
    data['color_logo'] = this.colorLogo;
    data['terms_of_use'] = this.termsOfUse;
    data['privacy_policy'] = this.privacyPolicy;
    data['is_watermark'] = this.isWatermark;
    data['watermark'] = this.watermark;
    data['vid_qty'] = this.vidQty;
    data['share_url'] = this.shareUrl;
    data['admob'] = this.admob;
    data['android_admob_app_id'] = this.androidAdmobAppId;
    data['android_banner'] = this.androidBanner;
    data['android_interstitial'] = this.androidInterstitial;
    data['android_rewarded'] = this.androidRewarded;
    data['android_native'] = this.androidNative;
    data['ios_native'] = this.iosNative;
    data['ios_admob_app_id'] = this.iosAdmobAppId;
    data['ios_banner'] = this.iosBanner;
    data['ios_interstitial'] = this.iosInterstitial;
    data['ios_rewarded'] = this.iosRewarded;
    data['imagePath'] = this.imagePath;
    data['facebook_banner'] = this.facebookBanner;
    data['facebook_init'] = this.facebookInit;
    return data;
  }
}
