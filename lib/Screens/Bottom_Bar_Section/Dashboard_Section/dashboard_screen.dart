import 'package:carousel_slider/carousel_slider.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/drawer_view.dart';
import 'package:firesafety/Widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/dashboard_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/select_subcategory_screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;
  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardController controller = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    controller.initialFunctioun().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Dashboard",
        leading: IconButton(
          onPressed: () {
            Get.to(() => const DrawerView());
          },
          icon: const Icon(Icons.menu_open_rounded, color: ColorConstant.white),
        ),
      ),
      drawer: appDrawer(),
      body: ListView(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeightPadding,
                  horizontal: screenHeightPadding),
              child: (controller.getadvertiesmentModel.advertisementList !=
                      null)
                  ? CarouselSlider.builder(
                      itemCount: controller
                          .getadvertiesmentModel.advertisementList?.length,
                      itemBuilder: (context, index, realIndex) {
                        final element = controller
                            .getadvertiesmentModel.advertisementList?[index];
                        return Container(
                            width: Get.width * 0.900,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                    image:
                                        NetworkImage("${element?.imagePath}"),
                                    fit: BoxFit.fill)));
                      },
                      options: CarouselOptions(
                          initialPage: 0,
                          autoPlay: true,
                          height: Get.height * 0.180,
                          viewportFraction: 1))
                  : CustomShimmer(
                      height: Get.height * 0.180, width: Get.width * 0.900)),
          Padding(
            padding: screenHorizontalPadding,
            child: (controller.getCategoryModel.categoryList != null)
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.getCategoryModel.categoryList?.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: contentHeightPadding,
                        crossAxisSpacing: contentWidthPadding,
                        childAspectRatio: 2 / 2),
                    itemBuilder: (BuildContext context, int index) {
                      final element =
                          controller.getCategoryModel.categoryList?[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => SelectSubcategoryScreen(
                              categoryId: "${element?.categoryId}",
                              userId: widget.userId));
                        },
                        child: Container(
                          padding: contentPadding,
                          decoration: BoxDecoration(
                              color: ColorConstant.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(24)),
                          child: Column(
                            children: [
                              Container(
                                height: Get.height * 0.120,
                                width: Get.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "${element?.categoryImage}"),
                                        fit: BoxFit.fill)),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: contentHeightPadding),
                                  child: Text("${element?.categoryName}",
                                      style: TextStyleConstant.medium18(),
                                      overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: contentHeightPadding,
                        crossAxisSpacing: contentWidthPadding,
                        childAspectRatio: 2 / 1.8),
                    itemBuilder: (BuildContext context, int index) {
                      return const CustomShimmer(radius: 24);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget appDrawer() {
    return ListView(
      children: [],
    );
  }
}
