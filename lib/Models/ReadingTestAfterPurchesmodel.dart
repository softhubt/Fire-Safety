import 'dart:convert';

// Function to parse JSON into the model
ReadListenTestTypeWiseModel readListenTestTypeWiseModelFromJson(String str) =>
    ReadListenTestTypeWiseModel.fromJson(json.decode(str));

// Function to convert the model back to JSON
String readListenTestTypeWiseModelToJson(ReadListenTestTypeWiseModel data) =>
    json.encode(data.toJson());

// Main model class
class ReadListenTestTypeWiseModel {
  String? statusCode;
  String? message;
  List<ReadingListeningTestDetailsList>? readingListeningTestDetailsList;

  ReadListenTestTypeWiseModel({
    this.statusCode,
    this.message,
    this.readingListeningTestDetailsList,
  });

  factory ReadListenTestTypeWiseModel.fromJson(Map<String, dynamic> json) =>
      ReadListenTestTypeWiseModel(
        statusCode: json["status_code"],
        message: json["message"],
        readingListeningTestDetailsList: json["reading_listening_test_details_list"] == null
            ? null
            : List<ReadingListeningTestDetailsList>.from(
            json["reading_listening_test_details_list"].map((x) => ReadingListeningTestDetailsList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "reading_listening_test_details_list": readingListeningTestDetailsList == null
        ? null
        : List<dynamic>.from(readingListeningTestDetailsList!.map((x) => x.toJson())),
  };
}

// Class for reading listening test details
class ReadingListeningTestDetailsList {
  String? id;
  String? readListeningTestId;
  String? readListeningTestType;
  String? readListeningTestDate;
  String? paragraph;
  String? audio;
  String? mark;
  String? readListeningTestTime;
  String? rightMark;
  List<TestQuestionDetail>? testQuestionDetails;

  ReadingListeningTestDetailsList({
    this.id,
    this.readListeningTestId,
    this.readListeningTestType,
    this.readListeningTestDate,
    this.paragraph,
    this.audio,
    this.mark,
    this.readListeningTestTime,
    this.rightMark,
    this.testQuestionDetails,
  });

  factory ReadingListeningTestDetailsList.fromJson(Map<String, dynamic> json) =>
      ReadingListeningTestDetailsList(
        id: json["id"],
        readListeningTestId: json["read_listening_test_id"],
        readListeningTestType: json["read_listening_test_type"],
        readListeningTestDate: json["read_listening_test_date"],
        paragraph: json["paragraph"],
        audio: json["audio"],
        mark: json["mark"],
        readListeningTestTime: json["read_listening_test_time"],
        rightMark: json["right_mark"],
        testQuestionDetails: json["test_question_details"] == null
            ? null
            : List<TestQuestionDetail>.from(
            json["test_question_details"].map((x) => TestQuestionDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "read_listening_test_id": readListeningTestId,
    "read_listening_test_type": readListeningTestType,
    "read_listening_test_date": readListeningTestDate,
    "paragraph": paragraph,
    "audio": audio,
    "mark": mark,
    "read_listening_test_time": readListeningTestTime,
    "right_mark": rightMark,
    "test_question_details": testQuestionDetails == null
        ? null
        : List<dynamic>.from(testQuestionDetails!.map((x) => x.toJson())),
  };
}

// Class for test question details
class TestQuestionDetail {
  String? id;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? answer;

  TestQuestionDetail({
    this.id,
    this.question,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.answer,
  });

  factory TestQuestionDetail.fromJson(Map<String, dynamic> json) =>
      TestQuestionDetail(
        id: json["id"],
        question: json["question"],
        option1: json["option1"],
        option2: json["option2"],
        option3: json["option3"],
        option4: json["option4"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "option1": option1,
    "option2": option2,
    "option3": option3,
    "option4": option4,
    "answer": answer,
  };
}
