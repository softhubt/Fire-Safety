import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/image_path_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Screens/speaking_test_Screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_asset_image.dart';
import 'package:firesafety/Widgets/custom_button.dart';

class StudentFormThankView extends StatefulWidget {
  final String userId;

  const StudentFormThankView({super.key, required this.userId});

  @override
  State<StudentFormThankView> createState() => _StudentFormThankViewState();
}

class _StudentFormThankViewState extends State<StudentFormThankView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Thanku",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorConstant.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: screenHorizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: Get.height * 0.100, bottom: Get.height * 0.064),
                  child: CustomAssetImage(
                      height: Get.height * 0.197,
                      width: Get.width * 0.511,
                      image: ImagePathConstant.paymentSuccess,
                      isSvg: false)),
              Text("Thank you! Your form has been successfully submitted.",
                  style:
                      TextStyleConstant.bold16(color: ColorConstant.primary)),
              Padding(
                padding: EdgeInsets.only(
                    top: Get.height * 0.040, bottom: Get.height * 0.034),
                child: Text(
                    "Thank you for your submission. We have received your form..",
                    style:
                        TextStyleConstant.regular14(color: ColorConstant.grey),
                    textAlign: TextAlign.center),
              ),
              CustomButton(
                title: "Give Tests",
                onTap: () {
                  // Get.to(() => SpeakingTestModule(chapterId: widget.chapterId, userId:widget.userId,));
                  Get.to(() => SpeakingTestModule(
                        userId: widget.userId,
                      ));
                  //  Get.to(() => SpeakingTestModule( cameras: [],));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
