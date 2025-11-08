import 'package:dio/dio.dart';
import 'api_config.dart';
import 'package:pippips/utils/auth_manager.dart';
import 'package:pippips/services/auth_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio _dio;
  bool _isRefreshing = false;
  List<Function> _pendingRequests = [];

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: APIConfig.baseUrl,
        connectTimeout: APIConfig.connectTimeout,
        receiveTimeout: APIConfig.receiveTimeout,
        sendTimeout: APIConfig.sendTimeout,
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }


  Future<void> _onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    print("---- REQUEST ----");
    print("URL: ${options.baseUrl}${options.path}");
    print("Method: ${options.method}");

    final isAuthEndpoint = options.path == APIConfig.login ||
        options.path == APIConfig.register ||
        options.path == APIConfig.refreshToken;

    if (!isAuthEndpoint) {
      final needsRefresh = await AuthManager.needsTokenRefresh();

      if (needsRefresh) {
        print(' Token needs refresh, refreshing before request...');
        final refreshResult = await _refreshToken();

        if (!refreshResult) {
          print(' Token refresh failed, rejecting request');
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Token refresh failed',
              type: DioExceptionType.cancel,
            ),
          );
        }
      }

      final token = await AuthManager.getToken();
      if (token != null && !token.isExpired) {
        options.headers['Authorization'] = 'Bearer ${token.accessToken}';
        print(" Token added to request");
      } else {
        print(" No valid token available");
      }
    }

    print("Headers: ${options.headers}");
    print("Data: ${options.data}");
    print("-------------------");

    return handler.next(options);
  }


  Future<void> _onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) async {
    print("---- RESPONSE ----");
    print("Status Code: ${response.statusCode}");
    print("Data: ${response.data}");
    print("--------------------");

    return handler.next(response);
  }


  Future<void> _onError(
      DioException error,
      ErrorInterceptorHandler handler,
      ) async {
    print("---- ERROR ----");
    print("Type: ${error.type}");
    print("Message: ${error.message}");
    print("Status Code: ${error.response?.statusCode}");
    print("------------------");

    if (error.response?.statusCode == 401) {
      print(' 401 Unauthorized - Attempting token refresh...');

      if (_isRefreshing) {
        print(' Already refreshing, queueing request...');
        return _queueRequest(error, handler);
      }

      _isRefreshing = true;
      final refreshSuccess = await _refreshToken();
      _isRefreshing = false;

      if (refreshSuccess) {
        print(' Token refreshed, retrying original request...');

        final retryResponse = await _retryRequest(error.requestOptions);

        _processPendingRequests();

        return handler.resolve(retryResponse);
      } else {
        print(' Token refresh failed - Logging out user');

        await _handleSessionExpired();

        _rejectPendingRequests(error);

        return handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: 'Session expired. Please login again.',
            type: DioExceptionType.badResponse,
            response: error.response,
          ),
        );
      }
    }

    return handler.next(error);
  }


  Future<bool> _refreshToken() async {
    try {
      print(' Refreshing token...');

      final authService = AuthService();
      final result = await authService.refreshToken();

      if (result['success'] == true) {
        print(' Token refresh successful');
        return true;
      } else {
        print(' Token refresh failed: ${result['message']}');

        if (result['should_logout'] == true) {
          await _handleSessionExpired();
        }

        return false;
      }
    } catch (e) {
      print(' Token refresh exception: $e');
      return false;
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final token = await AuthManager.getToken();

    if (token != null) {
      requestOptions.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    return await _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }

  void _queueRequest(
      DioException error,
      ErrorInterceptorHandler handler,
      ) {
    _pendingRequests.add(() async {
      try {
        final response = await _retryRequest(error.requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: e,
          ),
        );
      }
    });
  }

  void _processPendingRequests() {
    print(' Processing ${_pendingRequests.length} pending requests...');

    for (var request in _pendingRequests) {
      request();
    }

    _pendingRequests.clear();
    print(' All pending requests processed');
  }

  void _rejectPendingRequests(DioException error) {
    print(' Rejecting ${_pendingRequests.length} pending requests');
    _pendingRequests.clear();
  }

  Future<void> _handleSessionExpired() async {
    print(' Session expired - Logging out...');

    await AuthManager.logout();


    print(' App should navigate to login page');
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
        dynamic data,
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
        dynamic data,
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
        dynamic data,
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
        dynamic data,
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