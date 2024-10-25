import 'package:firesafety/Controllers/ListeningTest_Controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/My_Course_Section/my_course_screen.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class ListeningWithMcqView extends StatefulWidget {
  final String userId;

  const ListeningWithMcqView({
    Key? key,
    required this.userId,
  }) : super(key: key);
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
  }

  Future<void> _loadQuizData() async {
    await controller.getListeningTest(
        userId: widget.userId, type: "Listening Test");
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
        // Use the dynamic audio URL from the controller
        await _audioPlayer.play(UrlSource(controller.audioUrl.value));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error playing audio: $e')));
    }
  }

  void _submitAnswers() {
    // Submit answers logic
    controller
        .postListeningTestResult(
          testId: controller.listenTestTypeWiseModel
                  .readingListeningTestDetailsList?[0].readListeningTestId ??
              '',
          type: "Listening Test",
        )
        .whenComplete(() => _showResultDialog());
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
            Get.to(() => MyCourseListView());
          },
          child: const Text('Next Page'),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Listening Test', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                  height: 50,
                  width: 300,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 5.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: _playPauseAudio,
                      ),
                      Expanded(
                        child: Text(
                          '${_position.toString().split('.').first} / ${_audioDuration.toString().split('.').first}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                    "${controller.currentQuestionIndex.value + 1}. ${currentQuestion.question}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _submitAnswers,
          child: Text('Submit'),
        ),
      ),
    );
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
