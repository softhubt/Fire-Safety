import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/WritingTestController.dart'; // Ensure this import matches your file structure
import 'package:firesafety/Screens/ReadingTest_WithMCQ_Screen.dart';
import 'package:firesafety/Widgets/custom_button.dart';

class WritingTestPage extends StatelessWidget {
  final String userId;

  const WritingTestPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final WritingTestController controller = Get.put(WritingTestController());
    final TextEditingController answerController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title:
            const Text('Writing Test', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        final model = controller.getWriteTestModel.value;

        // Check if proficiencyTestDetailsList is available and not empty
        if (model.proficiencyTestDetailsList != null &&
            model.proficiencyTestDetailsList!.isNotEmpty) {
          final questionDetails =
              model.proficiencyTestDetailsList!.first.questionDetails;
          final questionId = model.proficiencyTestDetailsList!.first.id;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Upper part with paragraph (half screen height)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Display questionDetails from the API using flutter_html
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Html(
                          data: questionDetails ??
                              'No question details available',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Divider
              Divider(
                color: Colors.grey,
                thickness: 2,
                height: 20,
              ),
              // Writing field
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: answerController,
                  maxLines: null, // Allow multiple lines for writing
                  decoration: InputDecoration(
                    hintText: 'Start writing here...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          );
        } else {
          // Show loading indicator or empty state if no data
          return Center(child: CircularProgressIndicator());
        }
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          title: "Submit",
          onTap: () {
            final answer = answerController.text;
            final questionId = controller.getWriteTestModel.value
                    .proficiencyTestDetailsList?.first.id ??
                '';
            controller.submitWritingTest(
                questionId: questionId, answer: answer);
          },
        ),
      ),
    );
  }
}
