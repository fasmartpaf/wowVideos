class MyProfileModel {
  String? msg;
  MyProfileData? data;
  bool? success;

  MyProfileModel({this.msg, this.data, this.success});

  MyProfileModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data =
        json['data'] != null ? new MyProfileData.fromJson(json['data']) : null;
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

class MyProfileData {
  MainUser? mainUser;
  List<Posts>? posts;
  List<Saved>? saved;
  List<Liked>? liked;

  MyProfileData({this.mainUser, this.posts, this.saved, this.liked});

  MyProfileData.fromJson(Map<String, dynamic> json) {
    mainUser = json['mainUser'] != null
        ? new MainUser.fromJson(json['mainUser'])
        : null;
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(new Posts.fromJson(v));
      });
    }
    if (json['saved'] != null) {
      saved = <Saved>[];
      json['saved'].forEach((v) {
        saved!.add(new Saved.fromJson(v));
      });
    }
    if (json['liked'] != null) {
      liked = <Liked>[];
      json['liked'].forEach((v) {
        liked!.add(new Liked.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mainUser != null) {
      data['mainUser'] = this.mainUser!.toJson();
    }
    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    }
    if (this.saved != null) {
      data['saved'] = this.saved!.map((v) => v.toJson()).toList();
    }
    if (this.liked != null) {
      data['liked'] = this.liked!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainUser {
  int? id;
  String? name;
  String? userId;
  String? image;
  String? bio;
  String? bdate;
  String? phone;
  String? email;
  String? gender;
  String? imagePath;
  String? followersCount;
  String? followingCount;

  MainUser(
      {this.id,
      this.name,
      this.userId,
      this.image,
      this.bio,
      this.bdate,
      this.phone,
      this.email,
      this.gender,
      this.imagePath,
      this.followersCount,
      this.followingCount});

  MainUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    image = json['image'];
    bio = json['bio'];
    bdate = json['bdate'];
    phone = json['phone'];
    email = json['email'];
    gender = json['gender'];
    imagePath = json['imagePath'];
    followersCount = json['followersCount'];
    followingCount = json['followingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['image'] = this.image;
    data['bio'] = this.bio;
    data['bdate'] = this.bdate;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['imagePath'] = this.imagePath;
    data['followersCount'] = this.followersCount;
    data['followingCount'] = this.followingCount;
    return data;
  }
}

class Posts {
  int? id;
  String? screenshot;
  String? video;
  bool? isLike;
  String? imagePath;
  String? viewCount;
  bool showred = false;
  bool showwhite = false;

  Posts(
      {this.id,
      this.screenshot,
      this.video,
      this.isLike,
      this.imagePath,
      this.viewCount});

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenshot = json['screenshot'];
    video = json['video'];
    isLike = json['isLike'];
    imagePath = json['imagePath'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['screenshot'] = this.screenshot;
    data['video'] = this.video;
    data['isLike'] = this.isLike;
    data['imagePath'] = this.imagePath;
    data['viewCount'] = this.viewCount;
    return data;
  }
}

class Saved {
  int? id;
  String? userId;
  Video? video;

  Saved({this.id, this.userId, this.video});

  Saved.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    return data;
  }
}

class Video {
  int? id;
  String? userId;
  String? video;
  String? screenshot;
  String? imagePath;
  bool? isLike;
  String? viewCount;
  User? user;
  bool showred = false;
  bool showwhite = false;

  Video(
      {this.id,
      this.userId,
      this.video,
      this.screenshot,
      this.imagePath,
      this.isLike,
      this.viewCount,
      this.user});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    video = json['video'];
    screenshot = json['screenshot'];
    imagePath = json['imagePath'];
    isLike = json['isLike'];
    viewCount = json['viewCount'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video'] = this.video;
    data['screenshot'] = this.screenshot;
    data['imagePath'] = this.imagePath;
    data['isLike'] = this.isLike;
    data['viewCount'] = this.viewCount;
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

class Liked {
  int? id;
  Video? video;

  Liked({this.id, this.video});

  Liked.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    return data;
  }
}
