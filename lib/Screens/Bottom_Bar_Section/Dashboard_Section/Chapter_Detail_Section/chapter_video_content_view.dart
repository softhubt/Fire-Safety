import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/chapter_video_content_controller.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class ChapterVideoContentView extends StatefulWidget {
  final String chapterId;

  const ChapterVideoContentView({super.key, required this.chapterId});

  @override
  State<ChapterVideoContentView> createState() =>
      _ChapterVideoContentViewState();
}

class _ChapterVideoContentViewState extends State<ChapterVideoContentView> {
  late final ChapterVideoContentController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChapterVideoContentController());
    _initializeController();
  }

  Future<void> _initializeController() async {
    await controller.getVideoList(chapterId: widget.chapterId);
    if (controller
            .getChapterVideoListModel.chapterwiseTopicVideoList?.isNotEmpty ??
        false) {
      controller.videoPlayerController = VideoPlayerController.network(
        controller
            .getChapterVideoListModel.chapterwiseTopicVideoList![0].video!,
      );
      controller.initializeVideoPlayerFuture =
          controller.videoPlayerController!.initialize();
      setState(() {}); // Update UI after initialization
    }
  }

  @override
  void dispose() {
    controller.videoPlayerController?.dispose();
    controller.initializeVideoPlayerFuture = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.initializeVideoPlayerFuture != null
          ? FutureBuilder(
              future: controller.initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    controller.videoPlayerController != null &&
                    controller.videoPlayerController!.value.isInitialized) {
                  return buildVideoContent();
                } else if (snapshot.hasError) {
                  return const CustomNoDataFound(
                      message: "Error Loading Video");
                } else {
                  return buildShimmerEffect(); // Show shimmer while loading
                }
              },
            )
          : const Center(child: Text("No video available")),
    );
  }

  Widget buildShimmerEffect() {
    return Padding(
      padding: screenVerticalPadding,
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: Get.height * 0.25,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          Expanded(
            // Shimmer for the video list
            child: ListView.builder(
              itemCount: 5, // Simulating loading for 5 items
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: Get.height * 0.08,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVideoContent() {
    return Padding(
      padding: screenVerticalPadding,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (controller.videoPlayerController != null) {
                (controller.videoPlayerController != null &&
                        controller.videoPlayerController!.value.isInitialized)
                    ? controller.videoPlayerController!.pause()
                    : controller.videoPlayerController!.play();
                setState(() {});
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                    aspectRatio:
                        controller.videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(controller.videoPlayerController!)),
                if (controller.videoPlayerController != null &&
                    controller.videoPlayerController!.value.isInitialized)
                  Icon(
                    Icons.play_arrow,
                    color: ColorConstant.white,
                    size: Get.width * 0.130,
                  ),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.020),
          Expanded(
            child:
                controller.getChapterVideoListModel.chapterwiseTopicVideoList !=
                        null
                    ? ListView.builder(
                        itemCount: controller.getChapterVideoListModel
                                .chapterwiseTopicVideoList?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return buildVideoCard(index);
                        },
                      )
                    : const CustomNoDataFound(),
          ),
        ],
      ),
    );
  }

  Widget buildVideoCard(int index) {
    return Card(
      child: Container(
        padding: contentHorizontalPadding,
        height: Get.height * 0.080,
        width: Get.width,
        decoration: BoxDecoration(
          color: ColorConstant.extraLightPrimary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${controller.getChapterVideoListModel.chapterwiseTopicVideoList?[index].topicName}",
              style: TextStyleConstant.medium16(),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await controller.playVideo(
                      videoPath: controller.getChapterVideoListModel
                              .chapterwiseTopicVideoList?[index].video ??
                          "",
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.video_library),
                ),
                const Text("Play Video"),
              ],
            ),
            SizedBox(width: Get.width * 0.020),
          ],
        ),
      ),
    );
  }
}
