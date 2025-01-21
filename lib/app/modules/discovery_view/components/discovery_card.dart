import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:atelyam/app/modules/product_profil_view/views/product_profil_view.dart';
import 'package:atelyam/app/modules/settings_view/components/fav_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscoveryCard extends StatelessWidget {
  final ProductModel productModel;
  final bool homePageStyle;

  DiscoveryCard({
    required this.productModel,
    required this.homePageStyle,
    super.key,
  });
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductProfilView(productModel: productModel));
      },
      child: Container(
        margin: homePageStyle == true ? const EdgeInsets.only(left: 20, top: 10, bottom: 10) : EdgeInsets.zero,
        decoration: BoxDecoration(
          boxShadow: homePageStyle == true
              ? [BoxShadow(color: AppColors.darkSecondaryColor.withOpacity(0.1), spreadRadius: 5, blurRadius: 5)]
              : [BoxShadow(color: AppColors.kThirdColor.withOpacity(0.8), spreadRadius: 3, blurRadius: 3)],
          borderRadius: BorderRadii.borderRadius30,
        ),
        child: ClipRRect(
          borderRadius: BorderRadii.borderRadius30,
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: authController.ipAddress + productModel.img,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => EmptyStates().loadingData(),
                  errorWidget: (context, url, error) => EmptyStates().noMiniCategoryImage(),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: FavButton(
                  productProfilStyle: false,
                  product: productModel,
                ),
              ),
              homePageStyle
                  ? Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 12, left: 8, right: 8, top: 8),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadii.borderRadius20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              productModel.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppColors.kPrimaryColor, fontWeight: FontWeight.bold, fontSize: AppFontSizes.fontSize16),
                            ),
                            Text(
                              productModel.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppColors.kPrimaryColor, fontWeight: FontWeight.w400, fontSize: AppFontSizes.fontSize14),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
