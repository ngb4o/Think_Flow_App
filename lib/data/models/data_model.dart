// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  dynamic data;

  DataModel({
    this.data,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
  };

  // Helper method to check if response is successful
  bool get isSuccess => data != null && (data == true || (data is String && data.isNotEmpty));
}
