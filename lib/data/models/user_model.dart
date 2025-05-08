// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    Data? data;

    UserModel({
        this.data,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}

class Data {
    String? id;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? firstName;
    String? lastName;
    String? email;
    String? phone;
    Avatar? avatar;
    String? gender;
    String? systemRole;
    String? status;

    Data({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.avatar,
        this.gender,
        this.systemRole,
        this.status,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
        gender: json["gender"],
        systemRole: json["system_role"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "avatar": avatar?.toJson(),
        "gender": gender,
        "system_role": systemRole,
        "status": status,
    };
}

class Avatar {
    String? id;
    String? url;
    int? width;
    int? height;
    String? extension;

    Avatar({
        this.id,
        this.url,
        this.width,
        this.height,
        this.extension,
    });

    factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        id: json["id"],
        url: json["url"],
        width: json["width"],
        height: json["height"],
        extension: json["extension"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "width": width,
        "height": height,
        "extension": extension,
    };
}
