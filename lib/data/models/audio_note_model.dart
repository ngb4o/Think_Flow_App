// To parse this JSON data, do
//
//     final audioNoteModel = audioNoteModelFromJson(jsonString);

import 'dart:convert';

AudioNoteModel audioNoteModelFromJson(String str) => AudioNoteModel.fromJson(json.decode(str));

String audioNoteModelToJson(AudioNoteModel data) => json.encode(data.toJson());

class AudioNoteModel {
    Data? data;

    AudioNoteModel({
        this.data,
    });

    factory AudioNoteModel.fromJson(Map<String, dynamic> json) => AudioNoteModel(
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
    String? name;
    String? fileUrl;
    String? format;
    Transcript? transcript;
    Summary? summary;

    Data({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.fileUrl,
        this.format,
        this.transcript,
        this.summary,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
