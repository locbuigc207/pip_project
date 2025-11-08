import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';


class SessionManager {
  static const String _keySessionId = 'session_id';
  static const String _keyDeviceId = 'device_id';


  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_keyDeviceId);

    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await prefs.setString(_keyDeviceId, deviceId);
    }

    return deviceId;
  }


  static Future<String> createSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = const Uuid().v4();
    await prefs.setString(_keySessionId, sessionId);
    return sessionId;
  }


  static Future<String?> getCurrentSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySessionId);
  }


  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySessionId);
  }


  static Map<String, dynamic> buildSessionData({
    required String userId,
    required String deviceId,
    required String sessionId,
  }) {
    return {
      'user_id': userId,
      'device_id': deviceId,
      'session_id': sessionId,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }


  static Future<bool> hasValidSession() async {
    final sessionId = await getCurrentSessionId();
    return sessionId != null && sessionId.isNotEmpty;
  }
}