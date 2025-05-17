// To parse this JSON data, do
//
//     final noteModel = noteModelFromJson(jsonString);

import 'dart:convert';

NoteModel noteModelFromJson(String str) => NoteModel.fromJson(json.decode(str));

String noteModelToJson(NoteModel data) => json.encode(data.toJson());

class NoteModel {
    Data? data;

    NoteModel({
        this.data,
    });

    factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}

class Data {
    String? id;
    String? title;
    bool? archived;
    User? user;
    String? permission;
    Mindmap? mindmap;
    Summary? summary;
    String? createdAt;
    String? updatedAt;

    Data({
        this.id,
        this.title,
        this.archived,
        this.user,
        this.permission,
        this.mindmap,
        this.summary,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        archived: json["archived"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        permission: json["permission"],
        mindmap: json["mindmap"] == null ? null : Mindmap.fromJson(json["mindmap"]),
        summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "archived": archived,
        "user": user?.toJson(),
        "permission": permission,
        "mindmap": mindmap?.toJson(),
        "summary": summary?.toJson(),
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class Mindmap {
    String? id;
    MindmapData? mindmapData;

    Mindmap({
        this.id,
        this.mindmapData,
    });

    factory Mindmap.fromJson(Map<String, dynamic> json) => Mindmap(
        id: json["id"],
        mindmapData: json["mindmap_data"] == null ? null : MindmapData.fromJson(json["mindmap_data"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "mindmap_data": mindmapData?.toJson(),
    };
}

class MindmapData {
    List<ParentContent>? parentContent;
    int? totalBranches;

    MindmapData({
        this.parentContent,
        this.totalBranches,
    });

    factory MindmapData.fromJson(Map<String, dynamic> json) => MindmapData(
        parentContent: json["parent_content"] == null ? [] : List<ParentContent>.from(json["parent_content"]!.map((x) => ParentContent.fromJson(x))),
        totalBranches: json["total_branches"],
    );

    Map<String, dynamic> toJson() => {
        "parent_content": parentContent == null ? [] : List<dynamic>.from(parentContent!.map((x) => x.toJson())),
        "total_branches": totalBranches,
    };
}

class ParentContent {
    String? branch;
    String? parent;
    String? content;
    List<ParentContent>? children;

    ParentContent({
        this.branch,
        this.parent,
        this.content,
        this.children,
    });

    factory ParentContent.fromJson(Map<String, dynamic> json) => ParentContent(
        branch: json["branch"],
        parent: json["parent"],
        content: json["content"],
        children: json["children"] == null ? [] : List<ParentContent>.from(json["children"]!.map((x) => ParentContent.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "branch": branch,
        "parent": parent,
        "content": content,
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
    };
}

class User {
    String? id;
    String? email;
    String? lastName;
    String? firstName;
    Avatar? avatar;

    User({
        this.id,
        this.email,
        this.lastName,
        this.firstName,
        this.avatar,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        lastName: json["last_name"],
        firstName: json["first_name"],
        avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "last_name": lastName,
        "first_name": firstName,
        "avatar": avatar?.toJson(),
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
