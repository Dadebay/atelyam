import 'package:atelyam/app/core/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class EmptyStates {
  Center noMiniCategoryImage() {
    return Center(
      child: Text(
        'no_category_image'.tr,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: const TextStyle(
          color: AppColors.warmWhiteColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget errorData(String error) {
    return Center(child: Text('Error: $error'));
  }

  Widget noDataAvailable() {
    return Center(
      child: Text(
        'no_data_available'.tr,
        style: const TextStyle(
          color: AppColors.kPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget noDataAvailablePage() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Lottie.asset('assets/lottie/nodata.json'),
          ),
          Text(
            'no_data_available'.tr,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.whiteMainColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget noFavoritesFound() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Lottie.asset('assets/lottie/nodata.json'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'noFavoritesFound'.tr,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.darkMainColor,
                fontSize: AppFontSizes.fontSize20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget noBannersAvailable() {
    return Center(
      child: Text(
        'no_banners_to_display'.tr,
        style: const TextStyle(
          color: AppColors.kPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget noCategoriesAvailable() {
    return Center(
      child: Text(
        'no_categories_to_display'.tr,
        style: const TextStyle(
          color: AppColors.kPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  dynamic loadingData() {
    return Center(child: Lottie.asset(Assets.loading));
  }
}
