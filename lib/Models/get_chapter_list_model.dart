import 'dart:convert';

GetChapterListModel getChapterListModelFromJson(String str) =>
    GetChapterListModel.fromJson(json.decode(str));

String getChapterListModelToJson(GetChapterListModel data) =>
    json.encode(data.toJson());

class GetChapterListModel {
  String? statusCode;
  String? status;
  String? message;
  List<CourseChapterList>? courseChapterList;

  GetChapterListModel({
    this.statusCode,
    this.status,
    this.message,
    this.courseChapterList,
  });

  factory GetChapterListModel.fromJson(Map<String, dynamic> json) =>
      GetChapterListModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        courseChapterList: List<CourseChapterList>.from(
            json["course_chapter_list"]
                .map((x) => CourseChapterList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "course_chapter_list":
            List<dynamic>.from(courseChapterList!.map((x) => x.toJson())),
      };
}

class CourseChapterList {
  String? chapterId;
  String? courseId;
  String? chapterName;
  String? description;
  String? chapterImage;
  String? duration;
  String? categoryId;
  String? subcategoryId;

  CourseChapterList({
    this.chapterId,
    this.courseId,
    this.chapterName,
    this.description,
    this.chapterImage,
    this.duration,
    this.categoryId,
    this.subcategoryId,
  });

  factory CourseChapterList.fromJson(Map<String, dynamic> json) =>
      CourseChapterList(
        chapterId: json["chapter_id"],
        courseId: json["course_id"],
        chapterName: json["chapter_name"],
        description: json["description"],
        chapterImage: json["chapter_image"],
        duration: json["duration"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
      );

  Map<String, dynamic> toJson() => {
        "chapter_id": chapterId,
        "course_id": courseId,
        "chapter_name": chapterName,
        "description": description,
        "chapter_image": chapterImage,
        "duration": duration,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
      };
}
