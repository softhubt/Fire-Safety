import 'dart:developer';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Models/get_tab_access_list_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/Chapeter_FlashExercise_view.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/TopicWiseListQuize_View.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_FormativeAssement_View.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_StudyMaterial_view.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_video_content_view.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Widgets/custom_tab_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ChapterDetailController extends GetxController {
  GetTabAccessListModel getTabAccessListModel = GetTabAccessListModel();

  late TabController tabController;
  late VideoPlayerController videoPlayerController;
  late Future<void> initializeVideoPlayerFuture;

  RxString userId = "".obs;

  RxList<Widget> tabList = [
    const CustomTabBox(title: "Video", isExpandTab: false),
    const CustomTabBox(title: "Study Material", isExpandTab: false),
    const CustomTabBox(title: "Quiz(MCQ Based)", isExpandTab: false),
    const CustomTabBox(title: "FLASH EXERCISE", isExpandTab: false),
    const CustomTabBox(title: "FORMATIVE ASSESSMENT", isExpandTab: false),
  ].obs;

  Future<void> initialFunctioun({
    required String chapterId,
    required int initialIndex,
    required TickerProvider vsync,
  }) async {
    tabController = TabController(
      length: tabList.length,
      vsync: vsync,
      initialIndex: initialIndex,
    );

    userId.value = await StorageServices.getData(
      dataType: StorageKeyConstant.stringType,
      prefKey: StorageKeyConstant.userId,
    );

    await getChapterAccess(chapterId: chapterId);
  }

  Future<void> getChapterAccess({required String chapterId}) async {
    try {
      Map<String, dynamic> payload = {
        "user_id": userId.value,
        "chapter_id": chapterId,
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.chapterWiseTabAccess,
        payload: payload,
        urlMessage: "Get tab access url",
        payloadMessage: "Get tab access payload",
        statusMessage: "Get tab access status",
        bodyMessage: "Get tab access response",
      );

      getTabAccessListModel = getTabAccessListModelFromJson(response["body"]);
      if (getTabAccessListModel.statusCode == "200" ||
          getTabAccessListModel.statusCode == "201") {
        update();
      } else {
        log("Something went wrong during getting tab access ::: ${getTabAccessListModel.message}");
      }
    } catch (error) {
      log("Something went wrong during getting the tab access ::: $error");
    }
  }

  List<Map<String, dynamic>> getTabListWithAccess() {
    final accessList = getTabAccessListModel.elementwiseTabaccessList?.first;
    if (accessList == null) return [];

    return [
      {
        'widget': const CustomTabBox(title: "Video", isExpandTab: false),
        'isAccessible': accessList.videoAccess == "Yes",
        'view': ChapterVideoContentView(chapterId: accessList.chapterId!),
      },
      {
        'widget':
            const CustomTabBox(title: "Study Material", isExpandTab: false),
        'isAccessible': accessList.studymaterialAccess == "Yes",
        'view': ChapterStudyMaterialView(chapterId: accessList.chapterId!),
      },
      {
        'widget':
            const CustomTabBox(title: "Quiz(MCQ Based)", isExpandTab: false),
        'isAccessible': accessList.quizAccess == "Yes",
        'view': TopicListScreen(
            chapterId: accessList.chapterId!,
            userId: userId.value,
            testpaymentId: accessList.courseId!),
      },
      {
        'widget':
            const CustomTabBox(title: "FLASH EXERCISE", isExpandTab: false),
        'isAccessible': accessList.flashExerciseAccess == "Yes",
        'view': ChapterFlashExerciseView(
            chapterId: accessList.chapterId!,
            userId: userId.value,
            courseId: accessList.courseId!,
            testpaymentId: accessList.courseId!),
      },
      {
        'widget': const CustomTabBox(
            title: "FORMATIVE ASSESSMENT", isExpandTab: false),
        'isAccessible': accessList.formativeAccess == "Yes",
        'view': FormativeAssesmentView(
          chapterId: accessList.chapterId!,
          userId: userId.value,
          courseId: accessList.courseId!,
          testpaymentId: accessList.courseId!,
        ),
      },
    ];
  }
}
