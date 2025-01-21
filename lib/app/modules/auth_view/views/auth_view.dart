import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/agree_button_view.dart';
import 'package:atelyam/app/core/custom_widgets/background_pattern.dart';
import 'package:atelyam/app/core/custom_widgets/custom_text_field.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/modules/auth_view/views/otp_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class AuthView extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
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
              clipper: WaveClipper(),
              child: BackgroundPattern(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            height: Get.size.height / 2,
            child: logoPart(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: WaveClipper2(),
              child: Container(
                color: Colors.white,
                height: Get.size.height / 1.9,
                padding: EdgeInsets.only(bottom: 40, top: 80),
                child: Obx(
                  () => Column(
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
                              fontSize: AppFontSizes.fontSize20 - 2,
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
                          customColor: AppColors.kPrimaryColor.withOpacity(.4),
                          isNumber: false,
                          prefixIcon: IconlyLight.profile,
                          unFocus: false,
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 900),
                        child: CustomTextField(
                          labelName: 'phone_number',
                          controller: phoneController,
                          borderRadius: true,
                          prefixIcon: IconlyLight.call,
                          focusNode: phoneFocusNode,
                          customColor: AppColors.kPrimaryColor.withOpacity(.4),
                          requestfocusNode: usernameFocusNode,
                          isNumber: true,
                          unFocus: false,
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: AgreeButton(
                            onTap: () {
                              SignInService().register(phoneNumber: phoneController.text, name: usernameController.text).then((value) {
                                if (value.toString() == '200') {
                                  Get.to(() => OTPView(phoneNumber: phoneController.text, userName: usernameController.text));
                                } else if (value.toString() == '409') {
                                  SignInService().login(phone: phoneController.text).then((value) {
                                    if (value.toString() == '200') {
                                      Get.to(
                                        () => OTPView(
                                          phoneNumber: phoneController.text,
                                          userName: usernameController.text,
                                        ),
                                      );
                                    } else {
                                      showSnackBar('error', 'errorLogin', Colors.red);
                                    }
                                  });
                                } else {
                                  showSnackBar('error', 'errorRegister', Colors.red);
                                }
                              });
                            },
                            text: 'login',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget logoPart() {
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
              fontSize: AppFontSizes.fontSize24,
            ),
          ),
        ),
      ),
      FadeInDown(
        duration: const Duration(milliseconds: 700),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'welcome'.tr,
            style: TextStyle(
              color: AppColors.whiteMainColor,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.fontSize20,
            ),
          ),
        ),
      ),
    ],
  );
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.06); // Başlangıç noktası en üstte (y = 0)

    // İlk dalga: Ortadan yukarı çıkıp sonra aşağı inen
    final firstControlPointUp = Offset(size.width * 0.28, size.height * -0.05); // Yukarı çıkan kontrol noktası
    final firstEndPointUp = Offset(size.width * 0.5, size.height * 0.06); // Yukarı çıkışın bitiş noktası
    path.quadraticBezierTo(
      firstControlPointUp.dx,
      firstControlPointUp.dy,
      firstEndPointUp.dx,
      firstEndPointUp.dy,
    );

    final firstControlPointDown = Offset(size.width * 0.75, size.height * 0.15); // Aşağı inen kontrol noktası
    final firstEndPointDown = Offset(size.width, size.height * 0.05); // Aşağı inişin bitiş noktası
    path.quadraticBezierTo(
      firstControlPointDown.dx,
      firstControlPointDown.dy,
      firstEndPointDown.dx,
      firstEndPointDown.dy,
    );

    path.lineTo(size.width, size.height); // Sağ alt köşeye çizgi çek
    path.lineTo(0, size.height); // Sol alt köşeye çizgi çek
    path.close(); // Yolu kapat
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // Yeniden kesme işlemi gerekmiyor
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.4); // Başlangıç noktası

    // İlk dalga (daha kısa ve yakın)
    final firstControlPoint = Offset(size.width * 0.22, size.height * 0.35); // Kontrol noktası
    final firstEndPoint = Offset(size.width * 0.44, size.height * 0.4); // Bitiş noktası
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // İkinci dalga (daha kısa ve yakın)
    final secondControlPoint = Offset(size.width * 0.7, size.height * 0.45); // Kontrol noktası
    final secondEndPoint = Offset(size.width, size.height * 0.34); // Bitiş noktası
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0); // Sağ üst köşeye çizgi çek
    path.close(); // Yolu kapat
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // Yeniden kesme işlemi gerekmiyor
  }
}
