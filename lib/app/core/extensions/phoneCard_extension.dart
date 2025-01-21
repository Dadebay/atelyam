// ignore_for_file: file_names, deprecated_member_use

import 'package:atelyam/app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension PhoneCardExtensions on Widget {
  Widget phoneCard({
    required EdgeInsets padding,
    required EdgeInsets margin,
    Color? backColor,
    final VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: margin,
        padding: padding,
        width: AppFontSizes.screenWidth,
        decoration: BoxDecoration(
          color: backColor ?? AppColors.darkSecondaryColor,
          borderRadius: BorderRadii.borderRadius30,
          border: Border.all(
            color: AppColors.white1Color.withOpacity(0.13),
          ),
        ),
        child: this,
      ),
    );
  }
}
