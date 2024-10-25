import 'dart:convert';


GetFlashExerciseModel getFlashExerciseModelFromJson(String str) =>
    GetFlashExerciseModel.fromJson(json.decode(str));

String getFlashExerciseModelToJson(GetFlashExerciseModel data) =>
    json.encode(data.toJson());

// Main model class
class GetFlashExerciseModel {
  String? statusCode;
  String? message;
  List<FlashExerciseDetailsList>? flashExerciseDetailsList;

  GetFlashExerciseModel({
    this.statusCode,
    this.message,
    this.flashExerciseDetailsList,
  });

  factory GetFlashExerciseModel.fromJson(Map<String, dynamic> json) =>
      GetFlashExerciseModel(
        statusCode: json["status_code"],
        message: json["message"],
        flashExerciseDetailsList: json["flash_exercise_details_list"] == null
            ? null
            : List<FlashExerciseDetailsList>.from(
            json["flash_exercise_details_list"].map((x) => FlashExerciseDetailsList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "flash_exercise_details_list": flashExerciseDetailsList == null
        ? null
        : List<dynamic>.from(flashExerciseDetailsList!.map((x) => x.toJson())),
  };
}

// Class for flash exercise details
class FlashExerciseDetailsList {
  String? id;
  String? flashExerciseId;
  String? flashExerciseType;
  String? flashExerciseDate;
  String? courseName;
  String? chapterId;
  dynamic? flashExerciseName;
  String? mark;
  String? flashExerciseTime;
  String? rightMark;
  dynamic? tresultcount;
  List<FlashExerciseQuestionDetail>? flashExerciseQuestionDetails;

  FlashExerciseDetailsList({
    this.id,
    this.flashExerciseId,
    this.flashExerciseType,
    this.flashExerciseDate,
    this.courseName,
    this.chapterId,
    this.flashExerciseName,
    this.mark,
    this.flashExerciseTime,
    this.rightMark,
    this.tresultcount,
    this.flashExerciseQuestionDetails,
  });

  factory FlashExerciseDetailsList.fromJson(Map<String, dynamic> json) =>
      FlashExerciseDetailsList(
        id: json["id"],
        flashExerciseId: json["flash_exercise_id"],
        flashExerciseType: json["flash_exercise_type"],
        flashExerciseDate: json["flash_exercise_date"],
        courseName: json["course_name"],
        chapterId: json["chapter_id"],
        flashExerciseName: json["flash_exercise_name"],
        mark: json["mark"],
        flashExerciseTime: json["flash_exercise_time"],
        rightMark: json["right_mark"],
        tresultcount: json["tresultcount"],
        flashExerciseQuestionDetails: json["flash_exercise_question_details"] == null
            ? null
            : List<FlashExerciseQuestionDetail>.from(
            json["flash_exercise_question_details"].map((x) => FlashExerciseQuestionDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "flash_exercise_id": flashExerciseId,
    "flash_exercise_type": flashExerciseType,
    "flash_exercise_date": flashExerciseDate,
    "course_name": courseName,
    "chapter_id": chapterId,
    "flash_exercise_name": flashExerciseName,
    "mark": mark,
    "flash_exercise_time": flashExerciseTime,
    "right_mark": rightMark,
    "tresultcount": tresultcount,
    "flash_exercise_question_details": flashExerciseQuestionDetails == null
        ? null
        : List<dynamic>.from(flashExerciseQuestionDetails!.map((x) => x.toJson())),
  };
}

// Class for flash exercise question details
class FlashExerciseQuestionDetail {
  String? id;
  String? question;

  FlashExerciseQuestionDetail({
    this.id,
    this.question,
  });

  factory FlashExerciseQuestionDetail.fromJson(Map<String, dynamic> json) =>
      FlashExerciseQuestionDetail(
        id: json["id"],
        question: json["question"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
  };
}
