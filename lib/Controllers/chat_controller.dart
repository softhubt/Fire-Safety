import 'dart:developer';
import 'package:firesafety/Constant/endpoint_constant.dart';
import 'package:firesafety/Constant/storage_key_constant.dart';
import 'package:firesafety/Models/get_message_list_model.dart';
import 'package:firesafety/Models/post_send_message_model.dart';
import 'package:firesafety/Services/http_services.dart';
import 'package:firesafety/Services/local_storage_services.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  GetMessageListModel getMessageListModel = GetMessageListModel();
  PostSendMessageModel postSendMessageModel = PostSendMessageModel();

  RxString userId = "".obs;

  Future initialFunctioun({required String testPaymentId}) async {
    userId.value = await StorageServices.getData(
        dataType: StorageKeyConstant.stringType,
        prefKey: StorageKeyConstant.userId) ?? "";

    await getMessageList(testPaymentId: testPaymentId);
  }

  Future<void> postSendMessage(
      {required String teacherId,
      required String message,
      required String testPaymentId}) async {
    try {
      Map<String, dynamic> payload = {
        "user_id": userId.value,
        "teacher_id": teacherId,
        "message": message,
        "testpayment_id": testPaymentId
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.message,
          payload: payload,
          urlMessage: "Post send message url",
          payloadMessage: "Post send message payload",
          statusMessage: "Post send message status",
          bodyMessage: "Post send message response");

      postSendMessageModel = postSendMessageModelFromJson(response["body"] ?? "");

      if (postSendMessageModel.statusCode == "200" ||
          postSendMessageModel.statusCode == "201") {
        await getMessageList(testPaymentId: testPaymentId);
      } else {
        log("Something went wrong during posting send message ::: ${postSendMessageModel.message}");
      }
    } catch (error) {
      log("Something went wrong during posting send message ::: $error");
    }
  }

  Future<void> getMessageList({required String testPaymentId}) async {
    try {
      Map<String, dynamic> payload = {
        "user_id": userId.value,
        "testpayment_id": testPaymentId
      };

      var response = await HttpServices.postHttpMethod(
          url: EndPointConstant.messageReply,
          payload: payload,
          urlMessage: "Get message list url",
          payloadMessage: "Get message list payload",
          statusMessage: "Get message list status",
          bodyMessage: "Get message list response");

      getMessageListModel = getMessageListModelFromJson(response["body"] ?? "");

      if (getMessageListModel.statusCode == "200" ||
          getMessageListModel.statusCode == "201") {
      } else {
        log("Something went wrong during getting message list ::: ${getMessageListModel.message}");
      }
    } catch (error) {
      log("Something went wrong during getting meesage list ::: $error");
    }
  }
}
