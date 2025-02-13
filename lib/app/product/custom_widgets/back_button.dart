import 'package:atelyam/app/product/theme/color_constants.dart';
import 'package:atelyam/app/product/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class BackButtonMine extends StatelessWidget {
  const BackButtonMine({required this.miniButton, super.key});
  final bool miniButton;
  @override
  Widget build(BuildContext context) {
    return miniButton == true
        ? GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                IconlyLight.arrow_left_circle,
                color: ColorConstants.whiteMainColor,
                size: AppFontSizes.getFontSize(8),
              ),
            ),
          )
        : ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadii.borderRadius20,
                side: BorderSide(
                  color: ColorConstants.whiteMainColor,
                ),
              ),
            ),
            child: const Icon(
              IconlyLight.arrow_left_2,
              color: ColorConstants.warmWhiteColor,
            ),
          );
  }
}
