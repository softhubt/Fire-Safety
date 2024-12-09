import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/FlashExreciseController.dart';

class ChapterFlashExerciseView extends StatefulWidget {
  final String chapterId;
  final String userId;
  final String courseId;
  final String testpaymentId;

  const ChapterFlashExerciseView({
    super.key,
    required this.chapterId,
    required this.userId,
    required this.courseId,
    required this.testpaymentId,
  });

  @override
  State<ChapterFlashExerciseView> createState() =>
      _ChapterFlashExerciseViewState();
}

class _ChapterFlashExerciseViewState extends State<ChapterFlashExerciseView> {
  late final FlasExerciseController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(FlasExerciseController());

    // Fetch formative assessment data here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getFlashExercise(
        chapterId: widget.chapterId,
        userId: widget.userId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Flash Exercise'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.questions.isEmpty) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show loader while data is being fetched
          }

          return Form(
            key: controller.formKey,
            child: ListView.builder(
              itemCount: controller.questions.length,
              itemBuilder: (context, index) {
                final question = controller.questions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        ' Read a paragraph and then write it down exactly as it appears ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Question ${index + 1}: ${question.question}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.controllers[question.id],
                        focusNode: controller.focusNodes[index],
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Type your answer here...',
                        ),
                        validator: (value) => controller.validateAnswer(value),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a confirmation dialog before submitting the test
          _showConfirmationDialog();
        },
        child: const Icon(Icons.send),
      ),
    );
  }

  // Function to show a confirmation dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Submission'),
          content: const Text('Are you sure you want to submit your answers?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog without doing anything
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog and submit the test
                Navigator.of(context).pop();
                _submitTest();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle the test submission
  void _submitTest() {
    if (controller.formKey.currentState!.validate()) {
      // Submit the answers
      controller.submitFlashExerciseTest(
        userId: widget.userId,
        chapterId: widget.chapterId,
        courseId: widget.courseId, // Pass the actual course ID
        flashExerciseType: "5", // Replace with actual flash exercise type
        testpaymentId:
            widget.testpaymentId, // Replace with actual flash exercise type
      );
    }
  }
}
