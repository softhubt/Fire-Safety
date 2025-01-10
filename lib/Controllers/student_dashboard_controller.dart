import 'dart:developer';
import 'package:firesafety/Models/get_batch_details_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/My_Course_Section/my_course_screen.dart';
import 'package:firesafety/Widgets/custom_web_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Services/local_storage_services.dart';

class StudentDashboardController extends GetxController {
  GetBatchDetailsModel getBatchDetailsModel = GetBatchDetailsModel();

  RxString userId = "".obs;

  RxList<DashboardElementListModel> dashboardElementList =
      <DashboardElementListModel>[].obs;

  Future initialFunctioun(
      {required String subCategoryName,
      required String categoryId,
      required String subcategoryId,
      required String testPaymentId}) async {
    dashboardElementList.value = [
      DashboardElementListModel(
          title: "My Course",
          icon: Icons.description_rounded,
          onTap: () {
            Get.to(() => MyCourseListView(
                courseName: subCategoryName,
                categoryId: categoryId,
                subcategoryId: subcategoryId,
                testpaymentId: testPaymentId));
          }),
      DashboardElementListModel(
          title: "My Enrollment",
          icon: Icons.edit_rounded,
          onTap: () {
            Get.to(() => CustomWebView(
                url:
                    "https://softebuild.com/fire_safety/api/print_booking_form.php?order_number=$testPaymentId"));
          }),
      DashboardElementListModel(
          title: "Results",
          icon: Icons.book_rounded,
          onTap: () {
            Get.to(() => MyCourseListView(
                courseName: subCategoryName,
                categoryId: categoryId,
                subcategoryId: subcategoryId,
                testpaymentId: testPaymentId));
          }),
      DashboardElementListModel(
          title: "Notifications",
          icon: Icons.notifications_rounded,
          onTap: () {}),
      DashboardElementListModel(
          title: "My Batches", icon: Icons.groups_sharp, onTap: () {}),
      DashboardElementListModel(
          title: "Messages", icon: Icons.message_rounded, onTap: () {}),
    ];

    userId.value = await StorageServices.getData(
        dataType: StorageKeyConstant.stringType,
        prefKey: StorageKeyConstant.userId);

    await getBatchDetails(testPaymentId: testPaymentId);
  }

  Future getBatchDetails({required String testPaymentId}) async {
    try {
      Map<String, dynamic> payload = {
        "testpayment_id": testPaymentId,
        "user_id": userId.value
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.myBatchDetails,
          payload: payload,
          urlMessage: "Get batch details url",
          payloadMessage: "Get batch details payload",
          statusMessage: "Get batch details status code",
          bodyMessage: "Get batch details response");

      getBatchDetailsModel = getBatchDetailsModelFromJson(response["body"]);

      if (getBatchDetailsModel.statusCode == "200" ||
          getBatchDetailsModel.statusCode == "201") {
      } else {
        log("Something went wrong during getting Get batch details ::: ${getBatchDetailsModel.statusCode}");
      }
    } catch (error) {
      log("Something went wrong during getting Get batch details ::: $error");
    }
  }
}

class DashboardElementListModel {
  String title;
  IconData icon;
  Function() onTap;

  DashboardElementListModel(
      {required this.title, required this.icon, required this.onTap});
}
