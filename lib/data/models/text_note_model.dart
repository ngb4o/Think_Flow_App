// To parse this JSON data, do
//
//     final textNoteModel = textNoteModelFromJson(jsonString);

import 'dart:convert';

TextNoteModel textNoteModelFromJson(String str) => TextNoteModel.fromJson(json.decode(str));

String textNoteModelToJson(TextNoteModel data) => json.encode(data.toJson());

class TextNoteModel {
  Data? data;

  TextNoteModel({
    this.data,
  });

  factory TextNoteModel.fromJson(Map<String, dynamic> json) => TextNoteModel(
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
  int? noteId;
  TextContent? textContent;

  Data({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.noteId,
    this.textContent,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    noteId: json["note_id"],
    textContent: json["text_content"] == null ? null : TextContent.fromJson(json["text_content"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "note_id": noteId,
    "text_content": textContent?.toJson(),
  };
}

class TextContent {
  String? type;
  List<TextContentContent>? content;

  TextContent({
    this.type,
    this.content,
  });

  factory TextContent.fromJson(Map<String, dynamic> json) => TextContent(
    type: json["type"],
    content: json["content"] == null ? [] : List<TextContentContent>.from(json["content"]!.map((x) => TextContentContent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
  };
}

class TextContentContent {
  String? type;
  PurpleAttrs? attrs;
  List<PurpleContent>? content;

  TextContentContent({
    this.type,
    this.attrs,
    this.content,
  });

  factory TextContentContent.fromJson(Map<String, dynamic> json) => TextContentContent(
    type: json["type"],
    attrs: json["attrs"] == null ? null : PurpleAttrs.fromJson(json["attrs"]),
    content: json["content"] == null ? [] : List<PurpleContent>.from(json["content"]!.map((x) => PurpleContent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "attrs": attrs?.toJson(),
    "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
  };
}

class PurpleAttrs {
  int? level;
  String? textAlign;
  dynamic type;
  int? start;

  PurpleAttrs({
    this.level,
    this.textAlign,
    this.type,
    this.start,
  });

  factory PurpleAttrs.fromJson(Map<String, dynamic> json) => PurpleAttrs(
    level: json["level"],
    textAlign: json["textAlign"],
    type: json["type"],
    start: json["start"],
  );

  Map<String, dynamic> toJson() => {
    "level": level,
    "textAlign": textAlign,
    "type": type,
    "start": start,
  };
}

class PurpleContent {
  String? text;
  Type? type;
  List<Mark>? marks;
  List<FluffyContent>? content;

  PurpleContent({
    this.text,
    this.type,
    this.marks,
    this.content,
  });

  factory PurpleContent.fromJson(Map<String, dynamic> json) => PurpleContent(
    text: json["text"],
    type: typeValues.map[json["type"]]!,
    marks: json["marks"] == null ? [] : List<Mark>.from(json["marks"]!.map((x) => Mark.fromJson(x))),
    content: json["content"] == null ? [] : List<FluffyContent>.from(json["content"]!.map((x) => FluffyContent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "type": typeValues.reverse[type],
    "marks": marks == null ? [] : List<dynamic>.from(marks!.map((x) => x.toJson())),
    "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
  };
}

class FluffyContent {
  String? type;
  FluffyAttrs? attrs;
  List<TentacledContent>? content;

  FluffyContent({
    this.type,
    this.attrs,
    this.content,
  });

  factory FluffyContent.fromJson(Map<String, dynamic> json) => FluffyContent(
    type: json["type"],
    attrs: json["attrs"] == null ? null : FluffyAttrs.fromJson(json["attrs"]),
    content: json["content"] == null ? [] : List<TentacledContent>.from(json["content"]!.map((x) => TentacledContent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "attrs": attrs?.toJson(),
    "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
  };
}

class FluffyAttrs {
  String? textAlign;

  FluffyAttrs({
    this.textAlign,
  });

  factory FluffyAttrs.fromJson(Map<String, dynamic> json) => FluffyAttrs(
    textAlign: json["textAlign"],
  );

  Map<String, dynamic> toJson() => {
    "textAlign": textAlign,
  };
}

class TentacledContent {
  String? text;
  Type? type;

  TentacledContent({
    this.text,
    this.type,
  });

  factory TentacledContent.fromJson(Map<String, dynamic> json) => TentacledContent(
    text: json["text"],
    type: typeValues.map[json["type"]]!,
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "type": typeValues.reverse[type],
  };
}

enum Type {
  LIST_ITEM,
  TEXT
}

final typeValues = EnumValues({
  "listItem": Type.LIST_ITEM,
  "text": Type.TEXT
});

class Mark {
  String? type;

  Mark({
    this.type,
  });

  factory Mark.fromJson(Map<String, dynamic> json) => Mark(
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
