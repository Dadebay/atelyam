import 'package:atelyam/app/core/custom_widgets/agree_button.dart';
import 'package:atelyam/app/core/custom_widgets/background_pattern.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

class OTPView extends StatelessWidget {
  final String phoneNumber;
  final String userName;

  OTPView({required this.phoneNumber, required this.userName, Key? key}) : super(key: key);

  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (index) => FocusNode());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: BackgroundPattern()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildAppBar(),
                _buildOTPContent(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        IconButton(
          icon: Icon(IconlyLight.arrow_left_circle, size: 28, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'verify_phone'.tr,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.fontSize20 + 2,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Icon(
          IconlyBold.time_circle,
          color: Colors.transparent,
        ),
      ],
    );
  }

  Widget _buildOTPContent(BuildContext context) {
    return Container(
      height: Get.size.height / 1.12,
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: AppColors.whiteMainColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Lottie.asset(
            Assets.otp_loading,
            height: 200,
            width: 200,
          ),
          Text(
            'code_has_been_sent_to'.tr + ': +993$phoneNumber',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              height: 2,
              color: Colors.grey,
            ),
          ),
          _buildOTPFields(context),
          AgreeButton(
            onTap: () {
              authController.verifyOTP(userName, phoneNumber, _otpControllers);
            },
            text: 'verify',
          ),
        ],
      ),
    );
  }

  Widget _buildOTPFields(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 55,
          child: TextField(
            style: TextStyle(color: AppColors.darkMainColor, fontWeight: FontWeight.bold, fontSize: 20),
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadii.borderRadius15,
                borderSide: const BorderSide(color: AppColors.warmWhiteColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadii.borderRadius20,
                borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
              }

              if (_otpControllers.every((controller) => controller.text.isNotEmpty)) {
                authController.verifyOTP(userName,phoneNumber, _otpControllers);
              }
            },
          ),
        );
      }),
    );
  }
}
