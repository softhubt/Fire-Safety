import 'dart:convert';
import 'dart:developer';
import 'package:firesafety/Models/get_flash_excersice_result_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/Post_FlasExrecise_model.dart'; // Assuming this is the correct model
import 'package:firesafety/Models/Post_SubmitFlashExercise_model.dart';
import 'package:firesafety/Models/postSubmitForamtiveAsses_Model.dart';
import 'package:firesafety/Services/http_services.dart';

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
  final formKey = GlobalKey<FormState>();
  GetFlashExerciseModel getFlashExerciseModel = GetFlashExerciseModel();
  SubmitFormativeAssessmentModel submitFormativeAssessmentModel =
      SubmitFormativeAssessmentModel();
  SubmitFlashExerciseModel submitFlashExerciseModel =
      SubmitFlashExerciseModel();
  GetFlashExcersiceResultListModel getFlashExcersiceResultListModel =
      GetFlashExcersiceResultListModel();
  String? flashExerciseId;

  RxList<FlashExerciseResultList> resultList = <FlashExerciseResultList>[].obs;

  RxBool isFetchingData = true.obs;
  RxBool isRestartTest = false.obs;

  Future initialFunctioun(
      {required String chapterId,
      required String userId,
      required String testPaymentId}) async {
    isFetchingData.value = true;
    isRestartTest.value = false;
    questions.clear();
    controllers.clear();
    getFlashExerciseModel.flashExerciseDetailsList = null;
    submitFormativeAssessmentModel.result = null;
    submitFlashExerciseModel.result = null;
    getFlashExcersiceResultListModel.flashExerciseResultList = null;
    resultList.clear();

    await getFlashExercise(
        chapterId: chapterId, userId: userId, testPaymentId: testPaymentId);

    isFetchingData.value = false;
    isRestartTest.value = false;
  }

  String? Function(String?)? validateFields() {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return "Field is Required";
      }
      if (value.length < 100) {
        return 'At least 100 charactor required';
      }
      return null;
    };
  }

  Future<void> getFlashExercise({
    required String chapterId,
    required String userId,
    required String testPaymentId,
  }) async {
    try {
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
          flashExerciseId = model.flashExerciseDetailsList?[0].flashExerciseId;

          questions.value = model
                  .flashExerciseDetailsList![0].flashExerciseQuestionDetails
                  ?.map((element) {
                return FlashExerciseQuestion(
                    id: element.id ?? '', question: element.question ?? '');
              }).toList() ??
              [];

          await getFlashExerciseResultList(
              chapterId: chapterId,
              userId: userId,
              testPaymentId: testPaymentId,
              flashExerciseId:
                  "${model.flashExerciseDetailsList?.first.flashExerciseId}");

          controllers.value = {
            for (var item in questions) item.id: TextEditingController()
          };
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
    } finally {}
  }

  Future<void> getFlashExerciseResultList({
    required String chapterId,
    required String userId,
    required String testPaymentId,
    required String flashExerciseId,
  }) async {
    try {
      Map<String, dynamic> payload = {
        "flash_exercise_id": flashExerciseId,
        "user_id": userId,
        "testpayment_id": testPaymentId,
        "chapter_id": chapterId
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.flashExerciseResult,
          payload: payload,
          urlMessage: "Get flash exercise result details URL",
          payloadMessage: "Get flash exercise result details payload",
          statusMessage: "Get flash exercise result details status code",
          bodyMessage: "Get flash exercise result details response");

      getFlashExcersiceResultListModel =
          getFlashExcersiceResultListModelFromJson(response["body"]);

      if (getFlashExcersiceResultListModel.statusCode == "200" ||
          getFlashExcersiceResultListModel.statusCode == "201") {
        resultList.value = [];
        getFlashExcersiceResultListModel.flashExerciseResultList?.forEach(
          (element) {
            resultList.add(FlashExerciseResultList(
                chapterId: element.chapterId,
                courseId: element.courseId,
                ftrNumber: element.ftrNumber,
                id: element.id,
                mark: element.mark,
                obtainMarks: element.obtainMarks,
                subcategoryId: element.chapterId,
                tdate: element.tdate,
                topicId: element.topicId,
                ttime: element.ttime,
                flashExerciseId: element.flashExerciseId,
                flashExerciseResultDetails: element.flashExerciseResultDetails,
                flashExerciseType: element.flashExerciseType,
                userId: element.userId));
          },
        );
      } else {
        log("Something went wrong: ${getFlashExcersiceResultListModel.message}");
      }
    } catch (error) {
      log("Error fetching flash exercise result data: $error");
    }
  }

  Future<void> submitFlashExerciseTest(
      {required String userId,
      required String chapterId,
      required String courseId,
      required String flashExerciseType,
      required String testpaymentId,
      required TextEditingController textEditingController}) async {
    if (flashExerciseId == null) {
      log("flashExerciseId is not available");
      return;
    }

    try {
      List<SubmitOrderItemnew> orderItems = questions.map((question) {
        return SubmitOrderItemnew(
            cartId: question.id.isNotEmpty ? int.tryParse(question.id) : null,
            id: question.id,
            questionId: question.id,
            answer: controllers[question.id]?.text ?? "");
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
          bodyMessage: 'Submit flash exercise response');

      showInformationDialog();

      await getFlashExerciseResultList(
          chapterId: chapterId,
          userId: userId,
          testPaymentId: testpaymentId,
          flashExerciseId: flashExerciseId ?? "");
      isRestartTest.value = false;
      textEditingController.clear();

      // submitFlashExerciseModel =
      //     submitFlashExerciseModelFromJson(response["body"]);

      // if (submitFlashExerciseModel.statusCode == "200" ||
      //     submitFlashExerciseModel.statusCode == "201") {
      //   customToast(message: "Flash exercise submitted successfully!");

      // Get.offAll(() => FormativeAssesmentView(
      //       userId: userId,
      //       chapterId: chapterId,
      //       courseId: courseId,
      //       testpaymentId: testpaymentId,
      //     ));

      // Clear form fields if needed
      // clearAllFields();
      // } else {
      //   customToast(
      //       message:
      //           submitFlashExerciseModel.message ?? "Something went wrong");
      // }
    } catch (error) {
      log("Error during form submission: $error");
    }
  }

  showInformationDialog() {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Note"),
          content: const Text(
              "Result will display here within 4 to 5 working days."),
          actions: [
            ElevatedButton(onPressed: () => Get.back(), child: const Text("Ok"))
          ],
        );
      },
    );
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
