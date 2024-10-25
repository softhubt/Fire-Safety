import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/image_path_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Student_Form_View.dart';
import 'package:firesafety/Widgets/custom_asset_image.dart';
import 'package:firesafety/Widgets/custom_button.dart';

class PaymentThankYouView extends StatelessWidget {
  final String userId;
  const PaymentThankYouView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: screenHorizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: Get.height * 0.100,
                  bottom: Get.height * 0.064,
                ),
                child: CustomAssetImage(
                  height: Get.height * 0.197,
                  width: Get.width * 0.511,
                  image: ImagePathConstant.paymentSuccess,
                  isSvg: false,
                ),
              ),
              Text(
                "Payment Done successfully.",
                style: TextStyleConstant.bold16(color: ColorConstant.primary),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: Get.height * 0.040,
                  bottom: Get.height * 0.034,
                ),
                child: Text(
                  "Thank you for purchasing our course! We're excited to help you achieve your goals and look forward to your success.",
                  style: TextStyleConstant.regular14(color: ColorConstant.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              CustomButton(
                title: "Next",
                onTap: () {
                  Get.to(() => StudentFormView(
                        userId: userId,
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
