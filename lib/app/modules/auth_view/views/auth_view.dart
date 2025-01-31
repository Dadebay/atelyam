import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/agree_button.dart';
import 'package:atelyam/app/core/custom_widgets/background_pattern.dart';
import 'package:atelyam/app/core/custom_widgets/custom_text_field.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class AuthView extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final AuthController authController = Get.find();
  AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: ClipPath(
              clipper: WaveClipper(isTopWave: true), // Top wave
              child: BackgroundPattern(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            height: Get.size.height / 2,
            child: _buildLogoSection(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: WaveClipper(isTopWave: false), // Bottom wave
              child: Container(
                color: Colors.white,
                height: Get.size.height / 1.9,
                padding: const EdgeInsets.only(bottom: 40, top: 50),
                child: _buildFormSection(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 62,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(Assets.logoBlack), // Ensure this path is correct
              ),
            ),
          ),
        ),
        FadeInDown(
          duration: const Duration(milliseconds: 700),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Assets.appName.tr,
              style: TextStyle(
                color: AppColors.whiteMainColor,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.getFontSize(7),
              ),
            ),
          ),
        ),
        FadeInDown(
          duration: const Duration(milliseconds: 700),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'brandingTitle'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: AppFontSizes.getFontSize(5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'welcomeSubtitle'.tr,
              style: TextStyle(
                color: AppColors.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: AppFontSizes.getFontSize(4.5),
              ),
            ),
          ),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: CustomTextField(
            labelName: 'name',
            controller: usernameController,
            focusNode: usernameFocusNode,
            requestfocusNode: phoneFocusNode,
            borderRadius: true,
            customColor: AppColors.kPrimaryColor.withOpacity(.2),
            prefixIcon: IconlyLight.profile,
          ),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 900),
          child: PhoneNumberTextField(
            controller: phoneController,
            focusNode: phoneFocusNode,
            requestfocusNode: usernameFocusNode,
          ),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: AgreeButton(
              onTap: () {
                authController.handleAuthAction(phoneController: phoneController.text, usernameController: usernameController.text);
              },
              text: 'login',
            ),
          ),
        ),
      ],
    );
  }
}
