import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Services/local_storage_services.dart';
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

class StudentFormController extends GetxController {
  GetSubmitStudentFormModel getSubmitStudentFormModel =
      GetSubmitStudentFormModel();
  GetBranchList getBranchList = GetBranchList();

  TextEditingController nameController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController frmdatedobController = TextEditingController();
  TextEditingController countryBirthController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController altEmailController = TextEditingController();
  TextEditingController examvenueController = TextEditingController();
  TextEditingController institutionController = TextEditingController();
  TextEditingController disabilityRequirementsController =
      TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController degreeController = TextEditingController();

  var selectedCourses = <String>[].obs;

  RxList<bool> courseSelections = List.generate(5, (index) => false).obs;

  final formKey = GlobalKey<FormState>();

  io.File? selectedImage1;
  io.File? selectedImage2;
  io.File? selectedImage3;
  io.File? selectedImage4;

  RxString genderValue = 'Male'.obs;
  RxString maritalStatusValue = ''.obs;
  RxString SelectcountryListValue = ''.obs;
  RxString SelectStateListValue = ''.obs;
  RxString examVenueValue = ''.obs;
  RxString selectBranch = ''.obs;
  RxString selectModeOfEnrollment = ''.obs;
  RxString selectId = "1".obs;
  RxString userId = "".obs;
  RxString id = "".obs;
  RxString selectCode = "1".obs;
  RxList<OrderItem> educationEntries = <OrderItem>[].obs;

  RxBool isVerified = false.obs;

  Future initialFunctioun({required String widgetId}) async {
    id.value = widgetId;

    userId.value = await StorageServices.getData(
        dataType: StorageKeyConstant.stringType,
        prefKey: StorageKeyConstant.userId);

    await getBranchListform();
  }

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

  Future<void> pickFile({
    required int imageNo,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      if (imageNo == 1) {
        selectedImage1 = io.File(result.files.single.path!);
      } else if (imageNo == 2) {
        selectedImage2 = io.File(result.files.single.path!);
      } else if (imageNo == 3) {
        selectedImage3 = io.File(result.files.single.path!);
      } else if (imageNo == 4) {
        selectedImage4 = io.File(result.files.single.path!);
      }
    }
  }

  void toggleCourseSelection(String course) {
    if (selectedCourses.contains(course)) {
      selectedCourses.remove(course);
    } else {
      selectedCourses.add(course);
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
            selectedCourses.isNotEmpty ? selectedCourses[0] : null,
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
    } catch (error) {
      CustomLoader.closeCustomLoader();
      log("Error during form submission: $error");
    }
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:firesafety/Constant/storage_key_constant.dart';
// import 'package:firesafety/Services/local_storage_services.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firesafety/Constant/endpoint_constant.dart';
// import 'package:firesafety/Models/Post_SubmitStudentForm_Model.dart';
// import 'package:firesafety/Models/get_BranchList_model.dart';
// import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/StudentForm_Thanku_View.dart';
// import 'package:firesafety/Services/http_services.dart';
// import 'package:firesafety/Widgets/custom_loader.dart';
// import 'package:firesafety/Widgets/custom_toast.dart';

// class StudentFormController extends GetxController {
//   GetSubmitStudentFormModel getSubmitStudentFormModel =
//       GetSubmitStudentFormModel();
//   GetBranchList getBranchList = GetBranchList();

//   TextEditingController nameController = TextEditingController();
//   TextEditingController nationalityController = TextEditingController();
//   TextEditingController dobController = TextEditingController();
//   TextEditingController frmdatedobController = TextEditingController();
//   TextEditingController countryBirthController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController countryController = TextEditingController();
//   TextEditingController stateController = TextEditingController();
//   TextEditingController zipCodeController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController altEmailController = TextEditingController();
//   TextEditingController examvenueController = TextEditingController();
//   TextEditingController institutionController = TextEditingController();
//   TextEditingController disabilityRequirementsController =
//       TextEditingController();
//   TextEditingController fromDateController = TextEditingController();
//   TextEditingController toDateController = TextEditingController();
//   TextEditingController degreeController = TextEditingController();

//   var selectedCourses = <String>[].obs;

//   RxList<bool> courseSelections = List.generate(5, (index) => false).obs;

//   final formKey = GlobalKey<FormState>();

//   Rx<File?> selectedImage1 = Rx<File?>(null);
//   Rx<File?> selectedImage2 = Rx<File?>(null);
//   Rx<File?> selectedImage3 = Rx<File?>(null);
//   Rx<File?> selectedImage4 = Rx<File?>(null);

//   RxString genderValue = 'Male'.obs;
//   RxString maritalStatusValue = ''.obs;
//   RxString selectedCountryListValue = ''.obs;
//   RxString selectedStateListValue = ''.obs;
//   RxString examVenueValue = ''.obs;
//   RxString selectBranch = ''.obs;
//   RxString selectModeOfEnrollment = ''.obs;
//   RxString selectId = "1".obs;
//   RxString userId = "".obs;
//   RxString id = "".obs;
//   RxString selectCode = "1".obs;
//   RxList<OrderItem> educationEntries = <OrderItem>[].obs;

//   RxBool isVerified = false.obs;

//   Future initialFunctioun({required String widgetId}) async {
//     id.value = widgetId;

//     userId.value = await StorageServices.getData(
//             dataType: StorageKeyConstant.stringType,
//             prefKey: StorageKeyConstant.userId) ??
//         "";

//     await getBranchListform();
//   }

//   Future<void> pickImage(
//       {required int imageNo, required ImageSource imageSource}) async {
//     final pickedImage = await ImagePicker().pickImage(source: imageSource);

//     if (pickedImage?.path != null) {
//       if (imageNo == 1) {
//         selectedImage1.value = File(pickedImage!.path);
//       } else if (imageNo == 2) {
//         selectedImage2.value = File(pickedImage!.path);
//       } else if (imageNo == 3) {
//         selectedImage3.value = File(pickedImage!.path);
//       } else if (imageNo == 4) {
//         selectedImage4.value = File(pickedImage!.path);
//       }
//     } else {
//       log("No image selected");
//     }
//   }

//   void toggleCourseSelection(String course) {
//     if (selectedCourses.contains(course)) {
//       selectedCourses.remove(course);
//     } else {
//       selectedCourses.add(course);
//     }
//   }

//   void clearAllFields() {
//     nameController.clear();
//     nationalityController.clear();
//     dobController.clear();
//     countryBirthController.clear();
//     addressController.clear();
//     countryController.clear();
//     stateController.clear();
//     zipCodeController.clear();
//     phoneController.clear();
//     mobileController.clear();
//     emailController.clear();
//     altEmailController.clear();
//     genderValue.value = 'Male';
//     maritalStatusValue.value = '';
//     examVenueValue.value = '';
//     educationEntries.clear();
//   }

//   Future<void> getBranchListform() async {
//     CustomLoader.openCustomLoader();

//     try {
//       var response = await HttpServices.getHttpMethod(
//         url: EndPointConstant.branchlist,
//         urlMessage: 'Get Branch list url',
//         statusMessage: 'Get Branch list payload',
//         bodyMessage: 'Get Branch list response',
//       );

//       log("Get branch list response ::: $response");

//       getBranchList = getBranchListFromJson(response["body"]);

//       if (getBranchList.statusCode == "200" ||
//           getBranchList.statusCode == "201") {
//         CustomLoader.closeCustomLoader();
//       } else {
//         CustomLoader.closeCustomLoader();
//       }

//       // // Parse the response body
//       // var responseBody = json.decode(
//       //     response["body"]); // Ensure the response body is parsed correctly
//       // if (responseBody["status_code"] == "200" ||
//       //     responseBody["status_code"] == "201") {
//       //   // Successfully retrieved branch list
//       //   getBranchList.branchList = (responseBody["branch_list"] as List)
//       //       .map((item) => BranchListItem.fromJson(item))
//       //       .toList(); // Make sure your BranchListItem has a fromJson method
//       //   CustomLoader.closeCustomLoader();
//       //   update(); // Refresh UI
//       // } else {
//       //   CustomLoader.closeCustomLoader();
//       //   log("Failed to get branches: ${responseBody["message"]}");
//       // }
//     } catch (error, st) {
//       CustomLoader.closeCustomLoader();
//       log("Something went wrong during getting branch list ::: $error");
//       log("Error location during getting branch list ::: $st");
//     }
//   }

//   Future<void> submitForm({required String userId, required String id}) async {
//     CustomLoader.openCustomLoader();
//     try {
//       // Prepare the payload with form data
//       Map<String, dynamic> payload = {
//         "user_id": userId,
//         "customer_name": nameController.text,
//         "nationality": nationalityController.text,
//         "dob": dobController.text,
//         "gender": genderValue.value,
//         "country_birth_place": countryBirthController.text,
//         "marital_status": maritalStatusValue.value,
//         "address": addressController.text,
//         "country": selectedCountryListValue.value,
//         "state": selectedStateListValue.value,
//         "zipcode": zipCodeController.text,
//         "contact_detail": phoneController.text,
//         "contact_detail1": mobileController.text,
//         "email": emailController.text,
//         "alternative_email": altEmailController.text,
//         "exam_venue": examvenueController.text,
//         "branch": selectBranch.value,
//         "mode_of_enrollment": selectModeOfEnrollment.value,
//         "requirements": disabilityRequirementsController.text,
//         "testpayment_id": id,
//         "traning_course1":
//             selectedCourses.isNotEmpty ? selectedCourses[0] : null,
//         "traning_course2":
//             selectedCourses.length > 1 ? selectedCourses[1] : null,
//         "traning_course3":
//             selectedCourses.length > 2 ? selectedCourses[2] : null,
//         "traning_course4":
//             selectedCourses.length > 3 ? selectedCourses[3] : null,
//         "traning_course5":
//             selectedCourses.length > 4 ? selectedCourses[4] : null,
//         "order_item":
//             jsonEncode(educationEntries.map((item) => item.toJson()).toList()),
//       };

//       // Create multipart request
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(
//             'https://softebuild.com/fire_safety/api/booking_form_submit.php'),
//       );

//       // Attach form fields to the request
//       payload.forEach((key, value) {
//         if (value != null) {
//           request.fields[key] = value.toString();
//         }
//       });

//       // Attach images to the request
//       request.files.add(await http.MultipartFile.fromPath(
//           'photo', selectedImage1.value!.path));
//       request.files.add(await http.MultipartFile.fromPath(
//           'signature', selectedImage2.value!.path));
//       request.files.add(await http.MultipartFile.fromPath(
//           'document_img', selectedImage3.value!.path));

//       // Send the request
//       var response = await request.send();
//       var responseBody = await http.Response.fromStream(response);

//       log("Response body: ${responseBody.body}"); // Log response body

//       getSubmitStudentFormModel =
//           getSubmitStudentFormModelFromJson(responseBody.body);

//       if (getSubmitStudentFormModel.statusCode == "200" ||
//           getSubmitStudentFormModel.statusCode == "201") {
//         CustomLoader.closeCustomLoader();
//         customToast(message: "Booking Form Added Successfully!");
//         Get.to(() => StudentFormThankView(
//               userId: userId,
//               id: id,
//             ));
//         clearAllFields();

//         // Navigate to the thank you view
//         Get.to(() => StudentFormThankView(userId: userId, id: id));
//       } else {
//         // Get.to(() => StudentFormThankView(
//         //       userId: userId,
//         //       id: id,
//         //     ));
//         CustomLoader.closeCustomLoader();
//         customToast(
//             message:
//                 getSubmitStudentFormModel.message ?? "Something went wrong");
//       }
//     } catch (error) {
//       CustomLoader.closeCustomLoader();
//       log("Error during form submission: $error");
//     }
//   }
// }
