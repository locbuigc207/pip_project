import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Kết nối tới server quá lâu. Vui lòng thử lại.";
      case DioExceptionType.sendTimeout:
        return "Gửi dữ liệu quá lâu. Vui lòng thử lại.";
      case DioExceptionType.receiveTimeout:
        return "Nhận phản hồi quá lâu. Vui lòng thử lại.";
      case DioExceptionType.badCertificate:
        return "Chứng chỉ bảo mật không hợp lệ.";
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return "Yêu cầu đã bị hủy.";
      case DioExceptionType.connectionError:
        return "Không thể kết nối internet.";
      case DioExceptionType.unknown:
      default:
        return "Lỗi không xác định: ${error.message}";
    }
  }

  static String _handleBadResponse(Response? response) {
    if (response == null) return "Không có phản hồi từ server.";
    switch (response.statusCode) {
      case 400:
        return "Yêu cầu không hợp lệ.";
      case 401:
        return "Bạn cần đăng nhập lại.";
      case 403:
        return "Bạn không có quyền truy cập.";
      case 404:
        return "Không tìm thấy dữ liệu.";
      case 500:
        return "Lỗi server. Vui lòng thử lại sau.";
      default:
        return "Lỗi ${response.statusCode}: ${response.statusMessage}";
    }
  }
}
