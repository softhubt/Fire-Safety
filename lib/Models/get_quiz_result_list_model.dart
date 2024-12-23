import 'dart:convert';

GetQuizResultListModel getQuizResultListModelFromJson(String str) =>
    GetQuizResultListModel.fromJson(json.decode(str));

String getQuizResultListModelToJson(GetQuizResultListModel data) =>
    json.encode(data.toJson());

class GetQuizResultListModel {
  String? statusCode;
  String? message;
  List<TestResultList>? testResultList;

  GetQuizResultListModel({
    this.statusCode,
    this.message,
    this.testResultList,
  });

  factory GetQuizResultListModel.fromJson(Map<String, dynamic> json) =>
      GetQuizResultListModel(
        statusCode: json["status_code"],
        message: json["message"],
        testResultList: json["test_result_list"] == null
            ? []
            : List<TestResultList>.from(json["test_result_list"]!
                .map((x) => TestResultList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "test_result_list": testResultList == null
            ? []
            : List<dynamic>.from(testResultList!.map((x) => x.toJson())),
      };
}

class TestResultList {
  String? id;
  String? userId;
  String? testId;
  String? testType;
  String? obtainMarks;
  String? totalMarks;
  dynamic testName;
  dynamic answerSheet;
  dynamic checkedAnswerSheet;
  String? rightAnswers;
  String? wrongAnswers;
  int? totalQuestion;
  String? topperObtainMarks;
  String? courseId;
  String? chapterId;
  String? topicId;
  DateTime? tdate;
  String? ttime;

  TestResultList({
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
    this.courseId,
    this.chapterId,
    this.topicId,
    this.tdate,
    this.ttime,
  });

  factory TestResultList.fromJson(Map<String, dynamic> json) => TestResultList(
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
        courseId: json["course_id"],
        chapterId: json["chapter_id"],
        topicId: json["topic_id"],
        tdate: json["tdate"] == null ? null : DateTime.parse(json["tdate"]),
        ttime: json["ttime"],
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
        "course_id": courseId,
        "chapter_id": chapterId,
        "topic_id": topicId,
        "tdate":
            "${tdate!.year.toString().padLeft(4, '0')}-${tdate!.month.toString().padLeft(2, '0')}-${tdate!.day.toString().padLeft(2, '0')}",
        "ttime": ttime,
      };
}
