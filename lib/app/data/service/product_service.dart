// lib/app/data/services/product_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../modules/auth_view/controllers/auth_controller.dart';

class ProductService {
  final AuthController authController = Get.find();
  final http.Client _client = http.Client();
  final Auth _auth = Auth();

  Future<List<ProductModel>?> fetchProducts(int categoryId, int userId) async {
    try {
      final response = await _client.get(
        Uri.parse('${authController.ipAddress}/mobile/products/$categoryId/$userId/'),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(responseBody);
        final List<ProductModel> products = data.map((json) => ProductModel.fromJson(json)).toList();
        return products;
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

  Future<List<ProductModel>?> getMyProducts() async {
    try {
      final token = await _auth.getToken();
      final uri = Uri.parse('${authController.ipAddress}/mobile/GetMyProducts/');
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(responseBody);
        final List<ProductModel> products = data.map((json) => ProductModel.fromJson(json)).toList();
        return products;
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

  Future<List<ProductModel>?> fetchPopularProducts({int page = 1, int size = 10}) async {
    try {
      final response = await _client.get(Uri.parse('${authController.ipAddress}/mobile/getProductsPopular/?page=$page&size=$size'));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(responseBody);
        final List<dynamic> results = data['results'];
        return results.map((json) => ProductModel.fromJson(json)).toList();
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
