import 'dart:convert';

GetFlashExcersiceResultListModel getFlashExcersiceResultListModelFromJson(
        String str) =>
    GetFlashExcersiceResultListModel.fromJson(json.decode(str));

String getFlashExcersiceResultListModelToJson(
        GetFlashExcersiceResultListModel data) =>
    json.encode(data.toJson());

class GetFlashExcersiceResultListModel {
  String? statusCode;
  String? message;
  List<FlashExerciseResultList>? flashExerciseResultList;

  GetFlashExcersiceResultListModel({
    this.statusCode,
    this.message,
    this.flashExerciseResultList,
  });

  factory GetFlashExcersiceResultListModel.fromJson(
          Map<String, dynamic> json) =>
      GetFlashExcersiceResultListModel(
        statusCode: json["status_code"],
        message: json["message"],
        flashExerciseResultList: json["flash_exercise_result_list"] == null
            ? []
            : List<FlashExerciseResultList>.from(
                json["flash_exercise_result_list"]!
                    .map((x) => FlashExerciseResultList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "flash_exercise_result_list": flashExerciseResultList == null
            ? []
            : List<dynamic>.from(
                flashExerciseResultList!.map((x) => x.toJson())),
      };
}

class FlashExerciseResultList {
  String? id;
  String? ftrNumber;
  String? flashExerciseId;
  String? flashExerciseType;
  String? userId;
  String? courseId;
  String? chapterId;
  String? topicId;
  String? subcategoryId;
  String? obtainMarks;
  String? mark;
  DateTime? tdate;
  String? ttime;
  List<FlashExerciseResultDetail>? flashExerciseResultDetails;

  FlashExerciseResultList({
    this.id,
    this.ftrNumber,
    this.flashExerciseId,
    this.flashExerciseType,
    this.userId,
    this.courseId,
    this.chapterId,
    this.topicId,
    this.subcategoryId,
    this.obtainMarks,
    this.mark,
    this.tdate,
    this.ttime,
    this.flashExerciseResultDetails,
  });

  factory FlashExerciseResultList.fromJson(Map<String, dynamic> json) =>
      FlashExerciseResultList(
        id: json["id"],
        ftrNumber: json["ftr_number"],
        flashExerciseId: json["flash_exercise_id"],
        flashExerciseType: json["flash_exercise_type"],
        userId: json["user_id"],
        courseId: json["course_id"],
        chapterId: json["chapter_id"],
        topicId: json["topic_id"],
        subcategoryId: json["subcategory_id"],
        obtainMarks: json["obtain_marks"],
        mark: json["mark"],
        tdate: json["tdate"] == null ? null : DateTime.parse(json["tdate"]),
        ttime: json["ttime"],
        flashExerciseResultDetails:
            json["flash_exercise_result_details"] == null
                ? []
                : List<FlashExerciseResultDetail>.from(
                    json["flash_exercise_result_details"]!
                        .map((x) => FlashExerciseResultDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ftr_number": ftrNumber,
        "flash_exercise_id": flashExerciseId,
        "flash_exercise_type": flashExerciseType,
        "user_id": userId,
        "course_id": courseId,
        "chapter_id": chapterId,
        "topic_id": topicId,
        "subcategory_id": subcategoryId,
        "obtain_marks": obtainMarks,
        "mark": mark,
        "tdate":
            "${tdate!.year.toString().padLeft(4, '0')}-${tdate!.month.toString().padLeft(2, '0')}-${tdate!.day.toString().padLeft(2, '0')}",
        "ttime": ttime,
        "flash_exercise_result_details": flashExerciseResultDetails == null
            ? []
            : List<dynamic>.from(
                flashExerciseResultDetails!.map((x) => x.toJson())),
      };
}

class FlashExerciseResultDetail {
  String? id;
  String? questionId;
  String? question;
  String? answer;
  String? marks;
  String? comment;

  FlashExerciseResultDetail({
    this.id,
    this.questionId,
    this.question,
    this.answer,
    this.marks,
    this.comment,
  });

  factory FlashExerciseResultDetail.fromJson(Map<String, dynamic> json) =>
      FlashExerciseResultDetail(
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
