import 'dart:developer';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_chapter_video_list_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';

class ChapterMaterialContentController extends GetxController {
  GetChapterVideoListModel getChapterVideoListModel =
      GetChapterVideoListModel();

  Future initialFunctioun({required String chapterId}) async {
    await getVideoList(chapterId: chapterId);
  }

  Future getVideoList({required String chapterId}) async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {"chapter_id": chapterId};

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.chapterWiseTopicVideo,
          payload: payload,
          urlMessage: "Get video list url",
          payloadMessage: "Get video list payload",
          statusMessage: "Get video list status code",
          bodyMessage: "Get video list response");

      getChapterVideoListModel =
          getChapterVideoListModelFromJson(response["body"]);

      if (getChapterVideoListModel.statusCode == "200" ||
          getChapterVideoListModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();
      } else {
        CustomLoader.closeCustomLoader();
        log("Something went wrong during getting video list ::: ${getChapterVideoListModel.statusCode}");
      }
    } catch (error) {
      CustomLoader.closeCustomLoader();
      log("Something went wrong during getting video list ::: $error");
    }
  }
}
