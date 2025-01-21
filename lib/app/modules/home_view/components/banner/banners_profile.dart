import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/banner_model.dart';
import 'package:atelyam/app/modules/home_view/components/banner/banner_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class BannersProfile extends StatelessWidget {
  const BannersProfile({required this.banner, super.key});
  final BannerModel banner;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteMainColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(IconlyLight.arrow_left_circle, color: AppColors.whiteMainColor)),
        backgroundColor: AppColors.kPrimaryColor,
        title: Text(
          'banners_profile'.tr,
          style: TextStyle(color: AppColors.whiteMainColor, fontSize: AppFontSizes.fontSize20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: Get.size.height / 3.5,
            child: BannerCard(
              banner: banner,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              Assets.loremImpsum,
              style: TextStyle(color: AppColors.kPrimaryColor, fontWeight: FontWeight.w400, fontSize: AppFontSizes.fontSize16),
            ),
          ),
        ],
      ),
    );
  }
}
