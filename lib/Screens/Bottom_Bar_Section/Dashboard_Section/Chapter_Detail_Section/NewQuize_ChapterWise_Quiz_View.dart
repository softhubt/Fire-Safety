import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/NewQuizechaperwisecontroller.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';

class NewQuizeChperWIseQuizeScreen extends StatefulWidget {
  final String courseId;

  const NewQuizeChperWIseQuizeScreen({super.key, required this.courseId});

  @override
  State<NewQuizeChperWIseQuizeScreen> createState() =>
      _NewQuizeChperWIseQuizeScreenState();
}

class _NewQuizeChperWIseQuizeScreenState
    extends State<NewQuizeChperWIseQuizeScreen>
    with SingleTickerProviderStateMixin {
  NewquizechapeterwiseController controller =
      Get.put(NewquizechapeterwiseController());

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
      // appBar: CustomAppBar(
      //     title: "Course Details",
      //     leading: IconButton(
      //         onPressed: () => Get.back(),
      //         icon: const Icon(Icons.arrow_back, color: ColorConstant.white))),
      body: Padding(
        padding: EdgeInsets.only(
            top: screenHeightPadding,
            left: screenWidthPadding,
            right: screenWidthPadding),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.006, horizontal: Get.width * 0.014),
              height: Get.height * 0.054,
              decoration: BoxDecoration(
                color: ColorConstant.extraLightPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: controller.tabController,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: ColorConstant.primary),
                labelColor: ColorConstant.white,
                tabs: controller.tabList,
                dividerColor: ColorConstant.transparent,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  // overviewContent(controller: controller),
                  courseContent(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.only(
      //       bottom: screenHeightPadding,
      //       left: screenWidthPadding,
      //       right: screenWidthPadding),
      //   child: CustomButton(
      //     title: "Purchase",
      //     onTap: () {
      //       // Get.to(() => controller.openRazorPay());
      //
      //       //  Get.to(() => SpeakingTestModule(chapterId: ""));
      //       //  Get.to(() => StudentFormView());
      //       Get.to(() => PaymentThankYouView());
      //     },
      //   ),
      // ),
    );
  }

  // Widget overviewContent({required CourseDetailController controller}) {
  //   return const Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       ListTile(
  //         leading: Icon(Icons.watch, color: ColorConstant.primary),
  //         title: Text("Duration: 6 hours"),
  //       ),
  //       ListTile(
  //         leading:
  //         Icon(FontAwesomeIcons.certificate, color: ColorConstant.primary),
  //         title: Text("Completion Certificate"),
  //       ),
  //       ListTile(
  //         leading: Icon(Icons.calendar_today, color: ColorConstant.primary),
  //         title: Text("90 Days Access"),
  //       ),
  //       ListTile(
  //         leading: Icon(Icons.card_giftcard, color: ColorConstant.primary),
  //         title: Text("Enroll and win rewards"),
  //       ),
  //     ],
  //   );
  // }

  Widget courseContent({required NewquizechapeterwiseController controller}) {
    return (controller.getChapterListModel.courseChapterList != null)
        ? ListView.builder(
            itemCount: controller.getChapterListModel.courseChapterList?.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                // onTap: () {
                //   Get.to(() =>  ChapterDetailScreen(
                //       chapterId:
                //       "${controller.getChapterListModel.courseChapterList?[index].chapterId}")
                //
                //     // SpeakingTestModule(
                //     // chapterId:
                //     //     "${controller.getChapterListModel.courseChapterList?[index].chapterId}")
                //   );
                // },
                child: Padding(
                  padding: contentPadding,
                  child: Container(
                    padding: contentPadding,
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: ColorConstant.grey,
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${controller.getChapterListModel.courseChapterList?[index].chapterName}",
                                      style: TextStyleConstant.bold18()),
                                  Row(
                                    children: [
                                      const Icon(Icons.watch,
                                          color: ColorConstant.primary),
                                      Text(
                                        "${controller.getChapterListModel.courseChapterList?[index].duration}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.description,
                                          color: ColorConstant.primary),
                                      Text(
                                          "${controller.getChapterListModel.courseChapterList?[index].description}",
                                          style: TextStyleConstant.medium14()),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "${controller.getChapterListModel.courseChapterList?[index].chapterImage}",
                            width: 70,
                            height: 70,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : const CustomNoDataFound();
  }
}
