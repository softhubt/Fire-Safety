import 'dart:convert';

// Function to convert JSON string to GetFormativeAssessmentModel
GetFormativeAssessmentModel getFormativeAssessmentModelFromJson(String str) =>
    GetFormativeAssessmentModel.fromJson(json.decode(str));

// Function to convert GetFormativeAssessmentModel to JSON string
String getFormativeAssessmentModelToJson(GetFormativeAssessmentModel data) =>
    json.encode(data.toJson());

// Main model class
class GetFormativeAssessmentModel {
  String? statusCode;
  String? message;
  List<FormativeAssessmentDetailsList>? formativeAssessmentDetailsList;

  GetFormativeAssessmentModel({
    this.statusCode,
    this.message,
    this.formativeAssessmentDetailsList,
  });

  factory GetFormativeAssessmentModel.fromJson(Map<String, dynamic> json) =>
      GetFormativeAssessmentModel(
        statusCode: json["status_code"],
        message: json["message"],
        formativeAssessmentDetailsList:
            json["formative_assessment_details_list"] == null
                ? null
                : List<FormativeAssessmentDetailsList>.from(
                    json["formative_assessment_details_list"].map(
                        (x) => FormativeAssessmentDetailsList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "formative_assessment_details_list":
            formativeAssessmentDetailsList == null
                ? null
                : List<dynamic>.from(
                    formativeAssessmentDetailsList!.map((x) => x.toJson())),
      };
}

// Class for formative assessment details
class FormativeAssessmentDetailsList {
  String? id;
  String? testFormativeId;
  String? testFormativeType;
  String? testFormativeDate;
  String? courseName;
  String? chapterId;
  dynamic testFormativeName;
  String? mark;
  String? testFormativeTime;
  String? rightMark;
  dynamic tresultcount;
  List<FormativeQuestionDetail>? formativeQuestionDetails;

  FormativeAssessmentDetailsList({
    this.id,
    this.testFormativeId,
    this.testFormativeType,
    this.testFormativeDate,
    this.courseName,
    this.chapterId,
    this.testFormativeName,
    this.mark,
    this.testFormativeTime,
    this.rightMark,
    this.tresultcount,
    this.formativeQuestionDetails,
  });

  factory FormativeAssessmentDetailsList.fromJson(Map<String, dynamic> json) =>
      FormativeAssessmentDetailsList(
        id: json["id"],
        testFormativeId: json["test_formative_id"],
        testFormativeType: json["test_formative_type"],
        testFormativeDate: json["test_formative_date"],
        courseName: json["course_name"],
        chapterId: json["chapter_id"],
        testFormativeName: json["test_formative_name"],
        mark: json["mark"],
        testFormativeTime: json["test_formative_time"],
        rightMark: json["right_mark"],
        tresultcount: json["tresultcount"],
        formativeQuestionDetails: json["formative_question_details"] == null
            ? null
            : List<FormativeQuestionDetail>.from(
                json["formative_question_details"]
                    .map((x) => FormativeQuestionDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "test_formative_id": testFormativeId,
        "test_formative_type": testFormativeType,
        "test_formative_date": testFormativeDate,
        "course_name": courseName,
        "chapter_id": chapterId,
        "test_formative_name": testFormativeName,
        "mark": mark,
        "test_formative_time": testFormativeTime,
        "right_mark": rightMark,
        "tresultcount": tresultcount,
        "formative_question_details": formativeQuestionDetails == null
            ? null
            : List<dynamic>.from(
                formativeQuestionDetails!.map((x) => x.toJson())),
      };
}

// Class for formative question details
class FormativeQuestionDetail {
  String? id;
  String? question;

  FormativeQuestionDetail({
    this.id,
    this.question,
  });

  factory FormativeQuestionDetail.fromJson(Map<String, dynamic> json) =>
      FormativeQuestionDetail(
        id: json["id"],
        question: json["question"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
      };
}
