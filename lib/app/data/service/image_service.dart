import 'dart:convert';

import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/images_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ImageService {
  final AuthController authController = Get.find();
  final http.Client _client = http.Client();

  Future<ImageModel?> fetchImages(int productId) async {
    try {
      final response = await _client.get(
        Uri.parse('${authController.ipAddress}/mobile/images/$productId'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return ImageModel.fromJson(data[0]);
        }
        return null;
      } else {
        showSnackBar('error', 'errorFetchImage', Colors.red);
        return null;
      }
    } catch (e) {
      Get.snackbar('Hata', 'Bir hata oluştu: $e', backgroundColor: AppColors.errorRed);
      return null;
    }
  }

  Future<ProductModel?> fetchProductById(int productId) async {
    String? deviceToken = '';
    await FirebaseMessaging.instance.getToken().then((token) {
      deviceToken = token;
    });
    print(deviceToken);
    print('${authController.ipAddress}/mobile/product/$productId?device=$deviceToken');

    try {
      final response = await _client.get(
        Uri.parse('${authController.ipAddress}/mobile/product/$productId?device=$deviceToken'),
      );
      if (response.statusCode == 200) {
        print(ProductModel.fromJson(json.decode(response.body)).viewCount);
        return ProductModel.fromJson(json.decode(response.body));
      } else {
        showSnackBar('error', 'errorFetchImage', Colors.red);
        return null;
      }
    } catch (e) {
      Get.snackbar('Hata', 'Bir hata oluştu: $e', backgroundColor: AppColors.errorRed);
      return null;
    }
  }
}
