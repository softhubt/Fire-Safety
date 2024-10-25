import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Screens/Authentication_Section/login_screen.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({super.key});

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Drawer", isBack: true),
      body: Padding(
        padding: screenHorizontalPadding,
        child: ListView(
          children: [
            const ListTile(
              leading: Icon(Icons.star_rounded, color: ColorConstant.primary),
              title: Text("Rate Us"),
            ),
            const ListTile(
              leading:
                  Icon(Icons.privacy_tip_rounded, color: ColorConstant.primary),
              title: Text("Privacy Policy"),
            ),
            const ListTile(
              leading: Icon(Icons.currency_rupee_rounded,
                  color: ColorConstant.primary),
              title: Text("Refer and Earn"),
            ),
            const ListTile(
              leading: Icon(Icons.share_rounded, color: ColorConstant.primary),
              title: Text("Share Simply Learn AAP"),
            ),
            ListTile(
              onTap: () {
                StorageServices.clearData();
                customToast(message: "Log Out");
                Get.offAll(() => const LoginScreen());
              },
              leading: const Icon(Icons.logout_rounded,
                  color: ColorConstant.primary),
              title: const Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}
