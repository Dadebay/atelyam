import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/modules/discovery_view/components/discovery_card.dart';
import 'package:atelyam/app/modules/settings_view/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../../core/custom_widgets/dialogs.dart';

class FavoritesView extends StatelessWidget {
  FavoritesView({super.key});
  final NewSettingsPageController settingsController = Get.find<NewSettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(IconlyLight.arrow_left_circle, color: AppColors.whiteMainColor),
        ),
        backgroundColor: AppColors.kPrimaryColor,
        title: Text(
          'favorites'.tr,
          style: TextStyle(
            color: AppColors.whiteMainColor,
            fontSize: AppFontSizes.fontSize20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(
            () {
              return settingsController.favoriteProducts.isEmpty
                  ? SizedBox.shrink()
                  : IconButton(
                      onPressed: () {
                        Get.bottomSheet(
                          Dialogs().showClearFavoritesDialog(
                            onClearFav: () {
                              settingsController.clearFavorites();

                              Get.back();
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        IconlyLight.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (settingsController.favoriteProducts.isEmpty) {
          return EmptyStates().noFavoritesFound();
        }

        return MasonryGridView.builder(
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemCount: settingsController.favoriteProducts.length,
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
          itemBuilder: (BuildContext context, int index) {
            final product = settingsController.favoriteProducts[index];
            return Container(
              height: index % 2 == 0 ? 250 : 300,
              child: DiscoveryCard(productModel: product, homePageStyle: false),
            );
          },
        );
      }),
    );
  }
}
