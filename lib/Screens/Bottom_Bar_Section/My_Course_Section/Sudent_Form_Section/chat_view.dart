import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Controllers/chat_controller.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';

class ChatView extends StatefulWidget {
  final String testPaymentId;
  final String teacherId;

  const ChatView({
    super.key,
    required this.testPaymentId,
    required this.teacherId,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController controller = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller
        .initialFunctioun(testPaymentId: widget.testPaymentId)
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Message Teacher", isBack: true),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            // Observing the message list
            child: (controller.getMessageListModel.messageList != null &&
                    controller.getMessageListModel.messageList!.isNotEmpty)
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    itemCount:
                        controller.getMessageListModel.messageList?.length,
                    itemBuilder: (context, index) {
                      final message =
                          controller.getMessageListModel.messageList?[index];

                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              width: Get.width * 0.700,
                              decoration: BoxDecoration(
                                  color: ColorConstant.primary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message?.message ?? "",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: ColorConstant.white),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      message?.time ?? "",
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: ColorConstant.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (message?.replyList != null &&
                              message!.replyList!.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              itemCount: message.replyList?.length,
                              itemBuilder: (context, subIndex) {
                                final replyMessage =
                                    message.replyList?[subIndex];

                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    width: Get.width * 0.700,
                                    decoration: BoxDecoration(
                                        color: ColorConstant.primary
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          replyMessage?.reply ?? "",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            replyMessage?.time ?? "",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: ColorConstant.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                        ],
                      );
                    },
                  )
                : const CustomNoDataFound(message: "No Chat Found"),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Message Input
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Send Button
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () async {
                    final message = messageController.text.trim();
                    if (message.isNotEmpty) {
                      await controller
                          .postSendMessage(
                            teacherId: widget.teacherId,
                            message: message,
                            testPaymentId: widget.testPaymentId,
                          )
                          .whenComplete(() => setState(() {}));
                      messageController.clear(); // Clear input field
                    } else {
                      Get.snackbar("Error", "Message cannot be empty",
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
