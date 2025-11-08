import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

/// SessionManager - Quản lý session và device ID
///
/// Dùng để đảm bảo 1 tài khoản chỉ hoạt động trên 1 thiết bị tại 1 thời điểm
class SessionManager {
  // Keys cho SharedPreferences
  static const String _keySessionId = 'session_id';
  static const String _keyDeviceId = 'device_id';

  /// Tạo hoặc lấy Device ID duy nhất cho thiết bị
  ///
  /// Device ID được tạo 1 lần duy nhất khi cài app và giữ nguyên
  /// Returns: Device ID string (UUID v4)
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_keyDeviceId);

    if (deviceId == null) {
      // Tạo device ID mới nếu chưa có
      deviceId = const Uuid().v4();
      await prefs.setString(_keyDeviceId, deviceId);
    }

    return deviceId;
  }

  /// Tạo Session ID mới khi đăng nhập
  ///
  /// Session ID được tạo mỗi lần đăng nhập để tracking phiên làm việc
  /// Returns: Session ID string (UUID v4)
  static Future<String> createSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = const Uuid().v4();
    await prefs.setString(_keySessionId, sessionId);
    return sessionId;
  }

  /// Lấy Session ID hiện tại
  ///
  /// Returns: Session ID hoặc null nếu chưa có
  static Future<String?> getCurrentSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySessionId);
  }

  /// Xóa session (khi đăng xuất hoặc bị force logout)
  ///
  /// Returns: void
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySessionId);
  }

  /// Tạo dữ liệu session để gửi lên server
  ///
  /// Parameters:
  /// - userId: ID của user
  /// - deviceId: ID của thiết bị
  /// - sessionId: ID của phiên làm việc
  ///
  /// Returns: Map chứa thông tin session
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

  /// Kiểm tra xem session hiện tại có hợp lệ không
  ///
  /// Sử dụng khi cần verify session trước khi thực hiện các thao tác quan trọng
  /// Returns: true nếu có session, false nếu không
  static Future<bool> hasValidSession() async {
    final sessionId = await getCurrentSessionId();
    return sessionId != null && sessionId.isNotEmpty;
  }
}