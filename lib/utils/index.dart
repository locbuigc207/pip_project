import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppIndex{

  static bool checkPhonenumber(String text){
    // Regex cho số điện thoại VN: 10 số bắt đầu 0
    final phoneRegex = RegExp(r'(0[0-9]{9})');
    return phoneRegex.hasMatch(text);
  }

  static Map<String, String?> getPhoneNumber(String text) {
    final phoneRegex = RegExp(r'(0\d{8,10})');
    final match = phoneRegex.firstMatch(text);

    String? phone;
    String? name;

    if (match != null) {
      phone = match.group(0);
      int phoneIndex = match.start;
      name = text.substring(0, phoneIndex).trim();
    } else {
      name = text.trim();
    }

    return {
      'name': name,
      'phone': phone,
    };
  }

  static Future<void> openLink(BuildContext context, String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Link trống")),
      );
      return;
    }

    try {
      final Uri uri = Uri.parse(Uri.encodeFull(url));

      // Thử mở bằng external application
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // Nếu không mở được thì fallback sang in-app browser
        if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Không mở được link: $url")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Link không hợp lệ hoặc lỗi: $url")),
      );
    }
  }





}