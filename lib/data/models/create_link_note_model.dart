// To parse this JSON data, do
//
//     final createLinkNoteModel = createLinkNoteModelFromJson(jsonString);

import 'dart:convert';

CreateLinkNoteModel createLinkNoteModelFromJson(String str) => CreateLinkNoteModel.fromJson(json.decode(str));

String createLinkNoteModelToJson(CreateLinkNoteModel data) => json.encode(data.toJson());

class CreateLinkNoteModel {
  Data? data;

  CreateLinkNoteModel({
    this.data,
  });

  factory CreateLinkNoteModel.fromJson(Map<String, dynamic> json) => CreateLinkNoteModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  String? url;

  Data({
    this.url,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}
