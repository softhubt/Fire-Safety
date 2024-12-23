import 'dart:developer';
import 'package:firesafety/Models/get_quiz_result_list_model.dart';
import 'package:firesafety/Models/postShowlastResult_model.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_chapter_quiz_list_model.dart';
import 'package:firesafety/Models/post_chapter_quiz_result_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_quiz_content_view.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';

class ChapterQuizContentController extends GetxController {
  GetQuizResultListModel getQuizResultListModel = GetQuizResultListModel();
  GetChapterQuizListModel getChapterQuizListModel = GetChapterQuizListModel();
  PostChapterQuizResultModel postChapterQuizResultModel =
      PostChapterQuizResultModel();
  PostShowlastChapterresultQuizModel postShowlastChapterresultQuizModel =
      PostShowlastChapterresultQuizModel();

  final RxDouble progressBarValue = 0.0.obs;
  RxString selectedAnswer = "".obs;
  RxInt currentQuestionIndex = 0.obs;
  RxBool isAnswered = false.obs;

  RxInt correctAnswers = 0.obs;
  RxInt wrongAnswers = 0.obs;

  RxList<Question> questions = <Question>[].obs; // RxList<Question>
  RxList<TestResultList> resultList =
      <TestResultList>[].obs; // RxList<Question>

  // New variable to store the quiz result
  RxBool isQuizCompleted = false.obs;
  RxBool isFetchingData = true.obs;
  RxBool isRestart = false.obs;

  Future initialFunctioun(
      {required String chapterId,
      required String topicId,
      required String userId,
      required String quizType}) async {
    await getQuizResultList(userId: userId, topicId: topicId);
    await getQuizList(
        chapterId: chapterId, topicId: topicId, userId: userId, type: quizType);
    isFetchingData.value = false;
  }

  // This function checks the selected answer
  void checkAnswer(String answer) {
    selectedAnswer.value = answer;
    isAnswered.value = true;

    if (answer == questions[currentQuestionIndex.value].correctAnswer) {
      correctAnswers.value++;
    } else {
      wrongAnswers.value++;
    }
  }

  // Move to the next question
  void nextQuestion() {
    currentQuestionIndex.value++;
    isAnswered.value = false;
    selectedAnswer.value = "";
  }

  // Reset the quiz for a new attempt
  void resetQuiz() {
    currentQuestionIndex.value = 0;
    isAnswered.value = false;
    selectedAnswer.value = "";
    correctAnswers.value = 0;
    wrongAnswers.value = 0;
    isQuizCompleted.value = false; // Reset the completion flag
  }

  // Fetch quiz data
  Future<void> getQuizResultList(
      {required String userId, required String topicId}) async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {"user_id": userId, "test_id": topicId};

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.testResultDisplay,
          payload: payload,
          urlMessage: "Get quiz result list url",
          payloadMessage: "Get quiz result list payload",
          statusMessage: "Get quiz result list status code",
          bodyMessage: "Get quiz result list response");

      getQuizResultListModel = getQuizResultListModelFromJson(response["body"]);

      if (getQuizResultListModel.statusCode == "200" ||
          getQuizResultListModel.statusCode == "201") {
        if (getQuizResultListModel.testResultList != null) {
          getQuizResultListModel.testResultList?.forEach(
            (element) {
              resultList.add(TestResultList(
                  answerSheet: element.answerSheet,
                  chapterId: element.chapterId,
                  checkedAnswerSheet: element.checkedAnswerSheet,
                  courseId: element.courseId,
                  id: element.id,
                  obtainMarks: element.obtainMarks,
                  rightAnswers: element.rightAnswers,
                  tdate: element.tdate,
                  testId: element.testId,
                  testName: element.testName,
                  testType: element.testType,
                  topicId: element.topicId,
                  topperObtainMarks: element.topperObtainMarks,
                  totalMarks: element.totalMarks,
                  totalQuestion: element.totalQuestion,
                  ttime: element.ttime,
                  userId: element.userId,
                  wrongAnswers: element.wrongAnswers));
            },
          );
        }
      } else {
        questions.clear();
        log("Something went wrong during getting quiz result list ::: ${getQuizResultListModel.message}");
      }
    } catch (error) {
      questions.clear();
      log("Something went wrong during getting quiz result list ::: $error");
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }

  // Fetch quiz data
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

  // Submit the quiz result
  Future<void> postQuizResult({
    required String testId,
    required String userId,
    required String type,
    required String courseid,
    required String chapterid,
    required String topicid,
    required String testpaymentid,
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
        "testpayment_id": testpaymentid,
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
        isQuizCompleted.value = true; // Mark the quiz as completed
        log("Quiz results posted successfully.");
        //  Get.to(() =>  WritingTestPage(userId: '',id:id));
      } else {
        log("Something went wrong: ${postChapterQuizResultModel.statusCode}");
      }
    } catch (error) {
      log("Error posting quiz results: $error");
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }

  Future<void> ShowresultQuizResult({
    required String testId,
    required String userId,
  }) async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {
        "test_id": testId,
        "user_id": userId,
      };

      var response = await HttpServices.postHttpMethod(
        url: EndPointConstant.testresultdisplay,
        payload: payload,
        urlMessage: "Post quiz result url",
        payloadMessage: "Post quiz result payload",
        statusMessage: "Post quiz result status code",
        bodyMessage: "Post quiz result response",
      );

      postShowlastChapterresultQuizModel =
          postShowlastChapterresultQuizModelFromJson(response["body"]);

      if (postShowlastChapterresultQuizModel.statusCode == "200" ||
          postShowlastChapterresultQuizModel.statusCode == "201") {
        isQuizCompleted.value = true; // Mark the quiz as completed
        log("Quiz results fetched successfully.");
      } else {
        log("Something went wrong: ${postShowlastChapterresultQuizModel.statusCode}");
      }
    } catch (error) {
      log("Error fetching quiz results: $error");
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }
}
