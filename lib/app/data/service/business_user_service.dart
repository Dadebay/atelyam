import 'dart:convert';
import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BusinessUserService {
  final AuthController authController = Get.find();

  Future<List<BusinessUserModel>> fetchUsers(int id) async {
    final url = Uri.parse('${authController.ipAddress}/mobile/cats_id/$id/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic decodedResponse;
        try {
          final responseBody = utf8.decode(response.bodyBytes); // Force UTF-8 decoding
          decodedResponse = json.decode(responseBody);
        } catch (e) {
          throw Exception('Json decode error');
        }

        if (decodedResponse is List) {
          final List<BusinessUserModel> responseData = decodedResponse.map((json) => BusinessUserModel.fromJson(json as Map<String, dynamic>)).toList();
          return responseData;
        } else if (decodedResponse is Map) {
          final BusinessUserModel responseData = BusinessUserModel.fromJson(decodedResponse as Map<String, dynamic>);
          return [responseData]; // Eğer tek bir nesne dönüyorsa listeye çevir
        } else {
          throw Exception('Unexpected data type received in response.');
        }
      } else {
        throw Exception('Failed to fetch categories. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<List<BusinessUserModel>?> fetchPopularUsers() async {
    try {
      final uri = Uri.parse('${authController.ipAddress}/mobile/getPopular/');
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8', //Setting header explicitly
        },
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes); // Force UTF-8 decoding
        final List<dynamic> responseData = json.decode(responseBody);
        final List<BusinessUserModel> categories = responseData.map((json) => BusinessUserModel.fromJson(json)).toList();
        return categories;
      } else {
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
}
