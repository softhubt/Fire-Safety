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
        statusCode: json["status_code"] as String?,
        message: json["message"] as String?,
        testResultList: json["test_result_list"] != null
            ? List<TestResultList>.from(
                (json["test_result_list"] as List<dynamic>)
                    .map((x) => TestResultList.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "test_result_list": testResultList?.map((x) => x.toJson()).toList(),
      };
}

class TestResultList {
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
        id: json["id"] as String?,
        userId: json["user_id"] as String?,
        testId: json["test_id"] as String?,
        testType: json["test_type"] as String?,
        obtainMarks: json["obtain_marks"] as String?,
        totalMarks: json["total_marks"] as String?,
        testName: json["test_name"] ?? "", // Handle null
        answerSheet: json["answer_sheet"] ?? "", // Handle null
        checkedAnswerSheet: json["checked_answer_sheet"] ?? "", // Handle null
        rightAnswers: json["right_answers"] as String?,
        wrongAnswers: json["wrong_answers"] as String?,
        totalQuestion: json["total_question"] as int?,
        topperObtainMarks: json["topper_obtain_marks"] as String?,
        courseId: json["course_id"] as String?,
        chapterId: json["chapter_id"] as String?,
        topicId: json["topic_id"] as String?,
        tdate: json["tdate"] != null ? DateTime.tryParse(json["tdate"]) : null,
        ttime: json["ttime"] ?? "", // Handle null
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "test_id": testId,
        "test_type": testType,
        "obtain_marks": obtainMarks,
        "total_marks": totalMarks,
        "test_name": testName ?? "",
        "answer_sheet": answerSheet ?? "",
        "checked_answer_sheet": checkedAnswerSheet ?? "",
        "right_answers": rightAnswers,
        "wrong_answers": wrongAnswers,
        "total_question": totalQuestion,
        "topper_obtain_marks": topperObtainMarks,
        "course_id": courseId,
        "chapter_id": chapterId,
        "topic_id": topicId,
        "tdate": tdate != null
            ? "${tdate!.year.toString().padLeft(4, '0')}-${tdate!.month.toString().padLeft(2, '0')}-${tdate!.day.toString().padLeft(2, '0')}"
            : null,
        "ttime": ttime,
      };
}
