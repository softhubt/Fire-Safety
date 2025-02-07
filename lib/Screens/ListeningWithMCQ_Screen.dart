// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:firesafety/Controllers/ListeningTest_Controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/My_Course_Section/ListeningTestWithQuizRuselt_View.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class ListeningWithMcqView extends StatefulWidget {
  final String userId;
  final String id;

  const ListeningWithMcqView({
    super.key,
    required this.userId,
    required this.id,
  });
  @override
  _ListeningWithMcqViewState createState() => _ListeningWithMcqViewState();
}

class _ListeningWithMcqViewState extends State<ListeningWithMcqView> {
  final ListeningTestController controller = Get.put(ListeningTestController());
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _audioDuration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadQuizData();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _audioDuration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
      });
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
      });
    });

    controller.initialFunction().whenComplete(() => setState(() {}));
  }

  Future<void> _loadQuizData() async {
    await controller.getListeningTest(
        userId: widget.userId, type: "Listening Test");
  }

  backToDashboard() {
    Get.offAll(() => const BottomBarScreen());
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPauseAudio() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(UrlSource(controller.audioUrl.value));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error playing audio: $e')));
    }
  }

  void _submitAnswers() {
    controller
        .postListeningTestResult(
            testId:
                "${controller.listenTestTypeWiseModel.readingListeningTestDetailsList?.first.readListeningTestId}",
            type: "Listening Test",
            id: widget.id)
        .then((_) {
      // Navigate to the result screen
      Get.to(() => ListeningestResultView(
          testListId: controller.listenTestTypeWiseModel
                  .readingListeningTestDetailsList?[0].id ??
              '',
          testName: 'Quiz Test',
          attemptedQuestions: (controller.correctAnswers.value ?? 0).toDouble(),
          unattemptedQuestions: ((controller.questions.length -
                      (controller.correctAnswers.value)) ??
                  0)
              .toDouble(),
          skippedQuestion: 0.0,
          rightAnswer: (controller.correctAnswers.value ?? 0).toDouble(),
          wrongAnswer: (controller.wrongAnswers.value ?? 0).toDouble(),
          answeredList: controller.questions,
          userId: widget.userId));
    });
  }

  void _showResultDialog() {
    Get.dialog(AlertDialog(
      title: const Text('Quiz Results'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
              child: ListTile(
                  title: Text(
                      'Obtain Marks: ${controller.postListeningResultModel.result?.obtainMarks}'))),
          const SizedBox(height: 8.0),
          Card(
              child: ListTile(
                  title: Text(
                      'Total Marks: ${controller.postListeningResultModel.result?.totalMarks}'))),
          Card(
              child: ListTile(
                  title: Text('Right Answers: ${controller.correctAnswers}'))),
          const SizedBox(height: 8.0),
          Card(
              child: ListTile(
                  title: Text('Wrong Answers: ${controller.wrongAnswers}'))),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            controller.resetQuiz();
          },
          child: const Text('Restart Quiz'),
        ),
        TextButton(
            onPressed: () {
              Get.offAll(() => const BottomBarScreen(currentIndex: 1));
            },
            child: const Text('Next Page')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "Listening Test"),
        body: WillPopScope(
          onWillPop: () => backToDashboard(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              if (controller.questions.isEmpty) {
                return const CustomNoDataFound();
              }

              final currentQuestion =
                  controller.questions[controller.currentQuestionIndex.value];

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 70,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                              colors: [Colors.blueAccent, Colors.indigo],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: _playPauseAudio,
                          ),
                          Expanded(
                            child: Text(
                              '${_position.toString().split('.').first} / ${_audioDuration.toString().split('.').first}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                        "Q ${controller.currentQuestionIndex.value + 1}. ${currentQuestion.question}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
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
                    if (controller.isAnswered.value)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.currentQuestionIndex.value <
                                controller.questions.length - 1) {
                              controller.nextQuestion();
                            } else {
                              _submitAnswers();
                            }
                          },
                          child: Text((controller.currentQuestionIndex.value <
                                  controller.questions.length - 1)
                              ? 'Next Question'
                              : 'Submit'),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                CustomButton(title: "Submit", onTap: () => _submitAnswers())));
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
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isCorrect
              ? Colors.green
              : isWrong
                  ? Colors.red
                  : isSelected
                      ? Colors.grey[300]
                      : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey[400]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCorrect || isWrong ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
