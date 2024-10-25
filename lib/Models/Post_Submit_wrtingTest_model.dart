import 'dart:convert';


GetSumittheWritingtestmodel getSumittheWritingtestmodelFromJson(String str) =>
    GetSumittheWritingtestmodel.fromJson(json.decode(str));


String getSumittheWritingtestmodelToJson(GetSumittheWritingtestmodel data) =>
    json.encode(data.toJson());

class GetSumittheWritingtestmodel {
  String? statusCode;
  String? status;
  String? message;
  int? testDataSubmit;
  Result? result;

  GetSumittheWritingtestmodel({
    this.statusCode,
    this.status,
    this.message,
    this.testDataSubmit,
    this.result,
  });

  // Factory constructor to create GetSumittheWritingtestmodel from JSON
  factory GetSumittheWritingtestmodel.fromJson(Map<String, dynamic> json) =>
      GetSumittheWritingtestmodel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        testDataSubmit: json["test_data_submit"],
        result: json["result"] != null ? Result.fromJson(json["result"]) : null,
      );

  // Method to convert GetSumittheWritingtestmodel to JSON
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
  String? answer;
  String? tdate;
  String? ttime;

  Result({
    this.id,
    this.userId,
    this.type,
    this.questionId,
    this.questionDetails,
    this.answer,
    this.tdate,
    this.ttime,
  });

  // Factory constructor to create Result from JSON
  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    userId: json["user_id"],
    type: json["type"],
    questionId: json["question_id"],
    questionDetails: json["question_details"],
    answer: json["answer"],
    tdate: json["tdate"],
    ttime: json["ttime"],
  );

  // Method to convert Result to JSON
  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "type": type,
    "question_id": questionId,
    "question_details": questionDetails,
    "answer": answer,
    "tdate": tdate,
    "ttime": ttime,
  };
}
