import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dealsdray_app/utils/constants.dart';

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;

  ApiResponse({
    this.data,
    this.error,
    this.success = false,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(data: data, success: true);
  }

  factory ApiResponse.error(String error) {
    return ApiResponse(error: error, success: false);
  }
}

class ApiService {
  final http.Client _client = http.Client();

  Future<ApiResponse<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _client
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
          )
          .timeout(const Duration(seconds: 15));

      return _processResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error(ErrorMessages.noInternet);
    } on TimeoutException {
      return ApiResponse.error(ErrorMessages.timeoutError);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<T>> post<T>(
    String url, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            body: json.encode(body),
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
          )
          .timeout(const Duration(seconds: 15));

      return _processResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error(ErrorMessages.noInternet);
    } on TimeoutException {
      return ApiResponse.error(ErrorMessages.timeoutError);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  ApiResponse<T> _processResponse<T>(
    http.Response response,
    T Function(dynamic) fromJson,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == true || jsonData['success'] == true) {
        return ApiResponse.success(fromJson(jsonData));
      } else {
        final message = jsonData['message'] ?? ErrorMessages.unknownError;
        return ApiResponse.error(message.toString());
      }
    } else {
      try {
        final jsonData = json.decode(response.body);
        final message = jsonData['message'] ?? ErrorMessages.serverError;
        return ApiResponse.error(message.toString());
      } catch (e) {
        return ApiResponse.error(ErrorMessages.serverError);
      }
    }
  }

  void dispose() {
    _client.close();
  }
}