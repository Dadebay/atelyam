import 'dart:developer';
import 'dart:io';

import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddProductService {
  final AuthController authController = Get.find();

  Future<int?> addProduct({
    final String? categoryId,
    final String? hashtagId,
    final String? name,
    final String? desc,
    final String? price,
    final File? file,
  }) async {
    final headers = {
      'Authorization': 'Bearer ${await Auth().getToken()}',
    };
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(authController.ipAddress + '/mobile/uploadProducts/'),
    );
    request.fields.addAll({
      'category_id': categoryId ?? '',
      'hashtag_id': hashtagId ?? '',
      'name': name ?? '',
      'description': desc ?? '',
      'price': price ?? '',
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file!.path,
      ),
    );
    request.headers.addAll(headers);
    log(Auth().getToken().toString());
    log(request.fields.toString());

    final http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(await response.stream.bytesToString());
      return response.statusCode;
    } else {
      print(response.reasonPhrase);
      log(response.statusCode.toString());
    }
    return response.statusCode;
  }
}
