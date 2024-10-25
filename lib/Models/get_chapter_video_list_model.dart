// To parse this JSON data, do
//
//     final getChapterVideoListModel = getChapterVideoListModelFromJson(jsonString);

import 'dart:convert';

GetChapterVideoListModel getChapterVideoListModelFromJson(String str) =>
    GetChapterVideoListModel.fromJson(json.decode(str));

String getChapterVideoListModelToJson(GetChapterVideoListModel data) =>
    json.encode(data.toJson());

class GetChapterVideoListModel {
  String? statusCode;
  String? status;
  String? message;
  List<ChapterwiseTopicVideoList>? chapterwiseTopicVideoList;

  GetChapterVideoListModel({
    this.statusCode,
    this.status,
    this.message,
    this.chapterwiseTopicVideoList,
  });

  factory GetChapterVideoListModel.fromJson(Map<String, dynamic> json) =>
      GetChapterVideoListModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        chapterwiseTopicVideoList: json["chapterwise_topic_video_list"] == null
            ? []
            : List<ChapterwiseTopicVideoList>.from(
                json["chapterwise_topic_video_list"]!
                    .map((x) => ChapterwiseTopicVideoList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "chapterwise_topic_video_list": chapterwiseTopicVideoList == null
            ? []
            : List<dynamic>.from(
                chapterwiseTopicVideoList!.map((x) => x.toJson())),
      };
}

class ChapterwiseTopicVideoList {
  String? id;
  String? chapterId;
  String? topicName;
  String? video;
  String? imagePdf;
  String? pptPdf;
  String? addedBy;

  ChapterwiseTopicVideoList({
    this.id,
    this.chapterId,
    this.topicName,
    this.video,
    this.imagePdf,
    this.pptPdf,
    this.addedBy,
  });

  factory ChapterwiseTopicVideoList.fromJson(Map<String, dynamic> json) =>
      ChapterwiseTopicVideoList(
        id: json["id"],
        chapterId: json["chapter_id"],
        topicName: json["topic_name"],
        video: json["video"],
        imagePdf: json["image_pdf"],
        pptPdf: json["ppt_pdf"],
        addedBy: json["added_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chapter_id": chapterId,
        "topic_name": topicName,
        "video": video,
        "image_pdf": imagePdf,
        "ppt_pdf": pptPdf,
        "added_by": addedBy,
      };
}
