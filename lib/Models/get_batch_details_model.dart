import 'dart:convert';

GetBatchDetailsModel getBatchDetailsModelFromJson(String str) =>
    GetBatchDetailsModel.fromJson(json.decode(str));

String getBatchDetailsModelToJson(GetBatchDetailsModel data) =>
    json.encode(data.toJson());

class GetBatchDetailsModel {
  String? statusCode;
  String? status;
  String? message;
  String? userId;
  String? testpaymentId;
  String? batchId;
  String? teacherId;
  String? batchName;
  String? teacherName;

  GetBatchDetailsModel({
    this.statusCode,
    this.status,
    this.message,
    this.userId,
    this.testpaymentId,
    this.batchId,
    this.teacherId,
    this.batchName,
    this.teacherName,
  });

  factory GetBatchDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetBatchDetailsModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        userId: json["user_id"],
        testpaymentId: json["testpayment_id"],
        batchId: json["batch_id"],
        teacherId: json["teacher_id"],
        batchName: json["batch_name"],
        teacherName: json["teacher_name"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "user_id": userId,
        "testpayment_id": testpaymentId,
        "batch_id": batchId,
        "teacher_id": teacherId,
        "batch_name": batchName,
        "teacher_name": teacherName,
      };
}
