import 'package:dio/dio.dart';
import 'package:pippips/configs/api_config.dart';
import 'package:pippips/configs/dio_client.dart';
import 'package:pippips/configs/api_error_handler.dart';

class GetChatMessage {
  final DioClient dio = DioClient();

    Future<String> getChatfromStep(int step) async {
    try {
      final response = await dio.get(
        APIConfig.getTextFromStep,
        queryParameters: {
          "step": step,
        },
      );

      if (response.statusCode == 200) {
        if (response.data != null && response.data["message"] != null) {
          return response.data["message"];
        } else {
          throw Exception("Không tìm thấy trường 'message' trong phản hồi.");
        }
      } else {
        throw Exception("API trả về mã lỗi: ${response.statusCode}");
      }
    } on DioException catch (e) {
      return ApiErrorHandler.handleError(e);
    } catch (e) {
      return "Lỗi không xác định: $e";
    }
  }
}
