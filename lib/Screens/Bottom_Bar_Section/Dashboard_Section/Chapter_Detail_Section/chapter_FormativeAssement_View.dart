import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';
import 'package:firesafety/Widgets/custom_shimmer.dart';
import 'package:firesafety/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/Foramative_assessment_Controller.dart';

class FormativeAssesmentView extends StatefulWidget {
  final String chapterId;
  final String userId;
  final String courseId;
  final String testpaymentId;

  const FormativeAssesmentView(
      {super.key,
      required this.chapterId,
      required this.userId,
      required this.courseId,
      required this.testpaymentId});

  @override
  State<FormativeAssesmentView> createState() => _FormativeAssesmentViewState();
}

class _FormativeAssesmentViewState extends State<FormativeAssesmentView> {
  final ChapterFormativeAssessmentController controller =
      Get.put(ChapterFormativeAssessmentController());

  @override
  void initState() {
    super.initState();
    controller.initialFunctioun(
        chapterId: widget.chapterId,
        userId: widget.userId,
        testPaymentId: widget.testpaymentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: screenHorizontalPadding,
        child: Obx(() {
          return (controller.isFetchingData.value)
              ? CustomShimmer(height: Get.height * 0.600)
              : (controller.resultList.isNotEmpty &&
                      controller.isRestartExam.value == false)
                  ? (controller.resultList.last.obtainMarks != null)
                      ? ListView(
                          children: [
                            // Display Marks
                            Padding(
                                padding: EdgeInsets.only(
                                    top: screenHeightPadding,
                                    bottom: screenHeightPadding),
                                child: Card(
                                    color: ColorConstant.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Padding(
                                        padding: screenPadding,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Marks: ${controller.resultList.last.mark}",
                                                style: TextStyleConstant.bold22(
                                                    color: ColorConstant.blue)),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        Get.height * 0.008),
                                                child: Text(
                                                    "Obtained Marks: ${controller.resultList.last.obtainMarks}",
                                                    style: TextStyleConstant
                                                        .medium18())),
                                            Text(
                                                "Date: ${controller.resultList.last.tdate.toString().split(" ")[0]}",
                                                style:
                                                    TextStyleConstant.medium16(
                                                        color: ColorConstant
                                                            .grey)),
                                          ],
                                        )))),

                            // Formative Result Details
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.resultList.last
                                  .formativeResultDetails?.length,
                              itemBuilder: (context, index) {
                                final element = controller.resultList.last
                                    .formativeResultDetails?[index];
                                return Padding(
                                  padding:
                                      EdgeInsets.only(top: Get.height * 0.010),
                                  child: Card(
                                    color: ColorConstant.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Padding(
                                      padding: screenPadding,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Question
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.question_mark,
                                                  color: ColorConstant.blue),
                                              SizedBox(
                                                  width: Get.width * 0.016),
                                              Expanded(
                                                  child: Text(
                                                      "Q ${index + 1}: ${element?.question ?? ""}",
                                                      style: TextStyleConstant
                                                          .semiBold20())),
                                            ],
                                          ),

                                          // Marks
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Get.height * 0.008),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.star,
                                                      color:
                                                          ColorConstant.amber),
                                                  SizedBox(
                                                      width: Get.width * 0.016),
                                                  Text(
                                                      "Marks: ${element?.marks ?? ""}",
                                                      style: TextStyleConstant
                                                          .medium18()),
                                                ],
                                              )),

                                          // Comment
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.comment,
                                                  color: ColorConstant.green),
                                              SizedBox(
                                                  width: Get.width * 0.016),
                                              Expanded(
                                                child: Text(
                                                  "Comment: ${element?.comment ?? ""}",
                                                  style: TextStyleConstant
                                                      .semiBold18(
                                                          color: ColorConstant
                                                              .green),
                                                ),
                                              ),
                                            ],
                                          ),

                                          // User Answer
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: Get.height * 0.008),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.edit,
                                                    color:
                                                        ColorConstant.orange),
                                                SizedBox(
                                                    width: Get.width * 0.016),
                                                Expanded(
                                                  child: Text(
                                                    "Your Answer: ${element?.answer ?? ""}",
                                                    style: TextStyleConstant
                                                        .regular16(),
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
                            Padding(
                                padding: EdgeInsets.only(
                                    top: screenHeightPadding,
                                    bottom: Get.height * 0.040),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: CustomButton(
                                      title: "Restart Test",
                                      onTap: () {
                                        controller.isRestartExam.value = true;
                                      },
                                    )),
                                    SizedBox(width: screenWidthPadding),
                                    Expanded(
                                        child: CustomButton(
                                      title: "Finish",
                                      onTap: () {
                                        Get.offAll(
                                            () => const BottomBarScreen());
                                      },
                                    )),
                                  ],
                                )),
                          ],
                        )
                      : const CustomNoDataFound(
                          message:
                              "Your Give test is in Review\nResult will apper here soon")
                  : (controller.questions.isNotEmpty)
                      ? ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenHeightPadding,
                                  bottom: Get.height * 0.040),
                              child: Form(
                                  key: controller.formKey,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller.questions.length,
                                    itemBuilder: (context, index) {
                                      final question =
                                          controller.questions[index];
                                      return Padding(
                                          padding: EdgeInsets.only(
                                              top: screenHeightPadding),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Question ${index + 1}: ${question.question}',
                                                  style: TextStyleConstant
                                                      .semiBold18()),
                                              const SizedBox(height: 8),
                                              CustomTextField(
                                                  controller:
                                                      controller.controllers[
                                                          question.id]!,
                                                  hintText:
                                                      "Type Your Answer Here",
                                                  textInputType:
                                                      TextInputType.multiline,
                                                  maxLine: null,
                                                  isExpand: true,
                                                  validator: controller
                                                      .validateFields())
                                            ],
                                          ));
                                    },
                                  )),
                            ),
                            CustomButton(
                                title: "Submit",
                                onTap: () {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    showConfirmationDialog();
                                  }
                                }),
                            SizedBox(height: Get.height * 0.040),
                          ],
                        )
                      : const CustomNoDataFound();
        }),
      ),
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
                controller.submitFormativeAssesmentTest(
                  userId: widget.userId,
                  chapterId: widget.chapterId,
                  courseId: widget.courseId,
                  testFormativeType: "5",
                  testpaymentid: widget.testpaymentId,
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
