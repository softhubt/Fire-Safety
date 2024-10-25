import 'dart:convert';

PostChapterQuizResultModel postChapterQuizResultModelFromJson(String str) =>
    PostChapterQuizResultModel.fromJson(json.decode(str));

String postChapterQuizResultModelToJson(PostChapterQuizResultModel data) =>
    json.encode(data.toJson());

class PostChapterQuizResultModel {
  String? statusCode;
  int? testDataSubmit;
  Result? result;

  PostChapterQuizResultModel({
    this.statusCode,
    this.testDataSubmit,
    this.result,
  });

  factory PostChapterQuizResultModel.fromJson(Map<String, dynamic> json) =>
      PostChapterQuizResultModel(
        statusCode: json["Status_code"],
        testDataSubmit: json["test_data_submit"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "Status_code": statusCode,
        "test_data_submit": testDataSubmit,
        "result": result?.toJson(),
      };
}

class Result {
  String? id;
  String? userId;
  String? testId;
  String? testType;
  String? obtainMarks;
  String? totalMarks;
  String? rightAnswers;
  String? wrongAnswers;

  Result({
    this.id,
    this.userId,
    this.testId,
    this.testType,
    this.obtainMarks,
    this.totalMarks,
    this.rightAnswers,
    this.wrongAnswers,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        testId: json["test_id"],
        testType: json["test_type"],
        obtainMarks: json["obtain_marks"],
        totalMarks: json["total_marks"],
        rightAnswers: json["right_answers"],
        wrongAnswers: json["wrong_answers"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "test_id": testId,
        "test_type": testType,
        "obtain_marks": obtainMarks,
        "total_marks": totalMarks,
        "right_answers": rightAnswers,
        "wrong_answers": wrongAnswers,
      };
}
