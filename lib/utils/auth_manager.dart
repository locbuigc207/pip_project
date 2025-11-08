import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthManager {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserData = 'user_data';
  static const String _keyToken = 'auth_token';
  static const String _keyIsGuest = 'is_guest_mode';

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
      await prefs.setBool(_keyIsGuest, false);
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

  static Future<bool> enableGuestMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsGuest, true);
      await prefs.setBool(_keyIsLoggedIn, false);

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

  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  static Future<bool> isGuestMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsGuest) ?? false;
    } catch (e) {
      print('Error checking guest mode: $e');
      return false;
    }
  }


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


  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyToken);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }


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