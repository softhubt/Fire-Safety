import 'dart:convert';


PostShowlastChapterresultQuizModel postShowlastChapterresultQuizModelFromJson(String str) =>
    PostShowlastChapterresultQuizModel.fromJson(json.decode(str));


String postShowlastChapterresultQuizModelToJson(PostShowlastChapterresultQuizModel data) =>
    json.encode(data.toJson());

class PostShowlastChapterresultQuizModel {
  String? statusCode;
  String? message;
  List<TestResult>? testResultList;

  PostShowlastChapterresultQuizModel({
    this.statusCode,
    this.message,
    this.testResultList,
  });

  factory PostShowlastChapterresultQuizModel.fromJson(Map<String, dynamic> json) =>
      PostShowlastChapterresultQuizModel(
        statusCode: json["status_code"],
        message: json["message"],
        testResultList: json["test_result_list"] == null
            ? []
            : List<TestResult>.from(
            json["test_result_list"].map((x) => TestResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "test_result_list": testResultList != null
        ? List<dynamic>.from(testResultList!.map((x) => x.toJson()))
        : [],
  };
}

class TestResult {
  String? id;
  String? userId;
  String? testId;
  String? testType;
  String? obtainMarks;
  String? totalMarks;
  String? testName;
  String? answerSheet;
  String? checkedAnswerSheet;
  String? rightAnswers;
  String? wrongAnswers;
  String? totalQuestion;
  String? topperObtainMarks;

  TestResult({
    this.id,
    this.userId,
    this.testId,
    this.testType,
    this.obtainMarks,
    this.totalMarks,
    this.testName,
    this.answerSheet,
    this.checkedAnswerSheet,
    this.rightAnswers,
    this.wrongAnswers,
    this.totalQuestion,
    this.topperObtainMarks,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) => TestResult(
    id: json["id"],
    userId: json["user_id"],
    testId: json["test_id"],
    testType: json["test_type"],
    obtainMarks: json["obtain_marks"],
    totalMarks: json["total_marks"],
    testName: json["test_name"],
    answerSheet: json["answer_sheet"],
    checkedAnswerSheet: json["checked_answer_sheet"],
    rightAnswers: json["right_answers"],
    wrongAnswers: json["wrong_answers"],
    totalQuestion: json["total_question"],
    topperObtainMarks: json["topper_obtain_marks"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "test_id": testId,
    "test_type": testType,
    "obtain_marks": obtainMarks,
    "total_marks": totalMarks,
    "test_name": testName,
    "answer_sheet": answerSheet,
    "checked_answer_sheet": checkedAnswerSheet,
    "right_answers": rightAnswers,
    "wrong_answers": wrongAnswers,
    "total_question": totalQuestion,
    "topper_obtain_marks": topperObtainMarks,
  };
}
