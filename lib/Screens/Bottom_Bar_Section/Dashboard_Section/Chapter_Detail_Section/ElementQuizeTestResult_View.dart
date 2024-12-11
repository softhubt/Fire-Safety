import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/chapter_quiz_content_controller.dart';
import 'package:firesafety/Models/post_chapter_quiz_result_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/Chapeter_FlashExercise_view.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_quiz_content_view.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class TestResultView extends StatefulWidget {
  final String testListId;
  final String testName;
  final double attemptedQuestions;
  final double unattemptedQuestions;
  final double skippedQuestion;
  final double rightAnswer;
  final double wrongAnswer;
  final String courseid;
  final String userId;
  final String chapterid;
  final String testpaymentid;
  final List<Question> answeredList; // Change to List<Question> instead of List<Map>

  const TestResultView({
    Key? key,
    required this.testListId,
    required this.testName,
    required this.attemptedQuestions,
    required this.unattemptedQuestions,
    required this.skippedQuestion,
    required this.rightAnswer,
    required this.wrongAnswer,
    required this.answeredList,
    required this.courseid,
    required this.userId,
    required this.chapterid,
    required this.testpaymentid,
  }) : super(key: key);

  @override
  State<TestResultView> createState() => _TestResultViewState();
}

class _TestResultViewState extends State<TestResultView> {
  ChapterQuizContentController controller = Get.put(ChapterQuizContentController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Result')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Test: ${widget.testName}', style: TextStyle(fontSize: 22)),
              SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('Attempted: ${widget.attemptedQuestions}'),
              //     Text('Unattempted: ${widget.unattemptedQuestions}'),
              //     Text('Skipped: ${widget.skippedQuestion}'),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      "Total Marks: ${controller.postChapterQuizResultModel.result?.totalMarks ?? ""}",
                      style: TextStyleConstant.medium18()),
                  Text(
                      "Obtain Marks: ${controller.postChapterQuizResultModel.result?.obtainMarks ?? ""}",
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
                        "Right Answers: ${controller.postChapterQuizResultModel.result?.rightAnswers ?? ""}",
                        style: TextStyleConstant.medium18()),
                    Text(
                        "Wrong Answers: ${controller.postChapterQuizResultModel.result?.wrongAnswers ?? ""}",
                        style: TextStyleConstant.medium18())
                  ],
                ),
              ),
              Container(
                padding: contentPadding,
                decoration: BoxDecoration(
                    color: (double.parse(
                        "${controller.postChapterQuizResultModel.result?.obtainMarks}") >
                        0)
                        ? ColorConstant.green.withOpacity(0.1)
                        : ColorConstant.red.withOpacity(0.1),
                    border: Border.all(
                        width: 2,
                        color: (double.parse(
                            "${controller.postChapterQuizResultModel.result?.obtainMarks}") >
                            0)
                            ? ColorConstant.green
                            : ColorConstant.red),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Text(
                        "${controller.postChapterQuizResultModel.result?.obtainMarks}",
                        style: TextStyleConstant.bold36(
                            color: (double.parse(
                                "${controller.postChapterQuizResultModel.result?.obtainMarks}") >
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
                                  "${controller.postChapterQuizResultModel.result?.obtainMarks}") >
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
                        AlwaysStoppedAnimation<Color>(Colors.green),
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
                    border:
                    Border.all(width: 2, color: ColorConstant.blue),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.300,
                      child: PieChart(
                        PieChartData(
                          sections: showingSections(
                              attemptedQuestions:
                              widget.attemptedQuestions,
                              unattemptedQuestions:
                              widget.unattemptedQuestions,
                              skippedQuestions: widget.skippedQuestion),
                          centerSpaceRadius: 20,
                          sectionsSpace: 2,
                          borderData: FlBorderData(show: false),
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event,
                                pieTouchResponse) {},
                          ),
                        ),
                      ),
                    ),
                    buildLegend(),
                  ],
                ),
              ),
        
              // SizedBox(height: screenHeightPadding),
              // Container(
              //   padding: contentPadding,
              //   decoration: BoxDecoration(
              //       color: ColorConstant.blue.withOpacity(0.1),
              //       border:
              //       Border.all(width: 2, color: ColorConstant.blue),
              //       borderRadius: BorderRadius.circular(16)),
              //   child: Column(
              //     children: [
              //       SizedBox(
              //         height: Get.height * 0.300,
              //         child: PieChart(
              //           PieChartData(
              //             sections: showingSecondSections(
              //                 rightAnswer: widget.rightAnswer,
              //                 wrongAnswer: widget.wrongAnswer,
              //                 skippedQuestions: widget.skippedQuestion +
              //                     widget.unattemptedQuestions),
              //             centerSpaceRadius: 20,
              //             sectionsSpace: 2,
              //             borderData: FlBorderData(show: false),
              //             pieTouchData: PieTouchData(
              //               touchCallback: (FlTouchEvent event,
              //                   pieTouchResponse) {},
              //             ),
              //           ),
              //         ),
              //       ),
              //       buildSecondLegend(),
              //     ],
              //   ),
              // ),

              SizedBox(height: screenHeightPadding),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeightPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: "Next Test",
                        onTap: () {
                          Get.offAll(() =>  ChapterFlashExerciseView(chapterId:widget.chapterid, userId:widget.userId, courseId: widget.courseid, testpaymentId: widget.testpaymentid,));
                        },
                      ),
                    ),
                    SizedBox(width: contentWidthPadding),
                    Expanded(
                      child: CustomButton(
                        title: "Restart Test",
                         onTap: () {
                          Get.back();  // Goes back to the previous screen
                          setState(() {
                            controller.resetQuiz();  // Resets the quiz
                          });
                        },
                      ),
                    )

                  ],
                ),
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}

List<PieChartSectionData> showingSections(
    {required double attemptedQuestions,
      required double unattemptedQuestions,
      required double skippedQuestions}) {
  return [
    PieChartSectionData(
        color: ColorConstant.green,
        value: attemptedQuestions,
        title: attemptedQuestions.toString().split(".")[0],
        radius: 100,
        titleStyle:
        TextStyleConstant.extraBold18(color: ColorConstant.white)),
    PieChartSectionData(
      color: ColorConstant.red,
      value: unattemptedQuestions,
      title: unattemptedQuestions.toString().split(".")[0],
      radius: 100,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      color: ColorConstant.grey,
      value: skippedQuestions,
      title: skippedQuestions.toString().split(".")[0],
      radius: 100,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ];
}

List<PieChartSectionData> showingSecondSections(
    {required double rightAnswer,
      required double wrongAnswer,
      required double skippedQuestions}) {
  return [
    PieChartSectionData(
        color: ColorConstant.green,
        value: rightAnswer,
        title: rightAnswer.toString().split(".")[0],
        radius: 100,
        titleStyle:
        TextStyleConstant.extraBold18(color: ColorConstant.white)),
    PieChartSectionData(
      color: ColorConstant.red,
      value: wrongAnswer,
      title: wrongAnswer.toString().split(".")[0],
      radius: 100,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      color: ColorConstant.grey,
      value: skippedQuestions,
      title: skippedQuestions.toString().split(".")[0],
      radius: 100,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ];
}

Widget buildLegend() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      buildLegendItem('Wrong Answer', ColorConstant.red),
      buildLegendItem('Right Answer', ColorConstant.green),
      // buildLegendItem('Skipped', ColorConstant.grey),
    ],
  );
}


Widget buildLegendItem(String title, Color color) {
  return Row(
    children: [
      Container(
        width: 16,
        height: 16,
        color: color,
      ),
      SizedBox(width: 8),
      Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
    ],
  );
}

Widget buildSecondLegend() {
  return SizedBox(
    height: Get.height * 0.020,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        buildLegendItem('Right Answer', ColorConstant.green),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.052),
          child: buildLegendItem('Wrong Answer', ColorConstant.red),
        ),
        buildLegendItem('Not Attempted', ColorConstant.grey),
      ],
    ),
  );
}