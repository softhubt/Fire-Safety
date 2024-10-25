import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/chapter_quiz_content_controller.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';

class ChapterQuizContentView extends StatefulWidget {
  final String chapterId;
  final String topicId;
  final String userId;
  final String quizType;

  const ChapterQuizContentView({
    super.key,
    required this.chapterId,
    required this.topicId,
    required this.userId,
    required this.quizType,
  });

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
    // Check if questions are not empty
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
          // Display a no data found widget
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                        controller
                            .postQuizResult(
                              testId: controller.getChapterQuizListModel
                                      .testDetailsList?[0].testId ??
                                  '',
                              courseid: controller.getChapterQuizListModel
                                      .testDetailsList?[0].courseName ??
                                  '',
                              chapterid: controller.getChapterQuizListModel
                                      .testDetailsList?[0].chapterId ??
                                  '',
                              topicid: controller.getChapterQuizListModel
                                      .testDetailsList?[0].topicid ??
                                  '',
                              userId: widget.userId,
                              type: widget.quizType,
                            )
                            .whenComplete(() => showResultDialog());
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

  void showResultDialog() {
    Get.dialog(AlertDialog(
      title: const Text('Quiz Results'),
      content: Column(
        children: [
          Card(
            child: ListTile(
              title: Text(
                  'Obtain Marks: ${controller.postChapterQuizResultModel.result?.obtainMarks}'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: ListTile(
                title: Text(
                    'Total Marks: ${controller.postChapterQuizResultModel.result?.totalMarks}'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                  'Right Answers: ${controller.postChapterQuizResultModel.result?.rightAnswers}'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Card(
              child: ListTile(
                title: Text(
                    'Wrong Answers: ${controller.postChapterQuizResultModel.result?.wrongAnswers}'),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            setState(() {
              controller.resetQuiz();
            });
          },
          child: const Text('Restart Quiz'),
        ),
      ],
    ));
  }
}

class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String id;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.id,
  });
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
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isCorrect
              ? Colors.green
              : isWrong
                  ? Colors.red
                  : isSelected
                      ? Colors.grey
                      : null,
        ),
        onPressed: onPressed,
        child: Text(option),
      ),
    );
  }
}
