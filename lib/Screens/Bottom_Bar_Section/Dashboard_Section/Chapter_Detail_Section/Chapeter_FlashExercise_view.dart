// ignore: file_names
import 'dart:developer';

import 'package:firesafety/Widgets/custom_no_data_found.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:firesafety/Widgets/custom_shimmer.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Widgets/custom_textfield.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/FlashExreciseController.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';

class ChapterFlashExerciseView extends StatefulWidget {
  final String chapterId;
  final String userId;
  final String courseId;
  final String testpaymentId;

  const ChapterFlashExerciseView(
      {super.key,
      required this.chapterId,
      required this.userId,
      required this.courseId,
      required this.testpaymentId});

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
        .initialFunctioun(
            chapterId: widget.chapterId,
            userId: widget.userId,
            testPaymentId: widget.testpaymentId)
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: screenPadding,
        child: Obx(() {
          // Check if data is being fetched
          if (controller.isFetchingData.value) {
            return CustomShimmer(height: Get.height * 0.600);
          }

          // Check if results are available and the test is not being restarted
          if (controller.resultList.isNotEmpty &&
              !controller.isRestartTest.value) {
            // Check if the last result has `obtainMarks`
            if (controller.resultList.last.obtainMarks != null) {
              return ListView(
                children: [
                  // Result Card
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeightPadding,
                      bottom: screenHeightPadding,
                    ),
                    child: Card(
                      color: ColorConstant.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: screenPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Marks: ${controller.resultList.last.mark}",
                              style: TextStyleConstant.bold22(
                                color: ColorConstant.blue,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Get.height * 0.008,
                              ),
                              child: Text(
                                "Obtained Marks: ${controller.resultList.last.obtainMarks}",
                                style: TextStyleConstant.medium18(),
                              ),
                            ),
                            Text(
                              "Date: ${controller.resultList.last.tdate.toString().split(" ")[0]}",
                              style: TextStyleConstant.medium16(
                                color: ColorConstant.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Formative Result Details
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.resultList.last
                            .flashExerciseResultDetails?.length ??
                        0,
                    itemBuilder: (context, index) {
                      final element = controller
                          .resultList.last.flashExerciseResultDetails?[index];
                      return Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.010),
                        child: Card(
                          color: ColorConstant.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: screenPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Question
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.question_mark,
                                      color: ColorConstant.blue,
                                    ),
                                    SizedBox(width: Get.width * 0.016),
                                    Expanded(
                                      child: Text(
                                        "Q ${index + 1}: ${element?.question ?? ""}",
                                        style: TextStyleConstant.semiBold20(),
                                      ),
                                    ),
                                  ],
                                ),

                                // Marks
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Get.height * 0.008,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: ColorConstant.amber,
                                      ),
                                      SizedBox(width: Get.width * 0.016),
                                      Text(
                                        "Marks: ${element?.marks ?? ""}",
                                        style: TextStyleConstant.medium18(),
                                      ),
                                    ],
                                  ),
                                ),

                                // Comment
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.comment,
                                      color: ColorConstant.green,
                                    ),
                                    SizedBox(width: Get.width * 0.016),
                                    Expanded(
                                      child: Text(
                                        "Comment: ${element?.comment ?? ""}",
                                        style: TextStyleConstant.semiBold18(
                                            color: ColorConstant.black),
                                      ),
                                    ),
                                  ],
                                ),

                                // User Answer
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: Get.height * 0.008),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.edit,
                                        color: ColorConstant.orange,
                                      ),
                                      SizedBox(width: Get.width * 0.016),
                                      Expanded(
                                        child: Text(
                                          "Your Answer: ${element?.answer ?? ""}",
                                          style: TextStyleConstant.regular16(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Buttons
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeightPadding,
                      bottom: Get.height * 0.040,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            title: "Restart Test",
                            onTap: () {
                              controller.isRestartTest.value = true;
                            },
                          ),
                        ),
                        SizedBox(width: screenWidthPadding),
                        Expanded(
                            child: CustomButton(
                          title: "Finish",
                          onTap: () {
                            Get.offAll(() => const BottomBarScreen());
                          },
                        )),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              // Show "Test in Review" message
              return GestureDetector(
                onTap: () {
                  log("Data ::: ${controller.getFlashExcersiceResultListModel.flashExerciseResultList?.length}");
                },
                child: const CustomNoDataFound(
                    message:
                        "Your Give Test in Review\nResult will appear here soon"),
              );
            }
          }

          // Check if questions are available
          if (controller.questions.isNotEmpty) {
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
                          'Read a paragraph and then write it down exactly as it appears',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Question ${index + 1}: ${question.question}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: controller.controllers[question.id]!,
                          hintText: "Type Your Answer Here",
                          textInputType: TextInputType.multiline,
                          maxLine: null,
                          isExpand: true,
                          validator: controller.validateFields(),
                        ),
                        SizedBox(height: Get.height * 0.040),
                        CustomButton(
                          title: "Submit",
                          onTap: () {
                            if (controller.formKey.currentState!.validate()) {
                              showConfirmationDialog(
                                textEditingController:
                                    controller.controllers[question.id]!,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          // Default fallback for empty `questions`
          return const SizedBox();
        }),
      ),
    );
  }

  void showConfirmationDialog(
      {required TextEditingController textEditingController}) {
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
                        "6", // Replace with actual flash exercise type
                    testpaymentId: widget
                        .testpaymentId, // Replace with actual flash exercise type
                    textEditingController: textEditingController);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
