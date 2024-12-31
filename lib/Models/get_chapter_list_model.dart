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
        courseChapterList: json["course_chapter_list"] == null
            ? []
            : List<CourseChapterList>.from(json["course_chapter_list"]!
                .map((x) => CourseChapterList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "course_chapter_list": courseChapterList == null
            ? []
            : List<dynamic>.from(courseChapterList!.map((x) => x.toJson())),
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
  List<MockExaminationDetail>? mockExaminationDetails;

  CourseChapterList({
    this.chapterId,
    this.courseId,
    this.chapterName,
    this.description,
    this.chapterImage,
    this.duration,
    this.categoryId,
    this.subcategoryId,
    this.mockExaminationDetails,
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
        mockExaminationDetails: json["mock_examination_details"] == null
            ? []
            : List<MockExaminationDetail>.from(json["mock_examination_details"]!
                .map((x) => MockExaminationDetail.fromJson(x))),
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
        "mock_examination_details": mockExaminationDetails == null
            ? []
            : List<dynamic>.from(
                mockExaminationDetails!.map((x) => x.toJson())),
      };
}

class MockExaminationDetail {
  String? mockId;
  String? mockName;
  String? examTime;
  String? marks;
  String? chapterId;
  String? courseId;
  String? subcategoryid;
  String? categoryid;
  String? questionPdf;
  String? samplePdf;

  MockExaminationDetail({
    this.mockId,
    this.mockName,
    this.examTime,
    this.marks,
    this.chapterId,
    this.courseId,
    this.subcategoryid,
    this.categoryid,
    this.questionPdf,
    this.samplePdf,
  });

  factory MockExaminationDetail.fromJson(Map<String, dynamic> json) =>
      MockExaminationDetail(
        mockId: json["mock_id"],
        mockName: json["mock_name"],
        examTime: json["exam_time"],
        marks: json["marks"],
        chapterId: json["chapter_id"],
        courseId: json["course_id"],
        subcategoryid: json["subcategoryid"],
        categoryid: json["categoryid"],
        questionPdf: json["question_pdf"],
        samplePdf: json["sample_pdf"],
      );

  Map<String, dynamic> toJson() => {
        "mock_id": mockId,
        "mock_name": mockName,
        "exam_time": examTime,
        "marks": marks,
        "chapter_id": chapterId,
        "course_id": courseId,
        "subcategoryid": subcategoryid,
        "categoryid": categoryid,
        "question_pdf": questionPdf,
        "sample_pdf": samplePdf,
      };
}
