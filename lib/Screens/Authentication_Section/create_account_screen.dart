import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/image_path_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/create_account_controller.dart';
import 'package:firesafety/Services/form_validation_services.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:firesafety/Widgets/custom_textfield.dart';

class CreateAccountScreen extends StatelessWidget {
  final String id;

  const CreateAccountScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<CreateAccountController>(
          init: CreateAccountController(),
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
                    Text("Create Account", style: TextStyleConstant.bold30()),
                    Padding(
                      padding: EdgeInsets.only(
                          top: Get.height * 0.040, bottom: Get.height * 0.006),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("First Name",
                              style: TextStyleConstant.medium18())),
                    ),
                    CustomTextField(
                      controller: controller.firstNameController,
                      hintText: "First Name",
                      textInputType: TextInputType.name,
                      prefixIcon: const Icon(Icons.person),
                      validator: FormValidationServices.validateField(
                          fieldName: "First Name"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: contentHeightPadding,
                          bottom: Get.height * 0.006),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Last Name",
                              style: TextStyleConstant.medium18())),
                    ),
                    CustomTextField(
                      controller: controller.lastNameController,
                      hintText: "Last Name",
                      textInputType: TextInputType.name,
                      prefixIcon: const Icon(Icons.person),
                      validator: FormValidationServices.validateField(
                          fieldName: "Last Name"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: contentHeightPadding,
                          bottom: Get.height * 0.006),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Email",
                              style: TextStyleConstant.medium18())),
                    ),
                    CustomTextField(
                      controller: controller.emailController,
                      hintText: "Email",
                      textInputType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email),
                      validator: FormValidationServices.validateEmail(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: contentHeightPadding,
                          bottom: Get.height * 0.006),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Password",
                              style: TextStyleConstant.medium18())),
                    ),
                    CustomTextField(
                      controller: controller.passwordController,
                      hintText: "Password",
                      textInputType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(Icons.lock),
                      validator: FormValidationServices.validateField(
                          fieldName: "Password"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: contentHeightPadding,
                          bottom: Get.height * 0.006),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text("Bio", style: TextStyleConstant.medium18())),
                    ),
                    CustomTextField(
                      controller: controller.bioController,
                      hintText: "Bio",
                      textInputType: TextInputType.text,
                      prefixIcon: const Icon(Icons.info),
                      validator: FormValidationServices.validateField(
                          fieldName: "Bio"),
                    ),
                    const Spacer(),
                    CustomButton(
                      title: "Create Account",
                      onTap: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.postCreateAccount(id: id);
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
