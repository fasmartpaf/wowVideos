class TrendingVideo {
  String? msg;
  List<TrendingData>? data;
  bool? success;

  TrendingVideo({this.msg, this.data, this.success});

  TrendingVideo.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <TrendingData>[];
      json['data'].forEach((v) {
        data!.add(new TrendingData.fromJson(v));
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

class TrendingData {
  int? id;
  String? songId;
  String? audioId;
  String? userId;
  String? screenshot;
  String? hashtags;
  String? video;
  int? isComment;
  String? description;
  String? imagePath;
  String? originalAudio;
  String? commentCount;
  String? likeCount;
  String? viewCount;
  bool? isLike;
  int? isSaved;
  int? isReported;
  bool? isYou;
  User? user;

  TrendingData(
      {this.id,
      this.songId,
      this.audioId,
      this.userId,
      this.screenshot,
      this.hashtags,
      this.video,
      this.isComment,
      this.description,
      this.imagePath,
      this.originalAudio,
      this.commentCount,
      this.likeCount,
      this.viewCount,
      this.isLike,
      this.isSaved,
      this.isReported,
      this.isYou,
      this.user});

  TrendingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    songId = json['song_id'];
    audioId = json['audio_id'];
    userId = json['user_id'];
    screenshot = json['screenshot'];
    hashtags = json['hashtags'];
    video = json['video'];
    isComment = json['is_comment'];
    description = json['description'] == null ? "" :json['description'];
    imagePath = json['imagePath'];
    originalAudio = json['originalAudio'];
    commentCount = json['commentCount'];
    likeCount = json['likeCount'];
    viewCount = json['viewCount'];
    isLike = json['isLike'];
    isSaved = json['isSaved'];
    isReported = json['isReported'];
    isYou = json['isYou'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['song_id'] = this.songId;
    data['audio_id'] = this.audioId;
    data['user_id'] = this.userId;
    data['screenshot'] = this.screenshot;
    data['hashtags'] = this.hashtags;
    data['video'] = this.video;
    data['is_comment'] = this.isComment;
    data['description'] = this.description == null ? '' :this.description;
    data['imagePath'] = this.imagePath;
    data['originalAudio'] = this.originalAudio;
    data['commentCount'] = this.commentCount;
    data['likeCount'] = this.likeCount;
    data['viewCount'] = this.viewCount;
    data['isLike'] = this.isLike;
    data['isSaved'] = this.isSaved;
    data['isReported'] = this.isReported;
    data['isYou'] = this.isYou;
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
  int? isFollowing;
  int? isRequested;
  int? isCommentBlock;

  User(
      {this.id,
      this.userId,
      this.name,
      this.image,
      this.imagePath,
      this.isFollowing,
      this.isRequested,
      this.isCommentBlock});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    imagePath = json['imagePath'];
    isFollowing = json['isFollowing'];
    isRequested = json['isRequested'];
    isCommentBlock = json['isCommentBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['imagePath'] = this.imagePath;
    data['isFollowing'] = this.isFollowing;
    data['isRequested'] = this.isRequested;
    data['isCommentBlock'] = this.isCommentBlock;
    return data;
  }
}
