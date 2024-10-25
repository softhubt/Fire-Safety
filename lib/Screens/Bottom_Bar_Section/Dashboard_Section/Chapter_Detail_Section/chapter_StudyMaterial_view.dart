import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/StudyMaterialContentController.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/pdfView.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';

class ChapterStudyMaterialView extends StatefulWidget {
  final String chapterId;

  const ChapterStudyMaterialView({super.key, required this.chapterId});

  @override
  State<ChapterStudyMaterialView> createState() =>
      _ChapterStudyMaterialViewState();
}

class _ChapterStudyMaterialViewState extends State<ChapterStudyMaterialView> {
  final ChapterMaterialContentController controller =
      Get.put(ChapterMaterialContentController());

  @override
  void initState() {
    super.initState();
    controller
        .initialFunctioun(chapterId: widget.chapterId)
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: screenVerticalPadding,
        child: controller.getChapterVideoListModel.chapterwiseTopicVideoList !=
                null
            ? ListView.builder(
                itemCount: controller
                    .getChapterVideoListModel.chapterwiseTopicVideoList!.length,
                itemBuilder: (context, index) {
                  final topic = controller.getChapterVideoListModel
                      .chapterwiseTopicVideoList![index];
                  return Card(
                    child: Container(
                      padding: contentHorizontalPadding,
                      height: Get.height * 0.080,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: ColorConstant.extraLightPrimary,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(topic.topicName ?? '',
                              style: TextStyleConstant.medium16()),
                          const Spacer(),
                          SizedBox(width: Get.width * 0.020),
                          IconButton(
                              onPressed: () {
                                log("${topic.imagePdf}");
                                Get.to(() => CustomPdfView(
                                    title: "${topic.topicName}",
                                    url: "${topic.imagePdf}",
                                    needToDonloadPdf: true));
                              },
                              icon: const Icon(Icons.picture_as_pdf_rounded)),
                          IconButton(
                              onPressed: () {
                                log("${topic.imagePdf}");
                                Get.to(() => CustomPdfView(
                                    title: "${topic.topicName}",
                                    url: "${topic.pptPdf}",
                                    needToDonloadPdf: false));
                              },
                              icon: const Icon(Icons.assessment)),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const CustomNoDataFound(),
      ),
    );
  }

  Widget _buildPdfButton(topic) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            final imagePdf = topic.imagePdf;
            if (imagePdf != null && imagePdf.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CustomPdfView(
                      title: topic.topicName ?? '',
                      url: imagePdf,
                      needToDonloadPdf: true),
                ),
              );
            } else {
              Get.snackbar('Error', 'Invalid PDF URL');
            }
          },
          icon: const Icon(Icons.picture_as_pdf),
        ),
        const Text("PDF View"),
      ],
    );
  }

  Widget _buildPptButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            // Add functionality for PPT here
          },
          icon: const Icon(Icons.assessment),
        ),
        const Text("PPT"),
      ],
    );
  }
}
