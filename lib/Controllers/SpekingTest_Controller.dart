import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Models/post_SpeakingTest_model.dart';
import 'package:firesafety/Models/post_speaking_test_data_model.dart';
import 'package:firesafety/Screens/Writting_Test_Screen.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class SpekingTestController extends GetxController {
  GetSpeakingTestModel getSpeakingTestModel = GetSpeakingTestModel();
  PostSpeakingTestDataModel postSpeakingTestDataModel =
      PostSpeakingTestDataModel();

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  RxBool isRecording = false.obs;
  RxBool isCameraInitilize = false.obs;
  RxString userId = "".obs;
  RxString id = "".obs;
  RxString recordedVideoPath = "".obs;
  RxInt currentCameraIndex = 0.obs;

  Future<void> initialFunctioun() async {
    userId.value = await StorageServices.getData(
        dataType: StorageKeyConstant.stringType,
        prefKey: StorageKeyConstant.userId);

    await requestCameraPermission();
    await fetchWritingTest();
    await initializeCamera(currentCameraIndex
        .value); // This will now point to the front camera if available
  }

  void switchCamera() async {
    currentCameraIndex.value = (currentCameraIndex.value + 1) % cameras.length;

    await cameraController.dispose();
    await initializeCamera(currentCameraIndex.value);
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<void> startVideoRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      isRecording.value = true;

      try {
        await cameraController.startVideoRecording();
        log("Recording started...");
      } on CameraException catch (e) {
        log("Error recording video: $e");
      }
    }
  }

  Future<void> stopVideoRecording() async {
    if (cameraController.value.isRecordingVideo) {
      try {
        final XFile videoFile = await cameraController.stopVideoRecording();
        log("Video recorded to temporary path: ${videoFile.path}");

        final directory = await getApplicationDocumentsDirectory();
        final newFilePath = path.join(
            directory.path, '${DateTime.now().millisecondsSinceEpoch}.mp4');

        File tempFile = File(videoFile.path);
        File newFile = await tempFile.rename(newFilePath);
        log("Video saved with new path: ${newFile.path}");

        recordedVideoPath.value = newFile.path;
      } on CameraException catch (e) {
        log("Error stopping video: $e");
      } finally {
        isRecording.value = false;
      }
    }
  }

  Future<void> initializeCamera(int cameraIndex) async {
    try {
      cameras = await availableCameras();

      if (cameras.isEmpty) {
        log("No cameras available");
        return;
      }

      // Set default to front camera if available
      if (cameras.length > 1) {
        // Check if the front camera exists
        for (var i = 0; i < cameras.length; i++) {
          if (cameras[i].lensDirection == CameraLensDirection.front) {
            currentCameraIndex.value = i; // Set to front camera index
            break;
          }
        }
      }

      cameraController = CameraController(
          cameras[currentCameraIndex.value], ResolutionPreset.high);
      await cameraController.initialize();
      update();
    } catch (e) {
      log("Error initializing camera: $e");
    }
  }

  Future<void> fetchWritingTest() async {
    try {
      CustomLoader.openCustomLoader();

      Map<String, dynamic> payload = {"type": "Speaking Test"};

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.Spekingproficiencytesttypewise,
          payload: payload,
          urlMessage: "Get speaking test list URL",
          payloadMessage: "Get speaking test list payload",
          statusMessage: "Get speaking test list status code",
          bodyMessage: "Get speaking test list response");

      getSpeakingTestModel = getSpeakingTestModelFromJson(response["body"]);

      if (getSpeakingTestModel.statusCode == "200" ||
          getSpeakingTestModel.statusCode == "201") {
        log("Speaking test details fetched successfully.");
      } else {
        log("No data found for speaking test. Status code: ${getSpeakingTestModel.statusCode}");
      }
    } catch (error) {
      log("Error getting speaking test list: $error");
    } finally {
      CustomLoader.closeCustomLoader();
    }
  }

  Future<void> postSpeakingTest({required String id}) async {
    CustomLoader.openCustomLoader();
    try {
      var header = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              "${EndPointConstant.baseUrl}${EndPointConstant.proficiencySpeakingTestSubmit}"));

      log("Video file ::: ${recordedVideoPath.value}");

      request.headers.addAll(header);
      request.fields["user_id"] = userId.value;
      request.fields["type"] = "Speaking Test";
      request.fields["question_id"] =
          "${getSpeakingTestModel.proficiencyTestDetailsList?.first.id}";
      request.fields["question_details"] =
          "${getSpeakingTestModel.proficiencyTestDetailsList?.first.questionDetails}";

      request.files.add(await http.MultipartFile.fromPath(
          "videofile", recordedVideoPath.value));
      request.fields["testpayment_id"] = id;
      var response = await request.send();
      var responsed = await http.Response.fromStream(response);

      log("Post speaking test response ::: ${responsed.body}");

      postSpeakingTestDataModel =
          postSpeakingTestDataModelFromJson(responsed.body);

      if (postSpeakingTestDataModel.statusCode == "200" ||
          postSpeakingTestDataModel.statusCode == "201") {
        CustomLoader.closeCustomLoader();
        Get.to(() => WritingTestPage(userId: '', id: id));
      } else {
        CustomLoader.closeCustomLoader();
      }
    } catch (error) {
      CustomLoader.closeCustomLoader();
      log("Something went wrong during posting speaking test ::: $error");
    }
  }
}
