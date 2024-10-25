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
  final String userId;

  const SelectSubcategoryScreen(
      {super.key, required this.categoryId, required this.userId});

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
    controller
        .getSubcategory(categoryId: widget.categoryId)
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Subcategories",
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: ColorConstant.white)),
      ),
      body: Padding(
        padding: screenPadding,
        child: (controller.getSubcategoryModel.subcategoryList != null)
            ? GridView.builder(
                shrinkWrap: true,
                itemCount:
                    controller.getSubcategoryModel.subcategoryList?.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1.0),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => CourseListScreen(
                            categoryId:
                                "${controller.getSubcategoryModel.subcategoryList?[index].categoryId}",
                            subcategoryId:
                                "${controller.getSubcategoryModel.subcategoryList?[index].subcategoryId}",
                            userId: widget.userId,
                          ));
                    },
                    child: Card(
                      child: Container(
                        padding: contentPadding,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.123,
                              width: Get.width,
                              child: Image.network(
                                  "${controller.getSubcategoryModel.subcategoryList?[index].subcategoryImage}",
                                  fit: BoxFit.fill),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: Get.height * 0.020),
                              child: Text(
                                  "${controller.getSubcategoryModel.subcategoryList?[index].subcategoryName}",
                                  style: TextStyleConstant.semiBold16(),
                                  overflow: TextOverflow.ellipsis),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : const CustomNoDataFound(),
      ),
    );
  }
}
