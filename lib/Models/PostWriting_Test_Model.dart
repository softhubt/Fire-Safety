import 'dart:convert';

// Function to parse JSON string into GetWriteTestModel
GetWriteTestModel getWriteTestModelFromJson(String str) =>
    GetWriteTestModel.fromJson(json.decode(str));

// Function to convert GetWriteTestModel into JSON string
String getWriteTestModelToJson(GetWriteTestModel data) =>
    json.encode(data.toJson());

class GetWriteTestModel {
  String? statusCode;
  String? status;
  String? message;
  List<ProficiencyTestDetail>? proficiencyTestDetailsList;

  GetWriteTestModel({
    this.statusCode,
    this.status,
    this.message,
    this.proficiencyTestDetailsList,
  });

  // Factory constructor to create GetWriteTestModel from JSON
  factory GetWriteTestModel.fromJson(Map<String, dynamic> json) =>
      GetWriteTestModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        proficiencyTestDetailsList: List<ProficiencyTestDetail>.from(
            json["proficiency_test_details_list"].map((x) => ProficiencyTestDetail.fromJson(x))),
      );

  // Method to convert GetWriteTestModel to JSON
  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "message": message,
    "proficiency_test_details_list": (proficiencyTestDetailsList != null)
        ? List<dynamic>.from(proficiencyTestDetailsList!.map((x) => x.toJson()))
        : null,
  };
}

class ProficiencyTestDetail {
  String? id;
  String? questionDetails;
  String? type;
  String? note;

  ProficiencyTestDetail({
    this.id,
    this.questionDetails,
    this.type,
    this.note,
  });

  // Factory constructor to create ProficiencyTestDetail from JSON
  factory ProficiencyTestDetail.fromJson(Map<String, dynamic> json) => ProficiencyTestDetail(
    id: json["id"],
    questionDetails: json["question_details"],
    type: json["type"],
    note: json["note"],
  );

  // Method to convert ProficiencyTestDetail to JSON
  Map<String, dynamic> toJson() => {
    "id": id,
    "question_details": questionDetails,
    "type": type,
    "note": note,
  };
}
