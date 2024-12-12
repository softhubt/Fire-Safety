import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/profile_controller.dart';
import 'package:firesafety/Screens/Authentication_Section/login_screen.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:firesafety/Widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    controller.initialFunctioun().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.primary.withOpacity(0.1),
        body: Padding(
          padding: screenHorizontalPadding,
          child: ListView(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: Get.height * 0.060, bottom: screenHeightPadding),
                  child: Container(
                      padding: contentPadding,
                      alignment: Alignment.center,
                      height: Get.height * 0.120,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: ColorConstant.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              width: 2, color: ColorConstant.extraLightGrey)),
                      child: Row(
                        children: [
                          Container(
                              height: Get.height,
                              width: Get.width * 0.200,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConstant.extraLightGrey)),
                          Padding(
                              padding:
                                  EdgeInsets.only(left: screenWidthPadding),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controller.name.value,
                                      style: TextStyleConstant.semiBold20()),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom: Get.height * 0.026),
                                      child: Text(controller.email.value,
                                          style: TextStyleConstant.medium16(
                                              color: ColorConstant.grey))),
                                ],
                              )),
                        ],
                      ))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      leading: const Icon(Icons.wallet_rounded,
                          color: ColorConstant.primary),
                      title: Text("Payment Methods",
                          style: TextStyleConstant.medium18()),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded)),
                  ListTile(
                      leading: const Icon(Icons.info_rounded,
                          color: ColorConstant.primary),
                      title:
                          Text("About Us", style: TextStyleConstant.medium18()),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded)),
                  ListTile(
                      leading: const Icon(Icons.contacts_rounded,
                          color: ColorConstant.primary),
                      title: Text("Contact Us",
                          style: TextStyleConstant.medium18()),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded)),
                  ListTile(
                      leading: const Icon(Icons.star_rate_rounded,
                          color: ColorConstant.primary),
                      title:
                          Text("Rate Us", style: TextStyleConstant.medium18()),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded)),
                  ListTile(
                      leading: const Icon(Icons.rule_rounded,
                          color: ColorConstant.primary),
                      title: Text("Terms and Conditions",
                          style: TextStyleConstant.medium18()),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded)),
                  CustomButton(
                    title: "Log Out",
                    height: Get.height * 0.046,
                    width: Get.width * 0.300,
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      StorageServices.clearData();
                      customToast(message: "Log Out");
                      Get.offAll(() => const LoginScreen());
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
