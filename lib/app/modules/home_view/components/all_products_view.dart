import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/background_pattern.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/modules/discovery_view/components/discovery_card.dart';
import 'package:atelyam/app/modules/home_view/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllProductsView extends StatefulWidget {
  final String title;
  final int id;
  const AllProductsView({required this.title, required this.id, super.key});

  @override
  State<AllProductsView> createState() => _AllProductsViewState();
}

class _AllProductsViewState extends State<AllProductsView> {
  final HomeController _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _homeController.initializeProducts(widget.id);
    _homeController.isFilterExpanded.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return Stack(
          children: [
            BackgroundPattern(),
            if (_homeController.isLoadingProducts.value)
              EmptyStates().loadingData()
            else if (_homeController.allProducts.isEmpty)
              Positioned.fill(
                child: EmptyStates().noDataAvailablePage(),
              )
            else
              _buildProductGrid(),
            _buildFilterContainer(context),
            _appBar(),
          ],
        );
      }),
    );
  }

  Container _appBar() {
    return Container(
      height: kToolbarHeight + 40,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 45,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadii.borderRadius15,
                  side: BorderSide(
                    color: AppColors.whiteMainColor.withOpacity(0.2),
                  ),
                ),
              ),
              child: const Icon(
                IconlyLight.arrow_left_2,
                color: AppColors.warmWhiteColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              widget.title.tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.whiteMainColor, fontSize: AppFontSizes.fontSize20 + 2, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Positioned.fill(
      child: SmartRefresher(
        controller: _homeController.refreshController,
        enablePullUp: true,
        scrollDirection: Axis.vertical,
        onRefresh: () => _homeController.refreshProducts(widget.id),
        onLoading: () => _homeController.loadMoreProducts(widget.id),
        child: Container(
          margin: const EdgeInsets.only(top: kToolbarHeight + 40),
          child: MasonryGridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: _homeController.allProducts.length,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            itemBuilder: (context, index) {
              final product = _homeController.allProducts[index];
              if (index > 10) {
                return SizedBox(
                  height: index % 2 == 0 ? 250 : 220,
                  child: DiscoveryCard(
                    productModel: product,
                    homePageStyle: false,
                  ),
                );
              }

              // Apply animation only to the first 10 items
              return FadeInUp(
                duration: Duration(milliseconds: 300 * index),
                child: SizedBox(
                  height: index % 2 == 0 ? 250 : 220,
                  child: DiscoveryCard(
                    productModel: product,
                    homePageStyle: false,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterContainer(BuildContext context) {
    return Obx(() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {
            _homeController.toggleFilterExpanded(); // Filtre durumunu değiştir
            print(
              _homeController.selectedFilter.value,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _homeController.isFilterExpanded.value ? MediaQuery.of(context).size.height * 0.4 : 60,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: AppColors.whiteMainColor,
              borderRadius: BorderRadii.borderRadius20,
            ),
            child: _homeController.isFilterExpanded.value
                ? ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 10),
                    children: [
                      radioListTileButton(text: 'last', value: FilterOption.last),
                      radioListTileButton(text: 'first', value: FilterOption.first),
                      radioListTileButton(text: 'viewcount', value: FilterOption.viewCount),
                      radioListTileButton(text: 'LowPrice', value: FilterOption.lowPrice),
                      radioListTileButton(text: 'HighPrice', value: FilterOption.highPrice),
                      TextButton(
                        onPressed: () {
                          _homeController.toggleFilterExpanded(); // Filtre durumunu değiştir
                        },
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(color: Colors.black, fontSize: AppFontSizes.fontSize20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      'filter'.tr,
                      style: TextStyle(
                        color: AppColors.darkMainColor,
                        fontSize: AppFontSizes.fontSize20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ),
      );
    });
  }

  Widget radioListTileButton({required String text, required FilterOption value}) {
    return Obx(
      () => RadioListTile(
        title: Text(
          text.tr,
          maxLines: 1,
          style: TextStyle(
            color: AppColors.darkMainColor,
            fontSize: AppFontSizes.fontSize16,
            fontWeight: _homeController.selectedFilter.value == value ? FontWeight.bold : FontWeight.w300,
          ),
        ),
        value: value,
        groupValue: _homeController.selectedFilter.value,
        onChanged: (FilterOption? value) {
          if (value != null) {
            _homeController.selectedFilter.value = value;
            _homeController.activeFilter.value = text.toString();
            _homeController.initializeProducts(widget.id);
            _homeController.toggleFilterExpanded();
          }
        },
      ),
    );
  }
}
