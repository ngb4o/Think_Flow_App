// To parse this JSON data, do
//
//     final noteModel = noteModelFromJson(jsonString);

import 'dart:convert';

class ListNoteModel {
  final List<Note> data;
  final Paging paging;
  final Extra extra;

  ListNoteModel({
    required this.data,
    required this.paging,
    required this.extra,
  });

  factory ListNoteModel.fromJson(Map<String, dynamic> json) => ListNoteModel(
        data: List<Note>.from(json["data"].map((x) => Note.fromJson(x))),
        paging: Paging.fromJson(json["paging"]),
        extra: Extra.fromJson(json["extra"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "paging": paging.toJson(),
        "extra": extra.toJson(),
      };
}

class Note {
  final String id;
  final String title;
  final bool archived;
  final User user;
  final String createdAt;
  final String updatedAt;
  final String permission;

  Note({
    required this.id,
    required this.title,
    required this.archived,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.permission,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        archived: json["archived"],
        user: User.fromJson(json["user"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        permission: json["permission"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "archived": archived,
        "user": user.toJson(),
        "created_at": createdAt,
        "updated_at": updatedAt,
        "permission": permission,
      };
}

class User {
  final String id;
  final String email;
  final String lastName;
  final String firstName;
  final dynamic avatar;

  User({
    required this.id,
    required this.email,
    required this.lastName,
    required this.firstName,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        lastName: json["last_name"],
        firstName: json["first_name"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "last_name": lastName,
        "first_name": firstName,
        "avatar": avatar,
      };
}

class Extra {
  final String userId;

  Extra({
    required this.userId,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
      };
}

class Paging {
  final int page;
  final int limit;
  final int total;
  final String cursor;
  final String nextCursor;

  Paging({
    required this.page,
    required this.limit,
    required this.total,
    required this.cursor,
    required this.nextCursor,
  });

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
        cursor: json["cursor"],
        nextCursor: json["next_cursor"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
        "cursor": cursor,
        "next_cursor": nextCursor,
      };
}

ListNoteModel listNoteModelFromJson(String str) => ListNoteModel.fromJson(json.decode(str));

String listNoteModelToJson(ListNoteModel data) => json.encode(data.toJson());
