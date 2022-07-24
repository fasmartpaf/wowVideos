class SearchedData {
  String? msg;
  Data? data;
  bool? success;

  SearchedData({this.msg, this.data, this.success});

  SearchedData.fromJson(Map<String, dynamic> json) {
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
  List<Creators>? creators;
  List<Hashtags>? hashtags;

  Data({this.creators, this.hashtags});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['creators'] != null) {
      creators = <Creators>[];
      json['creators'].forEach((v) {
        creators!.add(new Creators.fromJson(v));
      });
    }
    if (json['hashtags'] != null) {
      hashtags = <Hashtags>[];
      json['hashtags'].forEach((v) {
        hashtags!.add(new Hashtags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.creators != null) {
      data['creators'] = this.creators!.map((v) => v.toJson()).toList();
    }
    if (this.hashtags != null) {
      data['hashtags'] = this.hashtags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Creators {
  int? id;
  String? image;
  String? name;
  String? userId;
  String? imagePath;
  int? isFollowing;
  int? isRequested;
  String? followersCount;

  Creators(
      {this.id,
      this.image,
      this.name,
      this.userId,
      this.imagePath,
      this.isFollowing,
      this.isRequested,
      this.followersCount});

  Creators.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    userId = json['user_id'];
    imagePath = json['imagePath'];
    isFollowing = json['isFollowing'];
    isRequested = json['isRequested'];
    followersCount = json['followersCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['imagePath'] = this.imagePath;
    data['isFollowing'] = this.isFollowing;
    data['isRequested'] = this.isRequested;
    data['followersCount'] = this.followersCount;
    return data;
  }
}

class Hashtags {
  String? tag;
  dynamic use;

  Hashtags({this.tag, this.use});

  Hashtags.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    use = json['use'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    data['use'] = this.use;
    return data;
  }
}
