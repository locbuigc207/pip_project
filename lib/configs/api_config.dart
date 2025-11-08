import 'package:flutter/material.dart';


class APIConfig{
  static String baseUrl = "https://ppapi1.adevz.com/api";

  // Auth endpoints
  static String login = "/auth/login";
  static String register = "/auth/register";

  // Chat endpoints
  static String getTextFromStep = "/chat/gettextfromstep";
  static String sendMessage = "/chat/sendmessage";
  static String getGroupDetail = "/chat/getgroupdetail/";
  static String getGroupName = "/chat/";

  // Order endpoints
  static String requestPayload = "/orderquotation/create";
  static String getQuote = "/orderquotation/getquotationbycode";
}