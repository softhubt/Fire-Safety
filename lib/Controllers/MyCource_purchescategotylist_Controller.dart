import 'dart:developer';
import 'package:firesafety/Models/get_purches_CategoryList_model.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_course_list_model.dart';
import 'package:firesafety/Services/http_services.dart';

class MypurschaseSubcategoryController extends GetxController {
  GetPurchaseSubcategoryModel getPurchaseSubcategoryModel =
      GetPurchaseSubcategoryModel();

  Future GetPurchesSubCategory({
    required String UserId,
  }) async {
    try {
      Map<String, dynamic> payload = {"user_id": UserId};

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.mypurchasesubcategorylist,
          payload: payload,
          urlMessage: "Get course list url",
          payloadMessage: "Get course list payload",
          statusMessage: "Get course list status code",
          bodyMessage: "Get course list response");

      getPurchaseSubcategoryModel =
          getPurchaseSubcategoryModelFromJson(response["body"]);

      if (getPurchaseSubcategoryModel.statusCode == "200" ||
          getPurchaseSubcategoryModel.statusCode == "201") {
      } else {
        log("Something went wrong during getting course list ::: ${getPurchaseSubcategoryModel.statusCode}");
      }
    } catch (error) {
      log("Something went wrong during getting course list ::: $error");
    }
  }

  // Future getPurchesCpource({
  //   required String categoryId,
  //   required String subcategoryId,
  //   required String userId,
  //   required String amount,
  //   required String days,
  // }) async {
  //   try {
  //     Map<String, dynamic> payload = {
  //       "category_id": categoryId,
  //       "user_id": userId,
  //       "subcategory_id": subcategoryId,
  //       "amount": amount,
  //       "days": days,
  //       "payment_id": "pay12334",
  //       "tdate": _getCurrentDate(),  // Fix here by calling the function with ()
  //       "ttime": _getCurrentTime(),  // Fix here by calling the function with ()
  //       "order_id": "123456" // You may need to generate a unique order ID dynamically
  //     };
  //
  //     var response = await HttpServices.postHttpMethod(
  //         url: EndPointConstant.subcategorycourseubscriptionpayment,
  //         payload: payload,
  //         urlMessage: "Get course list url",
  //         payloadMessage: "Get course list payload",
  //         statusMessage: "Get course list status code",
  //         bodyMessage: "Get course list response"
  //     );
  //
  //     getSubcategoryPaymentModel = getSubcategoryPaymentModelFromJson(response["body"]);
  //
  //     if (getSubcategoryPaymentModel.statusCode == "200" ||
  //         getSubcategoryPaymentModel.statusCode == "201") {
  //       CustomLoader.closeCustomLoader();
  //       Get.to(() => PaymentThankYouView(userId: userId));
  //     } else {
  //       log("Something went wrong during payment ::: ${getSubcategoryPaymentModel.statusCode}");
  //     }
  //   } catch (error) {
  //     log("Something went wrong during payment ::: $error");
  //   }
  // }
}
