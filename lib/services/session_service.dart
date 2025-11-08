import 'package:dio/dio.dart';
import 'package:pippips/configs/api_config.dart';
import 'package:pippips/configs/dio_client.dart';
import 'package:pippips/configs/api_error_handler.dart';

class SessionService {
  final DioClient dio = DioClient();

  Future<Map<String, dynamic>> verifySession({
    required String userId,
    required String sessionId,
    required String deviceId,
  }) async {
    try {
      final response = await dio.post(
        APIConfig.verifySession,
        data: {
          'user_id': userId,
          'session_id': sessionId,
          'device_id': deviceId,
        },
      );

      if (response.statusCode == 200) {
        return {
          "success": true,
          "is_valid": response.data['is_valid'] ?? false,
          "message": response.data['message'] ?? "Session verified"
        };
      } else {
        return {
          "success": false,
          "is_valid": false,
          "message": "Không thể xác minh session"
        };
      }
    } on DioException catch (e) {
      return {
        "success": false,
        "is_valid": false,
        "message": ApiErrorHandler.handleError(e)
      };
    } catch (e) {
      return {
        "success": false,
        "is_valid": false,
        "message": "Lỗi không xác định: $e"
      };
    }
  }

  Future<Map<String, dynamic>> updateSession({
    required String userId,
    required String sessionId,
    required String deviceId,
  }) async {
    try {
      final response = await dio.post(
        APIConfig.updateSession,
        data: {
          'user_id': userId,
          'session_id': sessionId,
          'device_id': deviceId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": "Session updated successfully"
        };
      } else {
        return {
          "success": false,
          "message": "Không thể cập nhật session"
        };
      }
    } on DioException catch (e) {
      return {
        "success": false,
        "message": ApiErrorHandler.handleError(e)
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Lỗi không xác định: $e"
      };
    }
  }


  Future<Map<String, dynamic>> forceLogoutAllDevices({
    required String userId,
  }) async {
    try {
      final response = await dio.post(
        '/auth/force-logout',
        data: {
          'user_id': userId,
        },
      );

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "Đã đăng xuất khỏi tất cả thiết bị"
        };
      } else {
        return {
          "success": false,
          "message": "Không thể đăng xuất"
        };
      }
    } on DioException catch (e) {
      return {
        "success": false,
        "message": ApiErrorHandler.handleError(e)
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Lỗi không xác định: $e"
      };
    }
  }
}