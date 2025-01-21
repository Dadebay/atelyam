// ignore_for_file: deprecated_member_use

import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/banner_model.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:atelyam/app/modules/home_view/components/banner/banners_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerCard extends StatelessWidget {
  BannerCard({required this.banner, super.key});
  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        await Get.to(() => BannersProfile(banner: banner));
      },
      child: _buildBannerContainer(size),
    );
  }

  final AuthController authController = Get.find();

  Widget _buildBannerContainer(Size size) {
    return Container(
      margin: const EdgeInsets.all(15),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadii.borderRadius30,
        boxShadow: [
          BoxShadow(
            color: AppColors.kThirdColor.withOpacity(0.2),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadii.borderRadius30,
        child: CachedNetworkImage(
          fadeInCurve: Curves.ease,
          imageUrl: authController.ipAddress + banner.img,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadii.borderRadius10,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => EmptyStates().loadingData(),
          errorWidget: (context, url, error) => EmptyStates().noMiniCategoryImage(),
        ),
      ),
    );
  }
}
