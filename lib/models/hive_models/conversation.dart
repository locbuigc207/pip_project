import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'chat_message.dart';

part 'conversation.g.dart';
@HiveType(typeId: 1)
class Conversation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String  lastMessage;

  @HiveField(3)
  final bool hasRead;

  @HiveField(4)
  final String? codeQuote;

  Conversation({
    required this.id,
    required this.title,
    required this.lastMessage,
    this.hasRead = false,
    this.codeQuote,
  });
}