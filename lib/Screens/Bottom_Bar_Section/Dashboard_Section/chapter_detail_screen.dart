import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Controllers/chapter_detail_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_StudyMaterial_view.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_video_content_view.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_FormativeAssement_View.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/TopicWiseListQuize_View.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/Chapeter_FlashExercise_view.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';

class ChapterDetailScreen extends StatefulWidget {
  final String chapterId;
  final String courseId;

  const ChapterDetailScreen(
      {super.key, required this.chapterId, required this.courseId});

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen>
    with SingleTickerProviderStateMixin {
  late ChapterDetailController controller;
  late String userId;
  // Nullable
  String? testFormativeId; // Nullable

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChapterDetailController());
    initialFunction();
  }

  @override
  void dispose() {
    controller.videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> initialFunction() async {
    controller.tabController =
        TabController(length: controller.tabList.length, vsync: this);

    userId = await StorageServices.getData(
        dataType: StorageKeyConstant.stringType,
        prefKey: StorageKeyConstant.userId);

    testFormativeId = await StorageServices.getData(
        dataType: StorageKeyConstant.stringType,
        prefKey: StorageKeyConstant.testFormativeId);

    setState(() {
      // Trigger rebuild after data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Chapter Detail",
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: ColorConstant.white))),
      body: Padding(
        padding: EdgeInsets.only(
            top: screenHeightPadding,
            left: screenWidthPadding,
            right: screenWidthPadding),
        child: userId.isEmpty
            ? const Center(
                child:
                    const CircularProgressIndicator()) // Show loader while userId is being fetched
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Get.height * 0.006,
                        horizontal: Get.width * 0.014),
                    height: Get.height * 0.054,
                    decoration: BoxDecoration(
                      color: ColorConstant.extraLightPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                      controller: controller.tabController,
                      isScrollable: true,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: ColorConstant.primary),
                      labelColor: ColorConstant.white,
                      tabs: controller.tabList,
                      dividerColor: ColorConstant.transparent,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        ChapterVideoContentView(chapterId: widget.chapterId),
                        ChapterStudyMaterialView(chapterId: widget.chapterId),
                        TopicListScreen(
                          chapterId: widget.chapterId,
                          userId: userId,
                        ),
                        ChapterFlashExerciseView(
                          chapterId: widget.chapterId,
                          userId: userId,
                          courseId: widget.courseId,
                        ),
                        FormativeAssesmentView(
                          chapterId: widget.chapterId,
                          userId: userId,
                          courseId: widget.courseId, // Handle null case
                          // Handle null case
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
