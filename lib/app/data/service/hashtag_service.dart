import 'dart:convert';

import 'package:atelyam/app/data/models/hashtag_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HashtagService {
  final AuthController authController = Get.find();

  Future<List<HashtagModel>> fetchHashtags() async {
    final String url = '${authController.ipAddress}/mobile/hashtags/';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<HashtagModel> hashtags = jsonData.map((item) => HashtagModel.fromJson(item)).toList();
      return hashtags;
    } else {
      throw Exception('Failed to load hashtags');
    }
  }

  Future<List<ProductModel>> fetchProductsByHashtagId(int id) async {
    final String url = '${authController.ipAddress}/mobile/hashtagId/$id/';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes); // Force UTF-8 decoding

      final Map<String, dynamic> jsonData = json.decode(responseBody);

      final List<dynamic> results = jsonData['results'];
      final List<ProductModel> products = results.map((item) => ProductModel.fromJson(item)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
