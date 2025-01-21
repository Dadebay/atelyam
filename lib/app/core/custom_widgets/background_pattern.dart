import 'package:atelyam/app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundPattern extends StatelessWidget {
  BackgroundPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.backgorundPattern,
      height: Get.size.height * 1.2,
      width: Get.size.width * 1.2,
      fit: BoxFit.cover,
    );
  }
}
