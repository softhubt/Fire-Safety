// import 'dart:developer';
//
// import 'package:firesafety/Constant/color_constant.dart';
// import 'package:firesafety/Constant/layout_constant.dart';
// import 'package:firesafety/Constant/textstyle_constant.dart';
// import 'package:firesafety/Controllers/ForamativeAssesmentResultView_Controller.dart';
// import 'package:firesafety/Controllers/Foramative_assessment_Controller.dart';
// import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
// import 'package:firesafety/Widgets/custom_appbar.dart';
// import 'package:firesafety/Widgets/custom_button.dart';
// import 'package:firesafety/Widgets/custom_shimmer.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
//
// class FormativeAssesmentResultView extends StatefulWidget {
//   final String testListId;
//
//
//   const FormativeAssesmentResultView(
//       {super.key,
//         required this.testListId,
//
//       });
//
//   @override
//   State<FormativeAssesmentResultView> createState() => _FormativeAssesmentResultViewState();
// }
//
// class _FormativeAssesmentResultViewState extends State<FormativeAssesmentResultView> {
//   //TestResultController controller = Get.put(TestResultController());
//   FormativeTestResultViewController controller = Get.put(FormativeTestResultViewController());
//
//   @override
//   void initState() {
//     super.initState();
//     controller
//         .initialFunctioun(testListId: widget.testListId)
//         .whenComplete(() => setState(() {}));
//   }
//
//   Future<bool> handelWillpop() async {
//     Get.offAll(() => BottomBarScreen());
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: const CustomAppBar(title: "Test Result"),
//         body: WillPopScope(
//           onWillPop: () {
//             return handelWillpop();
//           },
//           child: (controller.postFormativeAssessmentResultModel.formativeAssessmentResultList != null)
//               ? Padding(
//             padding: screenHorizontalPadding,
//             child: ListView(
//               children: [
//                 // Padding(
//                 //   padding: EdgeInsets.only(
//                 //       top: screenHeightPadding,
//                 //       bottom: screenHeightPadding),
//                 //   child:
//                 //   Text("Test Name: ${widget.testName}",
//                 //       style: TextStyleConstant.medium18()),
//                 // ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Text(
//                         "Total Marks: ${controller.postFormativeAssessmentResultModel.formativeAssessmentResultList?.last.mark ?? ""}",
//                         style: TextStyleConstant.medium18()),
//                     Text(
//                         "Total Question: ${controller.postFormativeAssessmentResultModel.formativeAssessmentResultList?.last.obtainMarks ?? ""}",
//                         style: TextStyleConstant.medium18()),
//                   ],
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                       top: screenHeightPadding,
//                       bottom: screenHeightPadding),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Text(
//                           "Date: ${controller.postFormativeAssessmentResultModel.formativeAssessmentResultList?.last.tdate.toString().split(" ")[0] ?? ""}",
//                           style: TextStyleConstant.medium18()),
//                       Text(
//                           "Time: ${controller.postFormativeAssessmentResultModel.formativeAssessmentResultList?.last.ttime.toString().split(".")[0] ?? ""}",
//                           style: TextStyleConstant.medium18())
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: contentPadding,
//                   decoration: BoxDecoration(
//                       color: (double.parse(
//                           "${controller.postFormativeAssessmentResultModel.formativeAssessmentResultList?.last.obtainMarks}") >
//                           0)
//                           ? ColorConstant.green.withOpacity(0.1)
//                           : ColorConstant.red.withOpacity(0.1),
//                       border: Border.all(
//                           width: 2,
//                           color: (double.parse(
//                               "${controller.postFormativeAssessmentResultModel.formativeAssessmentResultList?.last.obtainMarks}") >
//                               0)
//                               ? ColorConstant.green
//                               : ColorConstant.red),
//                       borderRadius: BorderRadius.circular(16)),
//                   child: Column(
//                     children: [
//                       Text(
//                           "${controller.postFormativeAssessmentResultModel.formativeAssessmentResultList?.last.obtainMarks}",
//                           style: TextStyleConstant.bold36(
//                               color: (double.parse(
//                                   "${controller.postFormativeAssessmentResultModel.formativeAssessmentResultList?.last.obtainMarks}") >
//                                   0)
//                                   ? ColorConstant.green
//                                   : ColorConstant.red),
//                           textAlign: TextAlign.center),
//                       Text("is your test score",
//                           style: TextStyleConstant.medium18(),
//                           textAlign: TextAlign.center),
//                       SizedBox(height: contentHeightPadding),
//                       Container(
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: (double.parse(
//                                     "${controller.postFormativeAssessmentResultModel.formativeAssessmentResultList?.last.obtainMarks}") >
//                                     0)
//                                     ? ColorConstant.green
//                                     : ColorConstant.red,
//                                 width: 2),
//                             borderRadius: BorderRadius.circular(12)),
//                         child: LinearProgressIndicator(
//                           value: controller.progressBarValue.value,
//                           minHeight: 40,
//                           borderRadius: BorderRadius.circular(10),
//                           backgroundColor: ColorConstant.transparent,
//                           valueColor:
//                           AlwaysStoppedAnimation<Color>(Colors.green),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: screenHeightPadding),
//                 Container(
//                   padding: contentPadding,
//                   decoration: BoxDecoration(
//                       color: ColorConstant.blue.withOpacity(0.1),
//                       border:
//                       Border.all(width: 2, color: ColorConstant.blue),
//                       borderRadius: BorderRadius.circular(16)),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: Get.height * 0.300,
//                         child: PieChart(
//                           PieChartData(
//                             sections: showingSections(
//                                 attemptedQuestions:
//                                 widget.attemptedQuestions,
//                                 unattemptedQuestions:
//                                 widget.unattemptedQuestions,
//                                 skippedQuestions: widget.skippedQuestion),
//                             centerSpaceRadius: 20,
//                             sectionsSpace: 2,
//                             borderData: FlBorderData(show: false),
//                             pieTouchData: PieTouchData(
//                               touchCallback: (FlTouchEvent event,
//                                   pieTouchResponse) {},
//                             ),
//                           ),
//                         ),
//                       ),
//                       buildLegend(),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: screenHeightPadding),
//                 Container(
//                   padding: contentPadding,
//                   decoration: BoxDecoration(
//                       color: ColorConstant.blue.withOpacity(0.1),
//                       border:
//                       Border.all(width: 2, color: ColorConstant.blue),
//                       borderRadius: BorderRadius.circular(16)),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: Get.height * 0.300,
//                         child: PieChart(
//                           PieChartData(
//                             sections: showingSecondSections(
//                                 rightAnswer: widget.rightAnswer,
//                                 wrongAnswer: widget.wrongAnswer,
//                                 skippedQuestions: widget.skippedQuestion +
//                                     widget.unattemptedQuestions),
//                             centerSpaceRadius: 20,
//                             sectionsSpace: 2,
//                             borderData: FlBorderData(show: false),
//                             pieTouchData: PieTouchData(
//                               touchCallback: (FlTouchEvent event,
//                                   pieTouchResponse) {},
//                             ),
//                           ),
//                         ),
//                       ),
//                       buildSecondLegend(),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: screenHeightPadding),
//                 Container(
//                   padding: contentPadding,
//                   decoration: BoxDecoration(
//                       color: ColorConstant.blue.withOpacity(0.1),
//                       border:
//                       Border.all(width: 2, color: ColorConstant.blue),
//                       borderRadius: BorderRadius.circular(16)),
//                   child: Column(
//                     children: [
//                       Text(
//                         "${widget.testName} - Attempt History",
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.center,
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           RotatedBox(
//                               quarterTurns: 135,
//                               child: Text("Obtain Marks",
//                                   style: TextStyleConstant.bold18())),
//                           SizedBox(
//                               height: Get.height * 0.220,
//                               width: Get.width * 0.760,
//                               child: BarChart(BarChartData(
//                                   borderData: FlBorderData(show: false),
//                                   barGroups: controller.testHistoryList,
//                                   barTouchData: BarTouchData(
//                                     touchCallback: (FlTouchEvent event,
//                                         BarTouchResponse?
//                                         barTouchResponse) {
//                                       if (!event
//                                           .isInterestedForInteractions ||
//                                           barTouchResponse == null ||
//                                           barTouchResponse.spot == null) {
//                                         setState(() {
//                                           controller.touchIndex.value =
//                                           -1;
//                                         });
//                                         return;
//                                       }
//                                       setState(() {
//                                         controller.touchIndex.value =
//                                             barTouchResponse.spot!
//                                                 .touchedBarGroupIndex;
//                                       });
//                                     },
//                                     touchTooltipData: BarTouchTooltipData(
//                                       getTooltipColor: (group) =>
//                                       Colors.grey[200]!,
//                                       getTooltipItem: (group, groupIndex,
//                                           rod, rodIndex) {
//                                         return BarTooltipItem(
//                                           textDirection:
//                                           TextDirection.ltr,
//                                           "${controller.postFormativeAssessmentResultModel.formativeAssessmentResultList?[groupIndex].obtainMarks}",
//                                           const TextStyle(
//                                               color: Colors.grey,
//                                               fontWeight:
//                                               FontWeight.w700),
//                                           textAlign: TextAlign.center,
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   titlesData: FlTitlesData(
//                                       bottomTitles: AxisTitles(
//                                         sideTitles: SideTitles(
//                                           showTitles: true,
//                                           getTitlesWidget: (double value,
//                                               TitleMeta meta) {
//                                             return Text(
//                                                 '${value.toInt() + 1}');
//                                           },
//                                         ),
//                                       ),
//                                       leftTitles: const AxisTitles(
//                                           sideTitles: SideTitles(
//                                               showTitles: false)),
//                                       topTitles: const AxisTitles(
//                                           sideTitles: SideTitles(
//                                               showTitles: false)),
//                                       rightTitles: const AxisTitles(
//                                           sideTitles: SideTitles(
//                                               showTitles: false))),
//                                   gridData:
//                                   const FlGridData(show: false))))
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: Get.height * 0.020,
//                             bottom: Get.height * 0.020),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("Number of Attempt",
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold),
//                                 textAlign: TextAlign.center),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   left: screenWidthPadding),
//                               child: Icon(Icons.arrow_forward_rounded),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: screenHeightPadding),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: widget.answeredList.length,
//                   itemBuilder: (context, index) {
//                     final element = widget.answeredList[index];
//                     return Padding(
//                         padding:
//                         EdgeInsets.only(top: contentHeightPadding),
//                         child: Container(
//                           padding: contentPadding,
//                           decoration: BoxDecoration(
//                               color: ColorConstant.blue.withOpacity(0.1),
//                               border: Border.all(
//                                   width: 2, color: ColorConstant.blue),
//                               borderRadius: BorderRadius.circular(12)),
//                           child: Column(
//                             children: [
//                               HtmlWidget(
//                                   "(${index + 1}) ${element["question"]}",
//                                   textStyle:
//                                   TextStyleConstant.semiBold18()),
//                               ...buildOptionButtons(questionIndex: index),
//                             ],
//                           ),
//                         ));
//                   },
//                 ),
//                 SizedBox(height: screenHeightPadding),
//                 Padding(
//                   padding: EdgeInsets.only(bottom: screenHeightPadding),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(
//                           title: "Exit",
//                           // onTap: () {
//                           //   Get.offAll(() => const BottomBarView());
//                           // },
//                         ),
//                       ),
//                       SizedBox(width: contentWidthPadding),
//                       Expanded(
//                         child: CustomButton(
//                           title: "See Attemped Test",
//                           // onTap: () {
//                           //   Get.offAll(() => const BottomBarView());
//                           // },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//               : Padding(
//             padding: screenHorizontalPadding,
//             child: ListView.builder(
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: EdgeInsets.only(top: Get.height * 0.010),
//                   child: CustomShimmer(
//                     topPadding: Get.height * 0.010,
//                     height: Get.height * 0.060,
//                     width: Get.width,
//                     radius: 12,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ));
//   }
//
//   Widget listTileBoxWidget({required String title}) {
//     return ListTile(
//       title: Text(title),
//     );
//   }
//
//   List<PieChartSectionData> showingSections(
//       {required double attemptedQuestions,
//         required double unattemptedQuestions,
//         required double skippedQuestions}) {
//     return [
//       PieChartSectionData(
//           color: ColorConstant.blue,
//           value: attemptedQuestions,
//           title: attemptedQuestions.toString().split(".")[0],
//           radius: 100,
//           titleStyle:
//           TextStyleConstant.extraBold18(color: ColorConstant.white)),
//       PieChartSectionData(
//         color: ColorConstant.orange,
//         value: unattemptedQuestions,
//         title: unattemptedQuestions.toString().split(".")[0],
//         radius: 100,
//         titleStyle: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//       PieChartSectionData(
//         color: ColorConstant.grey,
//         value: skippedQuestions,
//         title: skippedQuestions.toString().split(".")[0],
//         radius: 100,
//         titleStyle: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     ];
//   }
//
//   List<PieChartSectionData> showingSecondSections(
//       {required double rightAnswer,
//         required double wrongAnswer,
//         required double skippedQuestions}) {
//     return [
//       PieChartSectionData(
//           color: ColorConstant.green,
//           value: rightAnswer,
//           title: rightAnswer.toString().split(".")[0],
//           radius: 100,
//           titleStyle:
//           TextStyleConstant.extraBold18(color: ColorConstant.white)),
//       PieChartSectionData(
//         color: ColorConstant.red,
//         value: wrongAnswer,
//         title: wrongAnswer.toString().split(".")[0],
//         radius: 100,
//         titleStyle: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//       PieChartSectionData(
//         color: ColorConstant.grey,
//         value: skippedQuestions,
//         title: skippedQuestions.toString().split(".")[0],
//         radius: 100,
//         titleStyle: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     ];
//   }
//
//   Widget buildLegend() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         buildLegendItem('Attempted', ColorConstant.blue),
//         buildLegendItem('Not Visited', ColorConstant.orange),
//         buildLegendItem('Skipped', ColorConstant.grey),
//       ],
//     );
//   }
//
//   Widget buildSecondLegend() {
//     return SizedBox(
//       height: Get.height * 0.020,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: [
//           buildLegendItem('Right Answer', ColorConstant.green),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: Get.width * 0.052),
//             child: buildLegendItem('Wrong Answer', ColorConstant.red),
//           ),
//           buildLegendItem('Not Attempted', ColorConstant.grey),
//         ],
//       ),
//     );
//   }
//
//   Widget buildLegendItem(String title, Color color) {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           color: color,
//         ),
//         SizedBox(width: 8),
//         Text(
//           title,
//           style: TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }
//
//   List<Widget> buildOptionButtons({required int questionIndex}) {
//     int counter = 0;
//     final questionData =
//     widget.answeredList[questionIndex]; // Fetch question data
//     final options = questionData["option"]; // Get the list of options
//     final correctAnswer = questionData["answer"]; // Correct answer
//     final selectedAnswer =
//     questionData["selected_answer"]; // User-selected answer
//
//     return List<Widget>.generate(options.length, (index) {
//       final option = options[index];
//       bool isSelectedAnswer =
//           selectedAnswer == option; // Check if this option is the selected one
//
//       bool isCorrectAnswer =
//           correctAnswer == option; // Check if this option is correct
//
//       bool isRight = isSelectedAnswer &&
//           isCorrectAnswer; // Check if the selected option is correct
//
//       bool isWrong = isSelectedAnswer &&
//           !isCorrectAnswer; // Check if the selected option is wrong
//
//       // Reset counter after 5 options (or as per your logic)
//       if (counter >= 5) {
//         counter = 0;
//       } else {
//         counter++;
//       }
//
//       return Padding(
//         padding: EdgeInsets.only(top: Get.height * 0.010),
//         child: GestureDetector(
//           onTap: () {
//             log("Option ::: $option");
//             log("Correct Answer ::: $correctAnswer");
//             log("Selected Answer ::: $selectedAnswer");
//             log("Is Right ::: $isRight");
//           },
//           child: Container(
//             padding: contentPadding,
//             alignment: Alignment.centerLeft,
//             decoration: BoxDecoration(
//               color: (isRight)
//                   ? Colors.green // Green for correct selected answer
//                   : (isWrong)
//                   ? Colors.red // Red for wrong selected answer
//                   : Colors.white, // Default color for unselected options
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("($counter)  ",
//                     style: TextStyleConstant.medium18(
//                         color: (isRight || isWrong)
//                             ? Colors.white // White text for selected options
//                             : Colors
//                             .black)), // Black text for unselected options
//                 Expanded(
//                   child: HtmlWidget("$option",
//                       textStyle: TextStyleConstant.medium18(
//                           color: (isRight || isWrong)
//                               ? Colors.white // White text for selected options
//                               : Colors
//                               .black)), // Black text for unselected options
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
//
// /*
// BarChartGroupData(x: 9, barRods: [
//         BarChartRodData(toY: 97, color: Colors.green, width: 16),
//       ]),
//  */
