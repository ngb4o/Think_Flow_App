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
  List<TextContent>? textContent;

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
    textContent: json["text_content"] == null ? [] : List<TextContent>.from(json["text_content"]!.map((x) => TextContent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "note_id": noteId,
    "text_content": textContent == null ? [] : List<dynamic>.from(textContent!.map((x) => x.toJson())),
  };
}

class TextContent {
  Body? body;

  TextContent({
    this.body,
  });

  factory TextContent.fromJson(Map<String, dynamic> json) => TextContent(
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "body": body?.toJson(),
  };
}

class Body {
  String? type;
  List<BodyContent>? content;

  Body({
    this.type,
    this.content,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    type: json["type"],
    content: json["content"] == null ? [] : List<BodyContent>.from(json["content"]!.map((x) => BodyContent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
  };
}

class BodyContent {
  ContentType? type;
  List<ContentContent>? content;

  BodyContent({
    this.type,
    this.content,
  });

  factory BodyContent.fromJson(Map<String, dynamic> json) => BodyContent(
    type: contentTypeValues.map[json["type"]]!,
    content: json["content"] == null ? [] : List<ContentContent>.from(json["content"]!.map((x) => ContentContent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": contentTypeValues.reverse[type],
    "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
  };
}

class ContentContent {
  String? text;
  String? type;
  List<Mark>? marks;

  ContentContent({
    this.text,
    this.type,
    this.marks,
  });

  factory ContentContent.fromJson(Map<String, dynamic> json) => ContentContent(
    text: json["text"],
    type: json["type"],
    marks: json["marks"] == null ? [] : List<Mark>.from(json["marks"]!.map((x) => Mark.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "type": type,
    "marks": marks == null ? [] : List<dynamic>.from(marks!.map((x) => x.toJson())),
  };
}

class Mark {
  MarkType? type;

  Mark({
    this.type,
  });

  factory Mark.fromJson(Map<String, dynamic> json) => Mark(
    type: markTypeValues.map[json["type"]]!,
  );

  Map<String, dynamic> toJson() => {
    "type": markTypeValues.reverse[type],
  };
}

enum MarkType {
  BOLD,
  ITALIC,
  UNDERLINE,
  STRIKE,
}

final markTypeValues = EnumValues({
  "bold": MarkType.BOLD,
  "italic": MarkType.ITALIC,
  "underline": MarkType.UNDERLINE,
  "strike": MarkType.STRIKE
});

enum ContentType {
  PARAGRAPH
}

final contentTypeValues = EnumValues({
  "paragraph": ContentType.PARAGRAPH
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
