import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/image_path_constant.dart';
import 'package:firesafety/Controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashController>(
        init: SplashController(),
        builder: (controller) {
          return Center(
            child: Container(
              height: Get.height * 0.200,
              width: Get.width * 0.380,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImagePathConstant.logo),
                      fit: BoxFit.fill)),
            ),
          );
        },
      ),
    );
  }
}
