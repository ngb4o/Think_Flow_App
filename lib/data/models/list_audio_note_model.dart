// To parse this JSON data, do
//
//     final listAudioNoteModel = listAudioNoteModelFromJson(jsonString);

import 'dart:convert';

ListAudioNoteModel listAudioNoteModelFromJson(String str) => ListAudioNoteModel.fromJson(json.decode(str));

String listAudioNoteModelToJson(ListAudioNoteModel data) => json.encode(data.toJson());

class ListAudioNoteModel {
  List<Datum>? data;
  Paging? paging;
  Extra? extra;

  ListAudioNoteModel({
    this.data,
    this.paging,
    this.extra,
  });

  factory ListAudioNoteModel.fromJson(Map<String, dynamic> json) => ListAudioNoteModel(
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
  String? name;
  String? fileUrl;
  String? format;
  Transcript? transcript;
  Summary? summary;

  Datum({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.fileUrl,
    this.format,
    this.transcript,
    this.summary,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    name: json["name"],
    fileUrl: json["file_url"],
    format: json["format"],
    transcript: json["transcript"] == null ? null : Transcript.fromJson(json["transcript"]),
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "name": name,
    "file_url": fileUrl,
    "format": format,
    "transcript": transcript?.toJson(),
    "summary": summary?.toJson(),
  };
}

class Transcript {
  String? id;
  String? content;

  Transcript({
    this.id,
    this.content,
  });

  factory Transcript.fromJson(Map<String, dynamic> json) => Transcript(
    id: json["id"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
  };
}

class Summary {
  String? id;
  String? summaryText;

  Summary({
    this.id,
    this.summaryText,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    id: json["id"],
    summaryText: json["summary_text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "summary_text": summaryText,
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
