import 'dart:developer';
import 'package:firesafety/Models/get_purches_CategoryList_model.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_subcategory_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';

class SelectSubcategoryController extends GetxController {
  GetSubcategoryModel getSubcategoryModel = GetSubcategoryModel();
  GetPurchaseSubcategoryModel getPurchaseSubcategoryModel = GetPurchaseSubcategoryModel();
  RxString userId = "".obs;
  RxBool isLoading = false.obs; // Add a loading indicator

  // Initialize the controller and fetch userId
  // Future initialFunctioun() async {
  //   userId.value = await StorageServices.getData(
  //       dataType: StorageKeyConstant.stringType,
  //       prefKey: StorageKeyConstant.userId) ??
  //       "";
  //
  // }

  // Get subcategory list based on categoryId
  Future<void> getSubcategory({required String categoryId,required String userId}) async {
    try {
      isLoading.value = true; // Start loading
      CustomLoader.openCustomLoader(); // Show custom loader

      // Create payload for the request
      Map<String, dynamic> payload = {
        "category_id": categoryId,
        "user_id": userId,
      };

      // Make HTTP request to fetch subcategory data
      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.subcategoryList,
        payload: payload,
        urlMessage: "Get subcategory url",
        payloadMessage: "Get subcategory payload",
        statusMessage: "Get subcategory status code",
        bodyMessage: "Get subcategory response",
      );

      // Check if response body is valid
      if (response["body"] != null) {
        getSubcategoryModel = getSubcategoryModelFromJson(response["body"]);

        // Check if the status code indicates success
        if (getSubcategoryModel.statusCode == "200" || getSubcategoryModel.statusCode == "201") {
          CustomLoader.closeCustomLoader(); // Close loader on success
        } else {
          // Log and handle error status codes
          log("Something went wrong during getting subcategory list ::: ${getSubcategoryModel.statusCode}");
          CustomLoader.closeCustomLoader(); // Close loader on failure
        }
      } else {
        // Handle case when response body is null or empty
        log("No data received from the server.");
        CustomLoader.closeCustomLoader();
      }
    } catch (error) {
      // Catch and handle errors
      log("Error during getting subcategory list: $error");
      CustomLoader.closeCustomLoader(); // Close loader on error
    } finally {
      isLoading.value = false; // Stop loading at the end of the request
    }
  }
}
