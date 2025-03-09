// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
  Avatar avatar;
  int id;
  String iso6391;
  String iso31661;
  String name;
  bool includeAdult;
  String username;

  Account({
    required this.avatar,
    required this.id,
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.includeAdult,
    required this.username,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        avatar: Avatar.fromJson(json["avatar"]),
        id: json["id"],
        iso6391: json["iso_639_1"],
        iso31661: json["iso_3166_1"],
        name: json["name"],
        includeAdult: json["include_adult"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar.toJson(),
        "id": id,
        "iso_639_1": iso6391,
        "iso_3166_1": iso31661,
        "name": name,
        "include_adult": includeAdult,
        "username": username,
      };
}

class Avatar {
  Gravatar gravatar;
  Tmdb tmdb;

  Avatar({
    required this.gravatar,
    required this.tmdb,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        gravatar: Gravatar.fromJson(json["gravatar"]),
        tmdb: Tmdb.fromJson(json["tmdb"]),
      );

  Map<String, dynamic> toJson() => {
        "gravatar": gravatar.toJson(),
        "tmdb": tmdb.toJson(),
      };
}

class Gravatar {
  String hash;

  Gravatar({
    required this.hash,
  });

  factory Gravatar.fromJson(Map<String, dynamic> json) => Gravatar(
        hash: json["hash"],
      );

  Map<String, dynamic> toJson() => {
        "hash": hash,
      };
}

class Tmdb {
  String? avatarPath;

  Tmdb({
    this.avatarPath,
  });

  factory Tmdb.fromJson(Map<String, dynamic> json) => Tmdb(
        avatarPath: json["avatar_path"],
      );

  Map<String, dynamic> toJson() => {
        "avatar_path": avatarPath,
      };
}
