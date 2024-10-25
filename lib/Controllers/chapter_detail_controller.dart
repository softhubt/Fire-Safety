import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Models/get_chapter_video_list_model.dart';
import 'package:firesafety/Widgets/custom_tab_box.dart';
import 'package:video_player/video_player.dart';

class ChapterDetailController extends GetxController {
  GetChapterVideoListModel getChapterVideoListModel =
      GetChapterVideoListModel();

  late TabController tabController;
  late VideoPlayerController videoPlayerController;
  late Future<void> initializeVideoPlayerFuture;

  RxString userId = "".obs;

  RxList<Widget> tabList = [
    const CustomTabBox(title: "Video", isExpandTab: false),
    const CustomTabBox(title: "Study Material", isExpandTab: false),
    const CustomTabBox(title: "Quiz(MCQ Based)", isExpandTab: false),
    // const CustomTabBox(title: "Test", isExpandTab: false),
    // const CustomTabBox(title: "Ebook", isExpandTab: false),
    // const CustomTabBox(title: "MockTest", isExpandTab: false),
    // const CustomTabBox(title: "Practise Paper", isExpandTab: false),
    const CustomTabBox(title: " FLASH EXERCISE", isExpandTab: false),
    const CustomTabBox(title: " FORMATIVE ASSESSMENT", isExpandTab: false),
  ].obs;
}
