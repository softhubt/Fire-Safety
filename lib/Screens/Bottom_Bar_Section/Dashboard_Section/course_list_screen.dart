import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/course_list_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/Payment_thank_you_view.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/course_details_screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';

class CourseListScreen extends StatefulWidget {
  final String categoryId;
  final String userId;
  final String subcategoryId;

  const CourseListScreen({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
    required this.userId,
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
            ? GridView.builder(
                shrinkWrap: true,
                itemCount: controller.getCourseListModel.courseList?.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => CourseDetailScreen(
                          courseId:
                              "${controller.getCourseListModel.courseList?[index].courseId}"));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: contentPadding,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.123,
                              width: Get.width,
                              child: Image.network(
                                "${controller.getCourseListModel.courseList?[index].courseImage}",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: Get.height * 0.020),
                              child: Text(
                                "${controller.getCourseListModel.courseList?[index].courseName}",
                                style: TextStyleConstant.semiBold16(),
                                overflow: TextOverflow.ellipsis,
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: screenHeightPadding,
          left: screenWidthPadding,
          right: screenWidthPadding,
        ),
        child: CustomButton(
          title: "Purchase",
          onTap: () {
            Get.to(() => PaymentThankYouView(
                  //  chapterId: widget.chapterId,  // Use widget to access
                  userId: widget.userId, // Use widget to access
                ));
          },
        ),
      ),
    );
  }
}
