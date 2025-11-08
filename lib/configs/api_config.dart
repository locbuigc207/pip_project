import 'package:flutter/material.dart';

class APIConfig {
  // Base URL
  static String baseUrl = "https://ppapi1.adevz.com/api";

  // Auth endpoints
  static String login = "/auth/login";
  static String register = "/auth/register";
  static String verifySession = "/auth/verify-session";
  static String updateSession = "/auth/update-session";

  // Chat endpoints
  static String getTextFromStep = "/chat/gettextfromstep";
  static String sendMessage = "/chat/sendmessage";
  static String getGroupDetail = "/chat/getgroupdetail/";
  static String getGroupName = "/chat/";

  // Order endpoints
  static String requestPayload = "/orderquotation/create";
  static String getQuote = "/orderquotation/getquotationbycode";

  // Timeout settings
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}