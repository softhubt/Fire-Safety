import 'dart:developer';

import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Models/get_purches_CategoryList_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:get/get.dart';

class StudentDashboardController extends GetxController {
  GetPurchaseSubcategoryModel getPurchaseSubcategoryModel =
      GetPurchaseSubcategoryModel();

  RxString userId = "".obs;

  Future initialFunctioun() async {
    userId.value = await StorageServices.getData(
        dataType: StorageKeyConstant.stringType,
        prefKey: StorageKeyConstant.userId);
    await getPurchesSubCategoryList();
  }

  Future getPurchesSubCategoryList() async {
    try {
      Map<String, dynamic> payload = {"user_id": userId.value};

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
}
