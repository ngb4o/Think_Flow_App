// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    List<Datum>? data;
    Paging? paging;
    Extra? extra;

    NotificationModel({
        this.data,
        this.paging,
        this.extra,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        paging: json["paging"] == null ? null : Paging.fromJson(json["paging"]),
        extra: json["extra"] == null ? null : Extra.fromJson(json["extra"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "paging": paging?.toJson(),
        "extra": extra?.toJson(),
    };
}

class Datum {
    String? id;
    String? notiType;
    int? notiSenderId;
    int? notiReceivedId;
    String? notiContent;
    String? notiOptions;
    bool? isRead;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
        this.id,
        this.notiType,
        this.notiSenderId,
        this.notiReceivedId,
        this.notiContent,
        this.notiOptions,
        this.isRead,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        notiType: json["noti_type"],
        notiSenderId: json["noti_sender_id"],
        notiReceivedId: json["noti_received_id"],
        notiContent: json["noti_content"],
        notiOptions: json["noti_options"],
        isRead: json["is_read"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "noti_type": notiType,
        "noti_sender_id": notiSenderId,
        "noti_received_id": notiReceivedId,
        "noti_content": notiContent,
        "noti_options": notiOptions,
        "is_read": isRead,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Extra {
    String? notiReceivedId;

    Extra({
        this.notiReceivedId,
    });

    factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        notiReceivedId: json["noti_received_id"],
    );

    Map<String, dynamic> toJson() => {
        "noti_received_id": notiReceivedId,
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
