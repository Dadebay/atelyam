import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/background_pattern.dart';
import 'package:atelyam/app/core/custom_widgets/listview_top_name_and_icon.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/hashtag_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/modules/discovery_view/components/discovery_card.dart';
import 'package:atelyam/app/modules/home_view/components/all_products_view.dart';
import 'package:atelyam/app/modules/home_view/components/banners_view/banners_home_view.dart';
import 'package:atelyam/app/modules/home_view/components/business_category_view/business_category_view.dart';
import 'package:atelyam/app/modules/home_view/components/business_users/business_users_home_view.dart';
import 'package:atelyam/app/modules/home_view/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundPattern(),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double screenHeight = constraints.maxHeight;
            final double screenWidth = constraints.maxWidth;

            return RefreshIndicator(
              onRefresh: () => homeController.refreshBanners(),
              child: CustomScrollView(
                slivers: <Widget>[
                  _buildSliverAppBar(screenHeight),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadii.borderRadius40,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              FadeInUp(
                                delay: const Duration(milliseconds: 400),
                                child: Banners(),
                              ),
                              FadeInUp(
                                delay: const Duration(milliseconds: 500),
                                child: BusinessCategoryView(
                                  screenWidth: screenWidth,
                                  categoriesFuture: homeController.categoriesFuture.value,
                                ),
                              ),
                              FadeInUp(
                                delay: const Duration(milliseconds: 600),
                                child: const BusinessUsersHomeView(),
                              ),
                              FadeInUp(
                                delay: const Duration(milliseconds: 700),
                                child: _buildProducts(size: Size(screenWidth, screenHeight)),
                              ),
                              Container(
                                height: screenHeight * 0.20,
                                color: Colors.white,
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
          },
        ),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar(double screenHeight) {
    return SliverAppBar(
      floating: false,
      pinned: false,
      toolbarHeight: screenHeight * 0.06,
      backgroundColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Text(
          'home'.tr,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.fontSize24,
          ),
        ),
      ),
    );
  }

  Widget _buildProducts({required Size size}) {
    return Obx(() {
      return FutureBuilder<List<HashtagModel>>(
        future: homeController.hashtagsFuture.value,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return EmptyStates().loadingData();
          } else if (snapshot.hasError) {
            return EmptyStates().errorData(snapshot.hasError.toString());
          } else if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              print(snapshot.data!.length);
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final hashtag = snapshot.data![index];
                  print(hashtag.count);
                  return hashtag.count <= 0 ? const SizedBox.shrink() : _buildProductList(size: size, hashtagModel: hashtag);
                },
              );
            } else {
              return EmptyStates().noDataAvailable();
            }
          } else {
            return const Text('no data');
          }
        },
      );
    });
  }

  Widget _buildProductList({required Size size, required HashtagModel hashtagModel}) {
    return Wrap(
      children: [
        ListviewTopNameAndIcon(
          text: hashtagModel.name,
          icon: true,
          onTap: () {
            Get.to(() => AllProductsView(title: hashtagModel.name, id: hashtagModel.id));
          },
        ),
        SizedBox(
          height: size.height * 0.35,
          child: FutureBuilder<List<ProductModel>>(
            future: homeController.fetchProductsByHashtagId(hashtagModel.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return EmptyStates().loadingData();
              } else if (snapshot.hasError) {
                return EmptyStates().errorData(snapshot.hasError.toString());
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemExtent: size.width * 0.55,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return DiscoveryCard(
                      homePageStyle: true,
                      productModel: snapshot.data![index],
                    );
                  },
                );
              } else {
                return EmptyStates().noDataAvailable();
              }
            },
          ),
        ),
      ],
    );
  }
}
