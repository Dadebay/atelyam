import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController showSnackBar(String title, String subtitle, Color color) {
  if (SnackbarController.isSnackbarBeingShown) {
    SnackbarController.cancelAllSnackbars();
  }
  return Get.snackbar(
    title,
    subtitle,
    snackStyle: SnackStyle.FLOATING,
    titleText: title == ''
        ? const SizedBox.shrink()
        : Text(
            title.tr,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFontSizes.fontSize20, color: Colors.white),
          ),
    messageText: Text(
      subtitle.tr,
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: AppFontSizes.fontSize16, color: Colors.white),
    ),
    snackPosition: SnackPosition.TOP,
    backgroundColor: color,
    borderRadius: 20.0,
    duration: const Duration(milliseconds: 800),
    margin: const EdgeInsets.all(8),
  );
}

class WidgetsMine {
  Widget customCachedImage(String image) {
    final AuthController authController = Get.find();

    return CachedNetworkImage(
      imageUrl: authController.ipAddress + image,
      fit: BoxFit.cover,
      fadeInCurve: Curves.ease,
      height: Get.size.height,
      width: Get.size.width,
      placeholder: (context, url) => EmptyStates().loadingData(),
      errorWidget: (context, url, error) => EmptyStates().noMiniCategoryImage(),
    );
  }
}
