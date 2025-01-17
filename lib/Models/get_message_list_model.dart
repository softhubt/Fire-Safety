import 'dart:convert';

GetMessageListModel getMessageListModelFromJson(String str) =>
    GetMessageListModel.fromJson(json.decode(str));

String getMessageListModelToJson(GetMessageListModel data) =>
    json.encode(data.toJson());

class GetMessageListModel {
  String? statusCode;
  String? status;
  String? message;
  List<MessageList>? messageList;

  GetMessageListModel({
    this.statusCode,
    this.status,
    this.message,
    this.messageList,
  });

  factory GetMessageListModel.fromJson(Map<String, dynamic> json) =>
      GetMessageListModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        messageList: json["message_list"] != null
            ? List<MessageList>.from(
                json["message_list"].map((x) => MessageList.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "message_list": messageList != null
            ? List<dynamic>.from(messageList!.map((x) => x.toJson()))
            : [],
      };
}

class MessageList {
  String? id;
  String? userId;
  String? firstName;
  String? lastName;
  String? message;
  DateTime? date;
  String? time;
  List<ReplyList>? replyList;

  MessageList({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.message,
    this.date,
    this.time,
    this.replyList,
  });

  factory MessageList.fromJson(Map<String, dynamic> json) => MessageList(
        id: json["id"],
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        message: json["message"],
        date: json["date"] != null ? DateTime.tryParse(json["date"]) : null,
        time: json["time"],
        replyList: json["reply_list"] != null
            ? List<ReplyList>.from(
                json["reply_list"].map((x) => ReplyList.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "message": message,
        "date": date?.toIso8601String(),
        "time": time,
        "reply_list": replyList != null
            ? List<dynamic>.from(replyList!.map((x) => x.toJson()))
            : [],
      };
}

class ReplyList {
  String? id;
  String? messageId;
  String? teacherId;
  String? name;
  String? reply;
  DateTime? date;
  String? time;

  ReplyList({
    this.id,
    this.messageId,
    this.teacherId,
    this.name,
    this.reply,
    this.date,
    this.time,
  });

  factory ReplyList.fromJson(Map<String, dynamic> json) => ReplyList(
        id: json["id"],
        messageId: json["message_id"],
        teacherId: json["teacher_id"],
        name: json["name"],
        reply: json["reply"],
        date: json["date"] != null ? DateTime.tryParse(json["date"]) : null,
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message_id": messageId,
        "teacher_id": teacherId,
        "name": name,
        "reply": reply,
        "date": date?.toIso8601String(),
        "time": time,
      };
}
