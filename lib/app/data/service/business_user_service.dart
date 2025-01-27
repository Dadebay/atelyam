// lib/app/data/services/business_user_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BusinessUserService {
  final AuthController authController = Get.find();
  final Auth _auth = Auth();

  Future<List<BusinessUserModel>> getBusinessAccountsByCategory({required int categoryID}) async {
    final url = Uri.parse('${authController.ipAddress}/mobile/cats_id/$categoryID/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic decodedResponse;
        try {
          final responseBody = utf8.decode(response.bodyBytes);
          decodedResponse = json.decode(responseBody);
        } catch (e) {
          _handleApiError(500); // Json decode error will be a server side error
          return [];
        }

        if (decodedResponse is List) {
          final List<BusinessUserModel> responseData = decodedResponse.map((json) => BusinessUserModel.fromJson(json as Map<String, dynamic>)).toList();
          return responseData;
        } else if (decodedResponse is Map) {
          final BusinessUserModel responseData = BusinessUserModel.fromJson(decodedResponse as Map<String, dynamic>);
          return [responseData];
        } else {
          _handleApiError(500); //Unexpected data type
          return [];
        }
      } else {
        _handleApiError(response.statusCode);
        return [];
      }
    } on SocketException {
      showSnackBar('networkError'.tr, 'noInternet'.tr, Colors.red);
      return [];
    } catch (e) {
      showSnackBar('unknownError'.tr, 'anErrorOccurred'.tr, Colors.red);
      return [];
    }
  }

  Future<BusinessUserModel?> fetchBusinessAccountByID(int id) async {
    final url = Uri.parse('${authController.ipAddress}/mobile/GetUserId/$id/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return BusinessUserModel.fromJson(json.decode(response.body));
      } else {
        _handleApiError(response.statusCode);
        return null;
      }
    } on SocketException {
      showSnackBar('networkError'.tr, 'noInternet'.tr, Colors.red);
      return null;
    } catch (e) {
      showSnackBar('unknownError'.tr, 'anErrorOccurred'.tr, Colors.red);
      return null;
    }
  }

  Future<List<BusinessUserModel>?> fetchPopularBusinessAccounts() async {
    try {
      final uri = Uri.parse('${authController.ipAddress}/mobile/getPopular/');
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> responseData = json.decode(responseBody);
        final List<BusinessUserModel> categories = responseData.map((json) => BusinessUserModel.fromJson(json)).toList();
        return categories;
      } else {
        _handleApiError(response.statusCode);
        return null;
      }
    } on SocketException {
      showSnackBar('networkError'.tr, 'noInternet'.tr, Colors.red);
      return null;
    } catch (e) {
      showSnackBar('unknownError'.tr, 'anErrorOccurred'.tr, Colors.red);
      return null;
    }
  }

  Future<List<BusinessUserModel>?> getMyBusinessAccounts() async {
    final token = await _auth.getToken();
    try {
      final uri = Uri.parse('${authController.ipAddress}/mobile/getMyStatus/');
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> responseData = json.decode(responseBody);
        final List<BusinessUserModel> categories = responseData.map((json) => BusinessUserModel.fromJson(json)).toList();
        return categories;
      } else {
        _handleApiError(response.statusCode);
        return null;
      }
    } on SocketException {
      showSnackBar('networkError'.tr, 'noInternet'.tr, Colors.red);
      return null;
    } catch (e) {
      showSnackBar('unknownError'.tr, 'anErrorOccurred'.tr, Colors.red);
      return null;
    }
  }

  void _handleApiError(int statusCode) {
    showSnackBar('apiError'.tr, 'anErrorOccurred'.tr, Colors.red);
  }
}
