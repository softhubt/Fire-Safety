import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/Post_SubmitStudentForm_Model.dart';
import 'package:firesafety/Models/get_BranchList_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/StudentForm_Thanku_View.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:firesafety/Widgets/custom_toast.dart';
import 'dart:io' as io;

class SubmitStudentFormController extends GetxController {
  // Form fields

  GetSubmitStudentFormModel getSubmitStudentFormModel =
      GetSubmitStudentFormModel();
  GetBranchList getBranchList = GetBranchList();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController frmdatedobController = TextEditingController();
  final TextEditingController countryBirthController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController altEmailController = TextEditingController();
  final TextEditingController examvenueController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController disabilityRequirementsController =
      TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final RxString genderValue = 'Male'.obs;
  final RxString maritalStatusValue = ''.obs;
  final RxString SelectcountryListValue = ''.obs;
  final RxString SelectStateListValue = ''.obs;
  final RxString examVenueValue = ''.obs;
  final RxString selectBranch = ''.obs;
  final RxString selectModeOfEnrollment = ''.obs;
  RxString selectId = "1".obs;
  RxString userId = "".obs;
  RxString id = "".obs;
  RxString selectCode = "1".obs;
  final RxList<OrderItem> educationEntries = <OrderItem>[].obs;

  var selectedCourses = <String>[].obs; // Observable list for selected courses

  io.File? selectedImage1;
  io.File? selectedImage2;
  io.File? selectedImage3;
  io.File? selectedImage4;

  Future<void> pickImage(
      {required int imageNo, required ImageSource imageSource}) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);

    if (pickedImage?.path != null) {
      if (imageNo == 1) {
        selectedImage1 = io.File(pickedImage!.path);
      } else if (imageNo == 2) {
        selectedImage2 = io.File(pickedImage!.path);
      } else if (imageNo == 3) {
        selectedImage3 = io.File(pickedImage!.path);
      } else if (imageNo == 4) {
        selectedImage4 = io.File(pickedImage!.path);
      }
    } else {
      log("No image selected");
    }
  }

  final formKey = GlobalKey<FormState>();

  void toggleCourseSelection(String course) {
    if (selectedCourses.contains(course)) {
      selectedCourses.remove(course);
    } else {
      selectedCourses.add(course);
    }
  }

  Future<void> getBranchListform() async {
    CustomLoader.openCustomLoader();

    try {
      var response = await HttpServices.getHttpMethod(
        url: EndPointConstant.branchlist,
        urlMessage: 'Get Branch list url',
        statusMessage: 'Get Branch list payload',
        bodyMessage: 'Get Branch list response',
      );

      log("Get branch list response ::: $response");

      // Parse the response body
      var responseBody = json.decode(
          response["body"]); // Ensure the response body is parsed correctly
      if (responseBody["status_code"] == "200" ||
          responseBody["status_code"] == "201") {
        // Successfully retrieved branch list
        getBranchList.branchList = (responseBody["branch_list"] as List)
            .map((item) => BranchListItem.fromJson(item))
            .toList(); // Make sure your BranchListItem has a fromJson method
        CustomLoader.closeCustomLoader();
        update(); // Refresh UI
      } else {
        CustomLoader.closeCustomLoader();
        log("Failed to get branches: ${responseBody["message"]}");
      }
    } catch (error, st) {
      CustomLoader.closeCustomLoader();
      log("Something went wrong during getting branch list ::: $error");
      log("Error location during getting branch list ::: $st");
    }
  }

  Future<void> submitForm({required String userId, required String id}) async {
    CustomLoader.openCustomLoader();

    if (selectedImage1 == null ||
        selectedImage2 == null ||
        selectedImage3 == null) {
      CustomLoader.closeCustomLoader();
      customToast(
          message: "Please select all required images before submitting.");
      return; // Exit the method
    }
    try {
      // Prepare the payload with form data
      Map<String, dynamic> payload = {
        "user_id": userId,
        "customer_name": nameController.text,
        "nationality": nationalityController.text,
        "dob": dobController.text,
        "gender": genderValue.value,
        "country_birth_place": countryBirthController.text,
        "marital_status": maritalStatusValue.value,
        "address": addressController.text,
        "country": SelectcountryListValue.value,
        "state": SelectStateListValue.value,
        "zipcode": zipCodeController.text,
        "contact_detail": phoneController.text,
        "contact_detail1": mobileController.text,
        "email": emailController.text,
        "alternative_email": altEmailController.text,
        "exam_venue": examvenueController.text,
        "branch": selectBranch.value,
        "mode_of_enrollment": selectModeOfEnrollment.value,
        "requirements": disabilityRequirementsController.text,
        "testpayment_id": id,
        "traning_course1":
            selectedCourses.length > 0 ? selectedCourses[0] : null,
        "traning_course2":
            selectedCourses.length > 1 ? selectedCourses[1] : null,
        "traning_course3":
            selectedCourses.length > 2 ? selectedCourses[2] : null,
        "traning_course4":
            selectedCourses.length > 3 ? selectedCourses[3] : null,
        "traning_course5":
            selectedCourses.length > 4 ? selectedCourses[4] : null,
        "order_item":
            jsonEncode(educationEntries.map((item) => item.toJson()).toList()),
      };

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://softebuild.com/fire_safety/api/booking_form_submit.php'),
      );

      // Attach form fields to the request
      payload.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Attach images to the request
      if (selectedImage1 != null) {
        request.files.add(
            await http.MultipartFile.fromPath('photo', selectedImage1!.path));
      }
      if (selectedImage2 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'signature', selectedImage2!.path));
      }
      if (selectedImage3 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'document_img', selectedImage3!.path));
      }

      // Send the request
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      log("Response body: ${responseBody.body}"); // Log response body

      getSubmitStudentFormModel =
          getSubmitStudentFormModelFromJson(responseBody.body);

      if (getSubmitStudentFormModel.statusCode == "200" ||
          getSubmitStudentFormModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();
        customToast(message: "Booking Form Added Successfully!");
        Get.to(() => StudentFormThankView(
              userId: userId,
              id: id,
            ));
        clearAllFields();

        // Navigate to the thank you view
        Get.to(() => StudentFormThankView(userId: userId, id: id));
      } else {
        // Get.to(() => StudentFormThankView(
        //       userId: userId,
        //       id: id,
        //     ));
        CustomLoader.closeCustomLoader();
        customToast(
            message:
                getSubmitStudentFormModel.message ?? "Something went wrong");
      }
    } catch (error, st) {
      CustomLoader.closeCustomLoader();
      log("Error during form submission: $error");
    }
  }

  void clearAllFields() {
    nameController.clear();
    nationalityController.clear();
    dobController.clear();
    countryBirthController.clear();
    addressController.clear();
    countryController.clear();
    stateController.clear();
    zipCodeController.clear();
    phoneController.clear();
    mobileController.clear();
    emailController.clear();
    altEmailController.clear();
    genderValue.value = 'Male';
    maritalStatusValue.value = '';
    examVenueValue.value = '';
    educationEntries.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    nationalityController.dispose();
    dobController.dispose();
    countryBirthController.dispose();
    addressController.dispose();
    countryController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    phoneController.dispose();
    mobileController.dispose();
    emailController.dispose();
    altEmailController.dispose();
    examvenueController.dispose();
    super.onClose();
  }
}
