import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthManager {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserData = 'user_data';
  static const String _keyToken = 'auth_token';

  // Lưu thông tin đăng nhập
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

  // Kiểm tra đã đăng nhập chưa
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Lấy thông tin người dùng
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

  // Lấy token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyToken);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Đăng xuất
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIsLoggedIn);
      await prefs.remove(_keyUserData);
      await prefs.remove(_keyToken);
      return true;
    } catch (e) {
      print('Error logging out: $e');
      return false;
    }
  }

  // Xóa tất cả dữ liệu
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