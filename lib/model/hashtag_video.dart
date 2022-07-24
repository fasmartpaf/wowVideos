class HashtagVideos {
  String? msg;
  List<HashtagVideoData>? data;
  bool? success;

  HashtagVideos({this.msg, this.data, this.success});

  HashtagVideos.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <HashtagVideoData>[];
      json['data'].forEach((v) {
        data!.add(new HashtagVideoData.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class HashtagVideoData {
  int? id;
  String? userId;
  String? screenshot;
  bool? isLike;
  String? imagePath;
  dynamic viewCount;
  User? user;

  HashtagVideoData(
      {this.id,
      this.userId,
      this.screenshot,
      this.isLike,
      this.imagePath,
      this.viewCount,
      this.user});

  HashtagVideoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    screenshot = json['screenshot'];
    isLike = json['isLike'];
    imagePath = json['imagePath'];
    viewCount = json['viewCount'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['screenshot'] = this.screenshot;
    data['isLike'] = this.isLike;
    data['imagePath'] = this.imagePath;
    data['viewCount'] = this.viewCount;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? userId;
  String? name;
  String? image;
  String? imagePath;

  User({this.id, this.userId, this.name, this.image, this.imagePath});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['imagePath'] = this.imagePath;
    return data;
  }
}
