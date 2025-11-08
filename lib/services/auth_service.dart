import 'package:dio/dio.dart';
import 'package:pippips/configs/api_config.dart';
import 'package:pippips/configs/dio_client.dart';
import 'package:pippips/configs/api_error_handler.dart';

class AuthService {
  final DioClient dio = DioClient();

  /// Login với email và password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        APIConfig.login, // Thêm endpoint login vào APIConfig
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          return {
            "success": true,
            "data": response.data,
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

  /// Đăng ký tài khoản mới
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        APIConfig.register, // Thêm endpoint register vào APIConfig
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
}