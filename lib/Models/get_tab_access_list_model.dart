import 'dart:convert';

GetTabAccessListModel getTabAccessListModelFromJson(String str) =>
    GetTabAccessListModel.fromJson(json.decode(str));

String getTabAccessListModelToJson(GetTabAccessListModel data) =>
    json.encode(data.toJson());

class GetTabAccessListModel {
  String? statusCode;
  String? status;
  String? message;
  List<ElementwiseTabaccessList>? elementwiseTabaccessList;

  GetTabAccessListModel({
    this.statusCode,
    this.status,
    this.message,
    this.elementwiseTabaccessList,
  });

  factory GetTabAccessListModel.fromJson(Map<String, dynamic> json) =>
      GetTabAccessListModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        elementwiseTabaccessList: json["elementwise_tabaccess_list"] == null
            ? []
            : List<ElementwiseTabaccessList>.from(
                json["elementwise_tabaccess_list"]!
                    .map((x) => ElementwiseTabaccessList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "elementwise_tabaccess_list": elementwiseTabaccessList == null
            ? []
            : List<dynamic>.from(
                elementwiseTabaccessList!.map((x) => x.toJson())),
      };
}

class ElementwiseTabaccessList {
  String? id;
  String? chapterId;
  String? videoAccess;
  String? studymaterialAccess;
  String? quizAccess;
  String? flashExerciseAccess;
  String? formativeAccess;
  String? categoryId;
  String? subcategoryId;
  String? courseId;

  ElementwiseTabaccessList({
    this.id,
    this.chapterId,
    this.videoAccess,
    this.studymaterialAccess,
    this.quizAccess,
    this.flashExerciseAccess,
    this.formativeAccess,
    this.categoryId,
    this.subcategoryId,
    this.courseId,
  });

  factory ElementwiseTabaccessList.fromJson(Map<String, dynamic> json) =>
      ElementwiseTabaccessList(
        id: json["id"],
        chapterId: json["chapter_id"],
        videoAccess: json["video_access"],
        studymaterialAccess: json["studymaterial_access"],
        quizAccess: json["quiz_access"],
        flashExerciseAccess: json["flash_exercise_access"],
        formativeAccess: json["formative_access"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        courseId: json["course_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chapter_id": chapterId,
        "video_access": videoAccess,
        "studymaterial_access": studymaterialAccess,
        "quiz_access": quizAccess,
        "flash_exercise_access": flashExerciseAccess,
        "formative_access": formativeAccess,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "course_id": courseId,
      };
}
