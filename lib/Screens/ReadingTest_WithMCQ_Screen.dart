import 'dart:developer';
import 'package:firesafety/Controllers/ReadingTest_Controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/My_Course_Section/ReadingTestResult_View.dart';
import 'package:firesafety/Screens/ListeningWithMCQ_Screen.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadingScreenWithMCQ extends StatefulWidget {
  final String userId;
  final String quizType;
  final String id;

  const ReadingScreenWithMCQ({
    Key? key,
    required this.userId,
    required this.quizType, required this.id,
  }) : super(key: key);

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
      type: "Reading Test",
      userId: widget.userId,
    );

    if (controller.questions.isNotEmpty) {
      log("Question list: ${controller.questions}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Test'),
      ),
      body: Obx(() {
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        controller.paragraph.value,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Text(
                        "${controller.currentQuestionIndex.value + 1}. ",
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
                        controller.checkAnswer(option);
                      }
                    },
                  );
                }).toList(),
                if (controller.isAnswered.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      // Inside the ElevatedButton onPressed:
                      onPressed: () {
                        if (controller.currentQuestionIndex.value < controller.questions.length - 1) {
                          controller.nextQuestion(); // Move to next question
                        } else {
                          // Once the last question is reached, submit the result
                          controller.postReadingTestResult(
                            testId: controller.questions[0].id,
                            userId: widget.userId,
                            type: widget.quizType,
                            id: widget.id,
                          ).then((_) {
                            // Navigate to the result screen
                            Get.to(() => RedingTestResultView(
                              testListId: controller.readListenTestTypeWiseModel
                                  .readingListeningTestDetailsList?[0].id ?? '',
                              testName: 'Quiz Test',
                              attemptedQuestions: controller.correctAnswers.value.toDouble(),
                              unattemptedQuestions: (controller.questions.length - controller.correctAnswers.value).toDouble(),
                              skippedQuestion: 0.0, // Assuming skipped questions are 0
                              rightAnswer: controller.correctAnswers.value.toDouble(),
                              wrongAnswer: controller.wrongAnswers.value.toDouble(),
                              answeredList: controller.questions,
                            ));
                          });
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
          ),
        );
      }),
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
          const SizedBox(height: 8.0),
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
          const SizedBox(height: 8.0),
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
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ListeningWithMcqView(userId: widget.userId,id:widget.id),
                ),
              );
            },
            child: const Text('Next page'),
          ),
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
    Key? key,
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onPressed,
  }) : super(key: key);

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

