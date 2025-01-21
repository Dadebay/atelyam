// lib/app/data/services/category_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BusinessCategoryService {
  final AuthController authController = Get.find();

  Future<List<BusinessCategoryModel>?> fetchCategories() async {
    try {
      final uri = Uri.parse('${authController.ipAddress}/mobile/cats/');
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8', //Setting header explicitly
        },
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes); // Force UTF-8 decoding
        final List<dynamic> responseData = json.decode(responseBody);
        final List<BusinessCategoryModel> categories = responseData.map((json) => BusinessCategoryModel.fromJson(json)).toList();
        return categories;
      } else {
        _handleApiError(response.statusCode, response.body);

        return null;
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
        errorMessage = 'Bad Request: $message';
        break;
      case 401:
        errorMessage = 'Unauthorized: $message';
        break;
      case 404:
        errorMessage = 'Not Found: $message';
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
