// lib/app/core/utils/dialogs.dart

import 'package:atelyam/app/core/custom_widgets/agree_button_view.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/modules/settings_view/controllers/settings_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class Dialogs {
  void showNoConnectionDialog(BuildContext context, Function onRetry) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadii.borderRadius20),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadii.borderRadius20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'noConnection1'.tr,
                      style: const TextStyle(fontSize: 24.0, color: AppColors.brandYellow, fontFamily: Fonts.plusJakartaSans),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Text(
                        'noConnection2'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black, fontFamily: Fonts.plusJakartaSans, fontSize: 16.0),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(milliseconds: 1000), () => onRetry());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandYellow,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadii.borderRadius10),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      ),
                      child: Text(
                        'noConnection3'.tr,
                        style: const TextStyle(fontSize: 18, color: Colors.white, fontFamily: Fonts.plusJakartaSans),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.asset(Assets.noConnection, fit: BoxFit.fill),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAvatarDialog(BuildContext context) {
    final NewSettingsPageController settingsController = Get.find<NewSettingsPageController>();

    Widget _buildAvatarItem({required int index, required int pageViewIndex}) {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 62,
        child: CircleAvatar(
          radius: 60,
          child: Image.asset(
            settingsController.avatars[index],
            width: 90,
            height: 90,
          ),
        ),
      );
    }

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.whiteMainColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadii.borderRadius20),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'choose_avatar'.tr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.darkMainColor, fontSize: AppFontSizes.fontSize20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200,
                width: Get.size.width,
                child: CarouselSlider.builder(
                  itemCount: 12,
                  itemBuilder: (BuildContext context, int index, int pageViewIndex) {
                    return _buildAvatarItem(index: index, pageViewIndex: pageViewIndex);
                  },
                  options: CarouselOptions(
                    initialPage: settingsController.selectedAvatarIndex.value,
                    viewportFraction: 0.50,
                    height: 200.0,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      settingsController.selectedAvatarIndex.value = index;
                    },
                  ),
                ),
              ),
              AgreeButton(
                text: 'save_avatar'.tr,
                onTap: () {
                  settingsController.saveSelectedAvatar(settingsController.selectedAvatarIndex.value);
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLanguageDialog() {
    final NewSettingsPageController settingsController = Get.find<NewSettingsPageController>();

    Widget _buildLanguageItem({required int index, required Function() onLanguageSelected}) {
      return ListTile(
        contentPadding: EdgeInsets.only(top: 20),
        onTap: onLanguageSelected,
        title: Text(
          settingsController.appLanguages[index]['name']!,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            color: AppColors.darkMainColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.kPrimaryColor,
              width: 2,
            ),
            borderRadius: BorderRadii.borderRadius18,
          ),
          child: ClipRRect(
            borderRadius: BorderRadii.borderRadius15,
            child: SvgPicture.asset(
              settingsController.appLanguages[index]['icon']!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        trailing: const Icon(
          IconlyLight.arrow_right_circle,
          color: AppColors.kPrimaryColor,
        ),
      );
    }

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.whiteMainColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadii.borderRadius20),
        insetPadding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'choose_language'.tr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.darkMainColor, fontSize: AppFontSizes.fontSize20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              itemCount: settingsController.appLanguages.length,
              itemBuilder: (context, index) {
                return _buildLanguageItem(
                  index: index,
                  onLanguageSelected: () {
                    final locale = Locale(settingsController.appLanguages[index]['code'].toString());
                    Get.updateLocale(locale);
                    Get.back();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget logOut({required Function() onYestapped}) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Text(
                  'logout'.tr,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: const Icon(CupertinoIcons.xmark_circle, size: 22, color: AppColors.darkMainColor),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: Text(
              'log_out_title'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: onYestapped,
            child: Container(
              width: Get.size.width,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadii.borderRadius10),
              child: Text(
                'yes'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              Get.back();
            },
            child: Container(
              width: Get.size.width,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: AppColors.kPrimaryColor, borderRadius: BorderRadii.borderRadius10),
              child: Text(
                'no'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showClearFavoritesDialog({required Function() onClearFav}) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Text(
                  'clear_all_favorites'.tr,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back(); // Dialog'u kapat
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      CupertinoIcons.xmark_circle,
                      size: 22,
                      color: AppColors.darkMainColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: Text(
              'clear_all_favorites_desc'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClearFav,
            child: Container(
              width: Get.size.width,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadii.borderRadius10,
              ),
              child: Text(
                'yes'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back(); // Dialog'u kapat
            },
            child: Container(
              width: Get.size.width,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.kPrimaryColor,
                borderRadius: BorderRadii.borderRadius10,
              ),
              child: Text(
                'no'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
