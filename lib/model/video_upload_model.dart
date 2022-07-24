class VideoUpload {
  String? msg;
  Data? data;
  bool? success;

  VideoUpload({this.msg, this.data, this.success});

  VideoUpload.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? songId;
  String? language;
  String? video;
  String? screenshot;
  int? isApproved;
  String? description;
  String? hashtags;
  String? userTags;
  String? view;
  String? isComment;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? imagePath;
  String? originalAudio;
  String? commentCount;
  String? likeCount;
  String? viewCount;
  int? isLike;
  int? isSaved;
  int? isReported;
  int? report;

  Data(
      {this.userId,
      this.songId,
      this.language,
      this.video,
      this.screenshot,
      this.isApproved,
      this.description,
      this.hashtags,
      this.userTags,
      this.view,
      this.isComment,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.imagePath,
      this.originalAudio,
      this.commentCount,
      this.likeCount,
      this.viewCount,
      this.isLike,
      this.isSaved,
      this.isReported,
      this.report});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    songId = json['song_id'];
    language = json['language'];
    video = json['video'];
    screenshot = json['screenshot'];
    isApproved = json['is_approved'];
    description = json['description'];
    hashtags = json['hashtags'];
    userTags = json['user_tags'];
    view = json['view'];
    isComment = json['is_comment'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    imagePath = json['imagePath'];
    originalAudio = json['originalAudio'];
    commentCount = json['commentCount'];
    likeCount = json['likeCount'];
    viewCount = json['viewCount'];
    isLike = json['isLike'];
    isSaved = json['isSaved'];
    isReported = json['isReported'];
    report = json['report'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['song_id'] = this.songId;
    data['language'] = this.language;
    data['video'] = this.video;
    data['screenshot'] = this.screenshot;
    data['is_approved'] = this.isApproved;
    data['description'] = this.description;
    data['hashtags'] = this.hashtags;
    data['user_tags'] = this.userTags;
    data['view'] = this.view;
    data['is_comment'] = this.isComment;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['imagePath'] = this.imagePath;
    data['originalAudio'] = this.originalAudio;
    data['commentCount'] = this.commentCount;
    data['likeCount'] = this.likeCount;
    data['viewCount'] = this.viewCount;
    data['isLike'] = this.isLike;
    data['isSaved'] = this.isSaved;
    data['isReported'] = this.isReported;
    data['report'] = this.report;
    return data;
  }
}
