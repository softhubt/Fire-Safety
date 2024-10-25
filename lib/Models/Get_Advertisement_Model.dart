import 'dart:convert';

// Function to parse JSON string into GetadvertiesmentModel
GetadvertiesmentModel getadvertiesmentModelFromJson(String str) =>
    GetadvertiesmentModel.fromJson(json.decode(str));

// Function to convert GetadvertiesmentModel into JSON string
String getadvertiesmentModelToJson(GetadvertiesmentModel data) =>
    json.encode(data.toJson());

class GetadvertiesmentModel {
  String? statusCode;
  String? message;
  List<Advertisement>? advertisementList;

  GetadvertiesmentModel({
    this.statusCode,
    this.message,
    this.advertisementList,
  });

  // Factory constructor to create GetadvertiesmentModel from JSON
  factory GetadvertiesmentModel.fromJson(Map<String, dynamic> json) =>
      GetadvertiesmentModel(
        statusCode: json["status_code"],
        message: json["message"],
        advertisementList: List<Advertisement>.from(
            json["advertiesment_list"].map((x) => Advertisement.fromJson(x))),
      );

  // Method to convert GetadvertiesmentModel to JSON
  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "advertiesment_list": (advertisementList != null)
        ? List<dynamic>.from(advertisementList!.map((x) => x.toJson()))
        : null,
  };
}

class Advertisement {
  String? id;
  String? categoryId;
  String? description;
  String? imagePath;

  Advertisement({
    this.id,
    this.categoryId,
    this.description,
    this.imagePath,
  });

  // Factory constructor to create Advertisement from JSON
  factory Advertisement.fromJson(Map<String, dynamic> json) => Advertisement(
    id: json["id"],
    categoryId: json["category_id"],
    description: json["description"],
    imagePath: json["image_path"],
  );

  // Method to convert Advertisement to JSON
  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "description": description,
    "image_path": imagePath,
  };
}
