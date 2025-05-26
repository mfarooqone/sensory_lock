// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensory_app/screens/network_client/api_response.dart';

typedef GetUserAuthTokenCallback = Future<String?> Function();

class NetworkClient {
  static const contentTypeJson = 'application/json';
  static const contentTypeMultipart = 'multipart/form-data';

  final Dio _restClient;
  final Dio _fileClient;

  ///
  ///
  ///
  NetworkClient() : _restClient = _createDio(), _fileClient = _createDio();

  ///
  ///
  ///
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool? sendUserAuth,
  }) async {
    try {
      final resp = await _restClient.get(
        path,
        queryParameters: queryParameters,
        options: await _createDioOptions(
          contentType: contentTypeJson,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  Future<ApiResponse<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    bool? sendUserAuth,
  }) async {
    try {
      final resp = await _restClient.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: await _createDioOptions(
          contentType: contentTypeJson,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  Future<ApiResponse<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    bool? sendUserAuth,
  }) async {
    try {
      final resp = await _restClient.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: await _createDioOptions(
          contentType: contentTypeJson,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  Future<ApiResponse<T>> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    bool? sendUserAuth,
  }) async {
    try {
      final resp = await _restClient.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: await _createDioOptions(
          contentType: contentTypeJson,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  Future<ApiResponse<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    bool? sendUserAuth,
  }) async {
    try {
      final resp = await _restClient.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: await _createDioOptions(
          contentType: contentTypeJson,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  Future<ApiResponse<T>> upload<T>(
    String path, {
    required XFile file,
    required String uploadType,
    bool? sendUserAuth,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      String mimeType = file.mimeType ?? 'image/jpeg';
      print('Uploading file: $fileName with type: $mimeType');
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
        "upload_type": uploadType,
      });
      final resp = await _fileClient.post(
        path,
        data: formData,
        options: await _createDioOptions(
          contentType: contentTypeMultipart,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      print('Upload error: ${e.message}');
      print('Response data: ${e.response?.data}');
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  Future<ApiResponse<T>> uploadWebImage<T>(
    String path, {
    required XFile file,
    bool? sendUserAuth,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final fileName = file.name;
      final mimeType = file.mimeType ?? 'image/jpeg';

      print('Uploading file: $fileName with type: $mimeType');

      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(
          bytes,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
        "upload_type": 'book',
      });

      final resp = await _fileClient.post(
        path,
        data: formData,
        options: await _createDioOptions(
          contentType: contentTypeMultipart,
          sendUserAuth: sendUserAuth,
        ),
      );

      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: resp.data,
      );
    } on DioException catch (e) {
      print('Upload error: ${e.message}');
      print('Response data: ${e.response?.data}');
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///

  ///
  ///
  ///
  ApiResponse<T> _createResponse<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiResponse<T>.error(
          statusCode: 501,
          message: 'Connection timed out',
        );
      case DioExceptionType.connectionError:
        return ApiResponse<T>.error(
          statusCode: 502,
          message: 'Connection Error',
        );
      case DioExceptionType.unknown:
        return ApiResponse<T>.error(
          statusCode: 503,
          message:
              'Something went wrong, check your internet connection and try again later',
        );
      case DioExceptionType.receiveTimeout:
        return ApiResponse<T>.error(
          statusCode: 502,
          message: 'Receive timed out',
        );
      case DioExceptionType.sendTimeout:
        return ApiResponse<T>.error(
          statusCode: 500,
          message: 'Failed to connect to server',
        );
      case DioExceptionType.badResponse:
        final jsonResp = error.response?.data;
        final errorStr =
            jsonResp is Map<String, dynamic> && jsonResp.containsKey('error')
            ? jsonResp['error'] as String
            : 'Unknown error';
        final message =
            jsonResp is Map<String, dynamic> && jsonResp.containsKey('message')
            ? jsonResp['message'] as String
            : 'Unknown error message';
        if (error.response?.statusCode == 402) {
          return ApiResponse<T>.error(
            statusCode: 402,
            error: errorStr,
            message: message.isNotEmpty ? message : 'Payment Required',
          );
        }
        if (error.response?.statusCode == 409) {
          return ApiResponse<T>.error(
            statusCode: 409,
            error: errorStr,
            message: message.isNotEmpty ? message : 'Conflict',
          );
        }
        return ApiResponse<T>.error(
          statusCode: error.response?.statusCode,
          error: errorStr,
          message: message,
        );
      case DioExceptionType.cancel:
        return ApiResponse<T>.error(
          statusCode: 500,
          message: 'Request canceled',
        );
      case DioExceptionType.badCertificate:
        return ApiResponse<T>.error(
          statusCode: 500,
          message: 'Bad Certificate',
        );
    }
  }

  ///
  ///
  ///
  Future<Options> _createDioOptions({
    required String contentType,
    bool? sendUserAuth,
  }) async {
    final headers = <String, String>{};

    final options = Options(headers: headers, contentType: contentType);
    return options;
  }

  ///
  ///
  ///
  static Dio _createDio() {
    final options = BaseOptions(
      baseUrl: "https://neonwills.com/book_summary_php/",
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
    );
    final dio = Dio(options);
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        responseBody: true,
        requestBody: true,
        logPrint: (message) {
          log(message.toString());
        },
      ),
    );
    return dio;
  }
}
