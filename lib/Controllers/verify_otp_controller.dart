import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Models/post_verify_otp_model.dart';
import 'package:firesafety/Screens/Authentication_Section/create_account_screen.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:firesafety/Widgets/custom_toast.dart';

class VerifyOtpController extends GetxController {
  PostVerifyOtpModel postVerifyOtpModel = PostVerifyOtpModel();

  TextEditingController otpController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future postVerifyOtp({required String phone}) async {
    try {
      CustomLoader.openCustomLoader();
      Map<String, dynamic> payload = {
        "mobile_number": phone,
        "otp": otpController.text
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.verifyOtp,
          payload: payload,
          payloadMessage: "Post verify otp payload",
          urlMessage: "Post verify otp url",
          statusMessage: "Post verify otp url",
          bodyMessage: "Post verify otp response");

      postVerifyOtpModel = postVerifyOtpModelFromJson(response["body"]);

      if (postVerifyOtpModel.statusCode == "200" ||
          postVerifyOtpModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();
        if (postVerifyOtpModel.registerDetails?.email != "" ||
            postVerifyOtpModel.registerDetails?.firstName != "" ||
            postVerifyOtpModel.registerDetails?.lastName != "") {
          await StorageServices.setData(
              dataType: StorageKeyConstant.stringType,
              prefKey: StorageKeyConstant.phone,
              stringData:
                  "${postVerifyOtpModel.registerDetails?.mobileNumber}");

          await StorageServices.setData(
              dataType: StorageKeyConstant.stringType,
              prefKey: StorageKeyConstant.categoryName,
              stringData:
                  "${postVerifyOtpModel.registerDetails?.categoryName}");

          await StorageServices.setData(
              dataType: StorageKeyConstant.stringType,
              prefKey: StorageKeyConstant.email,
              stringData: "${postVerifyOtpModel.registerDetails?.email}");

          await StorageServices.setData(
              dataType: StorageKeyConstant.stringType,
              prefKey: StorageKeyConstant.userId,
              stringData: "${postVerifyOtpModel.registerDetails?.userId}");

          await StorageServices.setData(
              dataType: StorageKeyConstant.stringType,
              prefKey: StorageKeyConstant.categoryId,
              stringData: "${postVerifyOtpModel.registerDetails?.categoryId}");

          await StorageServices.setData(
              dataType: StorageKeyConstant.stringType,
              prefKey: StorageKeyConstant.subCategoryId,
              stringData:
                  "${postVerifyOtpModel.registerDetails?.subcategoryId}");

          await StorageServices.setData(
              dataType: StorageKeyConstant.stringType,
              prefKey: StorageKeyConstant.classId,
              stringData: "${postVerifyOtpModel.registerDetails?.classId}");

          await StorageServices.setData(
              dataType: StorageKeyConstant.boolType,
              prefKey: StorageKeyConstant.isAuthenticate,
              boolData: true);

          await StorageServices.setData(
              dataType: StorageKeyConstant.stringType,
              prefKey: StorageKeyConstant.userName,
              stringData:
                  "${postVerifyOtpModel.registerDetails?.firstName} ${postVerifyOtpModel.registerDetails?.lastName}");

          customToast(message: "${postVerifyOtpModel.message}");
          Get.offAll(() => const BottomBarScreen());
        } else {
          customToast(message: "${postVerifyOtpModel.message}");
          Get.to(() => CreateAccountScreen(
              id: "${postVerifyOtpModel.registerDetails?.userId}"));
        }
      } else {
        CustomLoader.closeCustomLoader();
        customToast(message: "${postVerifyOtpModel.message}");
      }
    } catch (error) {
      CustomLoader.closeCustomLoader();
      log("Something went wrong during posting verify otp ::: $error");
    }
  }
}
