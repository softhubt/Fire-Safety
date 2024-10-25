import 'dart:convert';

// Function to convert JSON string to SubmitFlashExerciseModel
SubmitFlashExerciseModel submitFlashExerciseModelFromJson(String str) =>
    SubmitFlashExerciseModel.fromJson(json.decode(str));

// Function to convert SubmitFlashExerciseModel to JSON string
String submitFlashExerciseModelToJson(SubmitFlashExerciseModel data) =>
    json.encode(data.toJson());

// Main model class
class SubmitFlashExerciseModel {
  String? statusCode;
  String? status;
  String? message;
  int? feDataSubmit;
  SubmitFlashExerciseResult? result;

  SubmitFlashExerciseModel({
    this.statusCode,
    this.status,
    this.message,
    this.feDataSubmit,
    this.result,
  });

  factory SubmitFlashExerciseModel.fromJson(Map<String, dynamic> json) =>
      SubmitFlashExerciseModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        feDataSubmit: json["fe_data_submit"],
        result: json["result"] == null
            ? null
            : SubmitFlashExerciseResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "message": message,
    "fe_data_submit": feDataSubmit,
    "result": result?.toJson(),
  };
}

// Class for result details
class SubmitFlashExerciseResult {
  String? id;
  String? courseId;
  String? chapterId;
  String? userId;
  String? flashExerciseId;
  String? flashExerciseType;
  String? tdate;
  String? ttime;
  List<SubmitOrderItemnew>? orderItem;

  SubmitFlashExerciseResult({
    this.id,
    this.courseId,
    this.chapterId,
    this.userId,
    this.flashExerciseId,
    this.flashExerciseType,
    this.tdate,
    this.ttime,
    this.orderItem,
  });

  factory SubmitFlashExerciseResult.fromJson(Map<String, dynamic> json) =>
      SubmitFlashExerciseResult(
        id: json["id"],
        courseId: json["course_id"],
        chapterId: json["chapter_id"],
        userId: json["user_id"],
        flashExerciseId: json["flash_exercise_id"],
        flashExerciseType: json["flash_exercise_type"],
        tdate: json["tdate"],
        ttime: json["ttime"],
        orderItem: json["order_item"] == null
            ? null
            : List<SubmitOrderItemnew>.from(
            jsonDecode(json["order_item"]).map((x) => SubmitOrderItemnew.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_id": courseId,
    "chapter_id": chapterId,
    "user_id": userId,
    "flash_exercise_id": flashExerciseId,
    "flash_exercise_type": flashExerciseType,
    "tdate": tdate,
    "ttime": ttime,
    "order_item": orderItem == null
        ? null
        : jsonEncode(orderItem!.map((x) => x.toJson()).toList()),
  };
}

// Class for order item details
class SubmitOrderItemnew {
  int? cartId;
  String? id;
  String? questionId;
  String? answer;

  SubmitOrderItemnew({
    this.cartId,
    this.id,
    this.questionId,
    this.answer,
  });

  factory SubmitOrderItemnew.fromJson(Map<String, dynamic> json) =>
      SubmitOrderItemnew(
        cartId: json["cartId"],
        id: json["id"],
        questionId: json["question_id"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
    "cartId": cartId,
    "id": id,
    "question_id": questionId,
    "answer": answer,
  };
}
