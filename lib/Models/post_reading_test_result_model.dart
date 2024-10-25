import 'dart:convert';

PostReadingResultModel postReadingResultModelFromJson(String str) =>
    PostReadingResultModel.fromJson(json.decode(str));

String postReadingResultModelToJson(PostReadingResultModel data) =>
    json.encode(data.toJson());

class PostReadingResultModel {
  String? statusCode;
  int? testDataSubmit;
  ReadingResult? result;

  PostReadingResultModel({
    this.statusCode,
    this.testDataSubmit,
    this.result,
  });

  factory PostReadingResultModel.fromJson(Map<String, dynamic> json) =>
      PostReadingResultModel(
        statusCode: json["Status_code"],
        testDataSubmit: json["test_data_submit"],
        result: json["result"] != null ? ReadingResult.fromJson(json["result"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "Status_code": statusCode,
    "test_data_submit": testDataSubmit,
    "result": result?.toJson(),
  };
}

class ReadingResult {
  String? id;
  String? userId;
  String? readListeningTestId;
  String? type;
  String? obtainMarks;
  String? totalMarks;
  String? rightAnswers;
  String? wrongAnswers;
  String? date;  // Renamed for clarity
  String? time;  // Renamed for clarity

  ReadingResult({
    this.id,
    this.userId,
    this.readListeningTestId,
    this.type,
    this.obtainMarks,
    this.totalMarks,
    this.rightAnswers,
    this.wrongAnswers,
    this.date,
    this.time,
  });

  factory ReadingResult.fromJson(Map<String, dynamic> json) => ReadingResult(
    id: json["id"],
    userId: json["user_id"],
    readListeningTestId: json["read_listening_test_id"],
    type: json["type"],
    obtainMarks: json["obtain_marks"],
    totalMarks: json["total_marks"],
    rightAnswers: json["right_answers"],
    wrongAnswers: json["wrong_answers"],
    date: json["tdate"],
    time: json["ttime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "read_listening_test_id": readListeningTestId,
    "type": type,
    "obtain_marks": obtainMarks,
    "total_marks": totalMarks,
    "right_answers": rightAnswers,
    "wrong_answers": wrongAnswers,
    "tdate": date,
    "ttime": time,
  };
}
