class UserBlockList {
  String? msg;
  List<UserBlockListData>? data;
  bool? success;

  UserBlockList({this.msg, this.data, this.success});

  UserBlockList.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <UserBlockListData>[];
      json['data'].forEach((v) {
        data!.add(new UserBlockListData.fromJson(v));
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

class UserBlockListData {
  int? id;
  String? name;
  String? userId;
  String? image;
  String? imagePath;

  UserBlockListData(
      {this.id, this.name, this.userId, this.image, this.imagePath});

  UserBlockListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    image = json['image'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['image'] = this.image;
    data['imagePath'] = this.imagePath;
    return data;
  }
}
