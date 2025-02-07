// lib/app/data/services/image_service.dart
import 'dart:convert';
import 'dart:io';

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

  Future<ImageModel?> fetchImageByProductID(int productId) async {
    try {
      final response = await _client.get(
        Uri.parse('${authController.ipAddress.value}/mobile/images/$productId'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        if (data.isNotEmpty) {
          return ImageModel.fromJson(data[0]);
        }
        return ImageModel(id: 0, images: [], product: 0);
      } else {
        _handleApiError(response.statusCode);
        return null;
      }
    } on SocketException {
      showSnackBar('networkError'.tr, 'noInternet'.tr, AppColors.redColor);
      return null;
    } catch (e) {
      showSnackBar('unknownError'.tr, 'anErrorOccurred'.tr, AppColors.redColor);
      return null;
    }
  }

  Future<ProductModel?> fetchProductById(int productId) async {
    String? deviceToken = '';
    await FirebaseMessaging.instance.getToken().then((token) {
      deviceToken = token;
    });
    try {
      final response = await _client.get(
        Uri.parse('${authController.ipAddress.value}/mobile/product/$productId?device=$deviceToken'),
      );
      if (response.statusCode == 200) {
        return ProductModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } on SocketException {
      return null;
    } catch (e) {
      return null;
    }
  }

  void _handleApiError(int statusCode) {
    showSnackBar('apiError'.tr, 'anErrorOccurred'.tr, Colors.red);
  }
}
