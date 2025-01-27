import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/images_model.dart';
import 'package:atelyam/app/data/service/image_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
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
    imagesFuture = ImageService().fetchImageByProductID(id);

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
      showSnackBar('Hata', 'Resimler yüklenemedi: $error', AppColors.redColor);
    });
  }

  void updateSelectedImageIndex(int index) {
    selectedImageIndex.value = index;
  }

  void checkPermissionAndDownloadImage(String imageURL) async {
    // İzinleri kontrol et
    final Map<Permission, PermissionStatus> statues = await [
      Permission.storage,
      Permission.photos, // Android 13 ve üzeri için
    ].request();

    final PermissionStatus? statusStorage = statues[Permission.storage];
    final PermissionStatus? statusPhotos = statues[Permission.photos];

    final bool isPermanentlyDenied = statusStorage == PermissionStatus.permanentlyDenied || statusPhotos == PermissionStatus.permanentlyDenied;

    if (isPermanentlyDenied) {
      showSnackBar('Uyarı', 'Depolama izni verilmedi. İndirme yapılamıyor.', AppColors.redColor);
    } else {
      try {
        showSnackBar('İndiriliyor', 'İndirme Başladı...', AppColors.greenColor);

        final Dio dio = Dio();

        // Genel depolama alanına kaydetmek için `Pictures` klasörünü kullan
        final Directory? downloadsDir = await getExternalStorageDirectory();
        final String savePath = '${downloadsDir!.path}/Pictures';

        // Klasör yoksa oluştur
        final Directory dir = Directory(savePath);
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }

        // Dosya adını dinamik olarak oluştur
        final String fileName = 'Atelyam_${DateTime.now().toString().replaceAll(RegExp(r'[^\w]'), '_')}.webp';
        final String fullPath = '$savePath/$fileName';

        // Dosyayı indir
        await dio.download(imageURL, fullPath);

        // Dosyayı galeriye ekle
        await Gal.putImage(fullPath);

        showSnackBar('Başarılı', 'Resim İndirildi ve Galeriye Eklendi.', AppColors.kSecondaryColor);
      } catch (e) {
        showSnackBar('Hata', 'Resim indirilirken hata oluştu: $e', AppColors.redColor);
      }
    }
  }
}
