import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/background_pattern.dart';
import 'package:atelyam/app/core/custom_widgets/dialogs.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/modules/home_view/views/bottom_nav_bar_view.dart';
import 'package:atelyam/app/modules/settings_view/components/settings_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends StatelessWidget {
  final NewSettingsPageController settingsController = Get.put<NewSettingsPageController>(NewSettingsPageController());

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (BuildContext context, constraints) {
        final scrolled = constraints.scrollOffset > 310;
        return SliverAppBar(
          expandedHeight: 300,
          floating: false,
          pinned: true,
          backgroundColor: scrolled ? Colors.transparent.withOpacity(0.6) : Colors.transparent,
          title: Text(
            'profil'.tr,
          ),
          titleTextStyle: TextStyle(color: AppColors.whiteMainColor, fontSize: AppFontSizes.fontSize24, fontWeight: FontWeight.w600),
          flexibleSpace: FlexibleSpaceBar(
            background: GestureDetector(
              onTap: () => Dialogs().showAvatarDialog(),
              child: Obx(
                () {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 62,
                          child: CircleAvatar(
                            radius: 60,
                            child: Image.asset(
                              settingsController.avatars[settingsController.selectedAvatarIndex.value],
                              width: 90,
                              height: 90,
                            ),
                          ),
                        ),
                      ),
                      FadeInDown(
                        duration: const Duration(milliseconds: 700),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            settingsController.username.value.isEmpty ? 'Ulanyjy 007 ' : settingsController.username.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.whiteMainColor, fontWeight: FontWeight.bold, fontSize: AppFontSizes.fontSize20 + 2),
                          ),
                        ),
                      ),
                      FadeInDown(
                        duration: const Duration(milliseconds: 900),
                        child: Text(
                          settingsController.phoneNumber.value.isEmpty ? ' +993-60-00-00-00' : '+993-${formatPhoneNumber(settingsController.phoneNumber.value)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppColors.warmWhiteColor, fontSize: AppFontSizes.fontSize16),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  String formatPhoneNumber(String phoneNumber) {
    // Remove any existing hyphens
    phoneNumber = phoneNumber.replaceAll('-', '');

    // Add a hyphen after every 2 characters
    String formattedNumber = '';
    for (int i = 0; i < phoneNumber.length; i++) {
      formattedNumber += phoneNumber[i];
      if ((i + 1) % 2 == 0 && i != phoneNumber.length - 1) {
        formattedNumber += '-';
      }
    }

    return formattedNumber;
  }

  Widget _buildSettingsList() {
    return FutureBuilder<String?>(
      future: Auth().getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(child: EmptyStates().loadingData());
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(child: EmptyStates().errorData(snapshot.error.toString()));
        } else {
          final String? token = snapshot.data;
          final List<Map<String, dynamic>> currentSettingsViews = token != null && token.isNotEmpty ? loggedInSettingsViews : settingsViews;

          return SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: ListView.builder(
                itemCount: currentSettingsViews.length,
                padding: const EdgeInsets.only(top: 20),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final item = currentSettingsViews[index];
                  return token != null && token.isNotEmpty && item['name'] == 'login'
                      ? FadeInUp(
                          duration: Duration(milliseconds: 500 * index),
                          child: SettingsButton(
                            name: 'logout'.tr,
                            lang: false,
                            onTap: () {
                              Get.bottomSheet(
                                Dialogs().logOut(
                                  onYestapped: () async {
                                    settingsController.isLoginView.value = false;
                                    await Auth().logout();
                                    Get.back();
                                    await Get.offAll(() => BottomNavBar());
                                    showSnackBar('logout', 'logOutUser', Colors.red);
                                  },
                                ),
                              );
                            },
                            icon: Icon(IconlyLight.logout, color: AppColors.kSecondaryColor),
                          ),
                        )
                      : FadeInUp(
                          duration: Duration(milliseconds: 500 * index),
                          child: SettingsButton(
                            name: "${item['name']}".tr,
                            lang: item['name'] == 'lang',
                            onTap: () {
                              if (item['name'] == 'lang') {
                                settingsController.showLanguageDialog(context);
                              } else {
                                Get.to(item['page']);
                              }
                            },
                            icon: Icon(item['icon'], color: AppColors.kSecondaryColor),
                          ),
                        );
                },
              ),
            ),
          );
        }
      },
    );
  }

  SliverToBoxAdapter _buildSpacer() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        height: Get.size.height / 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 0, left: 0, right: 0, child: BackgroundPattern()),
        CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            _buildSettingsList(),
            _buildSpacer(),
          ],
        ),
      ],
    );
  }
}
