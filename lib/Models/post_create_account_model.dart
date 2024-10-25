import 'dart:convert';

PostCreateAccountModel postCreateAccountModelFromJson(String str) => PostCreateAccountModel.fromJson(json.decode(str));

String postCreateAccountModelToJson(PostCreateAccountModel data) => json.encode(data.toJson());

class PostCreateAccountModel {
  String? statusCode;
  String? status;
  String? message;
  Result? result;

  PostCreateAccountModel({
    this.statusCode,
    this.status,
    this.message,
    this.result,
  });

  factory PostCreateAccountModel.fromJson(Map<String, dynamic> json) => PostCreateAccountModel(
    statusCode: json["Status_code"],
    status: json["status"],
    message: json["message"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "Status_code": statusCode,
    "status": status,
    "message": message,
    "result": result?.toJson(),
  };
}

class Result {
  String? userId;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? bio;
  DateTime? date;

  Result({
    this.userId,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
    this.bio,
    this.date,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    userId: json["user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    mobileNumber: json["mobile_number"],
    email: json["email"],
    bio: json["bio"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "mobile_number": mobileNumber,
    "email": email,
    "bio": bio,
    "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
  };
}
