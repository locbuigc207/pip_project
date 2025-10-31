import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'chat_message.g.dart';
@HiveType(typeId: 0)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String sender;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final int steps;

  @HiveField(3)
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.steps,
    required this.timestamp,
  });
}