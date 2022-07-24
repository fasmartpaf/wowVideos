class DefaultSearch {
  String? msg;
  List<Data>? data;
  bool? success;

  DefaultSearch({this.msg, this.data, this.success});

  DefaultSearch.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  String? title;
  String? image;
  List<Videos>? videos;
  dynamic views;
  int? trending;
  String? imagePath;

  Data(
      {this.id,
      this.title,
      this.image,
      this.videos,
      this.views,
      this.trending,
      this.imagePath});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
    views = json['views'];
    trending = json['trending'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    data['views'] = this.views;
    data['trending'] = this.trending;
    data['imagePath'] = this.imagePath;
    return data;
  }
}

class Videos {
  int? id;
  String? screenshot;
  String? imagePath;
  dynamic viewCount;

  Videos({this.id, this.screenshot, this.imagePath, this.viewCount});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenshot = json['screenshot'];
    imagePath = json['imagePath'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['screenshot'] = this.screenshot;
    data['imagePath'] = this.imagePath;
    data['viewCount'] = this.viewCount;
    return data;
  }
}
