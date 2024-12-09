import 'dart:developer';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Models/PostWriting_Test_Model.dart';
import 'package:firesafety/Models/Post_Submit_wrtingTest_model.dart';
import 'package:firesafety/Screens/ListeningWithMCQ_Screen.dart';
import 'package:firesafety/Screens/ReadingTest_WithMCQ_Screen.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';

class WritingTestController extends GetxController {
  // Initialize the model as an observable Rx
  var getWriteTestModel = Rx<GetWriteTestModel>(GetWriteTestModel());
  var writingTestSubmitResponse = Rx<GetSumittheWritingtestmodel?>(null);
  RxString userId = "".obs;

  @override
  void onInit() {
    super.onInit();
    initialFunction(); // Corrected spelling from "initialFunctioun" to "initialFunction"
  }

  Future<void> initialFunction() async {
    userId.value = await StorageServices.getData(
          dataType: StorageKeyConstant.stringType,
          prefKey: StorageKeyConstant.userId,
        ) ??
        "";

    await fetchWritingTest();
  }

  Future<void> fetchWritingTest() async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {
        "type": "Writing Test",
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.proficiencytesttypewise,
        payload: payload,
        urlMessage: "Get writing list URL",
        payloadMessage: "Get writing list payload",
        statusMessage: "Get writing list status code",
        bodyMessage: "Get writing list response",
      );

      // Update the observable with fetched data
      getWriteTestModel.value = getWriteTestModelFromJson(response["body"]);

      // Check the status code
      if (getWriteTestModel.value.statusCode == "200" ||
          getWriteTestModel.value.statusCode == "201") {
        log("Writing test details fetched successfully.");
      } else {
        log("No data found for writing test. Status code: ${getWriteTestModel.value.statusCode}");
      }
    } catch (error) {
      log("Error getting writing test list: $error");
    } finally {
      CustomLoader
          .closeCustomLoader(); // Ensure the loader is closed even if there's an error
    }
  }

  Future<void> submitWritingTest({
    required String questionId,
    required String answer, required String id,
  }) async {
    try {
      CustomLoader.openCustomLoader();

      // Get the question details from the fetched model
      final questionDetails = getWriteTestModel
              .value.proficiencyTestDetailsList?.first.questionDetails ??
          "";

      Map<String, dynamic> payload = {
        "user_id": userId.value, // Use userId.value instead of userId
        "type": "Writing Test",
        "question_id": questionId,
        "question_details": questionDetails,
        "answer": answer,
        "testpayment_id": id
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.proficiencywritingtestsubmit,
        payload: payload,
        urlMessage: "Get writing submission URL",
        payloadMessage: "Get writing submission payload",
        statusMessage: "Get writing submission status code",
        bodyMessage: "Get writing submission response",
      );

      writingTestSubmitResponse.value =
          getSumittheWritingtestmodelFromJson(response["body"]);

      // Check the status code
      if (writingTestSubmitResponse.value?.statusCode == "200" ||
          writingTestSubmitResponse.value?.statusCode == "201") {
        log("Writing test submitted successfully.");
        Get.snackbar(
            "Success", "Your writing test has been submitted successfully.",
            snackPosition: SnackPosition.BOTTOM);
        Get.to(() => ReadingScreenWithMCQ(
            userId: userId.value,
            quizType: 'Reading Test',id:id)
        ); // Corrected userId
      } else {
        log("Error submitting writing test. Status code: ${writingTestSubmitResponse.value?.statusCode}");
        // Optionally, show an error message
      }
    } catch (error) {
      log("Error submitting writing test: $error");
      // Optionally handle exception
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }
}
