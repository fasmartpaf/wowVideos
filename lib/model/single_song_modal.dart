class MusicSingleSong {
  String? msg;
  Data? data;
  bool? success;

  MusicSingleSong({this.msg, this.data, this.success});

  MusicSingleSong.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? audio;
  String? image;
  String? artist;
  String? movie;
  int? duration;
  List<Videos>? videos;
  String? imagePath;
  int? songUsed;
  int? isFavorite;

  Data(
      {this.id,
      this.title,
      this.audio,
      this.image,
      this.artist,
      this.movie,
      this.duration,
      this.videos,
      this.imagePath,
      this.songUsed,
      this.isFavorite});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    audio = json['audio'];
    image = json['image'];
    artist = json['artist'];
    movie = json['movie'];
    duration = json['duration'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
    imagePath = json['imagePath'];
    songUsed = json['songUsed'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['audio'] = this.audio;
    data['image'] = this.image;
    data['artist'] = this.artist;
    data['movie'] = this.movie;
    data['duration'] = this.duration;
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    data['imagePath'] = this.imagePath;
    data['songUsed'] = this.songUsed;
    data['isFavorite'] = this.isFavorite;
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
