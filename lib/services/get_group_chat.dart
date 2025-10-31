
import 'package:dio/dio.dart';
import 'package:pippips/configs/api_config.dart';
import 'package:pippips/configs/dio_client.dart';
import 'package:pippips/configs/api_error_handler.dart';
import 'package:pippips/models/group_message.dart';

class GetGroupChat{
  final DioClient dio = DioClient();

  Future<dynamic> getGroupChat(String convId) async {
    try {
      final response = await dio.get(
        APIConfig.getGroupName + convId + "/intro",
      );

      if (response.statusCode == 200) {
        if (response.data != null) {
          return response.data;
        } else {
          throw Exception("Không tìm thấy data trong phản hồi.");
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

  Future<dynamic> getgroupDetail(String id) async{
    try {
      final response = await dio.get(
        APIConfig.getGroupDetail + id,
      );

      if (response.statusCode == 200) {
        if (response.data != null) {
          return response.data;
        } else {
          throw Exception("Không tìm thấy data trong phản hồi.");
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