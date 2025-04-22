// To parse this JSON data, do
//
//     final audioNoteModel = audioNoteModelFromJson(jsonString);

import 'dart:convert';

AudioNoteModel audioNoteModelFromJson(String str) => AudioNoteModel.fromJson(json.decode(str));

String audioNoteModelToJson(AudioNoteModel data) => json.encode(data.toJson());

class AudioNoteModel {
  List<Datum>? data;
  Paging? paging;
  Extra? extra;

  AudioNoteModel({
    this.data,
    this.paging,
    this.extra,
  });

  factory AudioNoteModel.fromJson(Map<String, dynamic> json) => AudioNoteModel(
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
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fileUrl;
  String? format;

  Datum({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.fileUrl,
    this.format,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    fileUrl: json["file_url"],
    format: json["format"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "file_url": fileUrl,
    "format": format,
  };
}

class Extra {
  int? noteId;

  Extra({
    this.noteId,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
    noteId: json["note_id"],
  );

  Map<String, dynamic> toJson() => {
    "note_id": noteId,
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
