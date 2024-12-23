import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/student_dashboard_controller.dart';
import 'package:firesafety/Models/get_purches_CategoryList_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Student_Form_View.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/My_Course_Section/my_course_screen.dart';
import 'package:firesafety/Screens/ListeningWithMCQ_Screen.dart';
import 'package:firesafety/Screens/ReadingTest_WithMCQ_Screen.dart';
import 'package:firesafety/Screens/Writting_Test_Screen.dart';
import 'package:firesafety/Screens/speaking_test_Screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentDashboardView extends StatefulWidget {
  final String categoryId;
  final String courseName;
  final String subcategoryId;
  final String testpaymentId;

  const StudentDashboardView({
    super.key,
    required this.categoryId,
    required this.courseName,
    required this.subcategoryId,
    required this.testpaymentId,
  });

  @override
  State<StudentDashboardView> createState() => _StudentDashboardViewState();
}

class _StudentDashboardViewState extends State<StudentDashboardView> {
  final StudentDashboardController controller =
      Get.put(StudentDashboardController());

  @override
  void initState() {
    super.initState();
    controller.initialFunctioun().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Student Dashboard", isBack: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  top: screenHeightPadding, left: screenWidthPadding),
              child: Text("My Purchased Courses",
                  style: TextStyleConstant.semiBold22())),
          SizedBox(
            height: Get.height * 0.44, // Adjust the height for horizontal cards
            child: (controller.getPurchaseSubcategoryModel
                        .myPurchaseSubcategoryList !=
                    null)
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.getPurchaseSubcategoryModel
                            .myPurchaseSubcategoryList?.length ??
                        0,
                    itemBuilder: (BuildContext context, int index) {
                      final element = controller.getPurchaseSubcategoryModel
                          .myPurchaseSubcategoryList?[index];

                      // Navigation logic based on test completion status
                      return Padding(
                        padding: EdgeInsets.only(left: screenWidthPadding),
                        child: GestureDetector(
                          onTap: () {
                            if (element?.bookingForm?.toUpperCase() == "N") {
                              Get.offAll(() => StudentFormView(
                                    userId: controller.userId.value,
                                    id: element?.testpaymentId ?? '',
                                  ));
                            } else if (element?.speakingTest?.toUpperCase() ==
                                "N") {
                              Get.offAll(() => SpeakingTestModule(
                                    userId: controller.userId.value,
                                    id: element?.testpaymentId ?? '',
                                  ));
                            } else if (element?.writingTest?.toUpperCase() ==
                                "N") {
                              Get.offAll(() => WritingTestPage(
                                    userId: controller.userId.value,
                                    id: element?.testpaymentId ?? '',
                                  ));
                            } else if (element?.readingTest?.toUpperCase() ==
                                "N") {
                              Get.offAll(() => ReadingScreenWithMCQ(
                                    userId: controller.userId.value,
                                    id: element?.testpaymentId ?? '',
                                    quizType: 'Reading Test',
                                  ));
                            } else if (element?.listeningTest?.toUpperCase() ==
                                "N") {
                              Get.offAll(() => ListeningWithMcqView(
                                    userId: controller.userId.value,
                                    id: element?.testpaymentId ?? '',
                                  ));
                            } else {
                              Get.to(() => MyCourseListView(
                                    courseName: "${element?.subcategoryName}",
                                    categoryId: "${element?.categoryId}",
                                    subcategoryId: "${element?.subcategoryId}",
                                    testpaymentId: "${element?.testpaymentId}",
                                  ));
                            }
                          },
                          child: buildHorizontalCard(element),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return const CustomShimmer(
                          radius: 24); // Placeholder shimmer
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Redesigned horizontal card
  Widget buildHorizontalCard(PurchaseSubcategory? element) {
    return Card(
      color: ColorConstant.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: Get.width * 0.6, // Width for horizontal layout
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  element?.subcategoryImage ?? '',
                  height: Get.height * 0.2,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                element?.subcategoryName ?? '',
                style: TextStyleConstant.bold18(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee,
                          color: Colors.green, size: 18),
                      Text(
                        element?.amount ?? 'N/A',
                        style: TextStyleConstant.medium14(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.blue, size: 18),
                      Text(
                        "${element?.days ?? 'N/A'} Days",
                        style: TextStyleConstant.medium14(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: Colors.orange, size: 18),
                  Text(
                    "Purchased: ${element?.purchaseDate ?? 'N/A'}",
                    style: TextStyleConstant.regular12(),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.hourglass_bottom,
                      color: Colors.red, size: 18),
                  Text(
                    "Expires: ${element?.expiryDate ?? 'N/A'}",
                    style: TextStyleConstant.regular12(),
                  ),
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: element?.status?.toUpperCase() == "ACTIVE"
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    element?.status ?? 'N/A',
                    style: TextStyle(
                      color: element?.status?.toUpperCase() == "ACTIVE"
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// class StudentDashboardView extends StatefulWidget {
//   final String categoryId;
//   final String courseName;
//   final String subcategoryId;
//   final String testpaymentId;

//   const StudentDashboardView(
//       {super.key,
//       required this.categoryId,
//       required this.courseName,
//       required this.subcategoryId,
//       required this.testpaymentId});

//   @override
//   State<StudentDashboardView> createState() => _StudentDashboardViewState();
// }

// class _StudentDashboardViewState extends State<StudentDashboardView> {
//   StudentDashboardController controller = Get.put(StudentDashboardController());

//   @override
//   void initState() {
//     super.initState();
//     controller.initialFunctioun().whenComplete(() => setState(() {}));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//               height: Get.height * 0.200,
//               child: (controller.getPurchaseSubcategoryModel
//                           .myPurchaseSubcategoryList !=
//                       null)
//                   ? ListView.builder(
//                       itemCount: controller.getPurchaseSubcategoryModel
//                           .myPurchaseSubcategoryList?.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final element = controller.getPurchaseSubcategoryModel
//                             .myPurchaseSubcategoryList?[index];

//                         String? bookingForm = element?.bookingForm;
//                         String? speakingTest = element?.speakingTest;
//                         String? writingTest = element?.writingTest;
//                         String? readingTest = element?.readingTest;
//                         String? listeningTest = element?.listeningTest;

//                         // Handle navigation based on conditions
//                         if (bookingForm?.toUpperCase() == "N") {
//                           return GestureDetector(
//                             onTap: () {
//                               Get.offAll(() => StudentFormView(
//                                     userId: controller.userId.value,
//                                     id: element?.testpaymentId ?? '',
//                                   ));
//                             },
//                             child: buildDetailedCard(element),
//                           );
//                         } else if (bookingForm?.toUpperCase() == "Y" &&
//                             speakingTest?.toUpperCase() == "N") {
//                           return GestureDetector(
//                             onTap: () {
//                               Get.offAll(() => SpeakingTestModule(
//                                     userId: controller.userId.value,
//                                     id: element?.testpaymentId ?? '',
//                                   ));
//                             },
//                             child: buildDetailedCard(element),
//                           );
//                         } else if (speakingTest?.toUpperCase() == "Y" &&
//                             writingTest?.toUpperCase() == "N") {
//                           return GestureDetector(
//                             onTap: () {
//                               Get.offAll(() => WritingTestPage(
//                                     userId: controller.userId.value,
//                                     id: element?.testpaymentId ?? '',
//                                   ));
//                             },
//                             child: buildDetailedCard(element),
//                           );
//                         } else if (writingTest?.toUpperCase() == "Y" &&
//                             readingTest?.toUpperCase() == "N") {
//                           return GestureDetector(
//                             onTap: () {
//                               Get.offAll(() => ReadingScreenWithMCQ(
//                                     userId: controller.userId.value,
//                                     id: element?.testpaymentId ?? '',
//                                     quizType: 'Reading Test',
//                                   ));
//                             },
//                             child: buildDetailedCard(element),
//                           );
//                         } else if (readingTest?.toUpperCase() == "Y" &&
//                             listeningTest?.toUpperCase() == "N") {
//                           return GestureDetector(
//                               onTap: () {
//                                 Get.offAll(() => ListeningWithMcqView(
//                                     userId: controller.userId.value,
//                                     id: element?.testpaymentId ?? ''));
//                               },
//                               child: buildDetailedCard(element));
//                         } else if (listeningTest?.toUpperCase() == "Y") {
//                           return GestureDetector(
//                               onTap: () {
//                                 Get.to(() => MyCourseListView(
//                                       courseName: "${element?.subcategoryName}",
//                                       categoryId: "${element?.categoryId}",
//                                       subcategoryId:
//                                           "${element?.subcategoryId}",
//                                       testpaymentId:
//                                           "${element?.testpaymentId}",
//                                     ));
//                               },
//                               child: buildDetailedCard(element));
//                         }

//                         // Default behavior if no condition met
//                         return GestureDetector(
//                             onTap: () {
//                               Get.to(() => MyCourseListView(
//                                   courseName: "${element?.subcategoryName}",
//                                   categoryId: "${element?.categoryId}",
//                                   subcategoryId: "${element?.subcategoryId}",
//                                   testpaymentId: "${element?.testpaymentId}"));
//                             },
//                             child: buildDetailedCard(element));
//                       },
//                     )
//                   : ListView.builder(
//                       itemCount: 4,
//                       itemBuilder: (BuildContext context, int index) {
//                         return const CustomShimmer(radius: 24);
//                       },
//                     )),
//         ],
//       ),
//     );
//   }

//   Widget buildDetailedCard(PurchaseSubcategory? element) {
//     return Card(
//       color: ColorConstant.white,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: contentPadding,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: Image.network(element?.subcategoryImage ?? '',
//                     height: Get.height * 0.2,
//                     width: Get.width,
//                     fit: BoxFit.cover)),
//             const SizedBox(height: 10),
//             Text(
//               element?.subcategoryName ?? '',
//               style: TextStyleConstant.bold22(),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 5),
//             // Additional Details Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Amount
//                 Row(
//                   children: [
//                     const Icon(Icons.currency_rupee, color: Colors.green),
//                     Text(element?.amount ?? 'N/A',
//                         style: TextStyleConstant.medium16()),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const Icon(Icons.timer, color: Colors.blue),
//                     Text("${element?.days ?? 'N/A'} Days",
//                         style: TextStyleConstant.medium16()),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 5),
//             Row(
//               children: [
//                 const Icon(Icons.calendar_today, color: Colors.orange),
//                 Text(
//                   "Purchased: ${element?.purchaseDate ?? 'N/A'}",
//                   style: TextStyleConstant.regular14(),
//                 ),
//                 const Spacer(),
//                 const Icon(Icons.hourglass_bottom, color: Colors.red),
//                 Text(
//                   "Expires: ${element?.expiryDate ?? 'N/A'}",
//                   style: TextStyleConstant.regular14(),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Status Badge
//             Align(
//               alignment: Alignment.centerRight,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: element?.status?.toUpperCase() == "ACTIVE"
//                       ? Colors.green.withOpacity(0.2)
//                       : Colors.red.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   element?.status ?? 'N/A',
//                   style: TextStyle(
//                     color: element?.status?.toUpperCase() == "ACTIVE"
//                         ? Colors.green
//                         : Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
