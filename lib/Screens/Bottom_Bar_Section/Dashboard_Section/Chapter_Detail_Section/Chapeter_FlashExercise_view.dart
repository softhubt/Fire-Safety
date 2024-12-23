import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:firesafety/Widgets/custom_textfield.dart';
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
  final FlasExerciseController controller = Get.put(FlasExerciseController());

  @override
  void initState() {
    super.initState();
    controller
        .initialFunctioun(chapterId: widget.chapterId, userId: widget.userId)
        .whenComplete(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    controller.controllers.forEach((key, controller) => controller.dispose());
    for (var node in controller.focusNodes) {
      node.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: screenPadding,
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
                            const SizedBox(height: 20),
                            Text(
                              'Question ${index + 1}: ${question.question}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                                controller:
                                    controller.controllers[question.id]!,
                                hintText: "Type Your Answer Here",
                                textInputType: TextInputType.multiline,
                                maxLine: null,
                                isExpand: true,
                                validator: controller.validateFields()),
                            SizedBox(height: Get.height * 0.040),
                            CustomButton(
                                title: "Submit",
                                onTap: () {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    showConfirmationDialog();
                                  }
                                }),
                          ],
                        ));
                  },
                ));
          })),
    );
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Test'),
          content: const Text('Are you sure you want to submit your answers?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.submitFlashExerciseTest(
                  userId: widget.userId,
                  chapterId: widget.chapterId,
                  courseId: widget.courseId, // Pass the actual course ID
                  flashExerciseType:
                      "5", // Replace with actual flash exercise type
                  testpaymentId: widget
                      .testpaymentId, // Replace with actual flash exercise type
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
