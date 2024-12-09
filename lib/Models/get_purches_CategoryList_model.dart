import 'dart:convert';

GetPurchaseSubcategoryModel getPurchaseSubcategoryModelFromJson(String str) =>
    GetPurchaseSubcategoryModel.fromJson(json.decode(str));

String getPurchaseSubcategoryModelToJson(GetPurchaseSubcategoryModel data) =>
    json.encode(data.toJson());

class GetPurchaseSubcategoryModel {
  String? statusCode;
  String? message;
  List<PurchaseSubcategory>? myPurchaseSubcategoryList;

  GetPurchaseSubcategoryModel({
    this.statusCode,
    this.message,
    this.myPurchaseSubcategoryList,
  });

  factory GetPurchaseSubcategoryModel.fromJson(Map<String, dynamic> json) =>
      GetPurchaseSubcategoryModel(
        statusCode: json["status_code"],
        message: json["message"],
        myPurchaseSubcategoryList: json["my_purchase_subcategorylist"] != null
            ? List<PurchaseSubcategory>.from(json["my_purchase_subcategorylist"]
            .map((x) => PurchaseSubcategory.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "my_purchase_subcategorylist": myPurchaseSubcategoryList != null
        ? List<dynamic>.from(
        myPurchaseSubcategoryList!.map((x) => x.toJson()))
        : [],
  };
}

class PurchaseSubcategory {
  String? testpaymentId;
  String? categoryId;
  String? userId;
  String? subcategoryId;
  String? subcategoryName;
  String? subcategoryImage;
  String? amount;
  String? days;
  String? paymentId;
  String? date;
  String? time;
  String? purchaseDate;
  String? expiryDate;
  String? status;
  String? bookingForm;
  String? speakingTest;
  String? writingTest;
  String? readingTest;
  String? listeningTest;

  PurchaseSubcategory({
    this.testpaymentId,
    this.categoryId,
    this.userId,
    this.subcategoryId,
    this.subcategoryName,
    this.subcategoryImage,
    this.amount,
    this.days,
    this.paymentId,
    this.date,
    this.time,
    this.purchaseDate,
    this.expiryDate,
    this.status,
    this.bookingForm,
    this.speakingTest,
    this.writingTest,
    this.readingTest,
    this.listeningTest,
  });

  factory PurchaseSubcategory.fromJson(Map<String, dynamic> json) =>
      PurchaseSubcategory(
        testpaymentId: json["testpayment_id"],
        categoryId: json["category_id"],
        userId: json["user_id"],
        subcategoryId: json["subcategory_id"],
        subcategoryName: json["subcategory_name"],
        subcategoryImage: json["subcategory_image"],
        amount: json["amount"],
        days: json["days"],
        paymentId: json["payment_id"],
        date: json["date"],
        time: json["time"],
        purchaseDate: json["purchase_dt"],
        expiryDate: json["expiry_dt"],
        status: json["status"],
        bookingForm: json["booking_form"],
        speakingTest: json["speaking_test"],
        writingTest: json["writing_test"],
        readingTest: json["reading_test"],
        listeningTest: json["listening_test"],
      );

  Map<String, dynamic> toJson() => {
    "testpayment_id": testpaymentId,
    "category_id": categoryId,
    "user_id": userId,
    "subcategory_id": subcategoryId,
    "subcategory_name": subcategoryName,
    "subcategory_image": subcategoryImage,
    "amount": amount,
    "days": days,
    "payment_id": paymentId,
    "date": date,
    "time": time,
    "purchase_dt": purchaseDate,
    "expiry_dt": expiryDate,
    "status": status,
    "booking_form": bookingForm,
    "speaking_test": speakingTest,
    "writing_test": writingTest,
    "reading_test": readingTest,
    "listening_test": listeningTest,
  };
}
