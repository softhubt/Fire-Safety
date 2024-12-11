import 'package:firesafety/Widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/course_list_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/course_details_screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';

class MyCourseListView extends StatefulWidget {
  final String categoryId;
  final String subcategoryId;
  final String testpaymentId;

  const MyCourseListView({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
    required this.testpaymentId,
  });

  @override
  State<MyCourseListView> createState() => _MyCourseListViewState();
}

class _MyCourseListViewState extends State<MyCourseListView> {
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
      appBar: const CustomAppBar(title: "My Courses"),
      body: Padding(
        padding: screenHorizontalPadding,
        child: (controller.getCourseListModel.courseList != null)
            ? ListView.builder(
                itemCount: controller.getCourseListModel.courseList?.length,
                itemBuilder: (BuildContext context, int index) {
                  final element =
                      controller.getCourseListModel.courseList?[index];
                  return Padding(
                    padding: EdgeInsets.only(top: screenHeightPadding),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => CourseDetailScreen(
                            courseId: "${element?.courseId}",
                            testpaymentId: widget.testpaymentId,
                            isPurchase: '',
                            amount: "0"));
                      },
                      child: Container(
                        padding: contentPadding,
                        decoration: BoxDecoration(
                          color: ColorConstant.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: Get.height * 0.120,
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                image: DecorationImage(
                                  image:
                                      NetworkImage("${element?.courseImage}"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: contentHeightPadding),
                              child: Text(
                                "${element?.courseName}",
                                style: TextStyleConstant.medium18(),
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
            : ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return const CustomShimmer(radius: 24);
                },
              ),
      ),
    );
  }
}
