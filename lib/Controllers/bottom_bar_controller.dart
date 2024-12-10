import 'package:firesafety/Screens/Bottom_Bar_Section/My_Course_Section/my_purchase_categotylist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/dashboard_screen.dart';
import 'package:firesafety/Services/local_storage_services.dart';

class BottomBarController extends GetxController {
  RxString userId = "".obs;
  RxList<Widget> screenList = <Widget>[].obs;
  RxInt selectedIndex = 0.obs;
  RxBool isLoading = true.obs; // Loading state

  @override
  void onInit() {
    super.onInit();
    initialFunction();
  }

  Future<void> initialFunction() async {
    isLoading.value = true; // Start loading

    // Fetch userId from local storage
    userId.value = await StorageServices.getData(
          dataType: StorageKeyConstant.stringType,
          prefKey: StorageKeyConstant.userId,
        ) ??
        "";

    // Populate screenList after fetching userId
    screenList.value = [
      DashboardScreen(userId: userId.value),
      // const MyCourseListView(),
      MypurchesCatrgotyListscreen(userId: userId.value),
    ];

    isLoading.value = false; // Stop loading after data is fetched
  }

  // Optional: Lazily load screens when selected
  Widget getScreen(int index) {
    if (screenList.isEmpty || isLoading.value) {
      return const Center(
          child: CircularProgressIndicator()); // Show loading spinner
    } else {
      return screenList[index];
    }
  }
}
