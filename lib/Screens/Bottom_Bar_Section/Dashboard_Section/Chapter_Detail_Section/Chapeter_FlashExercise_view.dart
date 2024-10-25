import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/FlashExreciseController.dart';
// Update this path according to your project structure

class ChapterFlashExerciseView extends StatefulWidget {
  final String chapterId;
  final String userId;
  final String courseId;

  const ChapterFlashExerciseView({
    super.key,
    required this.chapterId,
    required this.userId,
    required this.courseId,
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
      appBar: AppBar(
        title: Text('Flash Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.questions.isEmpty) {
            return Center(
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
                      Text(
                        ' Read a paragraph and then write it down exactly as it appears ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Question ${index + 1}: ${question.question}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: controller.controllers[question.id],
                        focusNode: controller.focusNodes[index],
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
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
          if (controller.formKey.currentState!.validate()) {
            // Submit the answers
            controller.submitFlashExerciseTest(
              userId: widget.userId,
              chapterId: widget.chapterId,
              courseId: widget.courseId, // Pass the actual course ID
              flashExerciseType: "5", // Replace with actual flash exercise type
            );
          }
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
