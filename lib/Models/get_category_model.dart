import 'dart:convert';

GetCategoryModel getCategoryModelFromJson(String str) =>
    GetCategoryModel.fromJson(json.decode(str));

String getCategoryModelToJson(GetCategoryModel data) =>
    json.encode(data.toJson());

class GetCategoryModel {
  String? statusCode;
  String? status;
  String? message;
  List<CategoryList>? categoryList;

  GetCategoryModel({
    this.statusCode,
    this.status,
    this.message,
    this.categoryList,
  });

  factory GetCategoryModel.fromJson(Map<String, dynamic> json) =>
      GetCategoryModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        categoryList: List<CategoryList>.from(
            json["category_list"].map((x) => CategoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "category_list":
            List<dynamic>.from(categoryList!.map((x) => x.toJson())),
      };
}

class CategoryList {
  String? categoryId;
  String? categoryName;
  String? categoryImage;

  CategoryList({
    this.categoryId,
    this.categoryName,
    this.categoryImage,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryImage: json["category_image"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "category_image": categoryImage,
      };
}
