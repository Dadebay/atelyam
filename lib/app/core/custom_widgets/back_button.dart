import 'package:atelyam/app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class BackButtonMine extends StatelessWidget {
  const BackButtonMine({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Get.back(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadii.borderRadius20,
          side: BorderSide(
            color: AppColors.whiteMainColor.withOpacity(0.2),
          ),
        ),
      ),
      child: const Icon(
        IconlyLight.arrow_left_2,
        color: AppColors.warmWhiteColor,
      ),
    );
  }
}
