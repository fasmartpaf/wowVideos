class MyProfileInformation {
  String? msg;
  Data? data;
  bool? success;

  MyProfileInformation({this.msg, this.data, this.success});

  MyProfileInformation.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? userId;
  String? image;
  String? email;
  String? code;
  String? phone;
  String? bdate;
  String? gender;
  String? bio;
  int? status;
  int? isVerify;
  String? platform;
  String? provider;
  int? followerRequest;
  int? mentionNot;
  int? likeNot;
  int? commentNot;
  int? followNot;
  int? requestNot;
  String? notInterested;
  int? report;
  String? lat;
  String? lang;
  String? imagePath;
  int? isFollowing;
  int? isRequested;
  String? followersCount;
  String? followingCount;
  int? isCommentBlock;

  Data(
      {this.id,
      this.name,
      this.userId,
      this.image,
      this.email,
      this.code,
      this.phone,
      this.bdate,
      this.gender,
      this.bio,
      this.status,
      this.isVerify,
      this.platform,
      this.provider,
      this.followerRequest,
      this.mentionNot,
      this.likeNot,
      this.commentNot,
      this.followNot,
      this.requestNot,
      this.notInterested,
      this.report,
      this.lat,
      this.lang,
      this.imagePath,
      this.isFollowing,
      this.isRequested,
      this.followersCount,
      this.followingCount,
      this.isCommentBlock});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    image = json['image'];
    email = json['email'];
    code = json['code'];
    phone = json['phone'];
    bdate = json['bdate'];
    gender = json['gender'];
    bio = json['bio'];
    status = json['status'];
    isVerify = json['is_verify'];
    platform = json['platform'];
    provider = json['provider'];
    followerRequest = json['follower_request'];
    mentionNot = json['mention_not'];
    likeNot = json['like_not'];
    commentNot = json['comment_not'];
    followNot = json['follow_not'];
    requestNot = json['request_not'];
    notInterested = json['not_interested'];
    report = json['report'];
    lat = json['lat'];
    lang = json['lang'];
    imagePath = json['imagePath'];
    isFollowing = json['isFollowing'];
    isRequested = json['isRequested'];
    followersCount = json['followersCount'];
    followingCount = json['followingCount'];
    isCommentBlock = json['isCommentBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['image'] = this.image;
    data['email'] = this.email;
    data['code'] = this.code;
    data['phone'] = this.phone;
    data['bdate'] = this.bdate;
    data['gender'] = this.gender;
    data['bio'] = this.bio;
    data['status'] = this.status;
    data['is_verify'] = this.isVerify;
    data['platform'] = this.platform;
    data['provider'] = this.provider;
    data['follower_request'] = this.followerRequest;
    data['mention_not'] = this.mentionNot;
    data['like_not'] = this.likeNot;
    data['comment_not'] = this.commentNot;
    data['follow_not'] = this.followNot;
    data['request_not'] = this.requestNot;
    data['not_interested'] = this.notInterested;
    data['report'] = this.report;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['imagePath'] = this.imagePath;
    data['isFollowing'] = this.isFollowing;
    data['isRequested'] = this.isRequested;
    data['followersCount'] = this.followersCount;
    data['followingCount'] = this.followingCount;
    data['isCommentBlock'] = this.isCommentBlock;
    return data;
  }
}
