// ignore_for_file: deprecated_member_use

import 'package:camera/camera.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/bottom_bar_screen.dart';
import 'package:firesafety/Widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Controllers/SpekingTest_Controller.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_button.dart';

class SpeakingTestModule extends StatefulWidget {
  final String userId;
  final String id;
  const SpeakingTestModule({super.key, required this.userId, required this.id});

  @override
  _SpeakingTestModuleState createState() => _SpeakingTestModuleState();
}

class _SpeakingTestModuleState extends State<SpeakingTestModule> {
  final SpekingTestController controller = Get.put(SpekingTestController());

  @override
  void initState() {
    super.initState();
    _initializeEverything();
  }

  Future<void> _initializeEverything() async {
    await controller.initialFunctioun();
    // Wait for the camera to initialize before rebuilding the UI
    if (controller.cameraController.value.isInitialized) {
      controller.isCameraInitilize.value = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.cameraController.dispose();
    super.dispose();
  }

  backToDashboard() {
    Get.offAll(() => const BottomBarScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Speaking Test", leading: SizedBox()),
      body: WillPopScope(
          onWillPop: () => backToDashboard(),
          child: (controller.isCameraInitilize.value)
              ? Column(
                  children: [
                    if (controller.cameraController.value.isInitialized)
                      SizedBox(
                          height: Get.height * 0.400,
                          width: Get.width,
                          child: CameraPreview(controller.cameraController))
                    else
                      const SizedBox(),
                    SizedBox(height: screenHeightPadding),
                    Obx(
                      () {
                        return (controller.isRecording.value)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        await controller.stopVideoRecording();
                                        controller.stopTimer();
                                        setState(() {});
                                      },
                                      child: const Text("Stop Recording")),
                                  SizedBox(width: screenWidthPadding),
                                  Obx(() => Text(
                                      "Seconds: ${controller.elapsedSeconds.value}",
                                      style: TextStyleConstant.medium16())),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  await controller.startVideoRecording();
                                  controller.startTimer();
                                  setState(() {});
                                },
                                child: const Text("Start Recording"));
                      },
                    ),
                    if (controller
                            .getSpeakingTestModel.proficiencyTestDetailsList !=
                        null)
                      Padding(
                          padding: screenPadding,
                          child: SingleChildScrollView(
                              child: HtmlWidget(
                                  "${controller.getSpeakingTestModel.proficiencyTestDetailsList?.first.questionDetails}",
                                  textStyle: TextStyleConstant.medium14())))
                    else
                      const SizedBox(),
                  ],
                )
              : const Center(child: CircularProgressIndicator())),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          title: "Submit",
          onTap: () {
            if (controller.recordedVideoPath.value.isNotEmpty) {
              controller.postSpeakingTest(id: widget.id);
            } else {
              customToast(message: "Please Record Video");
            }
          },
        ),
      ),
    );
  }
}
