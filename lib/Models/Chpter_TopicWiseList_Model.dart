import 'dart:convert';

ChapterWiseTopicListModel chapterWiseTopicListModelFromJson(String str) =>
    ChapterWiseTopicListModel.fromJson(json.decode(str));

String chapterWiseTopicListModelToJson(ChapterWiseTopicListModel data) =>
    json.encode(data.toJson());

class ChapterWiseTopicListModel {
  String? statusCode;
  String? status;
  String? message;
  List<TopicList>? quizChapterwiseTopicList;

  ChapterWiseTopicListModel({
    this.statusCode,
    this.status,
    this.message,
    this.quizChapterwiseTopicList,
  });

  factory ChapterWiseTopicListModel.fromJson(Map<String, dynamic> json) =>
      ChapterWiseTopicListModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        quizChapterwiseTopicList: List<TopicList>.from(
            json["quiz_chapterwise_topic_list"].map((x) => TopicList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "message": message,
    "quiz_chapterwise_topic_list":
    List<dynamic>.from(quizChapterwiseTopicList!.map((x) => x.toJson())),
  };
}

class TopicList {
  String? topicId;
  String? topicName;
  String? chapterId;

  TopicList({
    this.topicId,
    this.topicName,
    this.chapterId,
  });

  factory TopicList.fromJson(Map<String, dynamic> json) => TopicList(
    topicId: json["topic_id"],
    topicName: json["topic_name"],
    chapterId: json["chapter_id"],
  );

  Map<String, dynamic> toJson() => {
    "topic_id": topicId,
    "topic_name": topicName,
    "chapter_id": chapterId,
  };
}
