import 'package:firesafety/Controllers/MyCource_purchescategotylist_Controller.dart';
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

class _MypurchesCatrgotyListscreenState extends State<MypurchesCatrgotyListscreen> {
  MypurschaseSubcategoryController controller =
  Get.put(MypurschaseSubcategoryController());

  @override
  void initState() {
    super.initState();
    controller
        .GetPurchesSubCategory(UserId: widget.userId)
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "My Purchases Category"),
      body: Padding(
        padding: screenHorizontalPadding,
        child: (controller.getPurchaseSubcategoryModel.myPurchaseSubcategoryList !=
            null)
            ? ListView.builder(
          itemCount: controller
              .getPurchaseSubcategoryModel.myPurchaseSubcategoryList?.length,
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
                  Get.to(() => StudentFormView(
                    userId: widget.userId,
                    id: element?.testpaymentId ?? '',
                  ));
                },
                child: buildSubcategoryCard(element),
              );
            } else if (bookingForm?.toUpperCase() == "Y" &&
                speakingTest?.toUpperCase() == "N") {
              return GestureDetector(
                onTap: () {
                  Get.to(() => SpeakingTestModule(
                    userId: widget.userId,
                    id: element?.testpaymentId ?? '',
                  ));
                },
                child: buildSubcategoryCard(element),
              );
            } else if (speakingTest?.toUpperCase() == "Y" &&
                writingTest?.toUpperCase() == "N") {
              return GestureDetector(
                onTap: () {
                  Get.to(() => WritingTestPage(
                    userId: widget.userId,
                    id: element?.testpaymentId ?? '',
                  ));
                },
                child: buildSubcategoryCard(element),
              );
            } else if (writingTest?.toUpperCase() == "Y" &&
                readingTest?.toUpperCase() == "N") {
              return GestureDetector(
                onTap: () {
                  Get.to(() => ReadingScreenWithMCQ(
                    userId: widget.userId,
                    id: element?.testpaymentId ?? '',
                    quizType: 'Reading Test',
                  ));
                },
                child: buildSubcategoryCard(element),
              );
            } else if (readingTest?.toUpperCase() == "Y" &&
                listeningTest?.toUpperCase() == "N") {
              return GestureDetector(
                onTap: () {
                  Get.to(() => ListeningWithMcqView(
                    userId: widget.userId,
                    id: element?.testpaymentId ?? '',
                  ));
                },
                child: buildSubcategoryCard(element),
              );
            } else if (listeningTest?.toUpperCase() == "Y") {
              return GestureDetector(
                onTap: () {
                  Get.to(() => MyCourseListView(
                    categoryId: "${element?.categoryId}",
                    subcategoryId: "${element?.subcategoryId}",
                    testpaymentId: "${element?.testpaymentId}",
                  ));
                },
                child: buildSubcategoryCard(element),
              );
            }

            // Default behavior if no condition met
            return GestureDetector(
              onTap: () {
                Get.to(() => MyCourseListView(
                  categoryId: "${element?.categoryId}",
                  subcategoryId: "${element?.subcategoryId}",
                  testpaymentId: "${element?.testpaymentId}",
                ));
              },
              child: buildSubcategoryCard(element),
            );
          },
        )
            : ListView.builder(
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return const CustomShimmer(radius: 24);
          },
        ),
      ),
    );
  }

  // Method to build subcategory card
  Widget buildSubcategoryCard(element) {
    return Container(
      padding: contentPadding,
      decoration: BoxDecoration(
        color: ColorConstant.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            height: Get.height * 0.2,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              image: DecorationImage(
                image: NetworkImage("${element?.subcategoryImage}"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: contentHeightPadding),
            child: Text(
              "${element?.subcategoryName}",
              style: TextStyleConstant.medium18(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
