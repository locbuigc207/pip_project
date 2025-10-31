import 'package:dio/dio.dart';
import 'package:pippips/configs/api_config.dart';
import 'package:pippips/configs/dio_client.dart';
import 'package:pippips/models/send_messsage.dart';
import '../configs/api_error_handler.dart';

class SendMessageService {
  final DioClient dio = DioClient();

  Future<Map<String, dynamic>> sendMessage(SendMessageModel pack) async {
    final body = pack.toJson();

    try {
      final response = await dio.post(
        APIConfig.sendMessage,
        data: body,
      );

      if (response.statusCode == 201) {
        if (response.data != null && response.data["groupid"] != null) {
          return {
            "success": true,
            "groupid": response.data["groupid"],
          };
        } else {
          return {
            "success": false,
            "message": "Không tìm thấy trường 'groupid' trong phản hồi."
          };
        }
      } else {
        return {
          "success": false,
          "message": "API trả về mã lỗi: ${response.statusCode}"
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
