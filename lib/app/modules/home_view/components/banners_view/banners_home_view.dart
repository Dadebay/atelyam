//lib/app/modules/home_view/components/banner/banners.dart
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/banner_model.dart';
import 'package:atelyam/app/modules/home_view/components/banners_view/banner_card.dart';
import 'package:atelyam/app/modules/home_view/controllers/home_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Banners extends StatelessWidget {
  Banners({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool sizeValue = size.width >= 800;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => FutureBuilder<List<BannerModel>>(
            future: controller.bannersFuture.value,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return EmptyStates().loadingData();
              } else if (snapshot.hasError) {
                return EmptyStates().errorData(snapshot.hasError.toString());
              } else if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return EmptyStates().noBannersAvailable();
                }
                return _buildCarousel(snapshot.data!);
              } else {
                return EmptyStates().noBannersAvailable();
              }
            },
          ),
        ),
        _buildDots(sizeValue, controller),
      ],
    );
  }

  Widget _buildCarousel(List<BannerModel> banners) {
    return CarouselSlider.builder(
      itemCount: banners.length,
      itemBuilder: (context, index, count) {
        return BannerCard(banner: banners[index]);
      },
      options: CarouselOptions(
        onPageChanged: (index, CarouselPageChangedReason a) {
          controller.carouselSelectedIndex.value = index;
        },
        height: 250,
        viewportFraction: 1.0,
        autoPlay: true,
        scrollPhysics: const BouncingScrollPhysics(),
        autoPlayCurve: Curves.fastLinearToSlowEaseIn,
        autoPlayAnimationDuration: const Duration(milliseconds: 2000),
      ),
    );
  }

  Widget _buildDots(bool sizeValue, HomeController controller) {
    return SizedBox(
      height: sizeValue ? 40 : 20,
      width: Get.size.width,
      child: Center(
        child: Obx(
          () => FutureBuilder<List<BannerModel>>(
            future: controller.bannersFuture.value,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const SizedBox();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildDot(index, sizeValue, controller);
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index, bool sizeValue, HomeController controller) {
    return Obx(
      () => AnimatedContainer(
        margin: EdgeInsets.symmetric(horizontal: sizeValue ? 8 : 4),
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
        height: controller.carouselSelectedIndex.value == index ? (sizeValue ? 22 : 16) : (sizeValue ? 16 : 10),
        width: controller.carouselSelectedIndex.value == index ? (sizeValue ? 21 : 15) : (sizeValue ? 16 : 10),
        decoration: BoxDecoration(
          color: controller.carouselSelectedIndex.value == index ? Colors.transparent : AppColors.kSecondaryColor,
          shape: BoxShape.circle,
          border: controller.carouselSelectedIndex.value == index ? Border.all(color: AppColors.kPrimaryColor, width: 3) : Border.all(color: Colors.white),
        ),
      ),
    );
  }
}
