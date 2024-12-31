// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Controllers/ReadingTest_Controller.dart';
import 'package:firesafety/Models/ReadingTestAfterPurchesmodel.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/My_Course_Section/ReadingTestResult_View.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
import 'package:firesafety/Screens/ListeningWithMCQ_Screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadingScreenWithMCQ extends StatefulWidget {
  final String userId;
  final String quizType;
  final String id;

  const ReadingScreenWithMCQ({
    super.key,
    required this.userId,
    required this.quizType,
    required this.id,
  });

  @override
  State<ReadingScreenWithMCQ> createState() => _ReadingScreenWithMCQState();
}

class _ReadingScreenWithMCQState extends State<ReadingScreenWithMCQ> {
  final ReadingTestController controller = Get.put(ReadingTestController());

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    await controller.getReadListeningTest(
        type: "Reading Test", userId: widget.userId);

    if (controller.questions.isNotEmpty) {
      log("Question list: ${controller.questions}");
    }
  }

  backToDashboard() {
    Get.offAll(() => const BottomBarScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Reading Test"),
      body: WillPopScope(
        onWillPop: () => backToDashboard(),
        child: Obx(() {
          if (controller.questions.isEmpty) {
            return const CustomNoDataFound();
          }

          final currentQuestion =
              controller.questions[controller.currentQuestionIndex.value];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Paragraph Section
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: ColorConstant.primary, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                      color: ColorConstant.primary.withOpacity(0.1),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      controller.paragraph.value,
                      style: const TextStyle(fontSize: 16.0, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Question Section
                  Row(
                    children: [
                      Text(
                        "Q ${controller.currentQuestionIndex.value + 1}. ",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Expanded(
                        child: Text(
                          currentQuestion.question,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Options Section
                  ...currentQuestion.options.map((option) {
                    return OptionButton(
                      option: option,
                      isSelected: controller.selectedAnswer.value == option,
                      isCorrect: controller.isAnswered.value &&
                          option == currentQuestion.correctAnswer,
                      isWrong: controller.isAnswered.value &&
                          option != currentQuestion.correctAnswer &&
                          controller.selectedAnswer.value == option,
                      onPressed: () {
                        if (!controller.isAnswered.value) {
                          controller.checkAnswer(option);
                        }
                      },
                    );
                  }),

                  // Next/Submit Button Section
                  if (controller.isAnswered.value)
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 24.0),
                            backgroundColor: ColorConstant.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            if (controller.currentQuestionIndex.value <
                                controller.questions.length - 1) {
                              controller
                                  .nextQuestion(); // Move to next question
                            } else {
                              // Submit the result and navigate to result screen
                              controller
                                  .postReadingTestResult(
                                testId:
                                    "${controller.readListenTestTypeWiseModel.readingListeningTestDetailsList?.first.readListeningTestId}",
                                userId: widget.userId,
                                type: widget.quizType,
                                id: widget.id,
                              )
                                  .then((_) {
                                debugPrint(
                                    'Post Reading Test Result successful');
                                Get.offAll(() => RedingTestResultView(
                                      testListId: controller
                                              .readListenTestTypeWiseModel
                                              .readingListeningTestDetailsList?[
                                                  0]
                                              .id ??
                                          '',
                                      testName: 'Quiz Test',
                                      attemptedQuestions:
                                          (controller.correctAnswers.value)
                                              .toDouble(),
                                      unattemptedQuestions: (controller
                                                  .questions.length -
                                              (controller.correctAnswers.value))
                                          .toDouble(),
                                      skippedQuestion:
                                          0.0, // Assuming skipped questions are 0
                                      rightAnswer:
                                          (controller.correctAnswers.value)
                                              .toDouble(),
                                      wrongAnswer:
                                          (controller.wrongAnswers.value)
                                              .toDouble(),
                                      answeredList: controller.questions,
                                      userId: widget.userId,
                                      id: widget.id,
                                      totalMarks: double.tryParse(
                                              "${controller.postReadingResultModel.result?.totalMarks}") ??
                                          0.0,
                                      obtainMarks: double.tryParse(
                                              "${controller.postReadingResultModel.result?.obtainMarks}") ??
                                          0.0,
                                    ));
                              }).catchError((error) {
                                debugPrint(
                                    'Error in postReadingTestResult: $error');
                              });
                            }
                          },
                          child: (controller.currentQuestionIndex.value <
                                  controller.questions.length - 1)
                              ? const Text(
                                  'Next Question',
                                  style: TextStyle(
                                      fontSize: 16, color: ColorConstant.white),
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontSize: 16, color: ColorConstant.white),
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void showResultDialog() {
    Get.dialog(AlertDialog(
      title: const Text('Quiz Results'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: ListTile(
              title: Text(
                  'Obtain Marks: ${controller.postReadingResultModel.result?.obtainMarks}'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                  'Total Marks: ${controller.postReadingResultModel.result?.totalMarks}'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Right Answers: ${controller.correctAnswers}'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Wrong Answers: ${controller.wrongAnswers}'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            controller.resetQuiz();
            _loadQuizData(); // Reload quiz data after reset
          },
          child: const Text('Restart Quiz'),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ListeningWithMcqView(userId: widget.userId, id: widget.id),
              ),
            );
          },
          child: const Text('Next Page'),
        ),
      ],
    ));
  }
}

class OptionButton extends StatelessWidget {
  final String option;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onPressed;

  const OptionButton({
    super.key,
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: (isCorrect)
              ? ColorConstant.green
              : (isWrong)
                  ? ColorConstant.red
                  : (isSelected)
                      ? ColorConstant.primary.withOpacity(0.2)
                      : Colors.grey[200],
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onPressed: onPressed,
        child: Text(
          option,
          style: TextStyle(
              fontSize: 16,
              color: (isCorrect)
                  ? ColorConstant.white
                  : (isWrong)
                      ? ColorConstant.white
                      : (isSelected)
                          ? ColorConstant.black
                          : ColorConstant.black),
        ),
      ),
    );
  }
}
