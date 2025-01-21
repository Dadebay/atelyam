import 'dart:convert';

import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../modules/auth_view/controllers/auth_controller.dart';

class ProductService {
  final AuthController authController = Get.find();
  final http.Client _client = http.Client();

  Future<List<ProductModel>?> fetchProducts(int categoryId, int userId) async {
    try {
      final response = await _client.get(
        Uri.parse('${authController.ipAddress}/mobile/products/$categoryId/$userId/'),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes); // Force UTF-8 decoding

        final List<dynamic> data = json.decode(responseBody);
        final List<ProductModel> products = data.map((json) => ProductModel.fromJson(json)).toList();
        return products;
      } else {
        showSnackBar('Hata', 'Bir hata oluştu: ${response.statusCode}', Colors.red);
        return null;
      }
    } catch (e) {
      showSnackBar('Hata', 'Bir hata oluştu: $e', Colors.red);

      return null;
    }
  }
}
