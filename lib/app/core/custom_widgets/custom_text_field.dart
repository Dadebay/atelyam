import 'package:atelyam/app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final String labelName;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode requestfocusNode;
  final bool? borderRadius;
  final IconData? prefixIcon;
  final Color? customColor;

  const CustomTextField({
    required this.labelName,
    required this.controller,
    required this.focusNode,
    required this.requestfocusNode,
    this.borderRadius,
    this.prefixIcon,
    this.customColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = customColor ?? AppColors.whiteMainColor;
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: TextFormField(
        style: TextStyle(
          color: Colors.black,
          fontSize: AppFontSizes.getFontSize(4.5),
          fontWeight: FontWeight.w600,
        ),
        cursorColor: defaultColor,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'errorEmpty'.tr;
          }
          return null;
        },
        onEditingComplete: () {
          requestfocusNode.requestFocus();
        },
        keyboardType: TextInputType.text,
        maxLines: 1,
        focusNode: focusNode,
        textInputAction: TextInputAction.done,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: AppColors.kSecondaryColor,
                  size: AppFontSizes.getFontSize(7),
                )
              : null,
          hintText: labelName.tr,
          hintStyle: TextStyle(
            color: defaultColor,
            fontSize: AppFontSizes.getFontSize(4.5),
            fontWeight: FontWeight.w600,
          ),
          //  Padding(
          //   padding: const EdgeInsets.only(bottom: 18),
          //   child: Text(
          //     labelName.tr,
          //     overflow: TextOverflow.ellipsis,
          //     style: TextStyle(
          //       color: defaultColor,
          //       fontSize: AppFontSizes.getFontSize(4.5),
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          contentPadding: EdgeInsets.only(left: 30, top: 18, bottom: 15, right: 10),
          isDense: true,
          alignLabelWithHint: true,
          border: _buildOutlineInputBorder(borderColor: defaultColor),
          enabledBorder: _buildOutlineInputBorder(borderColor: defaultColor),
          focusedBorder: _buildOutlineInputBorder(borderColor: AppColors.kSecondaryColor),
          focusedErrorBorder: _buildOutlineInputBorder(borderColor: defaultColor),
          errorBorder: _buildOutlineInputBorder(borderColor: Colors.red),
        ),
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder({Color? borderColor}) {
    final borderRadiusValue = borderRadius == null
        ? BorderRadii.borderRadius5
        : borderRadius == false
            ? BorderRadii.borderRadius5
            : BorderRadii.borderRadius20;
    return OutlineInputBorder(
      borderRadius: borderRadiusValue,
      borderSide: BorderSide(color: borderColor ?? Colors.grey, width: 2),
    );
  }
}

class PhoneNumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode requestfocusNode;

  const PhoneNumberTextField({
    required this.controller,
    required this.focusNode,
    required this.requestfocusNode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: TextFormField(
        style: TextStyle(
          color: Colors.black,
          fontSize: AppFontSizes.getFontSize(4.5),
          fontWeight: FontWeight.w600,
        ),
        cursorColor: Colors.black,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'errorEmpty'.tr;
          }
          if (value.length != 8) {
            return 'errorPhoneCount'.tr;
          }
          return null;
        },
        onEditingComplete: () {
          requestfocusNode.requestFocus();
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
          FilteringTextInputFormatter.digitsOnly,
        ],
        maxLines: 1,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              '+ 993',
              style: TextStyle(
                color: AppColors.kSecondaryColor,
                fontSize: AppFontSizes.getFontSize(4.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          hintText: '65 656565',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
            fontSize: AppFontSizes.getFontSize(4.5),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 80),
          contentPadding: const EdgeInsets.only(left: 30, top: 18, bottom: 15, right: 10),
          isDense: true,
          border: _buildOutlineInputBorder(borderColor: Colors.grey),
          enabledBorder: _buildOutlineInputBorder(borderColor: Colors.grey),
          focusedBorder: _buildOutlineInputBorder(borderColor: AppColors.kSecondaryColor),
          focusedErrorBorder: _buildOutlineInputBorder(borderColor: Colors.red),
          errorBorder: _buildOutlineInputBorder(borderColor: Colors.red),
        ),
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder({Color? borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadii.borderRadius20,
      borderSide: BorderSide(color: borderColor ?? Colors.grey, width: 2),
    );
  }
}
