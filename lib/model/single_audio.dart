class SingleAudio {
  String? msg;
  Data? data;
  bool? success;

  SingleAudio({this.msg, this.data, this.success});

  SingleAudio.fromJson(Map<String, dynamic> json) {
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
  String? videoId;
  String? audio;
  String? duration;
  List<AllVideos>? allVideos;
  String? imagePath;
  int? audioUsed;
  User? user;
  Video? video;

  Data(
      {this.id,
      this.userId,
      this.videoId,
      this.audio,
      this.duration,
      this.allVideos,
      this.imagePath,
      this.audioUsed,
      this.user,
      this.video});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    videoId = json['video_id'];
    audio = json['audio'];
    duration = json['duration'];
    if (json['all_videos'] != null) {
      allVideos = <AllVideos>[];
      json['all_videos'].forEach((v) {
        allVideos!.add(new AllVideos.fromJson(v));
      });
    }
    imagePath = json['imagePath'];
    audioUsed = json['audioUsed'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video_id'] = this.videoId;
    data['audio'] = this.audio;
    data['duration'] = this.duration;
    if (this.allVideos != null) {
      data['all_videos'] = this.allVideos!.map((v) => v.toJson()).toList();
    }
    data['imagePath'] = this.imagePath;
    data['audioUsed'] = this.audioUsed;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    return data;
  }
}

class AllVideos {
  int? id;
  String? screenshot;
  String? imagePath;
  bool? isLike;
  String? viewCount;

  AllVideos(
      {this.id, this.screenshot, this.imagePath, this.isLike, this.viewCount});

  AllVideos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenshot = json['screenshot'];
    imagePath = json['imagePath'];
    isLike = json['is_like'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['screenshot'] = this.screenshot;
    data['imagePath'] = this.imagePath;
    data['is_like'] = this.isLike;
    data['viewCount'] = this.viewCount;
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

class Video {
  int? id;
  String? screenshot;
  String? imagePath;

  Video({this.id, this.screenshot, this.imagePath});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenshot = json['screenshot'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['screenshot'] = this.screenshot;
    data['imagePath'] = this.imagePath;
    return data;
  }
}
