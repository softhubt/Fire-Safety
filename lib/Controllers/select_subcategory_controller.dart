import 'dart:developer';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_subcategory_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';

class SelectSubcategoryController extends GetxController {
  GetSubcategoryModel getSubcategoryModel = GetSubcategoryModel();

  Future getSubcategory({required String categoryId}) async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {"category_id": categoryId};

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.subcategoryList,
          payload: payload,
          urlMessage: "Get subcategory url",
          payloadMessage: "Get subcategory payload",
          statusMessage: "Get subcategory status code",
          bodyMessage: "Get subcategory response");

      getSubcategoryModel = getSubcategoryModelFromJson(response["body"]);

      if (getSubcategoryModel.statusCode == "200" ||
          getSubcategoryModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();
      } else {
        CustomLoader.closeCustomLoader();
        log("Something went wrong during getting subcategory list ::: ${getSubcategoryModel.statusCode}");
      }
    } catch (error) {
      CustomLoader.closeCustomLoader();
      log("Something went wrong during getting subcategory list ::: $error");
    }
  }
}
