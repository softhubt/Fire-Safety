import 'dart:convert';
import 'dart:developer';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_FormativeAssement_View.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/Post_FlasExrecise_model.dart'; // Assuming this is the correct model
import 'package:firesafety/Models/Post_SubmitFlashExercise_model.dart';
import 'package:firesafety/Models/postSubmitForamtiveAsses_Model.dart';
import 'package:firesafety/Models/post_FormativeAssessment_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:firesafety/Widgets/custom_toast.dart';

class FlashExerciseQuestion {
  final String id;
  final String question;

  FlashExerciseQuestion({
    required this.id,
    required this.question,
  });
}

class FlasExerciseController extends GetxController {
  final RxList<FlashExerciseQuestion> questions = <FlashExerciseQuestion>[].obs;
  final RxMap<String, TextEditingController> controllers =
      <String, TextEditingController>{}.obs;
  final RxList<FocusNode> focusNodes = <FocusNode>[].obs;
  final formKey = GlobalKey<FormState>();
  GetFlashExerciseModel getFlashExerciseModel = GetFlashExerciseModel();
  SubmitFormativeAssessmentModel submitFormativeAssessmentModel =
      SubmitFormativeAssessmentModel();
  SubmitFlashExerciseModel submitFlashExerciseModel =
      SubmitFlashExerciseModel();
  String? flashExerciseId;

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

  Future<void> getFlashExercise({
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
        url: EndPointConstant.elementwiseflashexercisedetails,
        payload: payload,
        urlMessage: "Get flash exercise details URL",
        payloadMessage: "Get flash exercise details payload",
        statusMessage: "Get flash exercise details status code",
        bodyMessage: "Get flash exercise details response",
      );

      var model = getFlashExerciseModelFromJson(response["body"]);

      if (model.statusCode == "200" || model.statusCode == "201") {
        if (model.flashExerciseDetailsList != null &&
            model.flashExerciseDetailsList!.isNotEmpty) {
          flashExerciseId = model.flashExerciseDetailsList![0].flashExerciseId;

          questions.value = model
                  .flashExerciseDetailsList![0].flashExerciseQuestionDetails
                  ?.map((element) {
                return FlashExerciseQuestion(
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
          log("No flash exercise data available.");
        }
      } else {
        questions.clear();
        log("Something went wrong: ${model.message}");
      }
    } catch (error) {
      questions.clear();
      log("Error fetching flash exercise data: $error");
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }

  Future<void> submitFlashExerciseTest({
    required String userId,
    required String chapterId,
    required String courseId,
    required String flashExerciseType,
    required String testpaymentId,
  }) async {
    if (flashExerciseId == null) {
      log("flashExerciseId is not available");
      return;
    }

    try {
      CustomLoader.openCustomLoader();

      List<SubmitOrderItemnew> orderItems = questions.map((question) {
        return SubmitOrderItemnew(
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
        "flash_exercise_id": flashExerciseId!,
        "flash_exercise_type": flashExerciseType,
        "testpayment_id": testpaymentId,
        "order_item":
            jsonEncode(orderItems.map((item) => item.toJson()).toList()),

      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.flashExerciseSubmit,
        payload: payload,
        urlMessage: 'Submit flash exercise URL',
        payloadMessage: 'Submit flash exercise payload',
        statusMessage: 'Submit flash exercise status code',
        bodyMessage: 'Submit flash exercise response',
      );

      submitFlashExerciseModel =
          submitFlashExerciseModelFromJson(response["body"]);

      if (submitFlashExerciseModel.statusCode == "200" ||
          submitFlashExerciseModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();
        customToast(message: "Flash exercise submitted successfully!");

        Get.offAll(() => FormativeAssesmentView(
          userId: userId,
          chapterId: chapterId,
          courseId: courseId,
          testpaymentId: testpaymentId,
        ));

        // Clear form fields if needed
        // clearAllFields();
      } else {
        CustomLoader.closeCustomLoader();
        customToast(
            message:
                submitFlashExerciseModel.message ?? "Something went wrong");
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

    final charCount = value.length;

    // Check if the character count is less than 100
    if (charCount < 100) {
      return 'Please write at least 100 characters';
    }

    return null;
  }

  String getCharacterCount(String value) {
    return '${value.length}/100'; // Returns the character count in the format "X/100"
  }

}
