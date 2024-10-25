import 'dart:convert';

GetSubmitStudentFormModel getSubmitStudentFormModelFromJson(String str) =>
    GetSubmitStudentFormModel.fromJson(json.decode(str));

String getSubmitStudentFormModelToJson(GetSubmitStudentFormModel data) =>
    json.encode(data.toJson());

class GetSubmitStudentFormModel {
  String? statusCode;
  String? status;
  String? message;
  BookingFormDetails? bookingFormDetails;

  GetSubmitStudentFormModel({
    this.statusCode,
    this.status,
    this.message,
    this.bookingFormDetails,
  });

  factory GetSubmitStudentFormModel.fromJson(Map<String, dynamic> json) => GetSubmitStudentFormModel(
    statusCode: json["status_code"],
    status: json["status"],
    message: json["message"],
    bookingFormDetails: BookingFormDetails.fromJson(json["Booking_form_Details"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "message": message,
    "Booking_form_Details": bookingFormDetails!.toJson(),
  };
}

class BookingFormDetails {
  String? id;
  String? customerName;
  String? customerCode;
  String? orderNumber;
  String? orderDt;
  List<OrderItem>? orderItem;
  String? nationality;
  String? dob;
  String? gender;
  String? maritalStatus;
  String? countryBirthPlace;
  String? address;
  String? country;
  String? state;
  String? zipcode;
  String? email;
  String? alternativeEmail;
  String? username;
  String? traningCourse1;
  String? traningCourse2;
  String? traningCourse3;
  String? traningCourse4;
  String? traningCourse5;
  String? branch;
  String? examVenue;
  String? modeOfEnrollment;
  String? photo;
  String? signature;
  String? documentImg;

  BookingFormDetails({
    this.id,
    this.customerName,
    this.customerCode,
    this.orderNumber,
    this.orderDt,
    this.orderItem,
    this.nationality,
    this.dob,
    this.gender,
    this.maritalStatus,
    this.countryBirthPlace,
    this.address,
    this.country,
    this.state,
    this.zipcode,
    this.email,
    this.alternativeEmail,
    this.username,
    this.traningCourse1,
    this.traningCourse2,
    this.traningCourse3,
    this.traningCourse4,
    this.traningCourse5,
    this.branch,
    this.examVenue,
    this.modeOfEnrollment,
    this.photo,
    this.signature,
    this.documentImg,
  });

  factory BookingFormDetails.fromJson(Map<String, dynamic> json) => BookingFormDetails(
    id: json["id"],
    customerName: json["customer_name"],
    customerCode: json["customer_code"],
    orderNumber: json["order_number"],
    orderDt: json["order_dt"],
    orderItem: json["order_item"] != null
        ? List<OrderItem>.from(jsonDecode(json["order_item"]).map((x) => OrderItem.fromJson(x)))
        : [],
    nationality: json["nationality"],
    dob: json["dob"],
    gender: json["gender"],
    maritalStatus: json["marital_status"],
    countryBirthPlace: json["country_birth_place"],
    address: json["address"],
    country: json["country"],
    state: json["state"],
    zipcode: json["zipcode"],
    email: json["email"],
    alternativeEmail: json["alternative_email"],
    username: json["username"],
    traningCourse1: json["traning_course1"],
    traningCourse2: json["traning_course2"],
    traningCourse3: json["traning_course3"],
    traningCourse4: json["traning_course4"],
    traningCourse5: json["traning_course5"],
    branch: json["branch"],
    examVenue: json["exam_venue"],
    modeOfEnrollment: json["mode_of_enrollment"],
    photo: json["photo"],
    signature: json["signature"],
    documentImg: json["document_img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_name": customerName,
    "customer_code": customerCode,
    "order_number": orderNumber,
    "order_dt": orderDt,
    "order_item": List<dynamic>.from(orderItem!.map((x) => x.toJson())),
    "nationality": nationality,
    "dob": dob,
    "gender": gender,
    "marital_status": maritalStatus,
    "country_birth_place": countryBirthPlace,
    "address": address,
    "country": country,
    "state": state,
    "zipcode": zipcode,
    "email": email,
    "alternative_email": alternativeEmail,
    "username": username,
    "traning_course1": traningCourse1,
    "traning_course2": traningCourse2,
    "traning_course3": traningCourse3,
    "traning_course4": traningCourse4,
    "traning_course5": traningCourse5,
    "branch": branch,
    "exam_venue": examVenue,
    "mode_of_enrollment": modeOfEnrollment,
    "photo": photo,
    "signature": signature,
    "document_img": documentImg,
  };
}

class OrderItem {
  String? cartId;
  String? id;
  final String instituteName;
  final String fromDate;
  final String toDate;
  final String degree;

  OrderItem({
    this.cartId,
    this.id,
    required this.instituteName,
    required this.fromDate,
    required this.toDate,
    required this.degree
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    cartId: json["cartId"],
    id: json["id"],
    instituteName: json["institute_name"],
    fromDate: json["fromdate"],
    toDate: json["todate"],
    degree: json["degree"],
  );

  Map<String, dynamic> toJson() => {
    "cartId": cartId,
    "id": id,
    "institute_name": instituteName,
    "fromdate": fromDate,
    "todate": toDate,
    "degree": degree,
  };
}
