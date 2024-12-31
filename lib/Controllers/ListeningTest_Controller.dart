import 'dart:developer';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Models/post_ListenTestData_model.dart';
import 'package:firesafety/Models/post_Submit_listendata_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:get/get.dart';

class ListenTestQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer; // Add this field for correct answer

  ListenTestQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer, // Initialize correct answer
  });
}

class ListeningTestController extends GetxController {
  ListenTestTypeWiseModel listenTestTypeWiseModel = ListenTestTypeWiseModel();
  PostListeningResultModel postListeningResultModel =
      PostListeningResultModel();
  final RxList<ListenTestQuestion> questions = <ListenTestQuestion>[].obs;
  final RxString audioUrl = ''.obs;
  final RxDouble progressBarValue = 0.0.obs;

  RxInt correctAnswers = 0.obs;
  RxInt wrongAnswers = 0.obs;
  RxBool isAnswered = false.obs;
  RxInt currentQuestionIndex = 0.obs;
  RxString selectedAnswer = "".obs;
  RxString userId = "".obs;

  Future<void> initialFunction() async {
    userId.value = await StorageServices.getData(
          dataType: StorageKeyConstant.stringType,
          prefKey: StorageKeyConstant.userId,
        ) ??
        "";
  }

  void checkAnswer(String answer) {
    selectedAnswer.value = answer;
    isAnswered.value = true;

    if (answer == questions[currentQuestionIndex.value].correctAnswer) {
      correctAnswers.value++;
    } else {
      wrongAnswers.value++;
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      isAnswered.value = false;
      selectedAnswer.value = "";
    }
  }

  Future<void> getListeningTest(
      {required String userId, required String type}) async {
    try {
      CustomLoader.openCustomLoader();
      Map<String, dynamic> payload = {
        "type": type,
        "user_id": userId,
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.listentesttypewise,
        payload: payload,
        urlMessage: "Get reading listening test details URL",
        payloadMessage: "Get reading listening test details payload",
        statusMessage: "Get reading listening test details status code",
        bodyMessage: "Get reading listening test details response",
      );

      listenTestTypeWiseModel =
          listenTestTypeWiseModelFromJson(response["body"]);

      if (listenTestTypeWiseModel.statusCode == "200" ||
          listenTestTypeWiseModel.statusCode == "201") {
        if (listenTestTypeWiseModel.readingListeningTestDetailsList != null &&
            listenTestTypeWiseModel
                .readingListeningTestDetailsList!.isNotEmpty) {
          audioUrl.value = listenTestTypeWiseModel
                  .readingListeningTestDetailsList![0].audio ??
              '';
          questions.value = listenTestTypeWiseModel
                  .readingListeningTestDetailsList![0].testQuestionDetails
                  ?.map((element) {
                return ListenTestQuestion(
                  id: element.id ?? '',
                  question: element.question ?? '',
                  options: [
                    element.option1 ?? '',
                    element.option2 ?? '',
                    element.option3 ?? '',
                    element.option4 ?? '',
                  ],
                  correctAnswer: element.answer ?? '', // Set the correct answer
                );
              }).toList() ??
              [];
        } else {
          questions.clear();
          log("No reading listening test data available.");
        }
      } else {
        questions.clear();
        log("Something went wrong: ${listenTestTypeWiseModel.message}");
      }
    } catch (error) {
      questions.clear();
      log("Error fetching reading listening test data: $error");
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }

  Future<void> postListeningTestResult({
    required String testId,
    required String type,
    required String id,
  }) async {
    try {
      CustomLoader.openCustomLoader();
      Map<String, dynamic> payload = {
        "type": type,
        "read_listening_test_id": testId,
        "user_id": userId.value, // Correctly using userId.value
        "testpayment_id": id, // Correctly using userId.value
        "obtain_marks": correctAnswers.value.toString(),
        "total_marks": questions.length.toString(),
        "right_answers": correctAnswers.value.toString(),
        "wrong_answers": wrongAnswers.value.toString(),
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.listeningtestestsubmit,
        payload: payload,
        urlMessage: "Post quiz result URL",
        payloadMessage: "Post quiz result payload",
        statusMessage: "Post quiz result status code",
        bodyMessage: "Post quiz result response",
      );

      postListeningResultModel =
          postListeningResultModelFromJson(response["body"]);

      if (postListeningResultModel.statusCode == "200" ||
          postListeningResultModel.statusCode == "201") {
        log("Quiz results posted successfully.");
      } else {
        log("Something went wrong: ${postListeningResultModel.statusCode}");
      }
    } catch (error) {
      log("Error posting quiz results: $error");
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }

  void resetQuiz() {
    currentQuestionIndex.value = 0;
    isAnswered.value = false;
    selectedAnswer.value = "";
    correctAnswers.value = 0;
    wrongAnswers.value = 0;
  }
}
