import 'dart:convert';

PostFormativeAssessmentResultModel postFormativeAssessmentResultModelFromJson(String str) =>
    PostFormativeAssessmentResultModel.fromJson(json.decode(str));

String postFormativeAssessmentResultModelToJson(PostFormativeAssessmentResultModel data) =>
    json.encode(data.toJson());

class PostFormativeAssessmentResultModel {
  String? statusCode;
  String? message;
  List<FormativeAssessmentResult>? formativeAssessmentResultList;

  PostFormativeAssessmentResultModel({
    this.statusCode,
    this.message,
    this.formativeAssessmentResultList,
  });

  // Factory constructor to create PostFormativeAssessmentResultModel from JSON
  factory PostFormativeAssessmentResultModel.fromJson(Map<String, dynamic> json) =>
      PostFormativeAssessmentResultModel(
        statusCode: json["status_code"],
        message: json["message"],
        formativeAssessmentResultList: List<FormativeAssessmentResult>.from(
            json["formative_assessment_result_list"].map((x) => FormativeAssessmentResult.fromJson(x))),
      );

  // Method to convert PostFormativeAssessmentResultModel to JSON
  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "formative_assessment_result_list": (formativeAssessmentResultList != null)
        ? List<dynamic>.from(formativeAssessmentResultList!.map((x) => x.toJson()))
        : null,
  };
}

class FormativeAssessmentResult {
  String? id;
  String? ftrNumber;
  String? testFormativeId;
  String? testFormativeType;
  String? courseId;
  String? chapterId;
  String? topicId;
  String? subcategoryId;
  String? obtainMarks;
  String? mark;
  String? tdate;
  String? ttime;
  List<FormativeResultDetail>? formativeResultDetails;

  FormativeAssessmentResult({
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

  // Factory constructor to create FormativeAssessmentResult from JSON
  factory FormativeAssessmentResult.fromJson(Map<String, dynamic> json) => FormativeAssessmentResult(
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
    tdate: json["tdate"],
    ttime: json["ttime"],
    formativeResultDetails: List<FormativeResultDetail>.from(
        json["formative_result_details"].map((x) => FormativeResultDetail.fromJson(x))),
  );

  // Method to convert FormativeAssessmentResult to JSON
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
    "tdate": tdate,
    "ttime": ttime,
    "formative_result_details": (formativeResultDetails != null)
        ? List<dynamic>.from(formativeResultDetails!.map((x) => x.toJson()))
        : null,
  };
}

class FormativeResultDetail {
  String? id;
  String? questionId;
  String? question;
  String? answer;
  String? marks;
  String? comment;

  FormativeResultDetail({
    this.id,
    this.questionId,
    this.question,
    this.answer,
    this.marks,
    this.comment,
  });

  // Factory constructor to create FormativeResultDetail from JSON
  factory FormativeResultDetail.fromJson(Map<String, dynamic> json) => FormativeResultDetail(
    id: json["id"],
    questionId: json["question_id"],
    question: json["question"],
    answer: json["answer"],
    marks: json["marks"],
    comment: json["comment"],
  );

  // Method to convert FormativeResultDetail to JSON
  Map<String, dynamic> toJson() => {
    "id": id,
    "question_id": questionId,
    "question": question,
    "answer": answer,
    "marks": marks,
    "comment": comment,
  };
}
