import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/data/models/get_popular_model.dart';
import 'package:atelyam/app/data/service/business_category_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetPopularService {
  final String _apiEndpoint = '/mobile/getPopular/';
  final AuthController authController = Get.find();
  Future<List<GetPopularModel>?> fetchGetPopular() async {
    try {
      final response =
          await http.get(Uri.parse(authController.ipAddress + _apiEndpoint));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> responseData = json.decode(responseBody);
        final List<GetPopularModel> getPopularList = responseData
            .map(
              (json) => GetPopularModel.fromMap(json),
            )
            .toList();
        return getPopularList;
      } else {
        handleApiError(response.statusCode, response.body);

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
