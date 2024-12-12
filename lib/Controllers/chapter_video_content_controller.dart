import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firesafety/Widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Models/get_chapter_video_list_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:video_player/video_player.dart';

class ChapterVideoContentController extends GetxController {
  GetChapterVideoListModel getChapterVideoListModel =
      GetChapterVideoListModel();

  VideoPlayerController? videoPlayerController; // Change to nullable
  Future<void>? initializeVideoPlayerFuture; // Change to nullable

  Future playVideo({required String videoPath}) async {
    if (videoPlayerController != null) {
      await videoPlayerController!.dispose();
    }

    videoPlayerController = VideoPlayerController.network(videoPath);
    initializeVideoPlayerFuture = videoPlayerController!.initialize();

    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
    } else {
      videoPlayerController!.play();
    }
  }

  final RxString selectedDropdown = "".obs;
  final RxList<String> dropDownList = [
    'consumer_home_delivery/consumer home delivery',
    'pick_up_the_franchise_point/pick up the franchise point',
  ].obs;

  skipForward() {
    final newPosition =
        videoPlayerController!.value.position + const Duration(seconds: 10);
    videoPlayerController?.seekTo(newPosition);
  }

  skipBackward() {
    final newPosition =
        videoPlayerController!.value.position - const Duration(seconds: 10);
    videoPlayerController?.seekTo(newPosition);
  }

  Future downloadFile(String url, String fileName) async {
    try {
      CustomLoader.openCustomLoader();

      // Get the directory to save the file
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String filePath = '$appDocPath/$fileName';

      Dio dio = Dio();
      await dio.download(url, filePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          print("${(received / total * 100).toStringAsFixed(0)}%");
        }
      });

      // Notify the user that the download is complete
      Fluttertoast.showToast(
        msg: "Your content has been downloaded",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      print('File saved to $filePath');

      CustomLoader.closeCustomLoader();
    } catch (e) {
      CustomLoader.closeCustomLoader();
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Error: $e');
    }
  }

  Future getVideoList({required String chapterId}) async {
    try {
      Map<String, dynamic> payload = {"chapter_id": chapterId};

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.chapterWiseTopicVideo,
          payload: payload,
          urlMessage: "Get video list url",
          payloadMessage: "Get video list payload",
          statusMessage: "Get video list status code",
          bodyMessage: "Get video list response");

      getChapterVideoListModel =
          getChapterVideoListModelFromJson(response["body"]);

      if (getChapterVideoListModel.statusCode == "200" ||
          getChapterVideoListModel.statusCode == "201") {
      } else {
        log("Something went wrong during getting video list ::: ${getChapterVideoListModel.statusCode}");
      }
    } catch (error) {
      log("Something went wrong during getting video list ::: $error");
    }
  }
}
