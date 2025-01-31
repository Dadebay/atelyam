import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/models/hashtag_model.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/data/service/business_category_service.dart';
import 'package:atelyam/app/data/service/hashtag_service.dart';
import 'package:atelyam/app/data/service/product_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:atelyam/app/modules/home_view/controllers/home_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  final AuthController authController = Get.find();
  RxList<BusinessCategoryModel> categories = <BusinessCategoryModel>[].obs;
  RxInt createdProductId = 0.obs; // Oluşturulan ürün ID'si
  RxList<HashtagModel> hashtags = <HashtagModel>[].obs;
  final HomeController homeController = Get.find<HomeController>();
  final maxImageCount = 4; // Maksimum resim sayısı
  Rx<BusinessCategoryModel?> selectedCategory = Rx<BusinessCategoryModel?>(null);
  Rx<HashtagModel?> selectedHashtag = Rx<HashtagModel?>(null);
  Rx<File?> selectedImage = Rx<File?>(null);
  RxList<File?> selectedImages = RxList<File?>([]); // 1. Değişiklik: Liste yapısı

  final BusinessCategoryService _categoryService = BusinessCategoryService();
  final dio.Dio _dio = dio.Dio(); // Dio örneğini oluştur
  final HashtagService _hashtagService = HashtagService();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadHashtags();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      if (selectedImages.length + images.length > maxImageCount) {
        showSnackBar('error', 'max_4_images'.tr, AppColors.redColor);
        return;
      }
      selectedImages.addAll(images.map((image) => File(image.path)));
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> submitProduct({required String nameController, required String descriptionController, required String priceController}) async {
    if (selectedCategory.value == null || selectedHashtag.value == null) {
      showSnackBar('error', 'fill_all_fields'.tr, AppColors.redColor);
      return;
    }

    homeController.agreeButton.toggle();
    final token = await Auth().getToken();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${authController.ipAddress}/mobile/uploadProducts/'),
      );
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      request.fields.addAll({
        'category_id': selectedCategory.value!.id.toString(),
        'hashtag_id': selectedHashtag.value!.id.toString(),
        'name': nameController,
        'description': descriptionController,
        'price': priceController,
      });

      // Ana resmi ekle
      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            selectedImage.value!.path,
          ),
        );
      }
      final response = await request.send();
      if (response.statusCode == 201) {
        await ProductService().getMyProducts().then((products) {
          if (products != null) {
            createdProductId.value = products.last.id;
          }
        });
        await uploadProductImages(int.parse(createdProductId.value.toString())); // Resimleri yükle
      } else {
        showSnackBar('error', 'product_creation_failed'.tr, AppColors.redColor);
      }
    } catch (e) {
      showSnackBar('error', 'error_occurred'.tr, AppColors.redColor);
    } finally {
      homeController.agreeButton.toggle();
    }
  }

  Future<void> uploadProductImages(int productId) async {
    final token = await Auth().getToken();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${authController.ipAddress}/mobile/uploadImage/$productId/'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      // Resimleri img1, img2, img3, img4 olarak ekle
      for (int i = 0; i < selectedImages.length; i++) {
        if (i >= 4) {
          break;
        }
        request.files.add(
          await http.MultipartFile.fromPath(
            'img${i + 1}',
            selectedImages[i]!.path,
          ),
        );
      }
      final response = await request.send();
      if (response.statusCode == 200) {
        Get.back(result: true);
        showSnackBar('success', 'product_upload_success'.tr, AppColors.greenColor);
      } else {
        showSnackBar('error', 'image_upload_failed'.tr, AppColors.redColor);
      }
    } catch (e) {
      showSnackBar('error', 'error_occurred'.tr, AppColors.redColor);
    }
  }

  Future<void> updateProduct({required int productId, required String nameController, required String descriptionController, required String priceController}) async {
    if (selectedCategory.value == null || selectedHashtag.value == null) {
      showSnackBar('error', 'fill_all_fields'.tr, AppColors.redColor);
      return;
    }

    homeController.agreeButton.toggle();
    final token = await Auth().getToken();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${authController.ipAddress}/mobile/productUpdate/$productId/'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      request.fields.addAll({
        'category_id': selectedCategory.value!.id.toString(),
        'hashtag_id': selectedHashtag.value!.id.toString(),
        'name': nameController,
        'description': descriptionController,
        'price': priceController,
      });

      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            selectedImage.value!.path,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.back(result: true);

        showSnackBar('success', 'product_updated'.tr, AppColors.greenColor);
      } else {
        showSnackBar('error', 'update_failed'.tr, AppColors.redColor);
      }
    } catch (e) {
      showSnackBar('error', 'error_occurred'.tr, AppColors.redColor);
    } finally {
      homeController.agreeButton.toggle();
    }
  }

  Future<void> deleteProduct(int id, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_product'),
        content: Text('${'are_you_sure'} ${'product'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('delete', style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    final token = await Auth().getToken();
    final headers = {
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.delete(
        Uri.parse('${authController.ipAddress}/mobile/productDelete/$id/'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        Get.back(result: true);
      } else {
        showSnackBar('error', 'Ürün silinemedi: ${response.reasonPhrase}', AppColors.redColor);
      }
    } catch (e) {
      Get.back(result: true);

      showSnackBar('error', 'Bir hata oluştu: $e', AppColors.redColor);
    }
  }

  Future<void> submitBusinessAccount(GetMyStatusModel businessUser) async {
    if (selectedCategory.value == null) {
      showSnackBar('error', 'fill_all_fields', AppColors.redColor);
      return;
    }
    if (selectedImage.value == null) {
      showSnackBar('error', 'logo_upload', AppColors.redColor);
      return;
    }

    final token = await Auth().getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${authController.ipAddress}/mobile/createUser/'),
    );
    request.fields.addAll({
      'title_id': selectedCategory.value!.id.toString(),
      'businessName': businessUser.businessName!,
      'businessPhone': businessUser.businessPhone!,
      'description': businessUser.description!,
      'address': businessUser.address!,
      'tiktok': businessUser.tiktok!,
      'instagram': businessUser.instagram!,
      'youtube': businessUser.youtube!,
      'website': businessUser.website!,
    });
    request.files.add(
      await http.MultipartFile.fromPath('file', selectedImage.value!.path),
    );
    request.headers.addAll(headers);
    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        Get.back(result: true);
      } else if (response.statusCode == 400) {
        showSnackBar('error', 'account_already_exist', AppColors.redColor);
      } else {
        showSnackBar('error', '${'account_create_failed'} ${response.reasonPhrase}', AppColors.redColor);
      }
    } catch (e) {
      Get.back(result: true);
      showSnackBar('error', '${'anErrorOccurred'} $e', AppColors.redColor);
    }
  }

  Future<void> updateBusinessAccount(GetMyStatusModel businessUser) async {
    homeController.agreeButton.toggle();
    final token = await Auth().getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };
    final dio.FormData formData = dio.FormData.fromMap({
      'businessName': businessUser.businessName!,
      'businessPhone': businessUser.businessPhone!,
      'description': businessUser.description!,
      'address': businessUser.address!,
      'tiktok': businessUser.tiktok!,
      'instagram': businessUser.instagram!,
      'youtube': businessUser.youtube!,
      'website': businessUser.website!,
    });
    if (selectedImage.value != null) {
      formData.files.add(
        MapEntry(
          'img',
          await dio.MultipartFile.fromFile(
            selectedImage.value!.path,
          ),
        ),
      );
    }
    try {
      final response = await _dio.post(
        '${authController.ipAddress}/mobile/updateBusiness/',
        data: formData,
        options: dio.Options(headers: headers),
      );
      if (response.statusCode == 200) {
        Get.back(result: true);
        showSnackBar('success', 'business_account_updated', AppColors.kSecondaryColor);
      } else {
        showSnackBar('error', '${'business_account_not_updated'} ${response.statusMessage}', AppColors.redColor);
      }
    } on dio.DioError catch (e) {
      Get.back(result: true);
      showSnackBar('error', '${'anErrorOccurred'} $e', AppColors.redColor);
    } finally {
      homeController.agreeButton.toggle();
    }
  }

  Future<void> deleteBusiness(int id, BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'delete_account'.tr,
          style: TextStyle(color: AppColors.kPrimaryColor, fontWeight: FontWeight.bold, fontSize: AppFontSizes.getFontSize(5)),
        ),
        content: Text(
          'are_you_sure'.tr,
          style: TextStyle(color: AppColors.kPrimaryColor, fontWeight: FontWeight.w400, fontSize: AppFontSizes.getFontSize(5)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: AppColors.kPrimaryColor, fontWeight: FontWeight.w400, fontSize: AppFontSizes.getFontSize(5)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'delete'.tr,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: AppFontSizes.getFontSize(5)),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final token = await Auth().getToken();
      final headers = {
        'Authorization': 'Bearer $token',
      };
      try {
        final response = await http.delete(
          Uri.parse('${authController.ipAddress}/mobile/deleteBusiness/'),
          headers: headers,
        );
        if (response.statusCode == 200) {
          Get.back(result: true);
          showSnackBar('success', 'deleted_success', AppColors.greenColor);
        } else {
          showSnackBar('error', 'anErrorOccurred'.tr + '${response.reasonPhrase}', AppColors.redColor);
        }
      } catch (e) {
        Get.back(result: true);
        showSnackBar('error', '${'anErrorOccurred'} $e', AppColors.redColor);
      } finally {}
    }
  }

  Future<void> loadCategories() async {
    final result = await _categoryService.fetchCategories();
    if (result != null) {
      categories.value = result;
    }
  }

  Future<void> loadHashtags() async {
    final result = await _hashtagService.fetchHashtags();
    hashtags.value = result;
  }
}
