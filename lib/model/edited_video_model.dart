class EditedVideoModel {
  String? msg;
  Data? data;
  bool? success;

  EditedVideoModel({this.msg, this.data, this.success});

  EditedVideoModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? songId;
  String? audioId;
  String? video;
  String? description;
  String? hashtags;
  String? userTags;
  String? screenshot;
  String? language;
  String? view;
  int? isDuet;
  String? isComment;
  int? isApproved;
  String? lat;
  String? lang;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? imagePath;
  String? originalAudio;
  String? commentCount;
  String? likeCount;
  String? viewCount;
  bool? isLike;
  int? isSaved;
  int? isReported;
  int? report;
  bool? isYou;

  Data(
      {this.id,
      this.userId,
      this.songId,
      this.audioId,
      this.video,
      this.description,
      this.hashtags,
      this.userTags,
      this.screenshot,
      this.language,
      this.view,
      this.isDuet,
      this.isComment,
      this.isApproved,
      this.lat,
      this.lang,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.imagePath,
      this.originalAudio,
      this.commentCount,
      this.likeCount,
      this.viewCount,
      this.isLike,
      this.isSaved,
      this.isReported,
      this.report,
      this.isYou});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    songId = json['song_id'];
    audioId = json['audio_id'];
    video = json['video'];
    description = json['description'];
    hashtags = json['hashtags'];
    userTags = json['user_tags'];
    screenshot = json['screenshot'];
    language = json['language'];
    view = json['view'];
    isDuet = json['is_duet'];
    isComment = json['is_comment'];
    isApproved = json['is_approved'];
    lat = json['lat'];
    lang = json['lang'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    imagePath = json['imagePath'];
    originalAudio = json['originalAudio'];
    commentCount = json['commentCount'];
    likeCount = json['likeCount'];
    viewCount = json['viewCount'];
    isLike = json['isLike'];
    isSaved = json['isSaved'];
    isReported = json['isReported'];
    report = json['report'];
    isYou = json['isYou'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['song_id'] = this.songId;
    data['audio_id'] = this.audioId;
    data['video'] = this.video;
    data['description'] = this.description;
    data['hashtags'] = this.hashtags;
    data['user_tags'] = this.userTags;
    data['screenshot'] = this.screenshot;
    data['language'] = this.language;
    data['view'] = this.view;
    data['is_duet'] = this.isDuet;
    data['is_comment'] = this.isComment;
    data['is_approved'] = this.isApproved;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['imagePath'] = this.imagePath;
    data['originalAudio'] = this.originalAudio;
    data['commentCount'] = this.commentCount;
    data['likeCount'] = this.likeCount;
    data['viewCount'] = this.viewCount;
    data['isLike'] = this.isLike;
    data['isSaved'] = this.isSaved;
    data['isReported'] = this.isReported;
    data['report'] = this.report;
    data['isYou'] = this.isYou;
    return data;
  }
}
