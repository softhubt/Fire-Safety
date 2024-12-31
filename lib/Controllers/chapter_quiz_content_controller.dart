import 'dart:developer';
import 'package:firesafety/Models/get_quiz_result_list_model.dart';
import 'package:firesafety/Models/postShowlastResult_model.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_chapter_quiz_list_model.dart';
import 'package:firesafety/Models/post_chapter_quiz_result_model.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_quiz_content_view.dart';
import 'package:firesafety/Services/http_services.dart';

class ChapterQuizContentController extends GetxController {
  GetQuizResultListModel getQuizResultListModel = GetQuizResultListModel();
  GetChapterQuizListModel getChapterQuizListModel = GetChapterQuizListModel();
  PostChapterQuizResultModel postChapterQuizResultModel =
      PostChapterQuizResultModel();
  PostShowlastChapterresultQuizModel postShowlastChapterresultQuizModel =
      PostShowlastChapterresultQuizModel();

  RxList<Question> questions = <Question>[].obs; // RxList<Question>
  RxList<TestResultList> resultList =
      <TestResultList>[].obs; // RxList<Question>

  RxString selectedAnswer = "".obs;
  RxString testQiuzeId = "".obs;

  final RxDouble progressBarValue = 0.0.obs;

  RxInt correctAnswers = 0.obs;
  RxInt wrongAnswers = 0.obs;
  RxInt currentQuestionIndex = 0.obs;

  // New variable to store the quiz result
  RxBool isAnswered = false.obs;
  RxBool isQuizCompleted = false.obs;
  RxBool isFetchingData = true.obs;
  RxBool isRestart = false.obs;

  Future initialFunctioun(
      {required String chapterId,
      required String topicId,
      required String userId,
      required String quizType}) async {
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
  Future<void> getQuizList(
      {required String chapterId,
      required String userId,
      required String type,
      required String topicId}) async {
    try {
      Map<String, dynamic> payload = {
        "type": type,
        "chapter_id": chapterId,
        "topic_id": topicId,
        "user_id": userId
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.testQuestionDetails,
          payload: payload,
          urlMessage: "Get quiz list url",
          payloadMessage: "Get quiz list payload",
          statusMessage: "Get quiz list status code",
          bodyMessage: "Get quiz list response");

      getChapterQuizListModel.testDetailsList = null;

      getChapterQuizListModel =
          getChapterQuizListModelFromJson(response["body"]);

      if (getChapterQuizListModel.statusCode == "200" ||
          getChapterQuizListModel.statusCode == "201") {
        if (getChapterQuizListModel.testDetailsList != null &&
            getChapterQuizListModel.testDetailsList!.isNotEmpty) {
          testQiuzeId.value =
              getChapterQuizListModel.testDetailsList?.first.testId ?? '';
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

          await getQuizResultList(
              userId: userId,
              testId:
                  getChapterQuizListModel.testDetailsList?.first.testId ?? "");
        } else {
          testQiuzeId.value = ''; // Ensure a non-null value is set
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
    }
  }

  Future<void> getQuizResultList(
      {required String userId, required String testId}) async {
    try {
      Map<String, dynamic> payload = {"user_id": userId, "test_id": testId};

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.testResultDisplay,
          payload: payload,
          urlMessage: "Get quiz result list url",
          payloadMessage: "Get quiz result list payload",
          statusMessage: "Get quiz result list status code",
          bodyMessage: "Get quiz result list response");

      log("Response body: ${response['body']}");

      if (response["body"] == null || response["body"] == "") {
        throw Exception("Response body is null or empty.");
      }

      getQuizResultListModel.testResultList = null;

      getQuizResultListModel = getQuizResultListModelFromJson(response["body"]);

      if (getQuizResultListModel.statusCode == "200" ||
          getQuizResultListModel.statusCode == "201") {
        if (getQuizResultListModel.testResultList != null &&
            getQuizResultListModel.testResultList!.isNotEmpty) {
          getQuizResultListModel.testResultList?.forEach((element) {
            if (element.obtainMarks != null) {
              resultList.add(TestResultList(
                  id: element.id ?? "",
                  userId: element.userId ?? "",
                  testId: element.testId ?? "",
                  testType: element.testType ?? "",
                  obtainMarks: element.obtainMarks ?? "0",
                  totalMarks: element.totalMarks ?? "0",
                  testName: element.testName ?? "",
                  answerSheet: element.answerSheet ?? "",
                  checkedAnswerSheet: element.checkedAnswerSheet ?? "",
                  rightAnswers: element.rightAnswers ?? "0",
                  wrongAnswers: element.wrongAnswers ?? "0",
                  totalQuestion: element.totalQuestion ?? 0,
                  topperObtainMarks: element.topperObtainMarks ?? "0",
                  courseId: element.courseId ?? "",
                  chapterId: element.chapterId ?? "",
                  topicId: element.topicId ?? "",
                  tdate: element.tdate,
                  ttime: element.ttime ?? ""));
            }
          });
        } else {
          log("Test result list is empty or null.");
        }
      } else {
        log("Failed to get quiz result: ${getQuizResultListModel.message}");
      }
    } catch (error) {
      questions.clear();
      log("Something went wrong during getting quiz result list ::: $error");
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
        "testpayment_id": testpaymentid
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.testSubmit,
          payload: payload,
          urlMessage: "Post quiz result url",
          payloadMessage: "Post quiz result payload",
          statusMessage: "Post quiz result status code",
          bodyMessage: "Post quiz result response");

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
    } finally {}
  }

  Future<void> ShowresultQuizResult({
    required String testId,
    required String userId,
  }) async {
    try {
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
    } finally {}
  }
}
