class AdvertiseManage {
  String? msg;
  List<Data>? data;
  bool? success;

  AdvertiseManage({this.msg, this.data, this.success});

  AdvertiseManage.fromJson(Map<String, dynamic> json) {
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
  String? location;
  String? network;
  String? type;
  String? unit;
  String? interval;
  int? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.location,
      this.network,
      this.type,
      this.unit,
      this.interval,
      this.status,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
    network = json['network'];
    type = json['type'];
    unit = json['unit'];
    interval = json['interval'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    data['network'] = this.network;
    data['type'] = this.type;
    data['unit'] = this.unit;
    data['interval'] = this.interval;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
