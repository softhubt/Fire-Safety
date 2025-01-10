import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/chapter_TopicWise_quize_Controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_quiz_content_view.dart';

class TopicListScreen extends StatefulWidget {
  final String chapterId;
  final String userId;
  final String testpaymentId;

  const TopicListScreen(
      {super.key,
      required this.chapterId,
      required this.userId,
      required this.testpaymentId});

  @override
  _TopicListScreenState createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  final ChapterTopicWiseQuizController controller =
      Get.put(ChapterTopicWiseQuizController());

  @override
  void initState() {
    super.initState();
    controller
        .initialFunctiioun(chapterId: widget.chapterId)
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (controller.chapterWiseTopicListModel.quizChapterwiseTopicList !=
                null)
            ? ListView.builder(
                itemCount: controller
                    .chapterWiseTopicListModel.quizChapterwiseTopicList?.length,
                itemBuilder: (context, index) {
                  final element = controller.chapterWiseTopicListModel
                      .quizChapterwiseTopicList?[index];
                  return Padding(
                      padding: EdgeInsets.only(top: contentHeightPadding),
                      child: Card(
                          color: ColorConstant.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                              onTap: () {
                                Get.to(() => ChapterQuizContentView(
                                    chapterId: widget.chapterId,
                                    topicId: "${element?.topicId}",
                                    userId: widget.userId,
                                    quizType: "3",
                                    testpaymentId: widget.testpaymentId));
                              },
                              leading: const Icon(Icons.book,
                                  color: ColorConstant.primary),
                              title: Text("${element?.topicName}"),
                              trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: ColorConstant.primary))));
                },
              )
            : ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CustomShimmer(
                      topPadding: contentHeightPadding,
                      height: Get.height * 0.100);
                },
              ));
  }
}
