import 'dart:convert';
import 'dart:developer';
import 'package:firesafety/Models/get_formative_assessment_result_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/postSubmitForamtiveAsses_Model.dart';
import 'package:firesafety/Models/post_FormativeAssessment_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:firesafety/Widgets/custom_toast.dart';

class ChapterFormativeAssessmentController extends GetxController {
  final RxList<FormativeQuestion> questions = <FormativeQuestion>[].obs;
  final RxList<FormativeAssessmentResultList> resultList =
      <FormativeAssessmentResultList>[].obs;
  final RxMap<String, TextEditingController> controllers =
      <String, TextEditingController>{}.obs;
  GetFormativeAssessmentModel getFormativeAssessmentModel =
      GetFormativeAssessmentModel();
  SubmitFormativeAssessmentModel submitFormativeAssessmentModel =
      SubmitFormativeAssessmentModel();
  GetFormativeAssessmentResultListModel getFormativeAssessmentResultListModel =
      GetFormativeAssessmentResultListModel();

  final formKey = GlobalKey<FormState>();
  // Add a variable to store testFormativeId
  String? testFormativeId;

  RxBool isFetchingData = true.obs;
  RxBool isRestartExam = false.obs;

  Future initialFunctioun(
      {required String chapterId,
      required String userId,
      required String testPaymentId}) async {
    questions.clear();
    resultList.clear();
    isFetchingData.value = true;
    isRestartExam.value = false;
    controllers.clear();
    getFormativeAssessmentModel.formativeAssessmentDetailsList = null;
    submitFormativeAssessmentModel.result = null;
    getFormativeAssessmentResultListModel.formativeAssessmentResultList = null;

    await getFormativeAssessmentResultList(
        userId: userId, testPaymentId: testPaymentId, chapterId: chapterId);
    await getFormativeAssessmentList(chapterId: chapterId, userId: userId);

    isRestartExam.value = false;
    isFetchingData.value = false;
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

  Future<void> getFormativeAssessmentList(
      {required String chapterId, required String userId}) async {
    try {
      Map<String, dynamic> payload = {
        "chapter_id": chapterId,
        "user_id": userId
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.elementwiseformativeassessmentdetails,
          payload: payload,
          urlMessage: "Get formative assessment list url",
          payloadMessage: "Get formative assessment list payload",
          statusMessage: "Get formative assessment list status code",
          bodyMessage: "Get formative assessment list response");

      getFormativeAssessmentModel =
          getFormativeAssessmentModelFromJson(response["body"]);

      if (getFormativeAssessmentModel.statusCode == "200" ||
          getFormativeAssessmentModel.statusCode == "201") {
        if (getFormativeAssessmentModel.formativeAssessmentDetailsList !=
            null) {
          questions.value = [];
          // Store the testFormativeId
          testFormativeId = getFormativeAssessmentModel
              .formativeAssessmentDetailsList![0].testFormativeId;

          questions.value = getFormativeAssessmentModel
                  .formativeAssessmentDetailsList![0].formativeQuestionDetails
                  ?.map((element) {
                return FormativeQuestion(
                  id: element.id ?? '',
                  question: element.question ?? '',
                );
              }).toList() ??
              [];

          controllers.value = {
            for (var item in questions) item.id: TextEditingController()
          };
        } else {
          questions.clear();
          log("No formative assessment data available.");
        }
      } else {
        questions.clear();
        log("Somethig went wrong during getting formative assessment list ::: ${getFormativeAssessmentModel.message}");
      }
    } catch (error, st) {
      questions.clear();
      log("Somethig went wrong during getting formative assessment list ::: $error");
      log("Somethig went wrong during getting formative assessment list ::: $st");
    } finally {}
  }

  Future<void> getFormativeAssessmentResultList(
      {required String userId,
      required String testPaymentId,
      required String chapterId}) async {
    try {
      Map<String, dynamic> payload = {
        "test_formative_id": testFormativeId,
        "user_id": userId,
        "testpayment_id": testPaymentId,
        "chapter_id": chapterId,
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.formativeAssessmentResult,
          payload: payload,
          urlMessage: "Get formative assessment result list url",
          payloadMessage: "Get formative assessment result list payload",
          statusMessage: "Get formative assessment result list status code",
          bodyMessage: "Get formative assessment result list response");

      getFormativeAssessmentResultListModel =
          getFormativeAssessmentResultListModelFromJson(response["body"]);

      if (getFormativeAssessmentResultListModel.statusCode == "200" ||
          getFormativeAssessmentResultListModel.statusCode == "201") {
        if (getFormativeAssessmentResultListModel
                .formativeAssessmentResultList !=
            null) {
          resultList.value = [];
          getFormativeAssessmentResultListModel.formativeAssessmentResultList
              ?.forEach(
            (element) {
              resultList.add(FormativeAssessmentResultList(
                  chapterId: element.chapterId,
                  courseId: element.courseId,
                  formativeResultDetails: element.formativeResultDetails,
                  ftrNumber: element.ftrNumber,
                  id: element.id,
                  mark: element.mark,
                  obtainMarks: element.obtainMarks,
                  subcategoryId: element.chapterId,
                  tdate: element.tdate,
                  testFormativeId: element.testFormativeId,
                  testFormativeType: element.testFormativeType,
                  topicId: element.topicId,
                  ttime: element.ttime));
            },
          );
        } else {
          questions.clear();
          log("No formative assessment data available.");
        }
      } else {
        questions.clear();
        log("Somethig went wrong during getting formative assessment list ::: ${getFormativeAssessmentModel.message}");
      }
    } catch (error) {
      questions.clear();
      log("Somethig went wrong during getting formative assessment list ::: $error");
    } finally {}
  }

  Future<void> submitFormativeAssesmentTest({
    required String userId,
    required String chapterId,
    required String courseId,
    required String testFormativeType,
    required String testpaymentid,
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
        "testpayment_id": testpaymentid,
        "order_item":
            jsonEncode(orderItems.map((item) => item.toJson()).toList()),
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.formativeassessmentsubmit,
          payload: payload,
          urlMessage: 'Submit formative assessment URL',
          payloadMessage: 'Submit formative assessment payload',
          statusMessage: 'Submit formative assessment status code',
          bodyMessage: 'Submit formative assessment response');

      submitFormativeAssessmentModel =
          submitFormativeAssessmentModelFromJson(response["body"]);

      if (submitFormativeAssessmentModel.statusCode == "200" ||
          submitFormativeAssessmentModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();
        showInformationDialog();
        await getFormativeAssessmentResultList(
            userId: userId, testPaymentId: testpaymentid, chapterId: chapterId);
        isRestartExam.value = false;
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
}

class FormativeQuestion {
  final String id;
  final String question;

  FormativeQuestion({
    required this.id,
    required this.question,
  });
}
