import 'package:flutter/material.dart';

class APIConfig {
  static String baseUrl = "https://ppapi1.adevz.com/api";

  static String login = "/auth-user/login";
  static String register = "/auth-user/register";
  static String logout = "/auth-user/logout";
  static String refreshToken = "/auth-user/refresh-token";
  static String verifySession = "/auth-user/verify-session";
  static String updateSession = "/auth-user/update-session";

  static String getTextFromStep = "/chat/gettextfromstep";
  static String sendMessage = "/chat/sendmessage";
  static String getGroupDetail = "/chat/getgroupdetail/";
  static String getGroupName = "/chat/";

  static String requestPayload = "/orderquotation/create";
  static String getQuote = "/orderquotation/getquotationbycode";

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const Duration tokenRefreshThreshold = Duration(minutes: 5);
  static const int maxRetryAttempts = 3;
}