import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/image_path_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/login_controller.dart';
import 'package:firesafety/Services/form_validation_services.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:firesafety/Widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<LoginController>(
          init: LoginController(),
          builder: (controller) {
            return Form(
              key: controller.formKey,
              child: Padding(
                padding: screenPadding,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: Get.height * 0.150, bottom: Get.height * 0.050),
                      child: SizedBox(
                          height: Get.height * 0.200,
                          width: Get.width * 0.400,
                          child: Image.asset(ImagePathConstant.logo,
                              fit: BoxFit.fill)),
                    ),
                    Text("Login", style: TextStyleConstant.bold30()),
                    Padding(
                      padding: EdgeInsets.only(
                          top: Get.height * 0.040, bottom: Get.height * 0.006),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Phone",
                              style: TextStyleConstant.medium18())),
                    ),
                    CustomTextField(
                      controller: controller.phoneController,
                      hintText: "Phone",
                      textInputType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone),
                      validator: FormValidationServices.validatePhone(),
                    ),
                    const Spacer(),
                    CustomButton(
                      title: "Send Otp",
                      onTap: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.getOtp();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
