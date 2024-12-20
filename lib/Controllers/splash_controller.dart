import 'dart:developer';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_purches_CategoryList_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Screens/Authentication_Section/login_screen.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
import 'package:firesafety/Services/local_storage_services.dart';

class SplashController extends GetxController {
  GetPurchaseSubcategoryModel getPurchaseSubcategoryModel =
      GetPurchaseSubcategoryModel();

  RxBool isAuthenticate = false.obs;

  @override
  void onInit() {
    super.onInit();
    changeView();
  }

  changeView() async {
    // Check authentication status
    isAuthenticate.value = await StorageServices.getData(
            dataType: StorageKeyConstant.boolType,
            prefKey: StorageKeyConstant.isAuthenticate) ??
        false;

    if (isAuthenticate.value) {
      // User is authenticated, check purchase category list
      Future.delayed(const Duration(seconds: 1), () {
        getPurchesSubCategory();
      });
    } else {
      // User not authenticated, navigate to login screen
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAll(() => const LoginScreen());
      });
    }
  }

  Future getPurchesSubCategory() async {
    try {
      // Fetch userId from local storage
      String userId = await StorageServices.getData(
          dataType: StorageKeyConstant.stringType,
          prefKey: StorageKeyConstant.userId);

      // Prepare payload
      Map<String, dynamic> payload = {"user_id": userId};

      // API call
      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.mypurchasesubcategorylist,
          payload: payload,
          urlMessage: "Get course list url",
          payloadMessage: "Get course list payload",
          statusMessage: "Get course list status code",
          bodyMessage: "Get course list response");

      // Parse response
      getPurchaseSubcategoryModel =
          getPurchaseSubcategoryModelFromJson(response["body"]);

      // Navigate to the BottomBarScreen with appropriate index
      if (getPurchaseSubcategoryModel.statusCode == "200" ||
          getPurchaseSubcategoryModel.statusCode == "201") {
        // If data is available, navigate to the second index
        int currentIndex =
            (getPurchaseSubcategoryModel.myPurchaseSubcategoryList != null)
                ? 1
                : 0;
        Get.offAll(() => BottomBarScreen(currentIndex: currentIndex));
      } else {
        log("Error during API call: ${getPurchaseSubcategoryModel.statusCode}");
        Get.offAll(() => const BottomBarScreen(currentIndex: 0));
      }
    } catch (error) {
      log("Error fetching data: $error");
      Get.offAll(() => const BottomBarScreen(
          currentIndex: 0)); // Navigate to default tab in case of error
    }
  }
}
