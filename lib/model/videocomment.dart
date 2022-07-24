class VideoComment {
  String? msg;
  List<CommentData>? data;
  bool? success;

  VideoComment({this.msg, this.data, this.success});

  VideoComment.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CommentData>[];
      json['data'].forEach((v) {
        data!.add(new CommentData.fromJson(v));
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

class CommentData {
  int? id;
  String? userId;
  String? comment;
  String? videoId;
  String? likesCount;
  int? isLike;
  bool showwhite = true;
  bool showred = false;
  int? isReported;
  int? canDelete;
  User? user;

  CommentData(
      {this.id,
      this.userId,
      this.comment,
      this.videoId,
      this.likesCount,
      this.isLike,
      this.isReported,
      this.canDelete,
      this.user});

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    comment = json['comment'];
    videoId = json['video_id'];
    likesCount = json['likesCount'];
    isLike = json['isLike'];
    isReported = json['isReported'];
    canDelete = json['canDelete'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['video_id'] = this.videoId;
    data['likesCount'] = this.likesCount;
    data['isLike'] = this.isLike;
    data['isReported'] = this.isReported;
    data['canDelete'] = this.canDelete;
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
  int? isRequested;
  int? isBlock;

  User(
      {this.id,
      this.userId,
      this.name,
      this.image,
      this.imagePath,
      this.isRequested,
      this.isBlock});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    imagePath = json['imagePath'];
    isRequested = json['isRequested'];
    isBlock = json['isBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['imagePath'] = this.imagePath;
    data['isRequested'] = this.isRequested;
    data['isBlock'] = this.isBlock;
    return data;
  }
}
