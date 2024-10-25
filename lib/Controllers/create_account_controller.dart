import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Models/post_create_account_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:firesafety/Widgets/custom_toast.dart';

class CreateAccountController extends GetxController {
  PostCreateAccountModel postCreateAccountModel = PostCreateAccountModel();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  RxBool isObscureText = false.obs;

  Future postCreateAccount({required String id}) async {
    try {
      CustomLoader.openCustomLoader();

      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.androidInfo;

      Map<String, dynamic> payload = {
        "id": id,
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "bio": deviceInfo.id,
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.createAccount,
          payload: payload,
          payloadMessage: "Post create account payload",
          urlMessage: "Post create account url",
          statusMessage: "Post create account status code",
          bodyMessage: "Post create account response");

      postCreateAccountModel = postCreateAccountModelFromJson(response["body"]);

      if (postCreateAccountModel.statusCode == "200" ||
          postCreateAccountModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();

        await StorageServices.setData(
            dataType: StorageKeyConstant.stringType,
            prefKey: StorageKeyConstant.phone,
            stringData: "${postCreateAccountModel.result?.mobileNumber}");

        await StorageServices.setData(
            dataType: StorageKeyConstant.stringType,
            prefKey: StorageKeyConstant.email,
            stringData: "${postCreateAccountModel.result?.email}");

        await StorageServices.setData(
            dataType: StorageKeyConstant.stringType,
            prefKey: StorageKeyConstant.userId,
            stringData: "${postCreateAccountModel.result?.userId}");

        await StorageServices.setData(
            dataType: StorageKeyConstant.boolType,
            prefKey: StorageKeyConstant.isAuthenticate,
            boolData: true);

        await StorageServices.setData(
            dataType: StorageKeyConstant.stringType,
            prefKey: StorageKeyConstant.userName,
            stringData:
                "${postCreateAccountModel.result?.firstName} ${postCreateAccountModel.result?.lastName}");

        customToast(message: "${postCreateAccountModel.message}");
        Get.offAll(() => const BottomBarScreen());
      } else {
        CustomLoader.closeCustomLoader();
        customToast(message: "${postCreateAccountModel.message}");
      }
    } catch (error) {
      CustomLoader.closeCustomLoader();
      log("Something went wrong during posting create account ::: $error");
    }
  }
}
