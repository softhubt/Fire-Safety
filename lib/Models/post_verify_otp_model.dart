import 'dart:convert';

PostVerifyOtpModel postVerifyOtpModelFromJson(String str) =>
    PostVerifyOtpModel.fromJson(json.decode(str));

String postVerifyOtpModelToJson(PostVerifyOtpModel data) =>
    json.encode(data.toJson());

class PostVerifyOtpModel {
  String? statusCode;
  String? status;
  String? message;
  RegisterDetails? registerDetails;

  PostVerifyOtpModel({
    this.statusCode,
    this.status,
    this.message,
    this.registerDetails,
  });

  factory PostVerifyOtpModel.fromJson(Map<String, dynamic> json) =>
      PostVerifyOtpModel(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        registerDetails: RegisterDetails.fromJson(json["register_details"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "register_details": registerDetails?.toJson(),
      };
}

class RegisterDetails {
  String? otp;
  String? userId;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? bio;
  String? categoryName;
  String? categoryId;
  String? subcategoryId;
  String? classId;
  String? profileImage;

  RegisterDetails({
    this.otp,
    this.userId,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
    this.bio,
    this.categoryName,
    this.categoryId,
    this.subcategoryId,
    this.classId,
    this.profileImage,
  });

  factory RegisterDetails.fromJson(Map<String, dynamic> json) =>
      RegisterDetails(
        otp: json["otp"],
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        mobileNumber: json["mobile_number"],
        email: json["email"],
        bio: json["bio"],
        categoryName: json["category_name"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        classId: json["class_id"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "otp": otp,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "mobile_number": mobileNumber,
        "email": email,
        "bio": bio,
        "category_name": categoryName,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "class_id": classId,
        "profile_image": profileImage,
      };
}
