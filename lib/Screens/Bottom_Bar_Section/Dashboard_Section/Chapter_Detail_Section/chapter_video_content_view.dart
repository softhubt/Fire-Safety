import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/chapter_video_content_controller.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';
import 'package:video_player/video_player.dart';

class ChapterVideoContentView extends StatefulWidget {
  final String chapterId;

  const ChapterVideoContentView({super.key, required this.chapterId});

  @override
  State<ChapterVideoContentView> createState() =>
      _ChapterVideoContentViewState();
}

class _ChapterVideoContentViewState extends State<ChapterVideoContentView> {
  ChapterVideoContentController controller =
      Get.put(ChapterVideoContentController());

  @override
  void initState() {
    super.initState();
    initialFunctioun().whenComplete(() => setState(() {}));
  }

  Future initialFunctioun() async {
    await controller.getVideoList(chapterId: widget.chapterId);

    controller.videoPlayerController = VideoPlayerController.network(
        "${controller.getChapterVideoListModel.chapterwiseTopicVideoList?[0].video}");

    controller.initializeVideoPlayerFuture =
        controller.videoPlayerController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: controller.initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: screenVerticalPadding,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.videoPlayerController.value.isPlaying
                        ? controller.videoPlayerController.pause()
                        : controller.videoPlayerController.play();
                    setState(() {});
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: controller
                                .videoPlayerController.value.aspectRatio,
                            child:
                                VideoPlayer(controller.videoPlayerController),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: VideoProgressIndicator(
                                controller.videoPlayerController,
                                allowScrubbing: true),
                          ),
                        ],
                      ),
                      (controller.videoPlayerController.value.isPlaying)
                          ? const SizedBox()
                          : Icon(
                              Icons.play_arrow,
                              color: ColorConstant.white,
                              size: Get.width * 0.130,
                            ),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.020),
                Expanded(
                    child: (controller.getChapterVideoListModel
                                .chapterwiseTopicVideoList !=
                            null)
                        ? ListView.builder(
                            itemCount: controller.getChapterVideoListModel
                                .chapterwiseTopicVideoList?.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Container(
                                  padding: contentHorizontalPadding,
                                  height: Get.height * 0.080,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.extraLightPrimary,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          "${controller.getChapterVideoListModel.chapterwiseTopicVideoList?[index].topicName}",
                                          style: TextStyleConstant.medium16()),
                                      const Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                controller
                                                    .playVideo(
                                                        videoPath:
                                                            "${controller.getChapterVideoListModel.chapterwiseTopicVideoList?[index].video}")
                                                    .whenComplete(
                                                        () => setState(() {}));
                                              },
                                              icon: const Icon(
                                                  Icons.video_library)),
                                          const Text("Play Video"),
                                        ],
                                      ),
                                      SizedBox(width: Get.width * 0.020),
                                      // Column(
                                      //   mainAxisAlignment:
                                      //   MainAxisAlignment.center,
                                      //   children: [
                                      //     IconButton(
                                      //         onPressed: () {
                                      //           controller.downloadVideo(
                                      //               "${controller.getChapterVideoListModel.chapterwiseTopicVideoList?[index].video}",
                                      //               "${controller.getChapterVideoListModel.chapterwiseTopicVideoList?[index].topicName}.mp4");
                                      //
                                      //           // controller.downloadFile(
                                      //           //     fileUrl:
                                      //           //         "${controller.getChapterVideoListModel.chapterwiseTopicVideoList?[index].video}",
                                      //           //     fileName:
                                      //           //         "${controller.getChapterVideoListModel.chapterwiseTopicVideoList?[index].topicName}.mp4");
                                      //         },
                                      //         icon: const Icon(Icons.file_download)),
                                      //     const Text(" PDF Download"),
                                      //   ],
                                      // ),
                                      // SizedBox(width: Get.width * 0.020),
                                      // Column(
                                      //   mainAxisAlignment:
                                      //   MainAxisAlignment.center,
                                      //   children: [
                                      //     IconButton(
                                      //         onPressed: () {},
                                      //         icon:
                                      //         const Icon(Icons.assessment)),
                                      //     const Text("PPT"),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const CustomNoDataFound())
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}
