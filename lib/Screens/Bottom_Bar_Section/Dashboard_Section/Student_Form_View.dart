import 'dart:developer';
import 'dart:io';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Controllers/SubmitStudentdfrom_Controller.dart';
import 'package:firesafety/Services/form_validation_services.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_button.dart';
import 'package:firesafety/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Models/Post_SubmitStudentForm_Model.dart';
import 'package:firesafety/Models/get_BranchList_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/StudentForm_Thanku_View.dart';
import 'package:firesafety/Widgets/custom_loader.dart';

class StudentFormView extends StatefulWidget {
  final String userId;
  final String id;
  const StudentFormView({super.key, required this.userId, required this.id});

  @override
  State<StudentFormView> createState() => _StudentFormViewState();
}

class _StudentFormViewState extends State<StudentFormView> {
  SubmitStudentFormController controller =
      Get.put(SubmitStudentFormController());

  // State to keep track of checkbox selections
  List<bool> courseSelections = List.generate(5, (index) => false);
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SubmitStudentFormController());
    controller.userId.value = widget.userId;
    controller.id.value = widget.id;
    controller.getBranchListform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Student Form", isBack: true),
      body: Padding(
        padding: screenHorizontalPadding,
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              // const Icon(Icons.remove_red_eye, color: Colors.blue), // Eye icon
              // const SizedBox(width: 8), // Space between icon and text
              // const Text("View Sample From", style: TextStyle(fontSize: 16)),
              // // Space between the form and the image
              // Padding(
              //   padding: const EdgeInsets.only(left: 170),
              //   child: Image.asset(
              //     ImagePathConstant.Receipt,
              //     width: 150,
              //     height: 150,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Name", style: TextStyleConstant.medium16())),
              CustomTextField(
                  controller: controller.nameController,
                  hintText: "Enter Your Name",
                  textInputType: TextInputType.name,
                  validator:
                      FormValidationServices.validateField(fieldName: "Name")),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child:
                      Text("Nationality", style: TextStyleConstant.medium16())),
              CustomTextField(
                  controller: controller.nationalityController,
                  hintText: "Enter Your Nationality",
                  textInputType: TextInputType.name,
                  validator: FormValidationServices.validateField(
                      fieldName: "Nationality")),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Date of Birth",
                      style: TextStyleConstant.medium16())),
              GestureDetector(
                  onTap: () {
                    showDatePickerDialog(
                        textEditingController: controller.dobController);
                  },
                  child: CustomTextField(
                      controller: controller.dobController,
                      hintText: "Enter Your Date of Birth",
                      textInputType: TextInputType.name,
                      enable: false,
                      validator: FormValidationServices.validateField(
                          fieldName: "Date of Birth"))),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Select Gender",
                      style: TextStyleConstant.medium16())),
              Row(
                children: [
                  Expanded(
                      child: CustomButton(
                    title: "Male",
                    backGroundColor: (controller.genderValue.value == "Male")
                        ? ColorConstant.primary
                        : ColorConstant.primary.withOpacity(0.1),
                    textColor: (controller.genderValue.value == "Male")
                        ? ColorConstant.white
                        : ColorConstant.primary,
                    onTap: () {
                      controller.genderValue.value = "Male";
                      setState(() {});
                    },
                  )),
                  SizedBox(width: screenWidthPadding),
                  Expanded(
                      child: CustomButton(
                    title: "Female",
                    backGroundColor: (controller.genderValue.value == "Female")
                        ? ColorConstant.primary
                        : ColorConstant.primary.withOpacity(0.1),
                    textColor: (controller.genderValue.value == "Female")
                        ? ColorConstant.white
                        : ColorConstant.primary,
                    onTap: () {
                      controller.genderValue.value = "Female";
                      setState(() {});
                    },
                  )),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Country and Birth Place",
                      style: TextStyleConstant.medium16())),
              CustomTextField(
                  controller: controller.countryBirthController,
                  hintText: "Enter Country Birth Place",
                  textInputType: TextInputType.name,
                  validator: FormValidationServices.validateField(
                      fieldName: "Country and Birth Place")),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Material Status",
                      style: TextStyleConstant.medium16())),
              buildMaritalStatusDropdown(),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Address", style: TextStyleConstant.medium16())),
              CustomTextField(
                  controller: controller.addressController,
                  hintText: "Enter Street Address",
                  textInputType: TextInputType.streetAddress,
                  validator: FormValidationServices.validateField(
                      fieldName: "Address")),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Country", style: TextStyleConstant.medium16())),
              buildGetContryListDropdown(),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("State", style: TextStyleConstant.medium16())),
              buildStateListDropdown(),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Zip Code", style: TextStyleConstant.medium16())),
              CustomTextField(
                  controller: controller.zipCodeController,
                  hintText: "Enter Zip Code",
                  textInputType: TextInputType.number,
                  validator: FormValidationServices.validateField(
                      fieldName: "Zip Code")),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Phone", style: TextStyleConstant.medium16())),
              CustomTextField(
                  controller: controller.phoneController,
                  hintText: "Enter Phone",
                  textInputType: TextInputType.phone,
                  validator: FormValidationServices.validatePhone()),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Alternative Phone",
                      style: TextStyleConstant.medium16())),
              CustomTextField(
                  controller: controller.mobileController,
                  hintText: "Enter Alternative Phone",
                  textInputType: TextInputType.number,
                  validator: FormValidationServices.validatePhone()),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Email", style: TextStyleConstant.medium16())),
              CustomTextField(
                  controller: controller.emailController,
                  hintText: "Enter Email",
                  textInputType: TextInputType.emailAddress,
                  validator: FormValidationServices.validateEmail()),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Alternative Email",
                      style: TextStyleConstant.medium16())),
              CustomTextField(
                  controller: controller.altEmailController,
                  hintText: "Enter Alternative Email",
                  textInputType: TextInputType.emailAddress,
                  validator: FormValidationServices.validateEmail()),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child:
                      Text("Exam Venue", style: TextStyleConstant.medium16())),
              CustomTextField(
                  controller: controller.examvenueController,
                  hintText: "Enter Exam Venue",
                  textInputType: TextInputType.streetAddress,
                  validator: FormValidationServices.validateField(
                      fieldName: "Exam Venue")),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Branch", style: TextStyleConstant.medium16())),
              buildSelectBranchDropdown(),

              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding),
                  child: Center(
                      child: Text('TRAINING COURSES',
                          style: TextStyleConstant.bold18()))),
              buildCourseCheckbox('1. Diploma Safety Course', 0),
              buildCourseCheckbox('2. POST DIPLOMA Safety COURSES', 1),
              buildCourseCheckbox('3. GRADUATION PROGRAMS (ASP/CSP)', 2),
              buildCourseCheckbox('4. CERTIFICATE COURSES', 3),
              buildCourseCheckbox(
                  '5. NIBOSH IGC (International General Certification) IG1 & IG2',
                  4),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Mode of Enrollment",
                      style: TextStyleConstant.medium16())),
              buildSelectModeeOfEnrollMentDropdown(), // Add some space
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text(
                      'Do any Delegates have disabilities that will\nrequire special facilities or assistance? If yes,\nplease outline their requirements.',
                      style: TextStyleConstant.medium16())),
              CustomTextField(
                  controller: controller.disabilityRequirementsController,
                  hintText: "Enter Requirements",
                  textInputType: TextInputType.text,
                  validator: FormValidationServices.validateField(
                      fieldName: "Requirements")),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Upload Your Document Images",
                      style: TextStyleConstant.semiBold16())),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Profile", style: TextStyleConstant.medium16()),
                      imageBox(
                          onTap: () {
                            selectImageSourceDialog(
                                controller: controller, imageNo: 1);
                          },
                          image: (controller.selectedImage1 != null)
                              ? File(controller.selectedImage1!.path)
                              : File("")),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Document", style: TextStyleConstant.medium16()),
                      imageBox(
                        onTap: () {
                          selectImageSourceDialog(
                              controller: controller, imageNo: 2);
                        },
                        image: (controller.selectedImage2 != null)
                            ? File(controller.selectedImage2!.path)
                            : File(""),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Signature", style: TextStyleConstant.medium16()),
                      imageBox(
                        onTap: () {
                          selectImageSourceDialog(
                              controller: controller, imageNo: 3);
                        },
                        image: (controller.selectedImage3 != null)
                            ? File(controller.selectedImage3!.path)
                            : File(""),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: screenHeightPadding, bottom: 6),
                  child: Text("Education Details",
                      style: TextStyleConstant.semiBold16())),
              CustomTextField(
                  controller: controller.institutionController,
                  hintText: "Institution Name",
                  textInputType: TextInputType.name),
              Padding(
                padding: contentVerticalPadding,
                child: GestureDetector(
                    onTap: () {
                      showDatePickerDialog(
                          textEditingController: controller.fromDateController);
                    },
                    child: CustomTextField(
                        controller: controller.fromDateController,
                        hintText: "From Date",
                        textInputType: TextInputType.name,
                        enable: false)),
              ),

              GestureDetector(
                  onTap: () {
                    showDatePickerDialog(
                        textEditingController: controller.toDateController);
                  },
                  child: CustomTextField(
                      controller: controller.toDateController,
                      hintText: "To Date",
                      textInputType: TextInputType.name,
                      enable: false)),
              Padding(
                padding: EdgeInsets.only(
                    top: contentHeightPadding, bottom: screenHeightPadding),
                child: CustomTextField(
                    controller: controller.degreeController,
                    hintText: "Enter Degree Obtained",
                    textInputType: TextInputType.name),
              ),
              CustomButton(title: "Add to List", onTap: addToList),
              buildAcademicTable(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Please verify the information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                  Checkbox(
                    value: _isVerified,
                    onChanged: (bool? value) {
                      setState(() {
                        _isVerified = value!;
                      });
                    },
                    activeColor: ColorConstant.green,
                    checkColor: Colors.white, // White checkmark color
                    side: BorderSide(
                        color: ColorConstant.lightGrey, // Subtle border color
                        width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: screenVerticalPadding,
                child: GestureDetector(
                    onTap: showTermsAndConditions,
                    child: Text("Read Terms and Conditions",
                        style: TextStyleConstant.bold18(
                            color: ColorConstant.primary))),
              ),
              CustomButton(title: "Submit", onTap: submitForm),
              SizedBox(height: screenHeightPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCourseCheckbox(String title, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorConstant.black.withOpacity(0.8),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Checkbox(
              key: ValueKey(courseSelections[index]),
              value: courseSelections[index],
              onChanged: (bool? value) {
                setState(() {
                  courseSelections[index] = value!;
                  controller.toggleCourseSelection(title);
                });
              },
              activeColor: ColorConstant.green,
              checkColor: Colors.white, // White checkmark color
              side: BorderSide(
                color: ColorConstant.lightGrey, // Subtle border color
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ... (other existing methods remain unchanged)

  TextFormField _buildTextField(TextEditingController controller, String label,
      {int? maxLines}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  TextFormField _buildTextEducationField(
      TextEditingController controller, String label,
      {int? maxLines}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      ),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'Please enter $label';
      //   }
      //   return null;
      // },
    );
  }

  TextFormField _nonmandatorybuildTextField(
      TextEditingController controller, String label,
      {int? maxLines}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      ),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'Please enter $label';
      //   }
      //   return null;
      // },
    );
  }

  Row _buildGenderSelector() {
    return Row(
      children: [
        Radio<String>(
          value: 'Male',
          groupValue: controller.genderValue.value,
          onChanged: (String? value) {
            setState(() {
              controller.genderValue.value = value!;
            });
          },
        ),
        const Text('Male'),
        const SizedBox(width: 20),
        Radio<String>(
          value: 'Female',
          groupValue: controller.genderValue.value,
          onChanged: (String? value) {
            setState(() {
              controller.genderValue.value = value!;
            });
          },
        ),
        const Text('Female'),
      ],
    );
  }

  DropdownButtonFormField<String> buildMaritalStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: controller.maritalStatusValue.value.isEmpty
          ? null
          : controller.maritalStatusValue.value,
      onChanged: (value) {
        setState(() {
          controller.maritalStatusValue.value = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Marital Status',
        labelStyle: TextStyle(
          color: ColorConstant.grey.withOpacity(0.8),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        hintText: 'Select Marital Status',
        hintStyle: TextStyle(
          color: ColorConstant.grey.withOpacity(0.6),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstant.lightGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: ColorConstant.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstant.lightGrey, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: <String>['', 'Single', 'Married', 'Divorced', 'Widowed']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value.isEmpty ? 'Select Marital Status' : value,
            style: TextStyle(
              color: value.isEmpty ? ColorConstant.grey : ColorConstant.black,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
      icon: Icon(
        Icons.arrow_drop_down,
        color: ColorConstant.primary.withOpacity(0.8),
      ),
      iconSize: 24,
      isExpanded: true,
      dropdownColor: ColorConstant.white,
    );
  }

  DropdownButtonFormField<String> buildGetContryListDropdown() {
    return DropdownButtonFormField<String>(
      value: controller.SelectcountryListValue.value.isEmpty
          ? null
          : controller.SelectcountryListValue.value,
      onChanged: (value) {
        setState(() {
          controller.SelectcountryListValue.value = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Select Country',
        labelStyle: TextStyle(
          color: ColorConstant.grey.withOpacity(0.8),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        hintText: 'Select a country',
        hintStyle: TextStyle(
          color: ColorConstant.grey.withOpacity(0.6),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstant.lightGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: ColorConstant.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstant.lightGrey, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: <String>['', 'India', 'Australia', 'China', 'Colombia', 'Italy']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value.isEmpty ? 'Select country' : value,
            style: TextStyle(
              color: value.isEmpty ? ColorConstant.grey : ColorConstant.black,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
      icon: Icon(
        Icons.arrow_drop_down,
        color: ColorConstant.primary.withOpacity(0.8),
      ),
      iconSize: 24,
      isExpanded: true,
      dropdownColor: ColorConstant.white,
    );
  }

  DropdownButtonFormField<String> buildStateListDropdown() {
    return DropdownButtonFormField<String>(
      value: controller.SelectStateListValue.value.isEmpty
          ? null
          : controller.SelectStateListValue.value,
      onChanged: (value) {
        setState(() {
          controller.SelectStateListValue.value = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Select State',
        labelStyle: TextStyle(
          color: ColorConstant.grey.withOpacity(0.8),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        hintText: 'Select a state',
        hintStyle: TextStyle(
          color: ColorConstant.grey.withOpacity(0.6),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstant.lightGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: ColorConstant.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstant.lightGrey, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: <String>[
        '',
        'Maharashtra',
        'Bihar',
        'Haryana',
        'Colombia',
        'Chhattisgarh'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value.isEmpty ? 'Select State' : value,
            style: TextStyle(
              color: value.isEmpty ? ColorConstant.grey : ColorConstant.black,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
      icon: Icon(
        Icons.arrow_drop_down,
        color: ColorConstant.primary.withOpacity(0.8),
      ),
      iconSize: 24,
      isExpanded: true,
      dropdownColor: ColorConstant.white,
    );
  }

  DropdownButtonFormField<String> buildSelectBranchDropdown() {
    return DropdownButtonFormField<String>(
      value: controller.selectBranch.value.isEmpty
          ? null
          : controller.selectBranch.value,
      onChanged: (value) {
        if (value != null) {
          controller.selectBranch.value = value;
        }
      },
      decoration: InputDecoration(
        labelText: 'Select Branch',
        labelStyle: TextStyle(
          color: ColorConstant.grey.withOpacity(0.8),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        hintText: 'Select a branch',
        hintStyle: TextStyle(
          color: ColorConstant.grey.withOpacity(0.6),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstant.lightGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: ColorConstant.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstant.lightGrey, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: controller.getBranchList.branchList != null
          ? controller.getBranchList.branchList!
              .map<DropdownMenuItem<String>>((BranchListItem item) {
              return DropdownMenuItem<String>(
                value: item.id,
                child: Text(
                  item.branch ?? 'Select Branch',
                  style: TextStyle(
                    color: item.branch?.isEmpty ?? false
                        ? ColorConstant.grey
                        : ColorConstant.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList()
          : [],
      icon: Icon(
        Icons.arrow_drop_down,
        color: ColorConstant.primary.withOpacity(0.8),
      ),
      iconSize: 24,
      isExpanded: true,
      dropdownColor: ColorConstant.white,
    );
  }

  DropdownButtonFormField<String> buildSelectModeeOfEnrollMentDropdown() {
    return DropdownButtonFormField<String>(
      value: controller.selectModeOfEnrollment.value.isEmpty
          ? null
          : controller.selectModeOfEnrollment.value,
      onChanged: (value) {
        setState(() {
          controller.selectModeOfEnrollment.value = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Select Mode of Enrollment',
        labelStyle: TextStyle(
          color: ColorConstant.grey.withOpacity(0.8),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        hintText: 'Select a branch',
        hintStyle: TextStyle(
          color: ColorConstant.grey.withOpacity(0.6),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstant.lightGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: ColorConstant.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorConstant.lightGrey, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: <String>['', 'Offline Enrollment', 'Online Enrollment']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value.isEmpty ? 'Select Mode of Enrollment' : value,
            style: TextStyle(
              color: value.isEmpty
                  ? ColorConstant.grey.withOpacity(0.6)
                  : ColorConstant.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }).toList(),
      icon: Icon(
        Icons.arrow_drop_down,
        color: ColorConstant.primary.withOpacity(0.8),
      ),
      iconSize: 24,
      isExpanded: true,
      dropdownColor: ColorConstant.white,
    );
  }

  showDatePickerDialog(
      {required TextEditingController textEditingController}) async {
    final DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (dateTime != null) {
      textEditingController.text = dateTime.toString().split(" ")[0];
      setState(() {});
    }
  }

  Widget _buildDatePickerField(TextEditingController controller, String label) {
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await _selectDate(context);
        if (selectedDate != null) {
          setState(() {
            controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText:
                controller.text.isNotEmpty ? controller.text : 'Select Date',
            prefixIcon: const Icon(Icons.calendar_today),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
  }

  void addToList() {
    setState(() {
      controller.educationEntries.add(OrderItem(
        cartId: controller.selectCode.value,
        id: controller.selectId.value,
        instituteName: controller.institutionController.text,
        fromDate: controller.fromDateController.text,
        toDate: controller.toDateController.text,
        degree: controller.degreeController.text,
      ));

      // Clear education form fields
      controller.institutionController.clear();
      controller.fromDateController.clear();
      controller.toDateController.clear();
      controller.degreeController.clear();
    });
  }

  Widget buildAcademicTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Institution Name')),
          DataColumn(label: Text('From Date')),
          DataColumn(label: Text('To Date')),
          DataColumn(label: Text('Degree Obtained')),
          DataColumn(label: Text('Action')),
        ],
        rows: controller.educationEntries.map((entry) {
          return DataRow(
            cells: [
              DataCell(Text(entry.instituteName)),
              DataCell(Text(entry.fromDate)),
              DataCell(Text(entry.toDate)),
              DataCell(Text(entry.degree)),
              DataCell(IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    controller.educationEntries.remove(entry);
                  });
                },
              )),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget imageBox({required Function() onTap, required File image}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.080,
        width: Get.width * 0.170,
        decoration: BoxDecoration(
            color: ColorConstant.lightGrey,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 2, color: ColorConstant.grey),
            image: image.path.isNotEmpty
                ? DecorationImage(image: FileImage(image), fit: BoxFit.fill)
                : null),
        child: image.path.isEmpty
            ? const Icon(Icons.add_a_photo, color: ColorConstant.grey)
            : null,
      ),
    );
  }

  selectImageSourceDialog(
      {required SubmitStudentFormController controller, required int imageNo}) {
    return Get.dialog(AlertDialog(
      title: const Text("Select Image Source Type"),
      actions: [
        Card(
            child: ListTile(
          onTap: () {
            Get.back();
            controller
                .pickImage(imageNo: imageNo, imageSource: ImageSource.camera)
                .whenComplete(() => setState(() {}));
          },
          title: const Text("Select From Camera"),
        )),
        Card(
            child: ListTile(
          onTap: () {
            Get.back();
            controller
                .pickImage(imageNo: imageNo, imageSource: ImageSource.gallery)
                .whenComplete(() => setState(() {}));
          },
          title: const Text("Select From Gallery"),
        )),
      ],
    ));
  }

  void showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Terms and Conditions of Service\n\n",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20), // Adjust color as needed
                  ),
                  TextSpan(
                    text:
                        "In these Terms and Conditions 'Company' means Parmanand College of Fire Safety Engineering and Safety Management (PCFSM), 5th floor, Landge Landmark, Kasarwadi, Mumbai - Pune Highway, Pune 411034, MH, India. The 'Client' means the person or persons and/or Companies that order products or services. The 'Product or Services' means the products or services offered by the Company and more particularly specified in the Booking Form and Company invoice. 'Order' means the written confirmation placed by the Client for the purchase of products or services. The terms and conditions apply to all contracts for Product or Services between the Client and the Company to the exclusion of any terms and conditions specified by the Client.\n\n",
                    style: TextStyle(
                        color: Colors.black), // Adjust color as needed
                  ),
                  WidgetSpan(
                    child: SizedBox(height: 20),
                  ),
                  TextSpan(
                    text: "Fees\n",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20), // Adjust color as needed
                  ),
                  TextSpan(
                    text:
                        "All prices quoted are subject to confirmation at the time of order and are exclusive of expenses, "
                        "which will be charged in accordance with legislation at the date of supply. Where applicable, the "
                        "Company accepts no responsibility for fees set by External Organizations; their prices may alter "
                        "without prior knowledge and will be invoiced accordingly. External Organizations are defined as "
                        "organizations or companies which are outside of our control. If you are referred to a NEBOSH exam, "
                        "you may retake the exam within five years from the date of your examinations. The resit fees for the "
                        "exams would be as per actuals.\n\n",
                    style: TextStyle(
                        color: Colors.black), // Adjust color as needed
                  ),
                  TextSpan(
                    text: "BASIS OF PURCHASE\n",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20), // Adjust color as needed
                  ),
                  TextSpan(
                    text:
                        "An Order constitutes an offer by the Client to purchase the Products or Services at "
                        "the formally agreed prices and unless otherwise agreed in writing, upon these Conditions of Purchase. "
                        "The Client hereby acknowledges that acceptance of an order implies acceptance of these Conditions, "
                        "which shall override any conditions attached by the Client. No contract shall be formed until the Client "
                        "either gives notice of acceptance expressly to the Company or implies acceptance by fulfilling an Order "
                        "in whole. The Company reserves the right to cancel or alter the dates of provision of service, the "
                        "content, timing, venue, or speakers/individual providing the service due to circumstances beyond their "
                        "control. In the unlikely event of the programme being cancelled by the Company, a full refund will be "
                        "made.\n\n",
                    style: TextStyle(
                        color: Colors.black), // Adjust color as needed
                  ),
                  TextSpan(
                    text: "PAYMENT FOR SERVICES\n",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20), // Adjust color as needed
                  ),
                  TextSpan(
                    text:
                        "Payment of accounts must be affected no later than 14 days from the date of invoice (and in any case "
                        "before the commencement of the programme). Failure to effect complete payment when due may "
                        "result in cancellation of the delegate place(s) without further notice and no advance payment would be "
                        "refunded.\n\n",
                    style: TextStyle(
                        color: Colors.black), // Adjust color as needed
                  ),
                  TextSpan(
                    text:
                        "NO SEAT WILL BE GUARANTEED UNTIL COMPLETE PAYMENT IS RECEIVED. FAILURE TO EFFECTPAYMENT WHEN DUE\n",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20), // Adjust color as needed
                  ),
                  TextSpan(
                    text:
                        "Failure to effect payment when due may result in an additional Rs1000 "
                        "administration fee and interest charged at 0.58% on a daily basis. The interest will be charged from the "
                        "payment due date.\n\n",
                    style: TextStyle(
                        color: Colors.black), // Adjust color as needed
                  ),
                  TextSpan(
                    text: "SUBSTITUTES & CANCELLATIONS\n",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20), // Adjust color as needed
                  ),
                  TextSpan(
                    text:
                        "No substitute candidates can be named after the initial consulting process has been initiated. Once a "
                        "delegate has been confirmed, he cannot be transferred, cancelled, or substituted.\n\n",
                    style: TextStyle(
                        color: Colors.black), // Adjust color as needed
                  ),
                  TextSpan(
                    text: "REFUND POLICY\n",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20), // Adjust color as needed
                  ),
                  TextSpan(
                    text:
                        "We offer a full money-back guarantee for all purchases made on our website, email, or telephone. If you are "
                        "not satisfied with the services that you have purchased from us, you can get your money back, no questions asked. "
                        "You are eligible for a full reimbursement within 14 calendar days of your purchase. After the 14-day period, you "
                        "will no longer be eligible and won't be able to receive a refund. If you have any additional questions or would like "
                        "to request a refund, feel free to contact us.\n\n",
                    style: TextStyle(
                        color: Colors.black), // Adjust color as needed
                  ),
                  TextSpan(
                    text:
                        "I have read and understood the above-listed terms and conditions of service:\n\n\n",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20), // Adjust color as needed
                  ),
                  TextSpan(
                    text: "Learner Agreement\n",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20), // Adjust color as needed
                  ),
                  TextSpan(
                    text:
                        "At PCFSM, we want to promote a philosophy of valuing people by supporting them in achieving their "
                        "personal best. Therefore, learners are treated with respect and without any discrimination in a caring "
                        "and supportive environment. The trainer will do their best to ensure all materials are covered, and the "
                        "learner develops the required skills to achieve their best during the examinations.\n\n\n",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text:
                        "PCFSM will offer regular consultations during the training, either face-to-face or virtually, to monitor and "
                        "assist learners with their progress. In addition, during the one-on-one sessions, we will provide "
                        "individual guidance to students to help them navigate the course. It is our responsibility to ensure "
                        "you always achieve the best of your ability.\n\n\n",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text:
                        "We would be grateful if you could read and sign the learning agreement copy to make the most of your "
                        "valuable time and provide you with a positive and rewarding learning experience. PCFSM's commitment "
                        "to learners:\n\n\n",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text:
                        ". I will discuss the purpose of the activity with the counselor before undertaking the said training to "
                        "understand my learning requirements from the program.\n"
                        ". I will ensure the aims and objectives of the course are suitable.\n"
                        ". I will do my best and commit to my studies.\n"
                        ". I will make all the necessary efforts to succeed and will be punctual for the duration of the training.\n"
                        ". I will listen to the trainers and other participants and respect their opinions and views.\n"
                        ". I will participate in all exercises and discussions, and if I feel at a disadvantage or unable to "
                        "participate in any aspects of the debate, I shall inform the tutor.\n"
                        ". If I am unable to complete the assignments or finish the training, I will notify my course provider.\n"
                        ". During the training, I will respect any differences that may arise with other participants or the trainer. "
                        "I will complete the learner feedback form after the course.\n"
                        ". I will raise any concerns that may arise during the training regarding practices.\n"
                        ". I will utilize private study time appropriately.\n"
                        ". I will also attend any additional sessions if directed by a staff member.\n"
                        "I will ensure all work submitted is entirely my own and is not plagiarized.\n\n\n",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void submitForm() {
    // Check if the form is valid first
    if (controller.formKey.currentState!.validate()) {
      // Check if all images are uploaded
      if (controller.selectedImage1 == null ||
          controller.selectedImage1!.path.isEmpty) {
        Get.snackbar(
          "Missing Image",
          "Please upload the first picture before submitting.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Exit the function if the image is not selected
      }

      if (controller.selectedImage2 == null ||
          controller.selectedImage2!.path.isEmpty) {
        Get.snackbar(
          "Missing Document Image",
          "Please upload the document image before submitting.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Exit the function if the document image is not selected
      }

      if (controller.selectedImage3 == null ||
          controller.selectedImage3!.path.isEmpty) {
        Get.snackbar(
          "Missing Signature Image",
          "Please upload the signature image before submitting.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Exit the function if the signature image is not selected
      }

      // Check if the verification checkbox is not ticked
      if (!_isVerified) {
        Get.snackbar(
          "Verification Required",
          "Please verify information.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Exit the function if not verified
      }

      // All validations passed, proceed with submission
      CustomLoader.openCustomLoader();
      controller.submitForm(userId: widget.userId, id: widget.id).then((_) {
        CustomLoader.closeCustomLoader();
        Get.offAll(() => StudentFormThankView(
              userId: widget.userId,
              id: widget.id,
            ));
      }).catchError((error) {
        CustomLoader.closeCustomLoader();
        log("Error during form submission: $error");
        // Optionally show an error message to the user
        Get.snackbar(
          "Error",
          "Something went wrong. Please try again later.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
    }
  }
}
