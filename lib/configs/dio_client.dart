import 'package:dio/dio.dart';
import 'api_config.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: APIConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );


  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("---- REQUEST ----");
          print("URL: ${options.baseUrl}${options.path}");
          print("Method: ${options.method}");
          print("Headers: ${options.headers}");
          print("Content-Type: ${options.contentType}");
          print("Query Parameters: ${options.queryParameters}");
          print("Data: ${options.data}");
          print("-------------------");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("---- RESPONSE ----");
          print("Status Code: ${response.statusCode}");
          print("Status Message: ${response.statusMessage}");
          print("Headers: ${response.headers}");
          print("Content-Type: ${response.headers.value('content-type')}");
          print("Data: ${response.data}");
          print("--------------------");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print("---- ERROR ----");
          print("Type: ${e.type}");
          print("Message: ${e.message}");
          if (e.response != null) {
            print("Status Code: ${e.response?.statusCode}");
            print("Headers: ${e.response?.headers}");
            print("Data: ${e.response?.data}");
          }
          print("------------------");
          return handler.next(e);
        },
      ),
    );
  }



  Future<Response> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _dio.get(
      url,
      queryParameters: queryParameters,
      options: options,
    );
  }


  Future<Response> post(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }


  Future<Response> put(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _dio.put(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }


  Future<Response> patch(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _dio.patch(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }


  Future<Response> delete(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _dio.delete(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
