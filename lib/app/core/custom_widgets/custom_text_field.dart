// ignore_for_file: file_names, must_be_immutable, use_key_in_widget_constructors

import 'package:atelyam/app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final String labelName;
  final int? maxline;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode requestfocusNode;
  final bool isNumber;
  final bool unFocus;
  final bool? borderRadius;
  final bool? disabled;
  final bool? isLabel;
  final IconData? prefixIcon;
  final Color? customColor;
  final bool style;

  /// Creates a [CustomTextField].
  const CustomTextField({
    required this.labelName,
    required this.controller,
    required this.focusNode,
    required this.requestfocusNode,
    required this.isNumber,
    required this.unFocus,
    this.isLabel = false,
    this.maxline,
    this.borderRadius,
    this.disabled,
    this.prefixIcon,
    this.customColor,
    this.style = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = customColor ?? AppColors.whiteMainColor;

    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: TextFormField(
        enabled: disabled ?? true,
        style: TextStyle(color: Colors.black, fontSize: isNumber ? 18 : null, fontWeight: FontWeight.w600),
        cursorColor: isNumber ? Colors.black : defaultColor,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'errorEmpty'.tr;
          }
          if (isNumber && value.length != 8) {
            return 'errorPhoneCount'.tr;
          }
          return null;
        },
        onEditingComplete: () {
          unFocus ? FocusScope.of(context).unfocus() : requestfocusNode.requestFocus();
        },
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber
            ? [
                LengthLimitingTextInputFormatter(8),
                FilteringTextInputFormatter.digitsOnly,
              ]
            : null,
        maxLines: maxline ?? 1,
        focusNode: focusNode,
        textInputAction: isNumber ? TextInputAction.next : TextInputAction.done,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          prefixIcon: isNumber
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text(
                    '+ 993',
                    style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                )
              : prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: defaultColor,
                      size: 30,
                    )
                  : null,
          errorMaxLines: 2,
          errorStyle: const TextStyle(fontFamily: Fonts.plusJakartaSans),
          hintMaxLines: 5,
          helperMaxLines: 5,
          hintText: isLabel!
              ? labelName.tr
              : isNumber
                  ? '65 656565 '
                  : '',
          hintStyle: TextStyle(color: defaultColor, fontFamily: Fonts.plusJakartaSans),
          prefixIconConstraints: isNumber ? const BoxConstraints(minWidth: 80) : null,
          label: isNumber
              ? null
              : isLabel!
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        labelName.tr,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: defaultColor, fontWeight: FontWeight.w600),
                      ),
                    ),
          contentPadding: const EdgeInsets.only(left: 30, top: 20, bottom: 20, right: 10),
          isDense: true,
          filled: style,
          fillColor: style ? Colors.grey.shade100 : null, // if style is true background color will be grey.shade100, otherwise null.
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

  /// Helper function to create the OutlineInputBorder with configurable border radius and border color
  OutlineInputBorder _buildOutlineInputBorder({Color? borderColor}) {
    final Color defaultBorderColor = borderColor ?? Colors.grey;
    final borderRadiusValue = borderRadius == null
        ? BorderRadii.borderRadius5
        : borderRadius == false
            ? BorderRadii.borderRadius5
            : BorderRadii.borderRadius20;
    return OutlineInputBorder(
      borderRadius: borderRadiusValue,
      borderSide: BorderSide(color: defaultBorderColor, width: 2),
    );
  }
}
