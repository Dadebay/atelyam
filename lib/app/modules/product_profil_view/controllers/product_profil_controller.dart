import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/images_model.dart';
import 'package:atelyam/app/data/service/image_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ProductProfilController extends GetxController {
  RxInt selectedImageIndex = 0.obs;
  RxList<String> productImages = <String>[].obs;
  RxBool isLoading = true.obs;
  late Future<ImageModel?> imagesFuture;
  final AuthController authController = Get.find();
  Future<void> fetchImages(final int id, final String mainImage) async {
    isLoading.value = true;
    imagesFuture = ImageService().fetchImages(id);

    await imagesFuture.then((imageModel) {
      if (imageModel != null) {
        productImages.value = imageModel.images.where((img) => img != null).map((img) => authController.ipAddress + img!).toList();
        productImages.insert(0, authController.ipAddress + mainImage);
      } else {
        productImages.insert(0, authController.ipAddress + mainImage);
      }
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      showSnackBar('Hata', 'Resimler yüklenemedi: $error', AppColors.red1Color);
    });
  }

  void updateSelectedImageIndex(int index) {
    selectedImageIndex.value = index;
  }

  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();

    return status == PermissionStatus.granted;
  }

  void checkPermission(BuildContext context) async {
    final Map<Permission, PermissionStatus> statues = await [Permission.camera, Permission.storage].request();
    final PermissionStatus? statusCamera = statues[Permission.camera];
    final PermissionStatus? statusStorage = statues[Permission.storage];
    final bool isPermanentlyDenied = statusCamera == PermissionStatus.permanentlyDenied || statusStorage == PermissionStatus.permanentlyDenied;
    if (isPermanentlyDenied) {
      showSnackBar('Uyarı', 'Depolama izni verilmedi. İndirme yapılamıyor.', AppColors.red1Color);
    }
  }

  Future<void> downloadImage(BuildContext context, String imageURL) async {
    try {
      if (await requestStoragePermission()) {
        showSnackBar('İndiriliyor', 'İndirme Başladı...', AppColors.systemGreenGraph);
        final Dio dio = Dio();
        final dir = await getExternalStorageDirectory();
        final String fileName = imageURL.split('/').last;
        final String savePath = '${dir!.path}/$fileName';
        await dio.download(imageURL, savePath);

        showSnackBar('Başarılı', 'Resim İndirildi.', AppColors.kSecondaryColor);
      } else {
        showSnackBar('Uyarı', 'Depolama izni verilmedi. İndirme yapılamıyor.', AppColors.red1Color);
      }
    } catch (e) {
      showSnackBar('Hata', 'Resim indirilirken hata oluştu.', AppColors.red1Color);
    }
  }
}
