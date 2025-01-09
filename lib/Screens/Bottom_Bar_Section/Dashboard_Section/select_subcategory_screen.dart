import 'package:firesafety/Models/get_subcategory_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/select_subcategory_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/course_list_screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';

class SelectSubcategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String userId;

  const SelectSubcategoryScreen(
      {super.key,
      required this.categoryId,
      required this.userId,
      required this.categoryName});

  @override
  State<SelectSubcategoryScreen> createState() =>
      _SelectSubcategoryScreenState();
}

class _SelectSubcategoryScreenState extends State<SelectSubcategoryScreen> {
  SelectSubcategoryController controller =
      Get.put(SelectSubcategoryController());

  @override
  void initState() {
    super.initState();
    // Fetch the subcategory data when the screen is initialized
    controller
        .getSubcategory(categoryId: widget.categoryId, userId: widget.userId)
        .whenComplete(() =>
            setState(() {})); // Call setState to refresh the UI after data load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "${widget.categoryName} Courses",
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: ColorConstant.white))),
      body: Padding(
        padding: screenPadding,
        child: (controller.getSubcategoryModel.subcategoryList != null)
            ? ListView.builder(
                itemCount:
                    controller.getSubcategoryModel.subcategoryList?.length,
                itemBuilder: (BuildContext context, int index) {
                  // Access the subcategory data for each item
                  var element =
                      controller.getSubcategoryModel.subcategoryList?[index];

                  return GestureDetector(
                    onTap: () {
                      // Access the subcategory object
                      var subcategory = controller
                          .getSubcategoryModel.subcategoryList?[index];

                      // Check if the subcategory has been purchased (is_purchase == 1)
                      if (subcategory?.isPurchase == 1) {
                        // If is_purchase is 1, navigate to MypurchesCatrgotyListscreen
                        Get.offAll(
                            () => const BottomBarScreen(currentIndex: 1));
                      } else {
                        // If is_purchase is 0, navigate to CourseListScreen
                        Get.to(() => CourseListScreen(
                              categoryId: "${subcategory?.categoryId}",
                              subcategoryId: "${subcategory?.subcategoryId}",
                              amount: "${subcategory?.amount}",
                              days: "${subcategory?.days}",
                              userId: widget.userId,
                              isPurchase: "${subcategory?.isPurchase}",
                            ));
                      }
                    },
                    child: buildDetailedCard(element),
                  );
                },
              )
            : const CustomNoDataFound(),
      ),
    );
  }

  Widget buildDetailedCard(SubcategoryList? element) {
    return Card(
        color: ColorConstant.white,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
            padding: contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    element?.subcategoryImage ?? '',
                    height: Get.height * 0.2,
                    width: Get.width,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                // Course Name
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
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee, color: Colors.green),
                        Text(element?.amount ?? 'N/A',
                            style: TextStyleConstant.semiBold20()),
                      ],
                    ),
                    // Duration
                    Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.blue),
                        Text("${element?.days ?? 'N/A'} Days",
                            style: TextStyleConstant.medium16()),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                (element?.isPurchase == 0)
                    ? CustomButton(
                        title: "Buy Now",
                        onTap: () {
                          Get.to(() => CourseListScreen(
                              categoryId: "${element?.categoryId}",
                              subcategoryId: "${element?.subcategoryId}",
                              amount: "${element?.amount}",
                              days: "${element?.days}",
                              userId: widget.userId,
                              isPurchase: "${element?.isPurchase}"));
                        },
                      )
                    : Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            element?.status ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ],
            )));
  }
}
