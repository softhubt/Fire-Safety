import 'dart:developer';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/Chpter_TopicWiseList_Model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';

class ChapterTopicWiseQuizController extends GetxController {
  RxList<TopicList> topicList = <TopicList>[].obs;

  Future<void> getTopicWiseList({required String chapterId}) async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {
        "chapter_id": chapterId,
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.chapterwisetopiclist,
        payload: payload,
        urlMessage: "Get quiz list url",
        payloadMessage: "Get quiz list payload",
        statusMessage: "Get quiz list status code",
        bodyMessage: "Get quiz list response",
      );

      ChapterWiseTopicListModel chapterWiseTopicListModel =
          chapterWiseTopicListModelFromJson(response["body"]);

      if (chapterWiseTopicListModel.statusCode == "200" ||
          chapterWiseTopicListModel.statusCode == "201") {
        if (chapterWiseTopicListModel.quizChapterwiseTopicList != null &&
            chapterWiseTopicListModel.quizChapterwiseTopicList!.isNotEmpty) {
          topicList.value = chapterWiseTopicListModel.quizChapterwiseTopicList!;
        } else {
          log("No data found for topic list. Status code: ${chapterWiseTopicListModel.statusCode}");
          topicList.clear(); // Clear list if no data is found
        }
      } else {
        log("Error getting quiz list: ${chapterWiseTopicListModel.statusCode}. Message: ${chapterWiseTopicListModel.message}");
        topicList.clear(); // Clear list on error status
      }
    } catch (error) {
      log("Error getting quiz list: $error");
      topicList.clear(); // Clear list on exception
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }
}
