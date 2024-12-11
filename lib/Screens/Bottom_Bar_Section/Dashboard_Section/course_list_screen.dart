import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/course_list_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/course_details_screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';

class CourseListScreen extends StatefulWidget {
  final String categoryId;
  final String userId;
  final String subcategoryId;
  final String amount;
  final String days;
  final String isPurchase;

  const CourseListScreen({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
    required this.userId,
    required this.amount,
    required this.days,
    required this.isPurchase,
  });

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CourseListController controller = Get.put(CourseListController());

  @override
  void initState() {
    super.initState();
    controller
        .getCourseList(
          categoryId: widget.categoryId,
          subcategoryId: widget.subcategoryId,
        )
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Course List",
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: ColorConstant.white),
          ),
        ),
        body: Padding(
          padding: screenPadding,
          child: (controller.getCourseListModel.courseList != null &&
                  controller.getCourseListModel.courseList!.isNotEmpty)
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.getCourseListModel.courseList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => CourseDetailScreen(
                            courseId:
                                "${controller.getCourseListModel.courseList?[index].courseId}",
                            testpaymentId: "widget.testpaymentId,",
                            isPurchase: widget.isPurchase,
                            amount: widget.amount));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: contentPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image (placed at the top)
                              SizedBox(
                                height: Get.height * 0.2, // Height of the image
                                width: double
                                    .infinity, // Image takes up full width
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      13), // Circular border radius
                                  child: Image.network(
                                    "${controller.getCourseListModel.courseList?[index].courseImage}",
                                    fit: BoxFit
                                        .cover, // Cover the container area without distortion
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: Get.height *
                                      0.02), // Space between image and text
                              // Text with course name and price
                              Padding(
                                padding:
                                    EdgeInsets.only(left: Get.width * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.school,
                                          size: 20,
                                          color: ColorConstant.primary,
                                        ),
                                        const SizedBox(
                                            width:
                                                8), // Add some space between the icon and text
                                        Expanded(
                                          child: Text(
                                            "${controller.getCourseListModel.courseList?[index].courseName}",
                                            style:
                                                TextStyleConstant.semiBold16(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today, // Calendar icon
                                          size: 20, // Adjust the icon size
                                          color: ColorConstant
                                              .primary, // Optional: Set the icon color
                                        ),
                                        const SizedBox(
                                            width:
                                                8), // Add space between the icon and the text
                                        Text(
                                          "Start on ${controller.getCourseListModel.courseList?[index].startDate}",
                                          style: TextStyleConstant.semiBold14(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
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
                )
              : const CustomNoDataFound(),
        ),
        bottomNavigationBar: (widget.isPurchase == "0")
            ? Padding(
                padding: EdgeInsets.only(
                    bottom: screenHeightPadding,
                    left: screenWidthPadding,
                    right: screenWidthPadding),
                child: Row(
                  children: [
                    Text("₹ ${widget.amount} /-",
                        style: TextStyleConstant.semiBold30()),
                    SizedBox(
                        width: screenWidthPadding), // Space between buttons
                    Expanded(
                      child: CustomButton(
                        title: "Buy",
                        onTap: () {
                          // Passing all required arguments to getPurchesCpource
                          controller.getPurchesCpource(
                            categoryId: widget.categoryId,
                            subcategoryId: widget.subcategoryId,
                            userId: widget.userId,
                            amount: widget.amount,
                            days: widget.days,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox());
  }
}
