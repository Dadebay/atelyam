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
  final ipAddress = 'http://216.250.12.49:8000/'.obs;
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

  Future<void> handleAuthAction({required String phoneController, required String usernameController}) async {
    final HomeController homeController = Get.find();
    homeController.agreeButton.toggle();
    final signInService = SignInService();
    final phoneNumber = phoneController;
    final userName = usernameController;
    try {
      final registerResponse = await signInService.register(phoneNumber: phoneNumber, name: userName);
      print('------------------------------------------------------------------------ ${registerResponse}');
      if (registerResponse == 200) {
        homeController.agreeButton.toggle();
        await Get.to(() => OTPView(phoneNumber: phoneNumber, userName: userName));
      } else {
        final loginResponse = await signInService.login(phone: phoneNumber);
        print('------------------------------------------------------------------------ ${loginResponse}');

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

  Future<void> verifyOTP({required String phoneNumber, required List<TextEditingController> otpControllers, required String username}) async {
    final String otp = otpControllers.map((controller) => controller.text).join();
    print(phoneNumber);
    print(otp);
    if (otp.length == 4) {
      final response = await SignInService().otpCheck(phoneNumber: phoneNumber, otp: otp);
      print(response);
      if (response == 200) {
        final homeController = Get.find<HomeController>();
        final settingsController = Get.find<NewSettingsPageController>();
        homeController.selectedIndex.value = 0;

        settingsController.isLoginView.value = true;
        await settingsController.saveUserData(username, phoneNumber);
        showSnackBar('success', 'successOTP', AppColors.kSecondaryColor);

        await Get.offAll(() => BottomNavBar());
      } else {
        showSnackBar('error', 'errorOTP', Colors.red);
      }
    } else {
      showSnackBar('error', 'errorOTP', Colors.red);
    }
  }
}
