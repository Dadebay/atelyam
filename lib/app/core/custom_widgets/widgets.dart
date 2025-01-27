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
    duration: const Duration(seconds: 1),
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

class WaveClipper extends CustomClipper<Path> {
  final bool isTopWave; // Parameter to control the clipping behavior

  WaveClipper({this.isTopWave = true});

  @override
  Path getClip(Size size) {
    final path = Path();

    if (isTopWave) {
      // Clipping logic for the top wave
      path.lineTo(0, size.height * 0.4);

      final firstControlPoint = Offset(size.width * 0.22, size.height * 0.35);
      final firstEndPoint = Offset(size.width * 0.44, size.height * 0.4);
      path.quadraticBezierTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        firstEndPoint.dx,
        firstEndPoint.dy,
      );

      final secondControlPoint = Offset(size.width * 0.7, size.height * 0.45);
      final secondEndPoint = Offset(size.width, size.height * 0.34);
      path.quadraticBezierTo(
        secondControlPoint.dx,
        secondControlPoint.dy,
        secondEndPoint.dx,
        secondEndPoint.dy,
      );

      path.lineTo(size.width, 0);
    } else {
      // Clipping logic for the bottom wave
      path.lineTo(0, size.height * 0.06);

      final firstControlPointUp = Offset(size.width * 0.28, size.height * -0.05);
      final firstEndPointUp = Offset(size.width * 0.5, size.height * 0.06);
      path.quadraticBezierTo(
        firstControlPointUp.dx,
        firstControlPointUp.dy,
        firstEndPointUp.dx,
        firstEndPointUp.dy,
      );

      final firstControlPointDown = Offset(size.width * 0.75, size.height * 0.15);
      final firstEndPointDown = Offset(size.width, size.height * 0.05);
      path.quadraticBezierTo(
        firstControlPointDown.dx,
        firstControlPointDown.dy,
        firstEndPointDown.dx,
        firstEndPointDown.dy,
      );

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
