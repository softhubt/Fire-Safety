import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/Post_SubmitStudentForm_Model.dart'; // Assuming this is the right model
import 'package:firesafety/Models/postSubmitForamtiveAsses_Model.dart';
import 'package:firesafety/Models/post_FormativeAssessment_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:firesafety/Widgets/custom_toast.dart';

class FormativeQuestion {
  final String id;
  final String question;

  FormativeQuestion({
    required this.id,
    required this.question,
  });
}

class ChapterFormativeAssessmentController extends GetxController {
  final RxList<FormativeQuestion> questions = <FormativeQuestion>[].obs;
  final RxMap<String, TextEditingController> controllers =
      <String, TextEditingController>{}.obs;
  final RxList<FocusNode> focusNodes = <FocusNode>[].obs;
  final formKey = GlobalKey<FormState>();
  GetFormativeAssessmentModel getFormativeAssessmentModel =
      GetFormativeAssessmentModel();
  SubmitFormativeAssessmentModel submitFormativeAssessmentModel =
      SubmitFormativeAssessmentModel();

  // Add a variable to store testFormativeId
  String? testFormativeId;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    controllers.forEach((key, controller) => controller.dispose());
    focusNodes.forEach((node) => node.dispose());
    super.onClose();
  }

  Future<void> getFormativeAssessmentList({
    required String chapterId,
    required String userId,
  }) async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {
        "chapter_id": chapterId,
        "user_id": userId,
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.elementwiseformativeassessmentdetails,
        payload: payload,
        urlMessage: "Get formative assessment list url",
        payloadMessage: "Get formative assessment list payload",
        statusMessage: "Get formative assessment list status code",
        bodyMessage: "Get formative assessment list response",
      );

      var model = getFormativeAssessmentModelFromJson(response["body"]);

      if (model.statusCode == "200" || model.statusCode == "201") {
        if (model.formativeAssessmentDetailsList != null &&
            model.formativeAssessmentDetailsList!.isNotEmpty) {
          // Store the testFormativeId
          testFormativeId =
              model.formativeAssessmentDetailsList![0].testFormativeId;

          questions.value = model
                  .formativeAssessmentDetailsList![0].formativeQuestionDetails
                  ?.map((element) {
                return FormativeQuestion(
                  id: element.id ?? '',
                  question: element.question ?? '',
                );
              }).toList() ??
              [];

          controllers.value = Map.fromIterable(
            questions,
            key: (item) => item.id,
            value: (item) => TextEditingController(),
          );

          focusNodes.value =
              List.generate(questions.length, (_) => FocusNode());
        } else {
          questions.clear();
          log("No formative assessment data available.");
        }
      } else {
        questions.clear();
        log("Something went wrong: ${model.message}");
      }
    } catch (error) {
      questions.clear();
      log("Error fetching formative assessment data: $error");
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }

  Future<void> submitFormativeAssesmentTest({
    required String userId,
    required String chapterId,
    required String courseId,
    required String testFormativeType,
  }) async {
    if (testFormativeId == null) {
      log("testFormativeId is not available");
      return;
    }

    try {
      CustomLoader.openCustomLoader();

      List<SubmitOrderItem> orderItems = questions.map((question) {
        return SubmitOrderItem(
          cartId: question.id.isNotEmpty ? int.tryParse(question.id) : null,
          id: question.id,
          questionId: question.id,
          answer: controllers[question.id]?.text ?? "",
        );
      }).toList();

      Map<String, dynamic> payload = {
        "user_id": userId,
        "course_id": courseId,
        "chapter_id": chapterId,
        "test_formative_id": testFormativeId!,
        "test_formative_type": testFormativeType,
        "order_item":
            jsonEncode(orderItems.map((item) => item.toJson()).toList()),
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.formativeassessmentsubmit,
        payload: payload,
        urlMessage: 'Submit formative assessment URL',
        payloadMessage: 'Submit formative assessment payload',
        statusMessage: 'Submit formative assessment status code',
        bodyMessage: 'Submit formative assessment response',
      );

      // if (response == null) {
      //   throw Exception("Response is null");
      // }

      submitFormativeAssessmentModel =
          submitFormativeAssessmentModelFromJson(response["body"]);

      if (submitFormativeAssessmentModel.statusCode == "200" ||
          submitFormativeAssessmentModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();
        customToast(message: "Formative assessment submitted successfully!");

        // Clear form fields if needed
        clearAllFields();
      } else {
        CustomLoader.closeCustomLoader();
        customToast(
            message: submitFormativeAssessmentModel.message ??
                "Something went wrong");
      }
    } catch (error) {
      CustomLoader.closeCustomLoader();
      log("Error during form submission: $error");
      customToast(message: "An error occurred. Please try again.");
    }
  }

  void clearAllFields() {
    controllers.forEach((key, controller) => controller.clear());
    focusNodes.forEach((node) => node.dispose());
  }

  String? validateAnswer(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final wordCount =
        value.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
    if (wordCount < 50) {
      return 'Please write at least 50 words';
    }
    return null;
  }
}
