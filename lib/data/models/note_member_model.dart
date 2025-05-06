// To parse this JSON data, do
//
//     final noteMemberModel = noteMemberModelFromJson(jsonString);

import 'dart:convert';

NoteMemberModel noteMemberModelFromJson(String str) => NoteMemberModel.fromJson(json.decode(str));

String noteMemberModelToJson(NoteMemberModel data) => json.encode(data.toJson());

class NoteMemberModel {
  List<Datum>? data;
  Paging? paging;

  NoteMemberModel({
    this.data,
    this.paging,
  });

  factory NoteMemberModel.fromJson(Map<String, dynamic> json) => NoteMemberModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    paging: json["paging"] == null ? null : Paging.fromJson(json["paging"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "paging": paging?.toJson(),
  };
}

class Datum {
  String? id;
  String? email;
  String? lastName;
  String? firstName;
  dynamic avatar;
  String? role;
  String? permission;

  Datum({
    this.id,
    this.email,
    this.lastName,
    this.firstName,
    this.avatar,
    this.role,
    this.permission,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    email: json["email"],
    lastName: json["last_name"],
    firstName: json["first_name"],
    avatar: json["avatar"],
    role: json["role"],
    permission: json["permission"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "last_name": lastName,
    "first_name": firstName,
    "avatar": avatar,
    "role": role,
    "permission": permission,
  };
}

class Paging {
  int? page;
  int? limit;
  int? total;
  String? cursor;
  String? nextCursor;

  Paging({
    this.page,
    this.limit,
    this.total,
    this.cursor,
    this.nextCursor,
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
