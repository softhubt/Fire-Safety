import 'package:firesafety/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/course_detail_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/MockExamination_View.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/chapter_detail_screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  final String testpaymentId;
  final String isPurchase; // * New field to track if course is purchased
  final String amount;
  final String categoryId;
  final String subCategoryId;
  final String userId;
  final String days;

  const CourseDetailScreen(
      {super.key,
      required this.courseId,
      required this.testpaymentId,
      required this.isPurchase,
      required this.amount,
      required this.categoryId,
      required this.days,
      required this.subCategoryId,
      required this.userId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  CourseDetailController controller = Get.put(CourseDetailController());

  @override
  void initState() {
    super.initState();
    initialFunctioun().whenComplete(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    controller.razorpay.clear();
  }

  Future initialFunctioun() async {
    controller.tabController =
        TabController(length: controller.tabList.length, vsync: this);
    await controller.getChapterList(courseId: widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: CustomAppBar(
        title: "Course Details",
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: ColorConstant.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeightPadding,
          horizontal: screenWidthPadding,
        ),
        child: Column(
          children: [
            // Tab Bar Container with smooth gradient background
            Container(
              padding: EdgeInsets.symmetric(
                vertical: Get.height * 0.006,
                horizontal: Get.width * 0.014,
              ),
              height: Get.height * 0.06,
              decoration: BoxDecoration(
                color: ColorConstant.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: controller.tabController,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: ColorConstant.primary),
                labelColor: ColorConstant.white,
                unselectedLabelColor: ColorConstant.primary,
                labelStyle: TextStyleConstant.semiBold16(),
                tabs: controller.tabList,
                dividerColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 10), // Add spacing for aesthetics
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  overviewContent(controller: controller),
                  courseContent(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: (widget.isPurchase == "0")
          ? Padding(
              padding: EdgeInsets.only(
                  bottom: screenHeightPadding,
                  left: screenWidthPadding,
                  right: screenWidthPadding),
              child: Row(
                children: [
                  Text(
                    "₹ ${widget.amount} /-",
                    style: TextStyleConstant.bold28(
                      color: ColorConstant.primary,
                    ),
                  ),
                  const SizedBox(width: 10), // Space between price and button
                  Expanded(
                    child: CustomButton(
                      title: "Buy Now",
                      gradient: const LinearGradient(
                        colors: [ColorConstant.primary, Colors.pink],
                      ),
                      onTap: () {
                        controller.postPurchesCource(
                            categoryId: widget.categoryId,
                            subcategoryId: widget.subCategoryId,
                            userId: widget.userId,
                            amount: widget.amount,
                            days: widget.days);
                        // Add purchase functionality
                      },
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  Widget overviewContent({required CourseDetailController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10), // Add spacing
        Text(
          "Overview",
          style: TextStyleConstant.bold20(color: ColorConstant.primary),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading:
              const Icon(Icons.watch, color: ColorConstant.primary, size: 30),
          title: Text(
            "Duration: 6 hours",
            style: TextStyleConstant.medium16(),
          ),
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.certificate,
              color: ColorConstant.primary, size: 30),
          title: Text(
            "Completion Certificate",
            style: TextStyleConstant.medium16(),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today,
              color: ColorConstant.primary, size: 30),
          title: Text(
            "90 Days Access",
            style: TextStyleConstant.medium16(),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.card_giftcard,
              color: ColorConstant.primary, size: 30),
          title: Text(
            "Enroll and win rewards",
            style: TextStyleConstant.medium16(),
          ),
        ),
      ],
    );
  }

  Widget courseContent({required CourseDetailController controller}) {
    return (controller.getChapterListModel.courseChapterList != null)
        ? Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount:
                      controller.getChapterListModel.courseChapterList?.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              if (widget.isPurchase == '0') {
                                Get.snackbar(
                                  "Locked Chapter",
                                  "Please purchase the course to access this chapter.",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.pink,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.to(() => ChapterDetailScreen(
                                      chapterId:
                                          "${controller.getChapterListModel.courseChapterList?[index].chapterId}",
                                      chapterName:
                                          "${controller.getChapterListModel.courseChapterList?[index].chapterName}",
                                      courseId: widget.courseId,
                                      testpaymentId: widget.testpaymentId,
                                    ));
                              }
                            },
                            child: Card(
                                color: ColorConstant.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                    padding: contentPadding,
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            "${controller.getChapterListModel.courseChapterList?[index].chapterImage}",
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${controller.getChapterListModel.courseChapterList?[index].chapterName}",
                                                    style: TextStyleConstant
                                                        .bold16(),
                                                  ),
                                                ),
                                                if (widget.isPurchase == '0')
                                                  const Icon(
                                                    FontAwesomeIcons.lock,
                                                    color: Colors.red,
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                                "${controller.getChapterListModel.courseChapterList?[index].description}",
                                                style: TextStyleConstant
                                                    .medium14(),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ],
                                        )),
                                      ],
                                    )))),
                        (controller
                                    .getChapterListModel
                                    .courseChapterList?[index]
                                    .mockExaminationDetails !=
                                null)
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller
                                    .getChapterListModel
                                    .courseChapterList?[index]
                                    .mockExaminationDetails
                                    ?.length,
                                itemBuilder: (context, subIndex) {
                                  final mockElement = controller
                                      .getChapterListModel
                                      .courseChapterList?[index]
                                      .mockExaminationDetails?[subIndex];

                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: GestureDetector(
                                        onTap: () {
                                          if (widget.isPurchase == '0') {
                                            Get.snackbar(
                                              "Locked Mock Test",
                                              "Please purchase the course to access this Mock Test.",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.pink,
                                              colorText: Colors.white,
                                            );
                                          } else {
                                            Get.to(() => MockExaminationView(
                                                mockId:
                                                    mockElement?.mockId ?? "",
                                                mockName:
                                                    mockElement?.mockName ?? "",
                                                examTime:
                                                    mockElement?.examTime ?? "",
                                                marks: mockElement?.marks ?? "",
                                                chapterId:
                                                    mockElement?.chapterId ??
                                                        "",
                                                courseId:
                                                    mockElement?.courseId ?? "",
                                                subcategoryid: mockElement
                                                        ?.subcategoryid ??
                                                    "",
                                                categoryid:
                                                    mockElement?.categoryid ??
                                                        "",
                                                questionPdf:
                                                    mockElement?.questionPdf ??
                                                        "",
                                                samplePdf:
                                                    mockElement?.samplePdf ??
                                                        ""));
                                          }
                                        },
                                        child: Container(
                                            padding: screenPadding,
                                            decoration: BoxDecoration(
                                              color: ColorConstant.primary,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Colors.pink,
                                                  ColorConstant.primary
                                                ],
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: ColorConstant.grey,
                                                    blurRadius: 8,
                                                    spreadRadius: 2,
                                                    offset: Offset(0, 3)),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "MOCK EXAMINATION",
                                                      style: TextStyleConstant
                                                          .bold18(
                                                              color:
                                                                  ColorConstant
                                                                      .white)),
                                                ),
                                                if (widget.isPurchase == '0')
                                                  const Icon(
                                                    FontAwesomeIcons.lock,
                                                    color: Colors.red,
                                                  ),
                                              ],
                                            ))),
                                  );
                                },
                              )
                            : const SizedBox(),
                      ],
                    );
                  },
                ),
              ),
            ],
          )
        : const CustomNoDataFound();
  }
}
