// ignore_for_file: deprecated_member_use

import 'package:atelyam/app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class SettingsButton extends StatelessWidget {
  final String name;
  final Function() onTap;
  final Widget icon;
  final bool? lang;
  const SettingsButton({
    required this.name,
    required this.onTap,
    required this.icon,
    super.key,
    this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onTap,
        tileColor: AppColors.white1Color,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadii.borderRadius15,
        ),
        minVerticalPadding: 23,
        title: Text(
          name.tr,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        leading: _buildLeadingIcon(),
        trailing: const Icon(
          IconlyLight.arrow_right_circle,
          color: AppColors.kPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    if (lang == true) {
      return _buildLanguageIcon();
    } else {
      return _buildCustomIcon();
    }
  }

  Widget _buildLanguageIcon() {
    String iconPath;
    switch (Get.locale!.languageCode) {
      case 'tm':
        iconPath = LanguageIcons.turkmenLangIcon;
        break;
      case 'ru':
        iconPath = LanguageIcons.russianLangIcon;
        break;
      case 'en':
        iconPath = LanguageIcons.englishLangIcon;
        break;
      case 'tr':
        iconPath = LanguageIcons.turkLangIcon;
        break;
      case 'ch':
        iconPath = LanguageIcons.chinaLangIcon;
        break;
      default:
        iconPath = LanguageIcons.englishLangIcon; // Varsayılan olarak İngilizce
    }

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: AppColors.kThirdColor.withOpacity(0.2),
        border: Border.all(
          color: AppColors.kSecondaryColor.withOpacity(0.4),
          width: 1,
        ),
        borderRadius: BorderRadii.borderRadius18,
      ),
      width: 45,
      height: 45,
      child: ClipRRect(
        borderRadius: BorderRadii.borderRadius18,
        child: SvgPicture.asset(
          iconPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Diğer ikonları oluşturur.
  Widget _buildCustomIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.kThirdColor.withOpacity(0.2),
        border: Border.all(
          color: AppColors.kSecondaryColor.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadii.borderRadius18,
      ),
      child: icon,
    );
  }
}
