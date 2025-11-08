import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// AuthManager - Quản lý trạng thái đăng nhập và chế độ khách
class AuthManager {
  // Keys cho SharedPreferences
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserData = 'user_data';
  static const String _keyToken = 'auth_token';
  static const String _keyIsGuest = 'is_guest_mode';

  /// Lưu thông tin đăng nhập cho user đã đăng ký
  ///
  /// Parameters:
  /// - userId: ID của user
  /// - fullName: Tên đầy đủ
  /// - email: Email
  /// - token: Token xác thực (optional)
  static Future<bool> saveLoginData({
    required String userId,
    required String fullName,
    required String email,
    String? token,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userData = {
        'user_id': userId,
        'full_name': fullName,
        'email': email,
      };

      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setBool(_keyIsGuest, false); // Đăng nhập = không phải guest
      await prefs.setString(_keyUserData, jsonEncode(userData));
      if (token != null) {
        await prefs.setString(_keyToken, token);
      }

      return true;
    } catch (e) {
      print('Error saving login data: $e');
      return false;
    }
  }

  /// Kích hoạt chế độ khách vãng lai
  ///
  /// Chế độ này cho phép user sử dụng app mà không cần đăng ký/đăng nhập
  /// Lịch sử chat chỉ lưu local trên thiết bị
  static Future<bool> enableGuestMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsGuest, true);
      await prefs.setBool(_keyIsLoggedIn, false);

      // Lưu thông tin khách vãng lai
      final guestData = {
        'user_id': 'guest',
        'full_name': 'Khách',
        'email': 'guest@local',
      };
      await prefs.setString(_keyUserData, jsonEncode(guestData));

      return true;
    } catch (e) {
      print('Error enabling guest mode: $e');
      return false;
    }
  }

  /// Kiểm tra user đã đăng nhập chưa
  ///
  /// Returns: true nếu đã đăng nhập, false nếu chưa
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  /// Kiểm tra có đang ở chế độ khách không
  ///
  /// Returns: true nếu đang ở chế độ khách, false nếu không
  static Future<bool> isGuestMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsGuest) ?? false;
    } catch (e) {
      print('Error checking guest mode: $e');
      return false;
    }
  }

  /// Lấy thông tin người dùng (cả user và guest)
  ///
  /// Returns: Map chứa user_id, full_name, email hoặc null nếu không có
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_keyUserData);

      if (userDataString != null) {
        return jsonDecode(userDataString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Lấy token xác thực
  ///
  /// Returns: Token string hoặc null nếu không có
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyToken);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  /// Đăng xuất (xóa thông tin đăng nhập hoặc thoát chế độ khách)
  ///
  /// Returns: true nếu thành công, false nếu có lỗi
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIsLoggedIn);
      await prefs.remove(_keyUserData);
      await prefs.remove(_keyToken);
      await prefs.remove(_keyIsGuest);
      return true;
    } catch (e) {
      print('Error logging out: $e');
      return false;
    }
  }

  /// Xóa tất cả dữ liệu đã lưu
  ///
  /// CẢNH BÁO: Hàm này sẽ xóa toàn bộ SharedPreferences
  /// Returns: true nếu thành công, false nếu có lỗi
  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return true;
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }
}