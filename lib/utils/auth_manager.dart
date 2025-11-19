import 'dart:convert';

import 'package:pippips/models/token_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserData = 'user_data';
  static const String _keyTokenData = 'token_data';
  static const String _keyIsGuest = 'is_guest_mode';
  static const String _keySessionId = 'session_id';
  static const String _keyDeviceId = 'device_id';

  static Future<bool> saveLoginData({
    required String userId,
    required String fullName,
    required String email,
    required TokenModel token,
    String? sessionId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userData = {
        'user_id': userId,
        'name': fullName,
        'identifier': email,
      };

      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setBool(_keyIsGuest, false);
      await prefs.setString(_keyUserData, jsonEncode(userData));
      await prefs.setString(_keyTokenData, jsonEncode(token.toJson()));

      if (sessionId != null) {
        await prefs.setString(_keySessionId, sessionId);
      }

      print(' Login data saved successfully');
      print('Token expires at: ${token.expiresAt}');

      return true;
    } catch (e) {
      print(' Error saving login data: $e');
      return false;
    }
  }

  static Future<TokenModel?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenString = prefs.getString(_keyTokenData);

      if (tokenString != null) {
        final tokenJson = jsonDecode(tokenString) as Map<String, dynamic>;
        return TokenModel.fromJson(tokenJson);
      }
      return null;
    } catch (e) {
      print(' Error getting token: $e');
      return null;
    }
  }

  static Future<bool> updateToken(TokenModel newToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyTokenData, jsonEncode(newToken.toJson()));

      print(' Token updated successfully');
      print('New token expires at: ${newToken.expiresAt}');

      return true;
    } catch (e) {
      print(' Error updating token: $e');
      return false;
    }
  }

  static Future<bool> isTokenValid() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final isValid = !token.isExpired;
      print(' Token validity check: $isValid');

      return isValid;
    } catch (e) {
      print(' Error checking token validity: $e');
      return false;
    }
  }

  static Future<bool> needsTokenRefresh() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final needsRefresh = token.needsRefresh;
      print(' Token needs refresh: $needsRefresh');

      return needsRefresh;
    } catch (e) {
      print(' Error checking token refresh need: $e');
      return false;
    }
  }

  static Future<String> getDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? deviceId = prefs.getString(_keyDeviceId);

      if (deviceId == null) {
        deviceId =
            'device_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
        await prefs.setString(_keyDeviceId, deviceId);
        print(' New device ID created: $deviceId');
      }

      return deviceId;
    } catch (e) {
      print(' Error getting device ID: $e');
      return 'unknown_device';
    }
  }

  static Future<String?> getSessionId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keySessionId);
    } catch (e) {
      print(' Error getting session ID: $e');
      return null;
    }
  }

  static Future<bool> updateSessionId(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keySessionId, sessionId);
      print(' Session ID updated: $sessionId');
      return true;
    } catch (e) {
      print(' Error updating session ID: $e');
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
        'name': 'Khách',
        'identifier'
            '': 'guest@local',
      };
      await prefs.setString(_keyUserData, jsonEncode(guestData));

      print(' Guest mode enabled');
      return true;
    } catch (e) {
      print(' Error enabling guest mode: $e');
      return false;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

      if (isLoggedIn) {
        final hasValidToken = await isTokenValid();
        return hasValidToken;
      }

      return false;
    } catch (e) {
      print(' Error checking login status: $e');
      return false;
    }
  }

  static Future<bool> isGuestMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsGuest) ?? false;
    } catch (e) {
      print(' Error checking guest mode: $e');
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
      print(' Error getting user data: $e');
      return null;
    }
  }

  static Future<String?> getUserId() async {
    try {
      final userData = await getUserData();
      return userData?['user_id'];
    } catch (e) {
      print(' Error getting user ID: $e');
      return null;
    }
  }

  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final deviceId = prefs.getString(_keyDeviceId);

      await prefs.remove(_keyIsLoggedIn);
      await prefs.remove(_keyUserData);
      await prefs.remove(_keyTokenData);
      await prefs.remove(_keyIsGuest);
      await prefs.remove(_keySessionId);

      if (deviceId != null) {
        await prefs.setString(_keyDeviceId, deviceId);
      }

      print(' Logout successful - All auth data cleared');
      return true;
    } catch (e) {
      print(' Error logging out: $e');
      return false;
    }
  }

  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print(' All data cleared');
      return true;
    } catch (e) {
      print(' Error clearing all data: $e');
      return false;
    }
  }
}
