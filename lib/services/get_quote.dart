
import 'package:dio/dio.dart';
import 'package:pippips/configs/api_config.dart';
import 'package:pippips/configs/dio_client.dart';
import 'package:pippips/configs/api_error_handler.dart';
import 'package:pippips/models/group_message.dart';
import 'package:pippips/models/request_quote_model.dart';

import '../models/quote_model.dart';

class GetQuote{
  final DioClient dio = DioClient();

  Future<Map<String, dynamic>> getQuote(RequestQuoteModel request) async {
    request.member = "1";
    final body = request.toJson();
    print("BODY:" + body.toString());
    try {
      final response = await dio.post(
        APIConfig.requestPayload,
        data: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          final quote = response.data;
          QuoteModel quotemodel = QuoteModel.fromJson(quote);
          return {
            "success": true,
            "link": quotemodel.data?.link?.toString(),
            "code": quotemodel.data?.code?.toString(),
          };
        } else {
          return {
            "success": false,
            "error": "Không tìm thấy data trong phản hồi."
          };
        }
      } else {
        return {
          "success": false,
          "error": "API trả về mã lỗi: ${response.statusCode}"
        };
      }
    } on DioException catch (e) {
      return {
        "success": false,
        "error": ApiErrorHandler.handleError(e).toString()
      };
    } catch (e) {
      return {
        "success": false,
        "error": "Lỗi không xác định: $e"
      };
    }
  }


  Future<String?> getQuoteById(String quoteId) async{
    try {
      final response = await dio.get(
        APIConfig.getQuote,
        queryParameters: {
          "code": quoteId
        },
      );

      if (response.statusCode == 200) {
        if (response.data != null && response.data["message"] != null) {
          final x = response.data["data"];
          QuoteData quote = QuoteData.fromJson(x.last);
          return quote.link;
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