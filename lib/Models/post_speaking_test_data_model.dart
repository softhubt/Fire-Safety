import 'dart:convert';

PostSpeakingTestDataModel postSpeakingTestDataModelFromJson(String str) =>
    PostSpeakingTestDataModel.fromJson(json.decode(str));

String postSpeakingTestDataModelToJson(PostSpeakingTestDataModel data) =>
    json.encode(data.toJson());

class PostSpeakingTestDataModel {
  String? statusCode;
  String? status;
  String? message;
  int? testDataSubmit;
  Result? result;

  PostSpeakingTestDataModel({
    this.statusCode,
    this.status,
    this.message,
    this.testDataSubmit,
    this.result,
  });

  factory PostSpeakingTestDataModel.fromJson(Map<String, dynamic> json) =>
      PostSpeakingTestDataModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        testDataSubmit: json["test_data_submit"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "test_data_submit": testDataSubmit,
        "result": result?.toJson(),
      };
}

class Result {
  String? id;
  String? userId;
  String? type;
  String? questionId;
  String? questionDetails;
  String? video;
  DateTime? tdate;
  String? ttime;

  Result({
    this.id,
    this.userId,
    this.type,
    this.questionId,
    this.questionDetails,
    this.video,
    this.tdate,
    this.ttime,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        questionId: json["question_id"],
        questionDetails: json["question_details"],
        video: json["video"],
        tdate: json["tdate"] == null ? null : DateTime.parse(json["tdate"]),
        ttime: json["ttime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "question_id": questionId,
        "question_details": questionDetails,
        "video": video,
        "tdate":
            "${tdate!.year.toString().padLeft(4, '0')}-${tdate!.month.toString().padLeft(2, '0')}-${tdate!.day.toString().padLeft(2, '0')}",
        "ttime": ttime,
      };
}
