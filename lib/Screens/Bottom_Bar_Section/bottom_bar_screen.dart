import 'package:firesafety/Constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/bottom_bar_controller.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';

class BottomBarScreen extends StatefulWidget {
  final int? currentIndex;
  const BottomBarScreen({super.key, this.currentIndex});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen>
    with TickerProviderStateMixin {
  BottomBarController controller = Get.put(BottomBarController());

  @override
  void initState() {
    super.initState();
    controller.initialFunction(vsync: this).whenComplete(() => setState(() {
          if (widget.currentIndex != null) {
            controller.motionTabBarController.index = widget.currentIndex!;
            controller.selectedIndex.value = widget.currentIndex!;
          } else {
            controller.motionTabBarController.index = 0;
            controller.selectedIndex.value = 0;
          }
        }));
  }

  @override
  void dispose() {
    super.dispose();
    controller.motionTabBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.screenList.isEmpty) {
          return const Center(child: Text("Loading...")); // Fallback content
        }
        return controller.screenList[controller.selectedIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        if (controller.screenList.isEmpty) {
          return const SizedBox.shrink(); // Hide navigation bar until ready
        }
        return MotionTabBar(
          controller: controller.motionTabBarController,
          initialSelectedTab:
              controller.lableList[controller.selectedIndex.value],
          labels: controller.lableList,
          icons: controller.iconList,
          tabIconColor: ColorConstant.primary,
          tabSelectedColor: ColorConstant.primary,
          tabIconSelectedColor: ColorConstant.white,
          tabBarColor: ColorConstant.white,
          onTabItemSelected: (int value) {
            setState(() {
              controller.motionTabBarController.index = value;
              controller.selectedIndex.value = value;
            });
          },
        );
      }),
    );
  }
}
