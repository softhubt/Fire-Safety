import 'package:firesafety/Controllers/MyCource_purchescategotylist_Controller.dart';
import 'package:firesafety/Models/get_purches_CategoryList_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Student_Form_View.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/My_Course_Section/my_course_screen.dart';
import 'package:firesafety/Screens/ListeningWithMCQ_Screen.dart';
import 'package:firesafety/Screens/ReadingTest_WithMCQ_Screen.dart';
import 'package:firesafety/Screens/Writting_Test_Screen.dart';
import 'package:firesafety/Screens/speaking_test_Screen.dart';
import 'package:firesafety/Widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';

class MypurchesCatrgotyListscreen extends StatefulWidget {
  final String userId;

  const MypurchesCatrgotyListscreen({super.key, required this.userId});

  @override
  State<MypurchesCatrgotyListscreen> createState() =>
      _MypurchesCatrgotyListscreenState();
}

class _MypurchesCatrgotyListscreenState
    extends State<MypurchesCatrgotyListscreen> {
  MypurschaseSubcategoryController controller =
      Get.put(MypurschaseSubcategoryController());

  @override
  void initState() {
    super.initState();
    controller.GetPurchesSubCategory(UserId: widget.userId)
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "My Courses"),
        body: Padding(
            padding: screenHorizontalPadding,
            child: (controller.getPurchaseSubcategoryModel
                        .myPurchaseSubcategoryList !=
                    null)
                ? ListView.builder(
                    itemCount: controller.getPurchaseSubcategoryModel
                        .myPurchaseSubcategoryList?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final element = controller.getPurchaseSubcategoryModel
                          .myPurchaseSubcategoryList?[index];

                      String? bookingForm = element?.bookingForm;
                      String? speakingTest = element?.speakingTest;
                      String? writingTest = element?.writingTest;
                      String? readingTest = element?.readingTest;
                      String? listeningTest = element?.listeningTest;

                      // Handle navigation based on conditions
                      if (bookingForm?.toUpperCase() == "N") {
                        return GestureDetector(
                          onTap: () {
                            Get.offAll(() => StudentFormView(
                                  userId: widget.userId,
                                  id: element?.testpaymentId ?? '',
                                ));
                          },
                          child: buildDetailedCard(element),
                        );
                      } else if (bookingForm?.toUpperCase() == "Y" &&
                          speakingTest?.toUpperCase() == "N") {
                        return GestureDetector(
                          onTap: () {
                            Get.offAll(() => SpeakingTestModule(
                                  userId: widget.userId,
                                  id: element?.testpaymentId ?? '',
                                ));
                          },
                          child: buildDetailedCard(element),
                        );
                      } else if (speakingTest?.toUpperCase() == "Y" &&
                          writingTest?.toUpperCase() == "N") {
                        return GestureDetector(
                          onTap: () {
                            Get.offAll(() => WritingTestPage(
                                  userId: widget.userId,
                                  id: element?.testpaymentId ?? '',
                                ));
                          },
                          child: buildDetailedCard(element),
                        );
                      } else if (writingTest?.toUpperCase() == "Y" &&
                          readingTest?.toUpperCase() == "N") {
                        return GestureDetector(
                          onTap: () {
                            Get.offAll(() => ReadingScreenWithMCQ(
                                  userId: widget.userId,
                                  id: element?.testpaymentId ?? '',
                                  quizType: 'Reading Test',
                                ));
                          },
                          child: buildDetailedCard(element),
                        );
                      } else if (readingTest?.toUpperCase() == "Y" &&
                          listeningTest?.toUpperCase() == "N") {
                        return GestureDetector(
                            onTap: () {
                              Get.offAll(() => ListeningWithMcqView(
                                  userId: widget.userId,
                                  id: element?.testpaymentId ?? ''));
                            },
                            child: buildDetailedCard(element));
                      } else if (listeningTest?.toUpperCase() == "Y") {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => MyCourseListView(
                                  courseName: "${element?.subcategoryName}",
                                  categoryId: "${element?.categoryId}",
                                  subcategoryId: "${element?.subcategoryId}",
                                  testpaymentId: "${element?.testpaymentId}",
                                ));
                          },
                          child: buildDetailedCard(element),
                        );
                      }

                      // Default behavior if no condition met
                      return GestureDetector(
                          onTap: () {
                            Get.to(() => MyCourseListView(
                                courseName: "${element?.subcategoryName}",
                                categoryId: "${element?.categoryId}",
                                subcategoryId: "${element?.subcategoryId}",
                                testpaymentId: "${element?.testpaymentId}"));
                          },
                          child: buildDetailedCard(element));
                    },
                  )
                : ListView.builder(
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return const CustomShimmer(radius: 24);
                    },
                  )));
  }

  Widget buildDetailedCard(PurchaseSubcategory? element) {
    return Card(
      color: ColorConstant.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: contentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(element?.subcategoryImage ?? '',
                    height: Get.height * 0.2,
                    width: Get.width,
                    fit: BoxFit.cover)),
            const SizedBox(height: 10),
            Text(
              element?.subcategoryName ?? '',
              style: TextStyleConstant.bold22(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            // Additional Details Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Amount
                Row(
                  children: [
                    const Icon(Icons.currency_rupee, color: Colors.green),
                    Text(element?.amount ?? 'N/A',
                        style: TextStyleConstant.medium16()),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.blue),
                    Text("${element?.days ?? 'N/A'} Days",
                        style: TextStyleConstant.medium16()),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.orange),
                Text(
                  "Purchased: ${element?.purchaseDate ?? 'N/A'}",
                  style: TextStyleConstant.regular14(),
                ),
                const Spacer(),
                const Icon(Icons.hourglass_bottom, color: Colors.red),
                Text(
                  "Expires: ${element?.expiryDate ?? 'N/A'}",
                  style: TextStyleConstant.regular14(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Status Badge
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: element?.status?.toUpperCase() == "ACTIVE"
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
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
    );
  }
}
