import 'dart:convert';

GetSubcategoryModel getSubcategoryModelFromJson(String str) =>
    GetSubcategoryModel.fromJson(json.decode(str));

String getSubcategoryModelToJson(GetSubcategoryModel data) =>
    json.encode(data.toJson());

class GetSubcategoryModel {
  String? statusCode;
  String? status;
  String? message;
  List<SubcategoryList>? subcategoryList;

  GetSubcategoryModel({
    this.statusCode,
    this.status,
    this.message,
    this.subcategoryList,
  });

  factory GetSubcategoryModel.fromJson(Map<String, dynamic> json) =>
      GetSubcategoryModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        subcategoryList: List<SubcategoryList>.from(
            json["subcategory_list"].map((x) => SubcategoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "subcategory_list":
            List<dynamic>.from(subcategoryList!.map((x) => x.toJson())),
      };
}

class SubcategoryList {
  String? subcategoryId;
  String? subcategoryName;
  String? subcategoryImage;
  String? categoryId;

  SubcategoryList({
    this.subcategoryId,
    this.subcategoryName,
    this.subcategoryImage,
    this.categoryId,
  });

  factory SubcategoryList.fromJson(Map<String, dynamic> json) =>
      SubcategoryList(
        subcategoryId: json["subcategory_id"],
        subcategoryName: json["subcategory_name"],
        subcategoryImage: json["subcategory_image"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "subcategory_id": subcategoryId,
        "subcategory_name": subcategoryName,
        "subcategory_image": subcategoryImage,
        "category_id": categoryId,
      };
}
