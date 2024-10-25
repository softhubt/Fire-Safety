import 'dart:convert';

GetCourseListModel getCourseListModelFromJson(String str) =>
    GetCourseListModel.fromJson(json.decode(str));

String getCourseListModelToJson(GetCourseListModel data) =>
    json.encode(data.toJson());

class GetCourseListModel {
  String? statusCode;
  String? status;
  String? message;
  List<CourseList>? courseList;

  GetCourseListModel({
    this.statusCode,
    this.status,
    this.message,
    this.courseList,
  });

  factory GetCourseListModel.fromJson(Map<String, dynamic> json) =>
      GetCourseListModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        courseList: List<CourseList>.from(
            json["course_list"].map((x) => CourseList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "course_list": List<dynamic>.from(courseList!.map((x) => x.toJson())),
      };
}

class CourseList {
  String? courseId;
  String? courseName;
  String? description;
  String? courseImage;
  String? file2;
  String? courseFee;
  String? freeLiveClasses;
  DateTime? startDate;
  DateTime? endDate;
  String? duration;
  String? status;
  String? categoryId;
  String? subcategoryId;

  CourseList({
    this.courseId,
    this.courseName,
    this.description,
    this.courseImage,
    this.file2,
    this.courseFee,
    this.freeLiveClasses,
    this.startDate,
    this.endDate,
    this.duration,
    this.status,
    this.categoryId,
    this.subcategoryId,
  });

  factory CourseList.fromJson(Map<String, dynamic> json) => CourseList(
        courseId: json["course_id"],
        courseName: json["course_name"],
        description: json["description"],
        courseImage: json["course_image"],
        file2: json["file2"],
        courseFee: json["course_fee"],
        freeLiveClasses: json["free_live_classes"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        duration: json["duration"],
        status: json["status"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
      );

  Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "course_name": courseName,
        "description": description,
        "course_image": courseImage,
        "file2": file2,
        "course_fee": courseFee,
        "free_live_classes": freeLiveClasses,
        "start_date":
            "${startDate?.year.toString().padLeft(4, '0')}-${startDate?.month.toString().padLeft(2, '0')}-${startDate?.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate?.year.toString().padLeft(4, '0')}-${endDate?.month.toString().padLeft(2, '0')}-${endDate?.day.toString().padLeft(2, '0')}",
        "duration": duration,
        "status": status,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
      };
}
