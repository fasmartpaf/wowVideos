class SingleUser {
  int? id;
  String? userId;
  String? name;
  String? image;
  String? bio;
  int? followerRequest;
  List<Videos>? videos;
  int? postCount;
  String? imagePath;
  int? isFollowing;
  int? isRequested;
  String? followersCount;
  String? followingCount;
  int? isBlock;
  int? isReported;

  SingleUser(
      {this.id,
      this.userId,
      this.name,
      this.image,
      this.bio,
      this.followerRequest,
      this.videos,
      this.postCount,
      this.imagePath,
      this.isFollowing,
      this.isRequested,
      this.followersCount,
      this.followingCount,
      this.isBlock,
      this.isReported});

  SingleUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    bio = json['bio'];
    followerRequest = json['follower_request'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
    postCount = json['postCount'];
    imagePath = json['imagePath'];
    isFollowing = json['isFollowing'];
    isRequested = json['isRequested'];
    followersCount = json['followersCount'];
    followingCount = json['followingCount'];
    isBlock = json['isBlock'];
    isReported = json['isReported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['bio'] = this.bio;
    data['follower_request'] = this.followerRequest;
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    data['postCount'] = this.postCount;
    data['imagePath'] = this.imagePath;
    data['isFollowing'] = this.isFollowing;
    data['isRequested'] = this.isRequested;
    data['followersCount'] = this.followersCount;
    data['followingCount'] = this.followingCount;
    data['isBlock'] = this.isBlock;
    data['isReported'] = this.isReported;
    return data;
  }
}

class Videos {
  int? id;
  String? screenshot;
  String? imagePath;
  bool? isLike;
  String? viewCount;

  Videos(
      {this.id, this.screenshot, this.imagePath, this.isLike, this.viewCount});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenshot = json['screenshot'];
    imagePath = json['imagePath'];
    isLike = json['isLike'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['screenshot'] = this.screenshot;
    data['imagePath'] = this.imagePath;
    data['isLike'] = this.isLike;
    data['viewCount'] = this.viewCount;
    return data;
  }
}
