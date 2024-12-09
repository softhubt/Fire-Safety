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

  // Factory method to convert JSON into GetSubcategoryModel object
  factory GetSubcategoryModel.fromJson(Map<String, dynamic> json) =>
      GetSubcategoryModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        subcategoryList: List<SubcategoryList>.from(
            json["subcategory_list"].map((x) => SubcategoryList.fromJson(x))),
      );

  // Method to convert GetSubcategoryModel object to JSON
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
  String? amount;
  String? days;
  int? isPurchase;
  String? message;
  String? status;
  String? bookingForm;
  String? speakingTest;
  String? writingTest;
  String? readingTest;
  String? listeningTest;

  SubcategoryList({
    this.subcategoryId,
    this.subcategoryName,
    this.subcategoryImage,
    this.categoryId,
    this.amount,
    this.days,
    this.isPurchase,
    this.message,
    this.status,
    this.bookingForm,
    this.speakingTest,
    this.writingTest,
    this.readingTest,
    this.listeningTest,
  });

  // Factory method to convert JSON into SubcategoryList object
  factory SubcategoryList.fromJson(Map<String, dynamic> json) =>
      SubcategoryList(
        subcategoryId: json["subcategory_id"],
        subcategoryName: json["subcategory_name"],
        subcategoryImage: json["subcategory_image"],
        categoryId: json["category_id"],
        amount: json["amount"],
        days: json["days"],
        isPurchase: json["is_purchase"],
        message: json["message"],
        status: json["status"],
        bookingForm: json["booking_form"],
        speakingTest: json["speaking_test"],
        writingTest: json["writing_test"],
        readingTest: json["reading_test"],
        listeningTest: json["listening_test"],
      );

  // Method to convert SubcategoryList object to JSON
  Map<String, dynamic> toJson() => {
    "subcategory_id": subcategoryId,
    "subcategory_name": subcategoryName,
    "subcategory_image": subcategoryImage,
    "category_id": categoryId,
    "amount": amount,
    "days": days,
    "is_purchase": isPurchase,
    "message": message,
    "status": status,
    "booking_form": bookingForm,
    "speaking_test": speakingTest,
    "writing_test": writingTest,
    "reading_test": readingTest,
    "listening_test": listeningTest,
  };
}
