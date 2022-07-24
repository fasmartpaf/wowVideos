class NotificationModal {
  String? msg;
  Data? data;
  bool? success;

  NotificationModal({this.msg, this.data, this.success});

  NotificationModal.fromJson(Map<String, dynamic> json) {
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
  int? requesteCount;
  LastRequest? lastRequest;
  List<Current>? current;
  List<LastSeven>? lastSeven;

  Data(
      {this.requesteCount,
      required this.lastRequest,
      this.current,
      this.lastSeven});

  Data.fromJson(Map<String, dynamic> json) {
    requesteCount = json['requeste_count'];
    lastRequest = json['last_request'] != null
        ? new LastRequest.fromJson(json['last_request'])
        : null;
    if (json['current'] != null) {
      current = <Current>[];
      json['current'].forEach((v) {
        current!.add(new Current.fromJson(v));
      });
    }
    if (json['last_seven'] != null) {
      lastSeven = <LastSeven>[];
      json['last_seven'].forEach((v) {
        lastSeven!.add(new LastSeven.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requeste_count'] = this.requesteCount;
    data['last_request'] = this.lastRequest;
    if (this.current != null) {
      data['current'] = this.current!.map((v) => v.toJson()).toList();
    }
    if (this.lastRequest != null) {
      data['last_request'] = this.lastRequest!.toJson();
    }
    if (this.lastSeven != null) {
      data['last_seven'] = this.lastSeven!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Current {
  int? id;
  String? userId;
  String? friendId;
  String? videoId;
  String? commentId;
  String? reason;
  String? msg;
  String? createdAt;
  String? time;
  User? user;
  Video? video;

  Current(
      {this.id,
      this.userId,
      this.friendId,
      this.videoId,
      this.commentId,
      this.reason,
      this.msg,
      this.createdAt,
      this.time,
      this.user,
      this.video});

  Current.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    friendId = json['friend_id'];
    videoId = json['video_id'];
    commentId = json['comment_id'];
    reason = json['reason'];
    msg = json['msg'];
    createdAt = json['created_at'];
    time = json['time'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['friend_id'] = this.friendId;
    data['video_id'] = this.videoId;
    data['comment_id'] = this.commentId;
    data['reason'] = this.reason;
    data['msg'] = this.msg;
    data['created_at'] = this.createdAt;
    data['time'] = this.time;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    return data;
  }
}

class LastRequest {
  int? id;
  String? image;
  String? imagePath;

  LastRequest({required this.id, required this.image, required this.imagePath});

  LastRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['imagePath'] = this.imagePath;
    return data;
  }
}

class LastSeven {
  int? id;
  String? userId;
  String? friendId;
  String? videoId;
  String? commentId;
  String? reason;
  String? msg;
  String? createdAt;
  String? time;
  User? user;
  Video? video;

  LastSeven(
      {this.id,
      this.userId,
      this.friendId,
      this.videoId,
      this.commentId,
      this.reason,
      this.msg,
      this.createdAt,
      this.time,
      this.user,
      this.video});

  LastSeven.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    friendId = json['friend_id'];
    videoId = json['video_id'];
    commentId = json['comment_id'];
    reason = json['reason'];
    msg = json['msg'];
    createdAt = json['created_at'];
    time = json['time'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['friend_id'] = this.friendId;
    data['video_id'] = this.videoId;
    data['comment_id'] = this.commentId;
    data['reason'] = this.reason;
    data['msg'] = this.msg;
    data['created_at'] = this.createdAt;
    data['time'] = this.time;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.video != null) {
      data['video'] = this.video!.toJson();
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
