import 'dart:convert';

GetChapterQuizListModel getChapterQuizListModelFromJson(String str) =>
    GetChapterQuizListModel.fromJson(json.decode(str));

String getChapterQuizListModelToJson(GetChapterQuizListModel data) =>
    json.encode(data.toJson());

class GetChapterQuizListModel {
  String? statusCode;
  String? message;
  List<TestDetailsList>? testDetailsList;

  GetChapterQuizListModel({
    this.statusCode,
    this.message,
    this.testDetailsList,
  });

  factory GetChapterQuizListModel.fromJson(Map<String, dynamic> json) =>
      GetChapterQuizListModel(
        statusCode: json["status_code"],
        message: json["message"],
        testDetailsList: List<TestDetailsList>.from(
            json["test_details_list"].map((x) => TestDetailsList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "test_details_list":
            List<dynamic>.from(testDetailsList!.map((x) => x.toJson())),
      };
}

class TestDetailsList {
  String? id;
  String? testId;
  String? testType;
  DateTime? testDate;
  String? courseName;
  String? chapterId;
  String? topicid;
  dynamic testName;
  String? mark;
  String? testTime;
  String? rightMark;
  int? tresultcount;
  List<TestQuestionDetail>? testQuestionDetails;

  TestDetailsList({
    this.id,
    this.testId,
    this.testType,
    this.testDate,
    this.courseName,
    this.chapterId,
    this.topicid,
    this.testName,
    this.mark,
    this.testTime,
    this.rightMark,
    this.tresultcount,
    this.testQuestionDetails,
  });

  factory TestDetailsList.fromJson(Map<String, dynamic> json) =>
      TestDetailsList(
        id: json["id"],
        testId: json["test_id"],
        testType: json["test_type"],
        testDate: DateTime.parse(json["test_date"]),
        courseName: json["course_name"],
        chapterId: json["chapter_id"],
        topicid: json["topic_id"],
        testName: json["test_name"],
        mark: json["mark"],
        testTime: json["test_time"],
        rightMark: json["right_mark"],
        tresultcount: json["tresultcount"],
        testQuestionDetails: List<TestQuestionDetail>.from(
            json["test_question_details"]
                .map((x) => TestQuestionDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "test_id": testId,
        "test_type": testType,
        "test_date":
            "${testDate?.year.toString().padLeft(4, '0')}-${testDate?.month.toString().padLeft(2, '0')}-${testDate?.day.toString().padLeft(2, '0')}",
        "course_name": courseName,
        "chapter_id": chapterId,
        "topic_id": topicid,
        "test_name": testName,
        "mark": mark,
        "test_time": testTime,
        "right_mark": rightMark,
        "tresultcount": tresultcount,
        "test_question_details":
            List<dynamic>.from(testQuestionDetails!.map((x) => x.toJson())),
      };
}

class TestQuestionDetail {
  String? id;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? answer;

  TestQuestionDetail({
    this.id,
    this.question,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.answer,
  });

  factory TestQuestionDetail.fromJson(Map<String, dynamic> json) =>
      TestQuestionDetail(
        id: json["id"],
        question: json["question"],
        option1: json["option1"],
        option2: json["option2"],
        option3: json["option3"],
        option4: json["option4"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
        "answer": answer,
      };
}
