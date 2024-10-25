import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_otp_model.dart';
import 'package:firesafety/Screens/Authentication_Section/verify_otp_screen.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';

class LoginController extends GetxController {
  GetOtpModel getOtpModel = GetOtpModel();

  TextEditingController phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  RxBool isObscureText = false.obs;

  Future getOtp() async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {"mobile_number": phoneController.text};

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.otp,
          payload: payload,
          payloadMessage: "Get otp payload",
          urlMessage: "Get otp url",
          statusMessage: "Get otp status code",
          bodyMessage: "Get otp response");

      getOtpModel = getOtpModelFromJson(response["body"]);

      if (getOtpModel.statusCode == "200" || getOtpModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();
        Get.to(() => VerifyOtpScreen(phone: phoneController.text));
      } else {
        CustomLoader.closeCustomLoader();
        log("Something went wrong during getting otp ::: ${getOtpModel.statusCode}");
      }
    } catch (error) {
      CustomLoader.closeCustomLoader();
      log("Something went wrong during getting otp ::: $error");
    }
  }
}
