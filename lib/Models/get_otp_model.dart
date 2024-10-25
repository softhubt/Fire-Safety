import 'dart:convert';

GetOtpModel getOtpModelFromJson(String str) => GetOtpModel.fromJson(json.decode(str));

String getOtpModelToJson(GetOtpModel data) => json.encode(data.toJson());

class GetOtpModel {
  String? statusCode;
  String? status;
  String? message;

  GetOtpModel({
    this.statusCode,
    this.status,
    this.message,
  });

  factory GetOtpModel.fromJson(Map<String, dynamic> json) => GetOtpModel(
    statusCode: json["status_code"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "message": message,
  };
}

