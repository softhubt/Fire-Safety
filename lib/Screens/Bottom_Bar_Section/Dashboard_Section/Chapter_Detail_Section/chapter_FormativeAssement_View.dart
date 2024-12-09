import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/Foramative_assessment_Controller.dart';

class FormativeAssesmentView extends StatefulWidget {
  final String chapterId;
  final String userId;
  final String courseId;
  final String testpaymentId;

  const FormativeAssesmentView({
    super.key,
    required this.chapterId,
    required this.userId,
    required this.courseId,
    required this.testpaymentId,
  });

  @override
  State<FormativeAssesmentView> createState() => _FormativeAssesmentViewState();
}

class _FormativeAssesmentViewState extends State<FormativeAssesmentView> {
  late final ChapterFormativeAssessmentController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChapterFormativeAssessmentController());

    // Fetch formative assessment data here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getFormativeAssessmentList(
        chapterId: widget.chapterId,
        userId: widget.userId,
      );
    });
  }

  // Function to show the confirmation dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit Test'),
          content: Text('Are you sure you want to submit your answers?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Submit the test if the user confirms
                if (controller.formKey.currentState!.validate()) {
                  controller.submitFormativeAssesmentTest(
                    userId: widget.userId,
                    chapterId: widget.chapterId,
                    courseId: widget.courseId, // Pass the actual course ID
                    testFormativeType: "5", // Replace with actual test formative type
                    testpaymentid: widget.testpaymentId, // Pass the actual test payment ID
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formative Assessment'),
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
        onPressed: _showConfirmationDialog, // Show confirmation dialog on press
        child: Icon(Icons.send),
      ),
    );
  }
}