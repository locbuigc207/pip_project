import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/hive_models/chat_message.dart';
import '../models/hive_models/conversation.dart';



class AppBoxChat{
  //Luu doan chat duoi dang map
  static Future<void> saveConversation(Conversation conv) async {
    final box = Hive.box<Conversation>('conversationBox');
    await box.put(conv.id, conv);
    print("save complete");
  }

  //Hien danh sach cuoc hoi thoai
  static List<Conversation> getAllConversations() {
    final box = Hive.box<Conversation>('conversationBox');
    return box.values.toList();
  }

  //Doc lai 1 conversation
  static Future<Conversation?> getConversationById(String convId) async {
    final box = Hive.box<Conversation>('conversationBox');
    return box.get(convId);
  }

  static Future<void> saveConversationWithMessages(Conversation conv) async {
    final box = Hive.box<Conversation>('conversations');
    await box.put(conv.id, conv);
  }

  // //Cap nhat tin nhan vao cuoc hoi thoai
  // static Future<void> addMessageToConversation(String convId, ChatMessage msg) async {
  //   final box = Hive.box<Conversation>('conversationBox');
  //   final conv = box.get(convId);
  //
  //   if (conv != null) {
  //     conv.lastMessage = msg;
  //     await conv.save(); // update Hive
  //   }
  // }

  //Cap nhat conv
  static Future<void> updateHasRead(String? convId, String? title,
      String? lastMessage, String? quoteId , {bool hasRead = true}
      ) async {
    final box = Hive.box<Conversation>('conversationBox');
    final conv = box.get(convId);
    if(quoteId == null) quoteId = conv!.codeQuote;

    if (conv != null) {
      final updatedConv = Conversation(
        id: conv.id,
        title: (title != null)? title : conv.title,
        lastMessage: (lastMessage != null)? lastMessage : conv.lastMessage,
        hasRead: hasRead,
        codeQuote: quoteId
      );
      await box.put(convId, updatedConv);
      print("Cập nhật conversation: $convId");
      print("---- Thông tin chi tiết ----");
      print("ID: ${updatedConv.id}");
      print("Title: ${updatedConv.title}");
      print("Last Message: ${updatedConv.lastMessage}");
      print("Has Read: ${updatedConv.hasRead}");
      print("Code Quote: ${updatedConv.codeQuote}");
      print("----------------------------");
    } else {
      print("Không tìm thấy conversation với id: $convId");
    }
  }

  //Xoa box
  static Future<void> clearSpecificBox(String boxName) async {
    // final box = await Hive.openBox(boxName);
    // await box.clear();
    // await box.close();
    await Hive.deleteBoxFromDisk(boxName);
    print("Đã xoá dữ liệu trong box: $boxName");
  }




}