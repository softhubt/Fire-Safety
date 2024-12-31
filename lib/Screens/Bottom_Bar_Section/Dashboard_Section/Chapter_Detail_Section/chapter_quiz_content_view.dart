import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
import 'package:firesafety/Screens/ListeningWithMCQ_Screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:firesafety/Widgets/custom_shimmer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/chapter_quiz_content_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/ElementQuizeTestResult_View.dart';

class ChapterQuizContentView extends StatefulWidget {
  final String chapterId;
  final String topicId;
  final String userId;
  final String quizType;
  final String testpaymentId;

  const ChapterQuizContentView({
    super.key,
    required this.chapterId,
    required this.topicId,
    required this.userId,
    required this.quizType,
    required this.testpaymentId,
  });

  @override
  State<ChapterQuizContentView> createState() => _ChapterQuizContentViewState();
}

class _ChapterQuizContentViewState extends State<ChapterQuizContentView> {
  final ChapterQuizContentController controller =
      Get.put(ChapterQuizContentController());

  @override
  void initState() {
    super.initState();
    controller
        .initialFunctioun(
            chapterId: widget.chapterId,
            topicId: widget.topicId,
            userId: widget.userId,
            quizType: widget.quizType)
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Quize", isBack: true),
      body: (controller.isFetchingData.value)
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: CustomShimmer(height: Get.height * 0.600))
          : (controller.resultList.isNotEmpty &&
                  controller.isRestart.value == false)
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                                "Total Marks: ${controller.resultList.first.totalMarks ?? ""}",
                                style: TextStyleConstant.medium18()),
                            Text(
                                "Obtain Marks: ${controller.resultList.first.obtainMarks ?? ""}",
                                style: TextStyleConstant.medium18()),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenHeightPadding,
                              bottom: screenHeightPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                  "Right Answers: ${controller.resultList.first.rightAnswers ?? ""}",
                                  style: TextStyleConstant.medium18()),
                              Text(
                                  "Wrong Answers: ${controller.resultList.first.wrongAnswers ?? ""}",
                                  style: TextStyleConstant.medium18())
                            ],
                          ),
                        ),
                        Container(
                          padding: contentPadding,
                          decoration: BoxDecoration(
                              color: (double.parse(
                                          "${controller.resultList.first.rightAnswers}") >
                                      0)
                                  ? ColorConstant.green.withOpacity(0.1)
                                  : ColorConstant.red.withOpacity(0.1),
                              border: Border.all(
                                  width: 2,
                                  color: (double.parse(
                                              "${controller.resultList.first.rightAnswers}") >
                                          0)
                                      ? ColorConstant.green
                                      : ColorConstant.red),
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              Text("${controller.resultList.first.obtainMarks}",
                                  style: TextStyleConstant.bold36(
                                      color: (double.parse(
                                                  "${controller.resultList.first.obtainMarks}") >
                                              0)
                                          ? ColorConstant.green
                                          : ColorConstant.red),
                                  textAlign: TextAlign.center),
                              Text("is your test score",
                                  style: TextStyleConstant.medium18(),
                                  textAlign: TextAlign.center),
                              SizedBox(height: contentHeightPadding),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: (double.parse(
                                                    "${controller.resultList.first.obtainMarks}") >
                                                0)
                                            ? ColorConstant.green
                                            : ColorConstant.red,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(12)),
                                child: LinearProgressIndicator(
                                  value: controller.progressBarValue.value,
                                  minHeight: 40,
                                  borderRadius: BorderRadius.circular(10),
                                  backgroundColor: ColorConstant.transparent,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeightPadding),
                        Container(
                            padding: contentPadding,
                            decoration: BoxDecoration(
                                color: ColorConstant.blue.withOpacity(0.1),
                                border: Border.all(
                                    width: 2, color: ColorConstant.blue),
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                SizedBox(
                                    height: Get.height * 0.300,
                                    child: PieChart(PieChartData(
                                        sections: showingSections(
                                            attemptedQuestions: double.parse(
                                                "${controller.resultList.first.rightAnswers}"),
                                            unattemptedQuestions: double.parse(
                                                "${controller.resultList.first.wrongAnswers}"),
                                            skippedQuestions:
                                                double.parse("0")),
                                        centerSpaceRadius: 20,
                                        sectionsSpace: 2,
                                        borderData: FlBorderData(show: false),
                                        pieTouchData: PieTouchData(
                                          touchCallback: (FlTouchEvent event,
                                              pieTouchResponse) {},
                                        )))),
                                buildLegend(),
                              ],
                            )),
                        SizedBox(height: screenHeightPadding),
                        Padding(
                          padding: EdgeInsets.only(bottom: screenHeightPadding),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CustomButton(
                                title: "Restart Test",
                                onTap: () {
                                  controller.isRestart.value = true;
                                  setState(() {});
                                },
                              )),
                              SizedBox(width: contentWidthPadding),
                              Expanded(
                                  child: CustomButton(
                                title: "Finish",
                                onTap: () {
                                  Get.offAll(() => const BottomBarScreen());
                                },
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : (controller.questions.isNotEmpty)
                  ? Obx(() {
                      final currentQuestion = controller
                          .questions[controller.currentQuestionIndex.value];

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                children: [
                                  Text(
                                    "${controller.currentQuestionIndex.value + 1}. ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Expanded(
                                    child: Text(
                                      currentQuestion.text,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...currentQuestion.options.map((option) {
                              return OptionButton(
                                option: option,
                                isSelected:
                                    controller.selectedAnswer.value == option,
                                isCorrect: controller.isAnswered.value &&
                                    option == currentQuestion.correctAnswer,
                                isWrong: controller.isAnswered.value &&
                                    option != currentQuestion.correctAnswer &&
                                    controller.selectedAnswer.value == option,
                                onPressed: () {
                                  if (!controller.isAnswered.value) {
                                    setState(() {
                                      controller.checkAnswer(option);
                                    });
                                  }
                                },
                              );
                            }),
                            if (controller.isAnswered.value)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (controller.currentQuestionIndex.value <
                                        controller.questions.length - 1) {
                                      setState(() {
                                        controller.nextQuestion();
                                      });
                                    } else {
                                      controller
                                          .postQuizResult(
                                              testId: controller
                                                      .getChapterQuizListModel
                                                      .testDetailsList?[0]
                                                      .testId ??
                                                  '',
                                              courseid: controller
                                                      .getChapterQuizListModel
                                                      .testDetailsList?[0]
                                                      .courseName ??
                                                  '',
                                              chapterid: controller
                                                      .getChapterQuizListModel
                                                      .testDetailsList?[0]
                                                      .chapterId ??
                                                  '',
                                              topicid: controller
                                                      .getChapterQuizListModel
                                                      .testDetailsList?[0]
                                                      .topicId ??
                                                  '',
                                              userId: widget.userId,
                                              type: widget.quizType,
                                              testpaymentid:
                                                  widget.testpaymentId)
                                          .then((_) {
                                        print(
                                            "Correct Answers: ${controller.correctAnswers.value}");
                                        print(
                                            "Questions Length: ${controller.questions.length}");
                                        print(
                                            "Wrong Answers: ${controller.wrongAnswers.value}");

                                        Get.offAll(() => TestResultView(
                                              testListId: controller
                                                      .getChapterQuizListModel
                                                      .testDetailsList?[0]
                                                      .testId ??
                                                  '',
                                              testName: 'Quiz Test',
                                              attemptedQuestions: double.tryParse(
                                                      "${controller.correctAnswers.value ?? 0}") ??
                                                  0.0,
                                              unattemptedQuestions: (double
                                                          .tryParse(
                                                              "${controller.questions.length ?? 0}") ??
                                                      0.0) -
                                                  (double.tryParse(
                                                          "${controller.correctAnswers.value}") ??
                                                      0.0),
                                              skippedQuestion: 0.0,
                                              rightAnswer: double.tryParse(
                                                      "${controller.correctAnswers.value ?? 0}") ??
                                                  0.0,
                                              wrongAnswer: double.tryParse(
                                                      "${controller.wrongAnswers.value ?? 0}") ??
                                                  0.0,
                                              obtainMarks: double.tryParse(
                                                      "${controller.postChapterQuizResultModel.result?.obtainMarks ?? 0}") ??
                                                  0.0,
                                              totalMarks: double.tryParse(
                                                      "${controller.postChapterQuizResultModel.result?.totalMarks ?? 0}") ??
                                                  0.0,
                                              answeredList:
                                                  controller.questions,
                                              courseid: controller
                                                      .getChapterQuizListModel
                                                      .testDetailsList?[0]
                                                      .courseName ??
                                                  '',
                                              userId: widget.userId,
                                              chapterid: controller
                                                      .getChapterQuizListModel
                                                      .testDetailsList?[0]
                                                      .chapterId ??
                                                  '',
                                              testpaymentid:
                                                  widget.testpaymentId,
                                            ));
                                      });
                                    }
                                  },
                                  child:
                                      (controller.currentQuestionIndex.value <
                                              controller.questions.length - 1)
                                          ? const Text('Next Question')
                                          : const Text('Submit'),
                                ),
                              ),
                          ],
                        ),
                      );
                    })
                  : const SizedBox(),
    );
  }
}

class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String id;
  String selectedAnswer; // Add selectedAnswer property

  Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.id,
    this.selectedAnswer = "", // Default to empty string if not selected
  });
}
