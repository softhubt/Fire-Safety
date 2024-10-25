import 'dart:developer';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_chapter_quiz_list_model.dart';
import 'package:firesafety/Models/post_chapter_quiz_result_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_quiz_content_view.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';

class ChapterQuizContentController extends GetxController {
  GetChapterQuizListModel getChapterQuizListModel = GetChapterQuizListModel();
  PostChapterQuizResultModel postChapterQuizResultModel =
      PostChapterQuizResultModel();

  RxString selectedAnswer = "".obs;
  RxInt currentQuestionIndex = 0.obs;
  RxBool isAnswered = false.obs;

  RxInt correctAnswers = 0.obs;
  RxInt wrongAnswers = 0.obs;

  RxList<Question> questions = <Question>[].obs;

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
    currentQuestionIndex.value++;
    isAnswered.value = false;
    selectedAnswer.value = "";
  }

  void resetQuiz() {
    currentQuestionIndex.value = 0;
    isAnswered.value = false;
    selectedAnswer.value = "";
    correctAnswers.value = 0;
    wrongAnswers.value = 0;
  }

  Future<void> getQuizList({
    required String chapterId,
    required String userId,
    required String type,
    required String topicId,
  }) async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {
        "type": type,
        "chapter_id": chapterId,
        "topic_id": topicId,
        "user_id": userId,
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.testQuestionDetails,
        payload: payload,
        urlMessage: "Get quiz list url",
        payloadMessage: "Get quiz list payload",
        statusMessage: "Get quiz list status code",
        bodyMessage: "Get quiz list response",
      );

      getChapterQuizListModel =
          getChapterQuizListModelFromJson(response["body"]);

      if (getChapterQuizListModel.statusCode == "200" ||
          getChapterQuizListModel.statusCode == "201") {
        if (getChapterQuizListModel.testDetailsList != null &&
            getChapterQuizListModel.testDetailsList!.isNotEmpty) {
          questions.value = getChapterQuizListModel
                  .testDetailsList![0].testQuestionDetails
                  ?.map((element) {
                return Question(
                  text: element.question ?? '',
                  options: [
                    element.option1 ?? '',
                    element.option2 ?? '',
                    element.option3 ?? '',
                    element.option4 ?? '',
                  ],
                  correctAnswer: element.answer ?? '',
                  id: element.id ?? '',
                );
              }).toList() ??
              [];
        } else {
          questions.clear();
          log("No quiz data available.");
        }
      } else {
        questions.clear();
        log("Something went wrong: ${getChapterQuizListModel.message}");
      }
    } catch (error) {
      questions.clear();
      log("Error fetching quiz data: $error");
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }

  Future<void> postQuizResult({
    required String testId,
    required String userId,
    required String type,
    required String courseid,
    required String chapterid,
    required String topicid,
  }) async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {
        "test_type": type,
        "course_id": courseid,
        "chapter_id": chapterid,
        "topic_id": topicid,
        "test_id": testId,
        "user_id": userId,
        "obtain_marks": "${correctAnswers.value}",
        "total_marks": "${questions.length}",
        "right_answers": "${correctAnswers.value}",
        "wrong_answers": "${wrongAnswers.value}",
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.testSubmit,
        payload: payload,
        urlMessage: "Post quiz result url",
        payloadMessage: "Post quiz result payload",
        statusMessage: "Post quiz result status code",
        bodyMessage: "Post quiz result response",
      );

      postChapterQuizResultModel =
          postChapterQuizResultModelFromJson(response["body"]);

      if (postChapterQuizResultModel.statusCode == "200" ||
          postChapterQuizResultModel.statusCode == "201") {
        log("Quiz results posted successfully.");
      } else {
        log("Something went wrong: ${postChapterQuizResultModel.statusCode}");
      }
    } catch (error) {
      log("Error posting quiz results: $error");
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }
}
