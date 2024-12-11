import 'dart:convert';
import 'dart:developer';
import 'package:firesafety/Models/post_Get_Subcategory_PaymentModel.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/Payment_thank_you_view.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_course_list_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CourseListController extends GetxController {
  GetCourseListModel getCourseListModel = GetCourseListModel();
  GetSubcategoryPaymentModel getSubcategoryPaymentModel = GetSubcategoryPaymentModel();


  RxString Id = ''.obs;
  String _formatDate(String? date) {
    if (date == null) return '';
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return ''; // Return an empty string in case of an error
    }
  }
  String _getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  // Function to get course list
  Future getCourseList({required String categoryId, required String subcategoryId,}) async {
    try {
      Map<String, dynamic> payload = {
        "category_id": categoryId,
        "subcategory_id": subcategoryId
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.courseList,
          payload: payload,
          urlMessage: "Get course list url",
          payloadMessage: "Get course list payload",
          statusMessage: "Get course list status code",
          bodyMessage: "Get course list response"
      );

      getCourseListModel = getCourseListModelFromJson(response["body"]);

      if (getCourseListModel.statusCode == "200" || getCourseListModel.statusCode == "201") {
        // You can also set some state here if needed.
      } else {
        log("Something went wrong during getting course list ::: ${getCourseListModel.statusCode}");
      }
    } catch (error) {
      log("Something went wrong during getting course list ::: $error");
    }
  }

  // Function for handling purchase
  Future getPurchesCpource({
    required String categoryId,
    required String subcategoryId,
    required String userId,
    required String amount,
    required String days,
  }) async {
    try {
      Map<String, dynamic> payload = {
        "category_id": categoryId,
        "user_id": userId,
        "subcategory_id": subcategoryId,
        "amount": amount,
        "days": days,
        "payment_id": "pay12334",
        "tdate": _getCurrentDate(),
        "ttime": _getCurrentTime(),
        "order_id": "123456"
      };

      // Send the request for purchase
      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.subcategorycourseubscriptionpayment,
          payload: payload,
          urlMessage: "Get purchase course URL",
          payloadMessage: "Get purchase course payload",
          statusMessage: "Get purchase status code",
          bodyMessage: "Get purchase response"
      );

      // Check if the response is valid and parse it
      getSubcategoryPaymentModel = getSubcategoryPaymentModelFromJson(response["body"]);

      if (getSubcategoryPaymentModel.statusCode == "200" || getSubcategoryPaymentModel.statusCode == "201") {
        // Close the loader
        CustomLoader.closeCustomLoader();

        // Navigate to the PaymentThankYouView screen and pass the userId and purchaseId
        Get.to(() => PaymentThankYouView(
          userId: userId,
          id: "${getSubcategoryPaymentModel.subcategoryPurchasePaymentResult?.id}",
        ));
      } else {
        log("Something went wrong during payment ::: ${getSubcategoryPaymentModel.statusCode}");
      }
    } catch (error) {
      log("Something went wrong during payment ::: $error");
    }
  }

}
