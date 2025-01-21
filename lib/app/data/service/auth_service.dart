// ignore_for_file: file_names, require_trailing_commas, avoid_void_async, avoid_bool_literals_in_conditional_expressions, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Auth {
  final storage = GetStorage();

  void login(String? data) async {
    await storage.write('data', data);
  }

  Future<bool> logout() async {
    await storage.remove('AccessToken');
    await storage.remove('RefreshToken');
    return storage.read('AccessToken') == null ? true : false;
  }

  /////////////////////////////////////////User Token///////////////////////////////////
  Future<bool> setToken(String token) async {
    await storage.write('AccessToken', token);
    return storage.read('AccessToken') == null ? false : true;
  }

  Future<String?> getToken() async {
    return storage.read('AccessToken');
  }

  Future<bool> removeToken() async {
    await storage.remove('AccessToken');
    return storage.read('AccessToken') == null ? true : false;
  }

/////////////////////////////////////////User Refresh Token///////////////////////////////////

  Future<bool> setRefreshToken(String token) async {
    await storage.write('RefreshToken', token);
    return storage.read('AccessToken') == null ? false : true;
  }

  Future<String?> getRefreshToken() async {
    return storage.read('RefreshToken');
  }

  Future<bool> removeRefreshToken() async {
    await storage.remove('RefreshToken');
    return storage.read('RefreshToken') == null ? true : false;
  }
}

class SignInService {
  final AuthController authController = Get.find();

  final Auth _auth = Auth();

  Future<int?> otpCheck({required String phoneNumber, String? otp}) async {
    return _handleApiRequest(
      '/mobile/auth/',
      body: <String, dynamic>{
        'phone': phoneNumber,
        'otp': otp,
      },
      method: 'POST',
      requiresToken: true,
      isForm: true,
      handleSuccess: (responseJson) async {
        _auth.login(responseJson['data']);
        await _auth.setToken(responseJson['access_token']);
        await _auth.setRefreshToken(responseJson['refresh']);
        return responseJson;
      },
    );
  }

  Future<int?> register({required String phoneNumber, required String name}) async {
    final result = await _handleApiRequest(
      '/mobile/signup/',
      body: <String, dynamic>{
        'phone': phoneNumber,
        'user_name': name,
      },
      method: 'POST',
      requiresToken: false,
      handleSuccess: (responseJson) async {
        return responseJson;
      },
      isForm: true,
    );

    return result;
  }

  Future<int?> login({required String phone}) async {
    return _handleApiRequest(
      '/mobile/login/',
      body: <String, dynamic>{
        'phone': phone,
      },
      method: 'POST',
      requiresToken: false,
      handleSuccess: (responseJson) async {
        return responseJson;
      },
      isForm: true,
    );
  }

  Future<int?> _handleApiRequest(
    String endpoint, {
    required Map<String, dynamic> body,
    required String method,
    required bool requiresToken,
    bool isForm = false,
    Future<dynamic> Function(dynamic)? handleSuccess,
  }) async {
    try {
      final token = await _auth.getToken();
      final uri = Uri.parse('${authController.ipAddress}$endpoint');
      late http.BaseRequest request;
      if (isForm) {
        request = http.MultipartRequest(method, uri);
        (request as http.MultipartRequest).fields.addAll(body.cast<String, String>());
      } else {
        request = http.Request(method, uri);
        if (body.isNotEmpty) {
          (request as http.Request).body = jsonEncode(body);
        }
      }

      request.headers.addAll(<String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        if (requiresToken && token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = json.decode(responseBody);
      if (response.statusCode == 200) {
        if (handleSuccess != null) {
          await handleSuccess(responseJson);
        }
        return response.statusCode;
      } else {
        _handleApiError(response.statusCode, responseJson['message']?.toString() ?? 'API Error Occurred');
        return response.statusCode;
      }
    } on SocketException {
      showSnackBar('Network Error', 'No internet connection', Colors.red);
      return null;
    } catch (e) {
      showSnackBar('Unknown Error', 'An error occurred', Colors.red);
      return null;
    }
  }

  void _handleApiError(int statusCode, String message) {
    String errorMessage = 'An error occurred';
    switch (statusCode) {
      case 400:
        errorMessage = 'Nomer Yalnys';
        break;
      case 401:
        errorMessage = 'Unauthorized: $message';
        break;
      case 404:
        errorMessage = 'Not Found: $message';
        break;
      case 405:
        errorMessage = 'Ulanyjy yok register etmedik';
        break;
      case 409:
        errorMessage = 'Ulanyjy bar login bol';
        break;
      case 500:
        errorMessage = 'Server Error: $message';
        break;
      default:
        errorMessage = 'Error Status $statusCode: $message';
    }
    showSnackBar('API Error', errorMessage, Colors.red);
  }
}
