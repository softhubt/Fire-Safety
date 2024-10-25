import 'dart:developer';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_course_list_model.dart';
import 'package:firesafety/Services/http_services.dart';

class CourseListController extends GetxController {
  GetCourseListModel getCourseListModel = GetCourseListModel();

  Future getCourseList(
      {required String categoryId, required String subcategoryId}) async {
    try {
      Map<String, dynamic> payload = {
        "category_id": categoryId,
        "subcategory_id": subcategoryId
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.courseList,
          payload: payload,
          urlMessage: "Get course list url",
          payloadMessage: "Get course list payload",
          statusMessage: "Get course list status code",
          bodyMessage: "Get course list response");

      getCourseListModel = getCourseListModelFromJson(response["body"]);

      if (getCourseListModel.statusCode == "200" ||
          getCourseListModel.statusCode == "201") {
      } else {
        log("Something went wrong during getting course list ::: ${getCourseListModel.statusCode}");
      }
    } catch (error) {
      log("Something went wrong during getting course list ::: $error");
    }
  }
}
