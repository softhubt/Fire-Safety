import 'dart:developer';
import 'package:firesafety/Models/post_Get_Subcategory_PaymentModel.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/Payment_thank_you_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_chapter_list_model.dart';
import 'package:firesafety/Screens/ThankuScreen_page.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CourseDetailController extends GetxController {
  GetChapterListModel getChapterListModel = GetChapterListModel();
  GetSubcategoryPaymentModel getSubcategoryPaymentModel =
      GetSubcategoryPaymentModel();

  late TabController tabController;

  Razorpay razorpay = Razorpay();

  RxList<Widget> tabList = [
    SizedBox(
        height: Get.height,
        width: Get.width,
        child: const Tab(text: "Overview")),
    SizedBox(
        height: Get.height, width: Get.width, child: const Tab(text: "Course")),
  ].obs;

  Future getChapterList({required String courseId}) async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {"course_id": courseId};

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.chapter,
          payload: payload,
          urlMessage: "Get chapter list url",
          payloadMessage: "Get chapter list payload",
          statusMessage: "Get chapter list status code",
          bodyMessage: "Get chapter list response");

      getChapterListModel = getChapterListModelFromJson(response["body"]);

      if (getChapterListModel.statusCode == "200" ||
          getChapterListModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();
      } else {
        CustomLoader.closeCustomLoader();
        log("Something went wrong during getting chapter list ::: ${getChapterListModel.statusCode}");
      }
    } catch (error) {
      CustomLoader.closeCustomLoader();
      log("Something went wrong during getting chapter list ::: $error");
    }
  }

  String _getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  // Function for handling purchase
  Future postPurchesCource({
    required String categoryId,
    required String subcategoryId,
    required String userId,
    required String amount,
    required String days,
  }) async {
    try {
      CustomLoader.openCustomLoader();
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
          bodyMessage: "Get purchase response");

      // Check if the response is valid and parse it
      getSubcategoryPaymentModel =
          getSubcategoryPaymentModelFromJson(response["body"]);

      if (getSubcategoryPaymentModel.statusCode == "200" ||
          getSubcategoryPaymentModel.statusCode == "201") {
        // Close the loader
        CustomLoader.closeCustomLoader();

        // Navigate to the PaymentThankYouView screen and pass the userId and purchaseId
        Get.to(() => PaymentThankYouView(
              userId: userId,
              id: "${getSubcategoryPaymentModel.subcategoryPurchasePaymentResult?.id}",
            ));
      } else {
        CustomLoader.closeCustomLoader();
        log("Something went wrong during payment ::: ${getSubcategoryPaymentModel.statusCode}");
      }
    } catch (error) {
      CustomLoader.closeCustomLoader();
      log("Something went wrong during payment ::: $error");
    }
  }

  openRazorPay() {
    var options = {
      'key': 'rzp_live_Tp4SvpEXNjV43K',
      'amount': "1000",
      'name': 'Chakki Town',
      'description': 'Chakki Town',
      'timeout': 300,
      'prefill': {
        'contact': '7777777777',
        'email': "twobelieversnt@gmail.com",
      },
      "notify": {"sms": false, "email": false},
      "method": {
        "netbanking": true,
        "card": true,
        "upi": true,
        "wallet": false,
        "emi": false,
        "paylater": false
      }
    };

    razorpay.open(options);
    razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess as Function);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError as Function);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.to(() => const ThankYouScreen(fromWhere: ''));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Get.to(() => const ThankYouScreen(fromWhere: ''));
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }
}
