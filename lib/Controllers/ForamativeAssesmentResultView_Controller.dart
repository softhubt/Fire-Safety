import 'dart:developer';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Models/post_formativeassesment_Result_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FormativeTestResultViewController extends GetxController {
 // GetTestResultModel getTestResultModel = GetTestResultModel();
  PostFormativeAssessmentResultModel postFormativeAssessmentResultModel = PostFormativeAssessmentResultModel();

  RxList<BarChartGroupData> testHistoryList = <BarChartGroupData>[].obs;

  RxString categoryId = "".obs;
  RxString userId = "".obs;

  RxInt touchIndex = 0.obs;

  final RxDouble totalMarks = 0.0.obs;
  final RxDouble obtainMarks = 0.0.obs;
  final RxDouble progressBarValue = 0.0.obs;

  Future initialFunctioun({required String testListId}) async {
    categoryId.value = await StorageServices.getData(
        dataType: StorageKeyConstant.stringType,
        prefKey: StorageKeyConstant.categoryId) ??
        "";
    userId.value = await StorageServices.getData(
        dataType: StorageKeyConstant.stringType,
        prefKey: StorageKeyConstant.userId) ??
        "";

    await getTestResult(testListId: testListId);
  }

  Future getTestResult({required String testListId}) async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {
        "test_formative_id": categoryId.value,
        "user_id": userId.value,
        "testpayment_id": testListId
      };

      log("Get test result payload ::: $payload");

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.formativeassessmentresult,
        payload: payload,
        urlMessage: 'Submit formative assessment URL',
        payloadMessage: 'Submit formative assessment payload',
        statusMessage: 'Submit formative assessment status code',
        bodyMessage: 'Submit formative assessment response',
      );

      log("Get test result response ::: $response");

      postFormativeAssessmentResultModel = postFormativeAssessmentResultModelFromJson(response["body"]);

      if (postFormativeAssessmentResultModel.statusCode == "200" ||
          postFormativeAssessmentResultModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();

        totalMarks.value = double.parse(
            "${postFormativeAssessmentResultModel.formativeAssessmentResultList?.last.mark}");
        obtainMarks.value = double.parse(
            "${postFormativeAssessmentResultModel.formativeAssessmentResultList?.last.obtainMarks}");
        progressBarValue.value = obtainMarks.value / totalMarks.value;

        log("Progress bar value ::: ${progressBarValue.value}");

        for (int i = 0; i < postFormativeAssessmentResultModel.formativeAssessmentResultList!.length; i++) {
          if (i <= 10) {
            testHistoryList.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: double.parse(
                        "${postFormativeAssessmentResultModel.formativeAssessmentResultList?[i].obtainMarks}"),
                    color: i == touchIndex.value ? Colors.amber : Colors.indigo,
                    width: 30,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 10,
                      color: Colors.transparent,
                    ),
                  ),
                ],
                showingTooltipIndicators: (touchIndex.value == i) ? [0] : [],
              ),
            );
          } else {
            break;
          }
        }
      } else {
        CustomLoader.closeCustomLoader();
      }
    } catch (error, st) {
      CustomLoader.closeCustomLoader();
      log("Something went wrong during getting test result ::: $error");
      log("Something went wrong during getting test result ::: $st");
    }
  }
}
