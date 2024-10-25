import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Controllers/SpekingTest_Controller.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_button.dart';

class SpeakingTestModule extends StatefulWidget {
  final String userId;
  const SpeakingTestModule({Key? key, required this.userId}) : super(key: key);

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
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Speaking Test", isBack: true),
      body: Column(
        children: [
          if (controller.cameraController.value.isInitialized)
            SizedBox(
              height: Get.height * 0.400,
              width: Get.width,
              child: CameraPreview(controller.cameraController),
            )
          else
            const SizedBox(),
          SizedBox(height: screenHeightPadding),
          ElevatedButton(
            onPressed: () async {
              if (!controller.isRecording.value) {
                await controller.startVideoRecording();
              } else {
                await controller.stopVideoRecording();
              }
              setState(() {}); // Update button text
            },
            child: Text(controller.isRecording.value
                ? "Stop Recording"
                : "Start Recording"),
          ),
          // Add a button to switch camera
          ElevatedButton(
            onPressed: () {
              controller.switchCamera();
            },
            child: const Text("Switch Camera"),
          ),
          if (controller.getSpeakingTestModel.proficiencyTestDetailsList !=
              null)
            Padding(
              padding: screenPadding,
              child: SingleChildScrollView(
                child: HtmlWidget(
                  "${controller.getSpeakingTestModel.proficiencyTestDetailsList?.first.questionDetails}",
                ),
              ),
            )
          else
            const SizedBox(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          title: "Submit",
          onTap: () {
            controller.postSpeakingTest();
          },
        ),
      ),
    );
  }
}
