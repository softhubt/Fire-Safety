import 'dart:developer';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/Chpter_TopicWiseList_Model.dart';
import 'package:firesafety/Services/http_services.dart';

class ChapterTopicWiseQuizController extends GetxController {
  ChapterWiseTopicListModel chapterWiseTopicListModel =
      ChapterWiseTopicListModel();

  Future initialFunctiioun({required String chapterId}) async {
    await chapterWiseTopicList(chapterId: chapterId);
  }

  Future<void> chapterWiseTopicList({required String chapterId}) async {
    try {
      Map<String, dynamic> payload = {"chapter_id": chapterId};

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.chapterwisetopiclist,
        payload: payload,
        urlMessage: "Get chapter wise quize list url",
        payloadMessage: "Get chapter wise quize list payload",
        statusMessage: "Get chapter wise quize list status code",
        bodyMessage: "Get chapter wise quize list response",
      );

      chapterWiseTopicListModel =
          chapterWiseTopicListModelFromJson(response["body"]);

      if (chapterWiseTopicListModel.statusCode == "200" ||
          chapterWiseTopicListModel.statusCode == "201") {
      } else {
        log("Something went wrong during getting chapter wise quiz list ::: ${chapterWiseTopicListModel.message}");
      }
    } catch (error) {
      log("Something went wrong during getting chapter wise quiz list ::: $error");
    }
  }
}
