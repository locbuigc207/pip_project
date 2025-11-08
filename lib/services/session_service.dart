import 'package:dio/dio.dart';
import 'package:pippips/configs/api_config.dart';
import 'package:pippips/configs/dio_client.dart';
import 'package:pippips/configs/api_error_handler.dart';

/// SessionService - Service xử lý API cho session management
///
/// LƯU Ý: Backend cần implement các endpoint sau:
/// - POST /auth/verify-session: Kiểm tra session có hợp lệ
/// - POST /auth/update-session: Cập nhật session mới khi đăng nhập
class SessionService {
  final DioClient dio = DioClient();

  /// Verify session với server
  ///
  /// Kiểm tra xem session hiện tại của user có còn hợp lệ không
  /// Nếu user đăng nhập ở thiết bị khác, session cũ sẽ invalid
  ///
  /// Parameters:
  /// - userId: ID của user
  /// - sessionId: ID của session cần verify
  /// - deviceId: ID của thiết bị
  ///
  /// Returns: Map với keys:
  /// - success: bool - API call thành công hay không
  /// - is_valid: bool - Session có hợp lệ hay không
  /// - message: String - Thông báo kết quả
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

  /// Update session khi đăng nhập
  ///
  /// Cập nhật session mới lên server khi user đăng nhập
  /// Session cũ (nếu có) sẽ bị vô hiệu hóa
  ///
  /// Parameters:
  /// - userId: ID của user
  /// - sessionId: ID của session mới
  /// - deviceId: ID của thiết bị
  ///
  /// Returns: Map với keys:
  /// - success: bool - API call thành công hay không
  /// - message: String - Thông báo kết quả
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

  /// Force logout - Đăng xuất khỏi tất cả thiết bị
  ///
  /// Optional: Backend có thể implement endpoint này để force logout
  /// tất cả session của 1 user
  Future<Map<String, dynamic>> forceLogoutAllDevices({
    required String userId,
  }) async {
    try {
      final response = await dio.post(
        '/auth/force-logout', // Endpoint tùy chọn - cần thêm vào APIConfig nếu backend implement
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