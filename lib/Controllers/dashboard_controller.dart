import 'dart:developer';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/Get_Advertisement_Model.dart';
import 'package:firesafety/Models/get_category_model.dart';
import 'package:firesafety/Services/http_services.dart';

class DashboardController extends GetxController {
  GetCategoryModel getCategoryModel = GetCategoryModel();
  GetadvertiesmentModel getadvertiesmentModel = GetadvertiesmentModel();

  Future initialFunctioun() async {
    await getCategory();
    await AdvertiesmentImages();
  }

  Future<void> AdvertiesmentImages() async {
    try {
      // Fetch data from the API
      var response = await HttpServices.getHttpMethod(
        url: EndPointConstant.advertiesment,
        urlMessage: "Get advertisement url",
        statusMessage: "Get advertisement status code",
        bodyMessage: "Get advertisement response",
      );

      log("Get advertisement images response ::: ${response["body"]}");

      final fetchedModel = getadvertiesmentModelFromJson(response["body"]);

      if (fetchedModel.statusCode == "200" ||
          fetchedModel.statusCode == "201") {
        getadvertiesmentModel = fetchedModel;
        log("Advertisement images fetched successfully.");
      } else {
        // Handle non-successful responses
        log("Error fetching advertisement images: ${fetchedModel.message}");
      }
    } catch (error) {
      log("Error occurred while fetching advertisement images: $error");
      // Optionally, show an error message to the user
    }
  }

  Future<void> getCategory() async {
    try {
      var response = await HttpServices.getHttpMethod(
          url: EndPointConstant.category,
          urlMessage: "Get category url",
          statusMessage: "Get category status code",
          bodyMessage: "Get category response");

      getCategoryModel = getCategoryModelFromJson(response["body"]);

      if (getCategoryModel.statusCode == "200" ||
          getCategoryModel.statusCode == "201") {
      } else {
        log("Something went wrong during getting category list ::: ${getCategoryModel.statusCode}");
      }
    } catch (error) {
      log("Something went wrong during getting category list ::: $error");
    }
  }
}
