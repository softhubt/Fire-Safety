// ignore_for_file: deprecated_member_use

import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_textfield.dart';
import 'package:firesafety/Widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/WritingTestController.dart'; // Ensure this import matches your file structure
import 'package:firesafety/Widgets/custom_button.dart';

class WritingTestPage extends StatefulWidget {
  final String userId;
  final String id;

  const WritingTestPage({super.key, required this.userId, required this.id});

  @override
  State<WritingTestPage> createState() => _WritingTestPageState();
}

class _WritingTestPageState extends State<WritingTestPage> {
  backToDashboard() {
    Get.offAll(() => const BottomBarScreen());
  }

  @override
  Widget build(BuildContext context) {
    final WritingTestController controller = Get.put(WritingTestController());
    final TextEditingController answerController = TextEditingController();

    return Scaffold(
      appBar: const CustomAppBar(title: "Writing Test"),
      body: WillPopScope(
        onWillPop: () => backToDashboard(),
        child: Obx(() {
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
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Markdown(
                            data: questionDetails ??
                                'No question details available')),
                  ],
                ))),
                Padding(
                    padding: screenHorizontalPadding,
                    child: CustomTextField(
                        controller: answerController,
                        hintText: "Start Writing Here...",
                        isExpand: true,
                        textInputType: TextInputType.multiline)),
              ],
            );
          } else {
            // Show loading indicator or empty state if no data
            return const Center(child: CircularProgressIndicator());
          }
        }),
      ),
      bottomNavigationBar: Padding(
        padding: screenPadding,
        child: CustomButton(
          title: "Submit",
          onTap: () {
            final questionId = controller.getWriteTestModel.value
                    .proficiencyTestDetailsList?.first.id ??
                '';

            if (answerController.text.isNotEmpty) {
              controller.submitWritingTest(
                  questionId: questionId,
                  answer: answerController.text,
                  id: widget.id);
            } else {
              customToast(message: "Answer is Empty");
            }
          },
        ),
      ),
    );
  }
}
