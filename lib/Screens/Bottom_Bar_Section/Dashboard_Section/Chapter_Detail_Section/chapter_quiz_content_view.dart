import 'dart:developer';
import 'package:firesafety/Screens/ListeningWithMCQ_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/chapter_quiz_content_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/ElementQuizeTestResult_View.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';

class ChapterQuizContentView extends StatefulWidget {
  final String chapterId;
  final String topicId;
  final String userId;
  final String quizType;
  final String testpaymentId;

  const ChapterQuizContentView({
    Key? key,
    required this.chapterId,
    required this.topicId,
    required this.userId,
    required this.quizType,
    required this.testpaymentId,
  }) : super(key: key);

  @override
  State<ChapterQuizContentView> createState() => _ChapterQuizContentViewState();
}

class _ChapterQuizContentViewState extends State<ChapterQuizContentView> {
  late final ChapterQuizContentController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChapterQuizContentController());
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    await controller.getQuizList(
      chapterId: widget.chapterId,
      topicId: widget.topicId,
      userId: widget.userId,
      type: widget.quizType,
    );
    if (controller.questions.isNotEmpty) {
      log("Question list ::: ${controller.questions}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Obx(() {
        if (controller.questions.isEmpty) {
          return const CustomNoDataFound();
        }

        final currentQuestion =
        controller.questions[controller.currentQuestionIndex.value];

        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Text(
                      "${controller.currentQuestionIndex.value + 1}. ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Expanded(
                      child: Text(
                        currentQuestion.text,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              ...currentQuestion.options.map((option) {
                return OptionButton(
                  option: option,
                  isSelected: controller.selectedAnswer.value == option,
                  isCorrect: controller.isAnswered.value && option == currentQuestion.correctAnswer,
                  isWrong: controller.isAnswered.value && option != currentQuestion.correctAnswer && controller.selectedAnswer.value == option,
                  onPressed: () {
                    if (!controller.isAnswered.value) {
                      setState(() {
                        controller.checkAnswer(option);
                      });
                    }
                  },
                );
              }).toList(),

              if (controller.isAnswered.value)
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.currentQuestionIndex.value <
                          controller.questions.length - 1) {
                        setState(() {
                          controller.nextQuestion();
                        });
                      } else {
                        controller.postQuizResult(
                          testId: controller.getChapterQuizListModel
                              .testDetailsList?[0].testId ?? '',
                          courseid: controller.getChapterQuizListModel
                              .testDetailsList?[0].courseName ?? '',
                          chapterid: controller.getChapterQuizListModel
                              .testDetailsList?[0].chapterId ?? '',
                          topicid: controller.getChapterQuizListModel
                              .testDetailsList?[0].topicid ?? '',
                          userId: widget.userId,
                          type: widget.quizType,
                          testpaymentid: widget.testpaymentId,
                        )
                            .then((_) {
                          Get.to(() =>
                              TestResultView(
                                testListId: controller.getChapterQuizListModel
                                    .testDetailsList?[0].testId ?? '',
                                testName: 'Quiz Test',
                                attemptedQuestions: controller.correctAnswers.value.toDouble(),
                                unattemptedQuestions: (controller.questions.length - controller.correctAnswers.value).toDouble(),
                                skippedQuestion: 0.0, // Assuming skipped questions are represented as double
                                rightAnswer: controller.correctAnswers.value.toDouble(),
                                wrongAnswer: controller.wrongAnswers.value.toDouble(),
                                answeredList: controller.questions,
                              )
                          );
                        }
                        );
                      }
                    },
                    child: (controller.currentQuestionIndex.value <
                        controller.questions.length - 1)
                        ? const Text('Next Question')
                        : const Text('Submit'),
                  ),
                ),
            ],
          ),
        );
      }),
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
