import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/modules/auth_view/views/otp_view.dart';
import 'package:atelyam/app/modules/home_view/controllers/home_controller.dart';
import 'package:atelyam/app/modules/home_view/views/bottom_nav_bar_view.dart';
import 'package:atelyam/app/modules/settings_view/controllers/settings_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final ipAddress = ''.obs;
  final db = FirebaseFirestore.instance;

  Future<void> fetchIpAddress() async {
    try {
      final DocumentSnapshot snapshot = await db.collection('server').doc('server_ip').get();
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        ipAddress.value = data['ip'] ?? 'http://216.250.12.49:8000/';
      } else {
        ipAddress.value = 'http://216.250.12.49:8000/';
      }
    } catch (e) {
      ipAddress.value = 'http://216.250.12.49:8000/';
    }
  }

  Future<void> saveIpAddress(String newIp) async {
    try {
      await db.collection('server').doc('server_ip').set({'ip': newIp});
      ipAddress.value = newIp;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> handleAuthAction({required String phoneController, required String usernameController}) async {
    final HomeController homeController = Get.find();
    homeController.agreeButton.toggle();

    final signInService = SignInService();
    final phoneNumber = phoneController;
    final userName = usernameController;

    try {
      final registerResponse = await signInService.register(phoneNumber: phoneNumber, name: userName);
      if (registerResponse == 200) {
        homeController.agreeButton.toggle();
        await Get.to(() => OTPView(phoneNumber: phoneNumber, userName: userName));
      } else {
        final loginResponse = await signInService.login(phone: phoneNumber);
        if (loginResponse == 200) {
          homeController.agreeButton.toggle();
          await Get.to(() => OTPView(phoneNumber: phoneNumber, userName: userName));
        } else {
          homeController.agreeButton.toggle();
          showSnackBar('error', 'errorLogin', AppColors.redColor);
        }
      }
    } catch (e) {
      homeController.agreeButton.toggle();
      showSnackBar('error', 'errorLogin', AppColors.redColor);
    }
  }

  Future<void> verifyOTP(String username, String phoneNumber, List<TextEditingController> otpControllers) async {
    final String otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length == 4) {
      final response = await SignInService().otpCheck(phoneNumber: phoneNumber, otp: otp);
      if (response == 200) {
        final homeController = Get.find<HomeController>();
        final settingsController = Get.find<NewSettingsPageController>();
        homeController.updateSelectedIndex(0);
        settingsController.isLoginView.value = true;
        await settingsController.saveUserData(username, phoneNumber);
        await Get.offAll(() => BottomNavBar());
        showSnackBar('success', 'successOTP', AppColors.kSecondaryColor);
      } else {
        showSnackBar('error', 'errorOTP', Colors.red);
      }
    } else {
      showSnackBar('error', 'errorOTP', Colors.red);
    }
  }
}
