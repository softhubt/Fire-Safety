import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/student_dashboard_controller.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentDashboardView extends StatefulWidget {
  final String categoryId;
  final String courseName;
  final String subcategoryId;
  final String testpaymentId;

  const StudentDashboardView(
      {super.key,
      required this.categoryId,
      required this.courseName,
      required this.subcategoryId,
      required this.testpaymentId});

  @override
  State<StudentDashboardView> createState() => _StudentDashboardViewState();
}

class _StudentDashboardViewState extends State<StudentDashboardView> {
  final StudentDashboardController controller =
      Get.put(StudentDashboardController());

  @override
  void initState() {
    super.initState();
    controller
        .initialFunctioun(
            categoryId: widget.categoryId,
            subCategoryName: widget.courseName,
            subcategoryId: widget.subcategoryId,
            testPaymentId: widget.testpaymentId)
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "Student Dashboard", isBack: true),
        body: Padding(
          padding: screenHorizontalPadding,
          child: ListView(
            children: [
              responsiveSizedBoxHeight(height: 10),
              Text("Batch: ${controller.getBatchDetailsModel.batchName ?? ""}",
                  style: TextStyleConstant.semiBold18()),
              Text(
                  "Teacher: ${controller.getBatchDetailsModel.teacherName ?? ""}",
                  style: TextStyleConstant.semiBold16()),
              responsiveSizedBoxHeight(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.dashboardElementList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1),
                itemBuilder: (context, index) {
                  final element = controller.dashboardElementList[index];
                  return GestureDetector(
                      onTap: element.onTap,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(2, 2)),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: ColorConstant.primary,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(element.icon,
                                      color: ColorConstant.white)),
                              const SizedBox(height: 8),
                              Text(element.title,
                                  style: TextStyleConstant.semiBold16(),
                                  textAlign: TextAlign.center),
                              if (index == 1)
                                IconButton(
                                    onPressed: () => openMyEnrollmentUrl(
                                        url:
                                            "https://softebuild.com/fire_safety/api/print_booking_form.php?order_number=${widget.testpaymentId}"),
                                    icon: const Icon(Icons.download_rounded,
                                        color: ColorConstant.primary))
                            ],
                          )));
                },
              ),
            ],
          ),
        ));
  }

  Future<void> openMyEnrollmentUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
