import 'package:firesafety/Widgets/custom_no_data_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Controllers/chapter_detail_controller.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';

class ChapterDetailScreen extends StatefulWidget {
  final int? initialIndex;
  final String chapterId;
  final String courseId;
  final String chapterName;
  final String testpaymentId;

  const ChapterDetailScreen(
      {super.key,
      required this.chapterId,
      required this.courseId,
      required this.testpaymentId,
      required this.chapterName,
      this.initialIndex});

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen>
    with SingleTickerProviderStateMixin {
  ChapterDetailController controller = ChapterDetailController();

  @override
  void initState() {
    super.initState();
    controller
        .initialFunctioun(
            chapterId: widget.chapterId,
            initialIndex: widget.initialIndex ?? 0,
            vsync: this)
        .whenComplete(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.chapterName,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: ColorConstant.white),
          )),
      body: Padding(
        padding: EdgeInsets.only(
            top: screenHeightPadding,
            left: screenWidthPadding,
            right: screenWidthPadding),
        child: controller.userId.value.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Obx(() {
                final tabs = controller.getTabListWithAccess();
                if (tabs.isEmpty) {
                  // If no tabs are accessible, show a "No Content" message
                  return const Center(
                    child: CustomNoDataFound(
                      message: "No content available for this chapter.",
                    ),
                  );
                }

                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: Get.height * 0.006,
                        horizontal: Get.width * 0.014,
                      ),
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
                          color: ColorConstant.primary,
                        ),
                        labelColor: ColorConstant.white,
                        tabs: tabs.map<Widget>((tab) => tab['widget']).toList(),
                        dividerColor: ColorConstant.transparent,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabController,
                        children:
                            tabs.map<Widget>((tab) => tab['view']).toList(),
                      ),
                    ),
                  ],
                );
              }),
      ),
    );
  }
}
