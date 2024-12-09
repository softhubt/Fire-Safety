import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/chapter_TopicWise_quize_Controller.dart';
import 'package:firesafety/Controllers/chapter_detail_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/chapter_quiz_content_view.dart';

class TopicListScreen extends StatefulWidget {
  final String chapterId;
  final String userId;
  final String testpaymentId;

  TopicListScreen({Key? key, required this.chapterId, required this.userId, required this.testpaymentId,})
      : super(key: key);

  @override
  _TopicListScreenState createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  late final ChapterTopicWiseQuizController controller;
  final ChapterDetailController chapterDetailController = Get.find();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChapterTopicWiseQuizController());
    // Load topic list initially
    controller.getTopicWiseList(chapterId: widget.chapterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Topics List', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (controller.topicList.isEmpty) {
          return Center(child: Text('No Topics Available'));
        }

        return Container(
          color: Colors.grey[100],
          child: ListView.separated(
            padding: EdgeInsets.all(16.0),
            separatorBuilder: (context, index) =>
                Divider(thickness: 1, color: Colors.grey[300]),
            itemCount: controller.topicList.length,
            itemBuilder: (context, index) {
              final topic = controller.topicList[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.topic, color: Colors.white),
                  ),
                  title: Text(topic.topicName ?? 'Unknown',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  onTap: () {
                    if (topic.topicId != null && topic.topicId!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterQuizContentView(
                            chapterId: widget.chapterId,
                            topicId: topic.topicId!,
                            userId: widget.userId,
                            //  userId: chapterDetailController.userId.value,
                            quizType: "3",
                            testpaymentId: widget.testpaymentId,

                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('No quizzes available for this topic')),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    // Optionally clear the topic list when the screen is disposed
    Get.delete<ChapterTopicWiseQuizController>();
    super.dispose();
  }
}
