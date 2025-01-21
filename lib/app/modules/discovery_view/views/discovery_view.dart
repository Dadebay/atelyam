// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/modules/discovery_view/views/getPopular_screen.dart';
import 'package:atelyam/app/modules/discovery_view/views/getUsers_screen.dart';
import 'package:atelyam/app/modules/search_view/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DiscoveryView extends StatelessWidget {
  const DiscoveryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteMainColor,
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Get.to(() => GetPopularScreen());
              },
              title: Text('Get Popular'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              onTap: () {
                Get.to(() => GetUsersScreen());
              },
              title: Text('Get Users'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ],
        ),
      ),
    );
  }

  SliverLayoutBuilder buildAppBar() {
    return SliverLayoutBuilder(
      builder: (BuildContext context, constraints) {
        final bool scrolled = constraints.scrollOffset > 30;
        return SliverAppBar(
          expandedHeight: 110,
          floating: false,
          pinned: true,
          titleTextStyle: TextStyle(
            color: AppColors.whiteMainColor,
            fontSize: AppFontSizes.fontSize30,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            scrolled
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: () {
                      Get.to(() => const SearchView());
                    },
                    icon: const Icon(
                      IconlyLight.search,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
          ],
          backgroundColor: scrolled
              ? Colors.transparent.withOpacity(0.6)
              : Colors.transparent,
          title: scrolled
              ? null
              : Text(
                  'Fasonlar'.tr,
                ),
          flexibleSpace: _buildCategoryList(),
        );
      },
    );
  }

  Widget _buildCategoryList() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          itemCount: 20,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return FadeInRight(
              duration: Duration(milliseconds: 600 * index),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.only(left: 10, top: 6, bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kThirdColor.withOpacity(0.8),
                      spreadRadius: 2,
                      blurRadius: 3,
                    ),
                  ],
                  borderRadius: BorderRadii.borderRadius15,
                ),
                child: Text(
                  'Asda',
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.kPrimaryColor,
                    fontSize: AppFontSizes.fontSize16,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildGridView() {
    return SliverToBoxAdapter(
      child: MasonryGridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 20,
        mainAxisSpacing: 15.0,
        crossAxisSpacing: 15.0,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: index % 2 == 0 ? 230 : 250,
            child: const Text('asd'),
            // DiscoveryCard(
            //   showLogo: false,
            //   image: 'assets/image/fasonlar/${index + 1}.webp',
            //   homePageStyle: false,
            // ),
          );
        },
      ),
    );
  }
}
