import 'dart:convert';

PostSendMessageModel postSendMessageModelFromJson(String str) =>
    PostSendMessageModel.fromJson(json.decode(str));

String postSendMessageModelToJson(PostSendMessageModel data) =>
    json.encode(data.toJson());

class PostSendMessageModel {
  String? statusCode;
  String? status;
  String? message;
  Result? result;

  PostSendMessageModel({
    this.statusCode,
    this.status,
    this.message,
    this.result,
  });

  // Updated fromJson method with null safety for "result"
  factory PostSendMessageModel.fromJson(Map<String, dynamic> json) =>
      PostSendMessageModel(
        statusCode: json["Status_code"],
        status: json["status"],
        message: json["message"],
        result: json["result"] != null ? Result.fromJson(json["result"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "Status_code": statusCode,
        "status": status,
        "message": message,
        "result": result?.toJson(),
      };
}

class Result {
  String? id;
  String? userId;
  String? teacherId;
  String? message;
  String? testpaymentId;
  String? time;
  DateTime? date;

  Result({
    this.id,
    this.userId,
    this.teacherId,
    this.message,
    this.testpaymentId,
    this.time,
    this.date,
  });

  // Updated fromJson method with null safety for each field
  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"] ?? "",
        userId: json["user_id"] ?? "",
        teacherId: json["teacher_id"] ?? "",
        message: json["message"] ?? "",
        testpaymentId: json["testpayment_id"] ?? "",
        time: json["time"] ?? "",
        date: json["date"] != null ? DateTime.tryParse(json["date"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "teacher_id": teacherId,
        "message": message,
        "testpayment_id": testpaymentId,
        "time": time,
        "date": date?.toIso8601String(),
      };
}
