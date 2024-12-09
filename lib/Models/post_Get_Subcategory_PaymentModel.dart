import 'dart:convert';


GetSubcategoryPaymentModel getSubcategoryPaymentModelFromJson(String str) =>
    GetSubcategoryPaymentModel.fromJson(json.decode(str));

String getSubcategoryPaymentModelToJson(GetSubcategoryPaymentModel data) =>
    json.encode(data.toJson());

class GetSubcategoryPaymentModel {
  String? statusCode;
  String? status;
  SubcategoryPurchasePaymentResult? subcategoryPurchasePaymentResult;

  GetSubcategoryPaymentModel({
    this.statusCode,
    this.status,
    this.subcategoryPurchasePaymentResult,
  });


  factory GetSubcategoryPaymentModel.fromJson(Map<String, dynamic> json) =>
      GetSubcategoryPaymentModel(
        statusCode: json["status_code"],
        status: json["status"],
        subcategoryPurchasePaymentResult: json["subcategory_purchasepayment_result"] != null
            ? SubcategoryPurchasePaymentResult.fromJson(json["subcategory_purchasepayment_result"])
            : null,
      );


  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "subcategory_purchasepayment_result":
    subcategoryPurchasePaymentResult?.toJson(),
  };
}

class SubcategoryPurchasePaymentResult {
  String? id;
  String? categoryId;
  String? userId;
  String? subcategoryId;
  String? amount;
  String? days;
  String? paymentId;
  String? date;
  String? time;
  String? orderId;

  SubcategoryPurchasePaymentResult({
    this.id,
    this.categoryId,
    this.userId,
    this.subcategoryId,
    this.amount,
    this.days,
    this.paymentId,
    this.date,
    this.time,
    this.orderId,
  });


  factory SubcategoryPurchasePaymentResult.fromJson(Map<String, dynamic> json) =>
      SubcategoryPurchasePaymentResult(
        id: json["id"],
        categoryId: json["category_id"],
        userId: json["user_id"],
        subcategoryId: json["subcategory_id"],
        amount: json["amount"],
        days: json["days"],
        paymentId: json["payment_id"],
        date: json["date"],
        time: json["time"],
        orderId: json["order_id"],
      );


  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "user_id": userId,
    "subcategory_id": subcategoryId,
    "amount": amount,
    "days": days,
    "payment_id": paymentId,
    "date": date,
    "time": time,
    "order_id": orderId,
  };
}
