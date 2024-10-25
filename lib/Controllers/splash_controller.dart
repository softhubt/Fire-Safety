import 'package:get/get.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Screens/Authentication_Section/login_screen.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
import 'package:firesafety/Services/local_storage_services.dart';

class SplashController extends GetxController {
  RxBool isAuthenticate = false.obs;

  @override
  void onInit() {
    super.onInit();
    changeView();
  }

  changeView() async {
    isAuthenticate.value = await StorageServices.getData(
            dataType: StorageKeyConstant.boolType,
            prefKey: StorageKeyConstant.isAuthenticate) ??
        false;
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (isAuthenticate.value) {
          Get.offAll(() => const BottomBarScreen());
        } else {
          Get.offAll(() => const LoginScreen());
        }
      },
    );
  }
}
