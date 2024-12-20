import 'dart:convert';

GetFormativeAssessmentResultListModel
    getFormativeAssessmentResultListModelFromJson(String str) =>
        GetFormativeAssessmentResultListModel.fromJson(json.decode(str));

String getFormativeAssessmentResultListModelToJson(
        GetFormativeAssessmentResultListModel data) =>
    json.encode(data.toJson());

class GetFormativeAssessmentResultListModel {
  String? statusCode;
  String? message;
  List<FormativeAssessmentResultList>? formativeAssessmentResultList;

  GetFormativeAssessmentResultListModel({
    this.statusCode,
    this.message,
    this.formativeAssessmentResultList,
  });

  factory GetFormativeAssessmentResultListModel.fromJson(
          Map<String, dynamic> json) =>
      GetFormativeAssessmentResultListModel(
        statusCode: json["status_code"],
        message: json["message"],
        formativeAssessmentResultList:
            json["formative_assessment_result_list"] == null
                ? []
                : List<FormativeAssessmentResultList>.from(
                    json["formative_assessment_result_list"]!
                        .map((x) => FormativeAssessmentResultList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "formative_assessment_result_list":
            formativeAssessmentResultList == null
                ? []
                : List<dynamic>.from(
                    formativeAssessmentResultList!.map((x) => x.toJson())),
      };
}

class FormativeAssessmentResultList {
  String? id;
  String? ftrNumber;
  String? testFormativeId;
  String? testFormativeType;
  String? courseId;
  String? chapterId;
  String? topicId;
  dynamic subcategoryId;
  dynamic obtainMarks;
  String? mark;
  DateTime? tdate;
  String? ttime;
  List<FormativeResultDetail>? formativeResultDetails;

  FormativeAssessmentResultList({
    this.id,
    this.ftrNumber,
    this.testFormativeId,
    this.testFormativeType,
    this.courseId,
    this.chapterId,
    this.topicId,
    this.subcategoryId,
    this.obtainMarks,
    this.mark,
    this.tdate,
    this.ttime,
    this.formativeResultDetails,
  });

  factory FormativeAssessmentResultList.fromJson(Map<String, dynamic> json) =>
      FormativeAssessmentResultList(
        id: json["id"],
        ftrNumber: json["ftr_number"],
        testFormativeId: json["test_formative_id"],
        testFormativeType: json["test_formative_type"],
        courseId: json["course_id"],
        chapterId: json["chapter_id"],
        topicId: json["topic_id"],
        subcategoryId: json["subcategory_id"],
        obtainMarks: json["obtain_marks"],
        mark: json["mark"],
        tdate: json["tdate"] == null ? null : DateTime.parse(json["tdate"]),
        ttime: json["ttime"],
        formativeResultDetails: json["formative_result_details"] == null
            ? []
            : List<FormativeResultDetail>.from(json["formative_result_details"]!
                .map((x) => FormativeResultDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ftr_number": ftrNumber,
        "test_formative_id": testFormativeId,
        "test_formative_type": testFormativeType,
        "course_id": courseId,
        "chapter_id": chapterId,
        "topic_id": topicId,
        "subcategory_id": subcategoryId,
        "obtain_marks": obtainMarks,
        "mark": mark,
        "tdate":
            "${tdate!.year.toString().padLeft(4, '0')}-${tdate!.month.toString().padLeft(2, '0')}-${tdate!.day.toString().padLeft(2, '0')}",
        "ttime": ttime,
        "formative_result_details": formativeResultDetails == null
            ? []
            : List<dynamic>.from(
                formativeResultDetails!.map((x) => x.toJson())),
      };
}

class FormativeResultDetail {
  String? id;
  String? questionId;
  String? question;
  String? answer;
  dynamic marks;
  dynamic comment;

  FormativeResultDetail({
    this.id,
    this.questionId,
    this.question,
    this.answer,
    this.marks,
    this.comment,
  });

  factory FormativeResultDetail.fromJson(Map<String, dynamic> json) =>
      FormativeResultDetail(
        id: json["id"],
        questionId: json["question_id"],
        question: json["question"],
        answer: json["answer"],
        marks: json["marks"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": questionId,
        "question": question,
        "answer": answer,
        "marks": marks,
        "comment": comment,
      };
}
