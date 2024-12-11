import 'dart:developer';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/ReadingTestAfterPurchesmodel.dart';
import 'package:firesafety/Models/post_reading_test_result_model.dart';
import 'package:firesafety/Screens/ListeningWithMCQ_Screen.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:get/get.dart';

// ReadingTestQuestion model
class ReadingTestQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;

  ReadingTestQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

// Question model used for the result screen
class Question {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class ReadingTestController extends GetxController {
  final RxList<ReadingTestQuestion> questions = <ReadingTestQuestion>[].obs;
  PostReadingResultModel postReadingResultModel = PostReadingResultModel();
  ReadListenTestTypeWiseModel readListenTestTypeWiseModel =
      ReadListenTestTypeWiseModel();
  final RxString paragraph = ''.obs;
  final RxInt correctAnswers = 0.obs;
  final RxInt wrongAnswers = 0.obs;
  final RxBool isAnswered = false.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxString selectedAnswer = "".obs;
  final RxDouble progressBarValue = 0.0.obs;

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

  Future<void> getReadListeningTest(
      {required String userId, required String type}) async {
    try {
      CustomLoader.openCustomLoader();
      Map<String, dynamic> payload = {
        "type": "Reading Test",
        "user_id": userId,
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.proficiencyreadlistentesttypewise,
        payload: payload,
        urlMessage: "Get reading listening test details URL",
        payloadMessage: "Get reading listening test details payload",
        statusMessage: "Get reading listening test details status code",
        bodyMessage: "Get reading listening test details response",
      );

      var model = readListenTestTypeWiseModelFromJson(response["body"]);

      if (model.statusCode == "200" || model.statusCode == "201") {
        if (model.readingListeningTestDetailsList != null &&
            model.readingListeningTestDetailsList!.isNotEmpty) {
          paragraph.value =
              model.readingListeningTestDetailsList![0].paragraph ?? '';
          questions.value = model
                  .readingListeningTestDetailsList![0].testQuestionDetails
                  ?.map((element) {
                return ReadingTestQuestion(
                  id: element.id ?? '',
                  question: element.question ?? '',
                  options: [
                    element.option1 ?? '',
                    element.option2 ?? '',
                    element.option3 ?? '',
                    element.option4 ?? '',
                  ],
                  correctAnswer: element.answer ?? '',
                );
              }).toList() ??
              [];
        } else {
          questions.clear();
          log("No reading listening test data available.");
        }
      } else {
        questions.clear();
        log("Something went wrong: ${model.message}");
      }
    } catch (error) {
      questions.clear();
      log("Error fetching reading listening test data: $error");
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }

  Future<void> postReadingTestResult({
    required String testId,
    required String userId,
    required String type,
    required String id,
  }) async {
    try {
      CustomLoader.openCustomLoader();
      Map<String, dynamic> payload = {
        "type": "Reading Test",
        "read_listening_test_id": testId,
        "user_id": userId,
        "testpayment_id": id,
        "obtain_marks": "${correctAnswers.value}",
        "total_marks": "${questions.length}",
        "right_answers": "${correctAnswers.value}",
        "wrong_answers": "${wrongAnswers.value}",
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.readinglisteningtestsubmit,
        payload: payload,
        urlMessage: "Post quiz result URL",
        payloadMessage: "Post quiz result payload",
        statusMessage: "Post quiz result status code",
        bodyMessage: "Post quiz result response",
      );

      postReadingResultModel = postReadingResultModelFromJson(response["body"]);

      if (postReadingResultModel.statusCode == "200" ||
          postReadingResultModel.statusCode == "201") {
        log("Quiz results posted successfully.");

        Get.to(
          () => ListeningWithMcqView(userId: userId, id: id),
        );
      } else {
        log("Something went wrong: ${postReadingResultModel.statusCode}");
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

  // Method to map ReadingTestQuestion to Question model
  List<Question> mapToQuestionList(
      List<ReadingTestQuestion> readingTestQuestions) {
    return readingTestQuestions.map((e) {
      return Question(
        id: e.id,
        question: e.question,
        options: e.options,
        correctAnswer: e.correctAnswer,
      );
    }).toList();
  }
}
