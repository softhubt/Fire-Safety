import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/image_path_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/SubmitStudentdfrom_Controller.dart';
import 'package:firesafety/Models/Post_SubmitStudentForm_Model.dart';
import 'package:firesafety/Models/get_BranchList_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/StudentForm_Thanku_View.dart';
import 'package:firesafety/Widgets/custom_loader.dart';

class StudentFormView extends StatefulWidget {
  final String userId;
  final String id;

  const StudentFormView({
    Key? key,
    required this.userId, required this.id,
  }) : super(key: key);

  @override
  _StudentFormViewState createState() => _StudentFormViewState();
}

class _StudentFormViewState extends State<StudentFormView> {
  // late final SubmitStudentFormController _controller;
  SubmitStudentFormController _controller =
      Get.put(SubmitStudentFormController());

  // State to keep track of checkbox selections
  List<bool> courseSelections = List.generate(5, (index) => false);
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(SubmitStudentFormController());
    _controller.userId.value = widget.userId;
    _controller.id.value = widget.id;
    _controller.getBranchListform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Form"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.remove_red_eye, color: Colors.blue), // Eye icon
                    SizedBox(width: 8), // Space between icon and text
                    Text("View Sample From", style: TextStyle(fontSize: 16)),
                    // Space between the form and the image
                    Padding(
                      padding: const EdgeInsets.only(left: 170),
                      child: Image.asset(
                        ImagePathConstant.Receipt,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(_controller.nameController, 'Name'),
                    const SizedBox(height: 10),
                    _buildTextField(
                        _controller.nationalityController, 'Nationality'),
                    const SizedBox(height: 10),
                    _buildDatePickerField(
                        _controller.dobController, 'Date Of Birth'),
                    const SizedBox(height: 10),
                    Text('Gender:', style: TextStyle(fontSize: 16)),
                    _buildGenderSelector(),
                    const SizedBox(height: 10),
                    _buildTextField(_controller.countryBirthController,
                        'Country and Birth Place'),
                    const SizedBox(height: 10),
                    Text('Marital Status:', style: TextStyle(fontSize: 16)),
                    _buildMaritalStatusDropdown(),
                    const SizedBox(height: 10),
                    Text('Address:', style: TextStyle(fontSize: 16)),
                    _buildTextField(_controller.addressController, 'Address',
                        maxLines: 3),
                    const SizedBox(height: 10),
                    Text('Select Country:', style: TextStyle(fontSize: 16)),
                    _buildGetContryListDropdown(),
                    const SizedBox(height: 10),
                    Text('Select State:', style: TextStyle(fontSize: 16)),
                    _buildStateListDropdown(),
                    const SizedBox(height: 10),
                    _buildTextField(_controller.zipCodeController, 'Zip Code'),
                    const SizedBox(height: 10),
                    _buildTextField(
                        _controller.phoneController, 'Phone Number'),
                    const SizedBox(height: 10),
                    _nonmandatorybuildTextField(
                        _controller.mobileController, 'Mobile Number'),
                    const SizedBox(height: 10),
                    _buildTextField(_controller.emailController, 'Email Id'),
                    const SizedBox(height: 10),
                    _nonmandatorybuildTextField(
                        _controller.altEmailController, 'Alternative Email Id'),
                    const SizedBox(height: 10),
                    _buildTextField(
                        _controller.examvenueController, 'Exam Venue:'),
                    const SizedBox(height: 10),
                    Text('Select Branch:', style: TextStyle(fontSize: 16)),
                    _buildSelectBranchDropdown(),
                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        'TRAINING COURSES',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildCourseCheckbox('1. Diploma Safety Course', 0),
                    _buildCourseCheckbox('2. POST DIPLOMA Safety COURSES', 1),
                    _buildCourseCheckbox('3. GRADUATION PROGRAMS (ASP/CSP)', 2),
                    _buildCourseCheckbox('4. CERTIFICATE COURSES', 3),
                    _buildCourseCheckbox(
                        '5. NIBOSH IGC (International General Certification) IG1 & IG2',
                        4),

                    const SizedBox(height: 20),

                    Text('Mode of Enrollment:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    _buildSelectModeeOfEnrollMentDropdown(), // Add some space
                    const SizedBox(height: 20),
                    Text(
                      'Do any Delegates have disabilities that will\nrequire special facilities or assistance? If yes,\nplease outline their requirements.',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10), // Add some space
                    _buildTextField(
                        _controller.disabilityRequirementsController,
                        'Requirements'),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Upload Your Documet Image",
                        style: TextStyleConstant.semiBold16(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.030),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text("Upload Picture"),
                              imageBox(
                                onTap: () {
                                  selectImageSourceDialog(
                                      controller: _controller, imageNo: 1);
                                },
                                image: (_controller.selectedImage1 != null)
                                    ? File(_controller.selectedImage1!.path)
                                    : File(""),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text("Upload Document Image"),
                                imageBox(
                                  onTap: () {
                                    selectImageSourceDialog(
                                        controller: _controller, imageNo: 2);
                                  },
                                  image: (_controller.selectedImage2 != null)
                                      ? File(_controller.selectedImage2!.path)
                                      : File(""),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text("Upload Signature Image"),
                                imageBox(
                                  onTap: () {
                                    selectImageSourceDialog(
                                        controller: _controller, imageNo: 3);
                                  },
                                  image: (_controller.selectedImage3 != null)
                                      ? File(_controller.selectedImage3!.path)
                                      : File(""),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      'Education Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    _buildTextEducationField(
                        _controller.institutionController, 'Institution Name'),
                    const SizedBox(height: 10),
                    _buildDatePickerField(
                        _controller.fromDateController, 'From Date'),
                    const SizedBox(height: 10),
                    _buildDatePickerField(
                        _controller.toDateController, 'To Date'),
                    const SizedBox(height: 10),
                    _buildTextEducationField(
                        _controller.degreeController, 'Degree Obtained'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addToList,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add to List'),
                    ),
                    const SizedBox(height: 20),
                    _buildAcademicTable(),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Checkbox(
                          value: _isVerified,
                          onChanged: (bool? value) {
                            setState(() {
                              _isVerified = value!;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        const Text(
                          " Please verify the  information .",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _showTermsAndConditions,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Read Terms and Conditions",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCheckbox(String title, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Checkbox(
            value: courseSelections[index],
            onChanged: (bool? value) {
              setState(() {
                courseSelections[index] = value!;
                _controller.toggleCourseSelection(title);
              });
            },
            activeColor: Colors.green,
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
        border: OutlineInputBorder(),
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
        border: OutlineInputBorder(),
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
        border: OutlineInputBorder(),
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
          groupValue: _controller.genderValue.value,
          onChanged: (String? value) {
            setState(() {
              _controller.genderValue.value = value!;
            });
          },
        ),
        const Text('Male'),
        const SizedBox(width: 20),
        Radio<String>(
          value: 'Female',
          groupValue: _controller.genderValue.value,
          onChanged: (String? value) {
            setState(() {
              _controller.genderValue.value = value!;
            });
          },
        ),
        const Text('Female'),
      ],
    );
  }

  DropdownButtonFormField<String> _buildMaritalStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _controller.maritalStatusValue.value.isEmpty
          ? null
          : _controller.maritalStatusValue.value,
      onChanged: (value) {
        setState(() {
          _controller.maritalStatusValue.value = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Marital Status',
        border: OutlineInputBorder(),
      ),
      items: <String>['', 'Single', 'Married', 'Divorced', 'Widowed']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.isEmpty ? 'Select Marital Status' : value),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> _buildGetContryListDropdown() {
    return DropdownButtonFormField<String>(
      value: _controller.SelectcountryListValue.value.isEmpty
          ? null
          : _controller.SelectcountryListValue.value,
      onChanged: (value) {
        setState(() {
          _controller.SelectcountryListValue.value = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Select Country',
        border: OutlineInputBorder(),
      ),
      items: <String>['', 'India', 'Australia', 'China', 'Colombia', 'Italy']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.isEmpty ? 'Select country' : value),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> _buildStateListDropdown() {
    return DropdownButtonFormField<String>(
      value: _controller.SelectStateListValue.value.isEmpty
          ? null
          : _controller.SelectStateListValue.value,
      onChanged: (value) {
        setState(() {
          _controller.SelectStateListValue.value = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Select State',
        border: OutlineInputBorder(),
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
          child: Text(value.isEmpty ? 'Select State' : value),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> _buildSelectBranchDropdown() {
    return DropdownButtonFormField<String>(
      value: _controller.selectBranch.value.isEmpty
          ? null
          : _controller.selectBranch.value,
      onChanged: (value) {
        if (value != null) {
          _controller.selectBranch.value = value;
        }
      },
      decoration: InputDecoration(
        labelText: 'Select Branch',
        border: OutlineInputBorder(),
      ),
      items: _controller.getBranchList.branchList != null
          ? _controller.getBranchList.branchList!
              .map<DropdownMenuItem<String>>((BranchListItem item) {
              return DropdownMenuItem<String>(
                value: item.id,
                child: Text(item.branch ?? ''),
              );
            }).toList()
          : [],
    );
  }

  DropdownButtonFormField<String> _buildSelectModeeOfEnrollMentDropdown() {
    return DropdownButtonFormField<String>(
      value: _controller.selectModeOfEnrollment.value.isEmpty
          ? null
          : _controller.selectModeOfEnrollment.value,
      onChanged: (value) {
        setState(() {
          _controller.selectModeOfEnrollment.value = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'select Mode Of Enrollment',
        border: OutlineInputBorder(),
      ),
      items: <String>['', 'Offline Enrollment ', 'Online Enrollment']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.isEmpty ? 'Select Mode of Enrollment ' : value),
        );
      }).toList(),
    );
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
            border: OutlineInputBorder(),
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

  void _addToList() {
    if (_controller.formKey.currentState?.validate() ?? false) {
      setState(() {
        _controller.educationEntries.add(OrderItem(
          cartId: _controller.selectCode.value,
          id: _controller.selectId.value,
          instituteName: _controller.institutionController.text,
          fromDate: _controller.fromDateController.text,
          toDate: _controller.toDateController.text,
          degree: _controller.degreeController.text,
        ));

        // Clear education form fields
        _controller.institutionController.clear();
        _controller.fromDateController.clear();
        _controller.toDateController.clear();
        _controller.degreeController.clear();
      });
    }
  }

  Widget _buildAcademicTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Institution Name')),
          DataColumn(label: Text('From Date')),
          DataColumn(label: Text('To Date')),
          DataColumn(label: Text('Degree Obtained')),
          DataColumn(label: Text('Action')),
        ],
        rows: _controller.educationEntries.map((entry) {
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
                    _controller.educationEntries.remove(entry);
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
            ? Icon(Icons.add_a_photo, color: ColorConstant.grey)
            : null,
      ),
    );
  }

  selectImageSourceDialog(
      {required SubmitStudentFormController controller, required int imageNo}) {
    return Get.dialog(AlertDialog(
      title: const Text("Select Image Source Type"),
      content: Column(
        children: [
          Card(
              child: ListTile(
            onTap: () {
              Get.back();
              controller
                  .pickImage(imageNo: imageNo, imageSource: ImageSource.camera)
                  .whenComplete(() => controller.update());
            },
            title: const Text("Select From Camera"),
          )),
          Card(
              child: ListTile(
            onTap: () {
              Get.back();
              controller
                  .pickImage(imageNo: imageNo, imageSource: ImageSource.gallery)
                  .whenComplete(() => controller.update());
            },
            title: const Text("Select From Gallery"),
          )),
        ],
      ),
    ));
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: const Text("Terms and Conditions of Service"),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
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

  // void _submitForm() {
  //   if (_controller.formKey.currentState?.validate() ?? false) {
  //     if (!_isVerified) {
  //       // Check if the checkbox is not ticked
  //       // Show a message to the user
  //       Get.snackbar(
  //         "Verification Required",
  //         "Please verify information .",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //       return; // Exit the function if not verified
  //     }
  //
  //     CustomLoader.openCustomLoader();
  //     _controller.submitForm(userId: widget.userId,id: widget.id).then((_) {
  //       CustomLoader.closeCustomLoader();
  //       Get.to(() => StudentFormThankView(
  //             userId: widget.userId, id: widget.id,
  //           ));
  //     }).catchError((error) {
  //       CustomLoader.closeCustomLoader();
  //       log("Error during form submission: $error");
  //       // Show a toast or some feedback to the user
  //     });
  //   }
  // }


  void _submitForm() {
    // Check if the form is valid first
    if (_controller.formKey.currentState?.validate() ?? false) {

      // Check if all images are uploaded
      if (_controller.selectedImage1 == null || _controller.selectedImage1!.path.isEmpty) {
        Get.snackbar(
          "Missing Image",
          "Please upload the first picture before submitting.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Exit the function if the image is not selected
      }

      if (_controller.selectedImage2 == null || _controller.selectedImage2!.path.isEmpty) {
        Get.snackbar(
          "Missing Document Image",
          "Please upload the document image before submitting.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Exit the function if the document image is not selected
      }

      if (_controller.selectedImage3 == null || _controller.selectedImage3!.path.isEmpty) {
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
      _controller.submitForm(userId: widget.userId, id: widget.id).then((_) {
        CustomLoader.closeCustomLoader();
        Get.to(() => StudentFormThankView(
          userId: widget.userId, id: widget.id,
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
