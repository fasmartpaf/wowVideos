class AddMusicModal {
  String? msg;
  Data? data;
  bool? success;

  AddMusicModal({this.msg, this.data, this.success});

  AddMusicModal.fromJson(Map<String, dynamic> json) {
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
  List<All>? all;
  List<Popular>? popular;
  List<Playlist>? playlist;
  List<Favorite>? favorite;

  Data({this.all, this.popular, this.playlist, this.favorite});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['all'] != null) {
      all = <All>[];
      json['all'].forEach((v) {
        all!.add(new All.fromJson(v));
      });
    }
    if (json['popular'] != null) {
      popular = <Popular>[];
      json['popular'].forEach((v) {
        popular!.add(new Popular.fromJson(v));
      });
    }
    if (json['playlist'] != null) {
      playlist = <Playlist>[];
      json['playlist'].forEach((v) {
        playlist!.add(new Playlist.fromJson(v));
      });
    }
    if (json['favorite'] != null) {
      favorite = <Favorite>[];
      json['favorite'].forEach((v) {
        favorite!.add(new Favorite.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.all != null) {
      data['all'] = this.all!.map((v) => v.toJson()).toList();
    }
    if (this.popular != null) {
      data['popular'] = this.popular!.map((v) => v.toJson()).toList();
    }
    if (this.playlist != null) {
      data['playlist'] = this.playlist!.map((v) => v.toJson()).toList();
    }
    if (this.favorite != null) {
      data['favorite'] = this.favorite!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class All {
  int? id;
  String? title;
  String? image;
  String? artist;
  String? movie;
  String? audio;
  int? duration;
  String? imagePath;
  int? songUsed;
  int? isFavorite;

  All(
      {this.id,
      this.title,
      this.image,
      this.artist,
      this.movie,
      this.audio,
      this.duration,
      this.imagePath,
      this.songUsed,
      this.isFavorite});

  All.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    artist = json['artist'];
    movie = json['movie'];
    audio = json['audio'];
    duration = json['duration'];
    imagePath = json['imagePath'];
    songUsed = json['songUsed'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['artist'] = this.artist;
    data['movie'] = this.movie;
    data['audio'] = this.audio;
    data['duration'] = this.duration;
    data['imagePath'] = this.imagePath;
    data['songUsed'] = this.songUsed;
    data['isFavorite'] = this.isFavorite;
    return data;
  }
}

class Popular {
  int? id;
  String? title;
  String? image;
  String? artist;
  String? movie;
  String? audio;
  int? duration;
  String? imagePath;
  int? isFavorite;

  Popular(
      {this.id,
      this.title,
      this.image,
      this.artist,
      this.movie,
      this.audio,
      this.duration,
      this.imagePath,
      this.isFavorite});

  Popular.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    artist = json['artist'];
    movie = json['movie'];
    audio = json['audio'];
    duration = json['duration'];
    imagePath = json['imagePath'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['artist'] = this.artist;
    data['movie'] = this.movie;
    data['audio'] = this.audio;
    data['duration'] = this.duration;
    data['imagePath'] = this.imagePath;
    data['isFavorite'] = this.isFavorite;
    return data;
  }
}

class Playlist {
  int? id;
  String? title;
  String? image;
  String? imagePath;

  Playlist({this.id, this.title, this.image, this.imagePath});

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['imagePath'] = this.imagePath;
    return data;
  }
}

class Favorite {
  int? id;
  Song? song;

  Favorite({this.id, this.song});

  Favorite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    song = json['song'] != null ? new Song.fromJson(json['song']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.song != null) {
      data['song'] = this.song!.toJson();
    }
    return data;
  }
}

class Song {
  int? id;
  String? title;
  String? image;
  String? artist;
  String? movie;
  String? audio;
  String? imagePath;

  Song(
      {this.id,
      this.title,
      this.image,
      this.artist,
      this.movie,
      this.audio,
      this.imagePath});

  Song.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    artist = json['artist'];
    movie = json['movie'];
    audio = json['audio'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['artist'] = this.artist;
    data['movie'] = this.movie;
    data['audio'] = this.audio;
    data['imagePath'] = this.imagePath;
    return data;
  }
}
