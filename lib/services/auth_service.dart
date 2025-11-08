import 'package:dio/dio.dart';
import 'package:pippips/configs/api_config.dart';
import 'package:pippips/configs/dio_client.dart';
import 'package:pippips/configs/api_error_handler.dart';
import 'package:pippips/models/token_model.dart';
import 'package:pippips/utils/auth_manager.dart';

class AuthService {
  final DioClient dio = DioClient();


  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final deviceId = await AuthManager.getDeviceId();

      final response = await dio.post(
        APIConfig.login,
        data: {
          'email': email,
          'password': password,
          'device_id': deviceId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          TokenModel token;

          if (response.data['token'] != null) {
            token = TokenModel.fromJson(response.data['token']);
          } else {
            token = TokenModel.fromJson(response.data);
          }

          return {
            "success": true,
            "data": response.data,
            "token": token,
            "message": "Đăng nhập thành công"
          };
        } else {
          return {
            "success": false,
            "message": "Không nhận được dữ liệu từ server"
          };
        }
      } else {
        return {
          "success": false,
          "message": "Đăng nhập thất bại. Vui lòng thử lại."
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


  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        APIConfig.register,
        data: {
          'full_name': fullName,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          return {
            "success": true,
            "data": response.data,
            "message": "Đăng ký thành công"
          };
        } else {
          return {
            "success": false,
            "message": "Không nhận được dữ liệu từ server"
          };
        }
      } else {
        return {
          "success": false,
          "message": "Đăng ký thất bại. Vui lòng thử lại."
        };
      }
    } on DioException catch (e) {
      final mess = e.response?.data is Map && e.response?.data["message"] != null
          ? e.response?.data["message"]
          : ApiErrorHandler.handleError(e);
      return {
        "success": false,
        "message": mess
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Lỗi không xác định: $e"
      };
    }
  }


  Future<Map<String, dynamic>> refreshToken() async {
    try {
      print(' Attempting to refresh token...');

      final currentToken = await AuthManager.getToken();
      if (currentToken == null) {
        return {
          "success": false,
          "message": "Không tìm thấy token hiện tại"
        };
      }

      final deviceId = await AuthManager.getDeviceId();
      final userId = await AuthManager.getUserId();

      final response = await dio.post(
        APIConfig.refreshToken,
        data: {
          'refresh_token': currentToken.refreshToken,
          'device_id': deviceId,
          'user_id': userId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${currentToken.accessToken}',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          TokenModel newToken = TokenModel.fromJson(response.data);

          await AuthManager.updateToken(newToken);

          print(' Token refreshed successfully');
          print('New token expires at: ${newToken.expiresAt}');

          return {
            "success": true,
            "token": newToken,
            "message": "Token đã được làm mới"
          };
        } else {
          return {
            "success": false,
            "message": "Không nhận được token mới từ server"
          };
        }
      } else {
        return {
          "success": false,
          "message": "Làm mới token thất bại"
        };
      }
    } on DioException catch (e) {
      print(' Token refresh failed: ${e.message}');

      // If refresh fails with 401, logout user
      if (e.response?.statusCode == 401) {
        return {
          "success": false,
          "should_logout": true,
          "message": "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại."
        };
      }

      return {
        "success": false,
        "message": ApiErrorHandler.handleError(e)
      };
    } catch (e) {
      print(' Token refresh error: $e');
      return {
        "success": false,
        "message": "Lỗi không xác định: $e"
      };
    }
  }


  Future<Map<String, dynamic>> logout() async {
    try {
      print(' Logging out...');

      final token = await AuthManager.getToken();
      final deviceId = await AuthManager.getDeviceId();
      final userId = await AuthManager.getUserId();

      if (token != null) {
        final response = await dio.post(
          APIConfig.logout,
          data: {
            'device_id': deviceId,
            'user_id': userId,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer ${token.accessToken}',
            },
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          print(' Server logout successful');
        } else {
          print(' Server logout returned status: ${response.statusCode}');
        }
      }

      await AuthManager.logout();

      return {
        "success": true,
        "message": "Đăng xuất thành công"
      };
    } on DioException catch (e) {
      print('⚠️ Logout API failed, clearing local data anyway');

      await AuthManager.logout();

      return {
        "success": true,
        "message": "Đăng xuất thành công",
        "api_error": ApiErrorHandler.handleError(e)
      };
    } catch (e) {
      print(' Logout error: $e');

      // Try to clear local data
      await AuthManager.logout();

      return {
        "success": true,
        "message": "Đăng xuất thành công",
        "error": e.toString()
      };
    }
  }


  Future<Map<String, dynamic>> verifySession() async {
    try {
      final token = await AuthManager.getToken();
      final deviceId = await AuthManager.getDeviceId();
      final userId = await AuthManager.getUserId();
      final sessionId = await AuthManager.getSessionId();

      if (token == null || userId == null) {
        return {
          "success": false,
          "is_valid": false,
          "message": "Không tìm thấy thông tin phiên"
        };
      }

      final response = await dio.post(
        APIConfig.verifySession,
        data: {
          'user_id': userId,
          'session_id': sessionId,
          'device_id': deviceId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${token.accessToken}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final isValid = response.data['is_valid'] ?? false;

        print(isValid
            ? ' Session is valid'
            : ' Session is invalid');

        return {
          "success": true,
          "is_valid": isValid,
          "message": response.data['message'] ?? "Session verified"
        };
      } else {
        return {
          "success": false,
          "is_valid": false,
          "message": "Không thể xác minh phiên"
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


  Future<Map<String, dynamic>> updateSession() async {
    try {
      final token = await AuthManager.getToken();
      final deviceId = await AuthManager.getDeviceId();
      final userId = await AuthManager.getUserId();
      final sessionId = await AuthManager.getSessionId();

      if (token == null || userId == null) {
        return {
          "success": false,
          "message": "Không tìm thấy thông tin phiên"
        };
      }

      final response = await dio.post(
        APIConfig.updateSession,
        data: {
          'user_id': userId,
          'session_id': sessionId,
          'device_id': deviceId,
          'timestamp': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${token.accessToken}',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(' Session updated');

        return {
          "success": true,
          "message": "Session updated successfully"
        };
      } else {
        return {
          "success": false,
          "message": "Không thể cập nhật phiên"
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