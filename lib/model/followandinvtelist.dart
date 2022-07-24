class FollowAndInviteList {
  String? msg;
  List<FollowInviteData>? data;
  bool? success;

  FollowAndInviteList({this.msg, this.data, this.success});

  FollowAndInviteList.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <FollowInviteData>[];
      json['data'].forEach((v) {
        data!.add(new FollowInviteData.fromJson(v));
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

class FollowInviteData {
  int? id;
  String? name;
  String? userId;
  String? image;
  String? imagePath;
  String? followersCount;

  FollowInviteData(
      {this.id,
      this.name,
      this.userId,
      this.image,
      this.imagePath,
      this.followersCount});

  FollowInviteData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    image = json['image'];
    imagePath = json['imagePath'];
    followersCount = json['followersCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['image'] = this.image;
    data['imagePath'] = this.imagePath;
    data['followersCount'] = this.followersCount;
    return data;
  }
}
