import 'dart:convert';

// Function to convert JSON string to SubmitFormativeAssessmentModel
SubmitFormativeAssessmentModel submitFormativeAssessmentModelFromJson(String str) =>
    SubmitFormativeAssessmentModel.fromJson(json.decode(str));

// Function to convert SubmitFormativeAssessmentModel to JSON string
String submitFormativeAssessmentModelToJson(SubmitFormativeAssessmentModel data) =>
    json.encode(data.toJson());

// Main model class
class SubmitFormativeAssessmentModel {
  String? statusCode;
  String? status;
  String? message;
  int? testDataSubmit;
  SubmitFormativeAssessmentResult? result;

  SubmitFormativeAssessmentModel({
    this.statusCode,
    this.status,
    this.message,
    this.testDataSubmit,
    this.result,
  });

  factory SubmitFormativeAssessmentModel.fromJson(Map<String, dynamic> json) =>
      SubmitFormativeAssessmentModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        testDataSubmit: json["test_data_submit"],
        result: json["result"] == null
            ? null
            : SubmitFormativeAssessmentResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "message": message,
    "test_data_submit": testDataSubmit,
    "result": result?.toJson(),
  };
}

// Class for result details
class SubmitFormativeAssessmentResult {
  String? id;
  String? courseId;
  String? chapterId;
  String? userId;
  String? testFormativeId;
  String? testFormativeType;
  String? tdate;
  String? ttime;
  List<SubmitOrderItem>? orderItem;

  SubmitFormativeAssessmentResult({
    this.id,
    this.courseId,
    this.chapterId,
    this.userId,
    this.testFormativeId,
    this.testFormativeType,
    this.tdate,
    this.ttime,
    this.orderItem,
  });

  factory SubmitFormativeAssessmentResult.fromJson(Map<String, dynamic> json) =>
      SubmitFormativeAssessmentResult(
        id: json["id"],
        courseId: json["course_id"],
        chapterId: json["chapter_id"],
        userId: json["user_id"],
        testFormativeId: json["test_formative_id"],
        testFormativeType: json["test_formative_type"],
        tdate: json["tdate"],
        ttime: json["ttime"],
        orderItem: json["order_item"] == null
            ? null
            : List<SubmitOrderItem>.from(
            jsonDecode(json["order_item"]).map((x) => SubmitOrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_id": courseId,
    "chapter_id": chapterId,
    "user_id": userId,
    "test_formative_id": testFormativeId,
    "test_formative_type": testFormativeType,
    "tdate": tdate,
    "ttime": ttime,
    "order_item": orderItem == null
        ? null
        : jsonEncode(orderItem!.map((x) => x.toJson()).toList()),
  };
}

// Class for order item details
class SubmitOrderItem {
  int? cartId;
  String? id;
  String? questionId;
  String? answer;

  SubmitOrderItem({
    this.cartId,
    this.id,
    this.questionId,
    this.answer,
  });

  factory SubmitOrderItem.fromJson(Map<String, dynamic> json) =>
      SubmitOrderItem(
        cartId: json["cartId"],
        id: json["id"],
        questionId: json["question_id"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
    "cartId": cartId,
    "id": id,
    "question_id": questionId,
    "answer": answer,
  };
}
