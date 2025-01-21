import 'dart:developer';
import 'dart:io';

import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CreateBusinessAccService {
  final AuthController authController = Get.find();

  Future<int?> createAccaunt({
    final String? titleId,
    final String? businessName,
    final String? phone,
    final String? desc,
    final String? address,
    final String? tiktok,
    final String? instagram,
    final String? youtube,
    final String? website,
    final File? file,
  }) async {
    final headers = {
      'Authorization': 'Bearer ${await Auth().getToken()}',
    };
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(authController.ipAddress + '/mobile/createUser/'),
    );
    request.fields.addAll({
      'title_id': titleId ?? '',
      'businessName': businessName ?? '',
      'businessPhone': phone ?? '',
      'description': desc ?? '',
      'address': address ?? '',
      'tiktok': tiktok ?? '',
      'instagram': instagram ?? '',
      'youtube': youtube ?? '',
      'website': website ?? '',
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file!.path,
      ),
    );
    request.headers.addAll(headers);
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
