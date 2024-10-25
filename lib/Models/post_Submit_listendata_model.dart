import 'dart:convert';


PostListeningResultModel postListeningResultModelFromJson(String str) =>
    PostListeningResultModel.fromJson(json.decode(str));


String postListeningResultModelToJson(PostListeningResultModel data) =>
    json.encode(data.toJson());

class PostListeningResultModel {
  String? statusCode;
  int? testDataSubmit;
  ListeningResult? result;

  PostListeningResultModel({
    this.statusCode,
    this.testDataSubmit,
    this.result,
  });

  factory PostListeningResultModel.fromJson(Map<String, dynamic> json) =>
      PostListeningResultModel(
        statusCode: json["Status_code"],
        testDataSubmit: json["test_data_submit"],
        result: json["result"] != null ? ListeningResult.fromJson(json["result"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "Status_code": statusCode,
    "test_data_submit": testDataSubmit,
    "result": result?.toJson(),
  };
}

class ListeningResult {
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

  ListeningResult({
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

  factory ListeningResult.fromJson(Map<String, dynamic> json) => ListeningResult(
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
