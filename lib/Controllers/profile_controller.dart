import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxString name = "".obs;
  RxString email = "".obs;

  Future initialFunctioun() async {
    name.value = await StorageServices.getData(
        dataType: StorageKeyConstant.stringType,
        prefKey: StorageKeyConstant.userName);

    email.value = await StorageServices.getData(
        dataType: StorageKeyConstant.stringType,
        prefKey: StorageKeyConstant.email);
  }
}
