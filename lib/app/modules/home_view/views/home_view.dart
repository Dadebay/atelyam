import 'package:atelyam/app/data/models/hashtag_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/modules/discovery_view/components/discovery_card.dart';
import 'package:atelyam/app/modules/home_view/components/all_products_view.dart';
import 'package:atelyam/app/modules/home_view/components/banners_view/banners_home_view.dart';
import 'package:atelyam/app/modules/home_view/components/business_category_view/business_category_view.dart';
import 'package:atelyam/app/modules/home_view/components/business_users/business_users_home_view.dart';
import 'package:atelyam/app/modules/home_view/controllers/home_controller.dart';
import 'package:atelyam/app/product/custom_widgets/index.dart';
import 'package:atelyam/app/product/empty_states/empty_states.dart';
import 'package:atelyam/app/product/theme/theme.dart';
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
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenHeight = constraints.maxHeight;
        final double screenWidth = constraints.maxWidth;

        return RefreshIndicator(
          onRefresh: homeController.refreshBanners,
          child: CustomScrollView(
            slivers: <Widget>[
              _buildSliverAppBar(screenHeight),
              _buildMainContent(screenWidth, screenHeight),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar(double screenHeight) {
    return SliverAppBar(
      floating: false,
      pinned: false,
      toolbarHeight: screenHeight * 0.04,
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

  Widget _buildMainContent(double screenWidth, double screenHeight) {
    return SliverToBoxAdapter(
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
          child: Column(
            children: [
              WidgetsMine().buildAnimatedWidget(
                Banners(),
                screenWidth >= 800 ? 400 : 220,
              ),
              WidgetsMine().buildAnimatedWidget(
                BusinessCategoryView(
                  screenWidth: screenWidth,
                  categoriesFuture: homeController.categoriesFuture.value,
                ),
                500,
              ),
              WidgetsMine().buildAnimatedWidget(const BusinessUsersHomeView(), 600),
              WidgetsMine().buildAnimatedWidget(_buildProducts(Size(screenWidth, screenHeight)), 700),
              Container(height: screenHeight * 0.20, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProducts(Size size) {
    return Obx(() {
      return FutureBuilder<List<HashtagModel>>(
        future: homeController.hashtagsFuture.value,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return EmptyStates().loadingData();
          } else if (snapshot.hasError) {
            return EmptyStates().errorData(snapshot.hasError.toString());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final hashtag = snapshot.data![index];
                return hashtag.count > 0 ? _buildProductList(size, hashtag) : const SizedBox.shrink();
              },
            );
          } else {
            return EmptyStates().noDataAvailable();
          }
        },
      );
    });
  }

  Widget _buildProductList(Size size, HashtagModel hashtagModel) {
    return Column(
      children: [
        ListviewTopNameAndIcon(
          text: hashtagModel.name,
          icon: true,
          onTap: () => Get.to(() => AllProductsView(title: hashtagModel.name, id: hashtagModel.id)),
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
                  itemBuilder: (context, index) {
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
