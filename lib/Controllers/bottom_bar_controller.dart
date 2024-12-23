import 'package:firesafety/Screens/Bottom_Bar_Section/My_Course_Section/my_purchase_categotylist_screen.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Profile_Section/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/dashboard_screen.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class BottomBarController extends GetxController {
  RxList<Widget> screenList = <Widget>[].obs;
  RxList<IconData> iconList = <IconData>[
    Icons.home_rounded,
    Icons.book_rounded,
    Icons.person_rounded
  ].obs;
  RxList<String> lableList = <String>["Dashboard", "My Courses", "Profile"].obs;

  late MotionTabBarController motionTabBarController;

  RxString userId = "".obs;

  RxInt selectedIndex = 0.obs;

  Future<void> initialFunction(
      {required TickerProvider vsync, required int widgetCurrentIndex}) async {
    userId.value = await StorageServices.getData(
            dataType: StorageKeyConstant.stringType,
            prefKey: StorageKeyConstant.userId) ??
        "";

    screenList.value = [
      DashboardScreen(userId: userId.value),
      MypurchesCatrgotyListscreen(userId: userId.value),
      const ProfileView(),
    ];

    // Initialize motionTabBarController
    motionTabBarController = MotionTabBarController(
      initialIndex: widgetCurrentIndex,
      length: screenList.length,
      vsync: vsync,
    );

    // Assign widgetCurrentIndex
    selectedIndex.value = widgetCurrentIndex;

    // Ensure the controller is ready before setting its index
    await Future.delayed(Duration.zero);
    motionTabBarController.index = widgetCurrentIndex;
  }
}
