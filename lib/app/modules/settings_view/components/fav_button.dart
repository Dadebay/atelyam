// ignore_for_file: deprecated_member_use

import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/modules/settings_view/controllers/settings_controller.dart';
import 'package:atelyam/app/product/theme/color_constants.dart';
import 'package:atelyam/app/product/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class FavButton extends StatefulWidget {
  const FavButton({
    required this.productProfilStyle,
    required this.product,
    super.key,
  });

  final bool productProfilStyle;
  final ProductModel product;

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
  final NewSettingsPageController settingsController = Get.find<NewSettingsPageController>();

  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      isFavorited = settingsController.isProductFavorite(widget.product);
      return GestureDetector(
        onTap: () {
          settingsController.toggleFavoriteProduct(widget.product);
          isFavorited = !isFavorited;
          setState(() {}); // Durumu güncelle
        },
        child: Container(
          padding: const EdgeInsets.all(9),
          margin: EdgeInsets.only(right: widget.productProfilStyle ? 8 : 0),
          decoration: BoxDecoration(
            color: widget.productProfilStyle
                ? ColorConstants.whiteMainColor
                : isFavorited
                    ? Colors.white
                    : ColorConstants.kThirdColor.withOpacity(0.6),
            borderRadius: BorderRadii.borderRadius15,
          ),
          child: Icon(
            isFavorited ? IconlyBold.heart : IconlyLight.heart,
            size: AppFontSizes.fontSize24,
            color: isFavorited
                ? Colors.red
                : widget.productProfilStyle
                    ? ColorConstants.darkMainColor
                    : ColorConstants.whiteMainColor,
          ),
        ),
      );
    });
  }
}
