import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/category_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/hashtag_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:atelyam/app/modules/discovery_view/components/discovery_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class CategoryProductView extends StatefulWidget {
  final CategoryModel categoryModel;

  const CategoryProductView({required this.categoryModel, super.key});

  @override
  _CategoryProductViewState createState() => _CategoryProductViewState();
}

class _CategoryProductViewState extends State<CategoryProductView> {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: Get.size.height * 0.80,
              child: CachedNetworkImage(
                imageUrl: '${authController.ipAddress}${widget.categoryModel.logo}',
                fit: BoxFit.cover,
                placeholder: (context, url) => EmptyStates().loadingData(),
                errorWidget: (context, url, error) => EmptyStates().noMiniCategoryImage(),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: imagePart(),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    floating: false,
                    automaticallyImplyLeading: false,
                    pinned: false,
                    expandedHeight: constraints.maxHeight * 0.20,
                    backgroundColor: Colors.transparent,
                    leadingWidth: 70,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black38,
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadii.borderRadius20,
                            side: BorderSide(
                              color: AppColors.whiteMainColor,
                            ),
                          ),
                        ),
                        child: const Icon(
                          IconlyLight.arrow_left_2,
                          size: 20,
                          color: AppColors.warmWhiteColor,
                        ),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.8),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: FutureBuilder<List<ProductModel>>(
                        future: HashtagService().fetchProductsByHashtagId(widget.categoryModel.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: EmptyStates().loadingData()); // Use Center instead of SliverToBoxAdapter
                          } else if (snapshot.hasError) {
                            return Center(child: EmptyStates().errorData(snapshot.hasError.toString())); // Use Center instead of SliverToBoxAdapter
                          } else if (snapshot.hasData) {
                            return MasonryGridView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(top: 20),
                              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: snapshot.data!.length,
                              mainAxisSpacing: 15.0,
                              crossAxisSpacing: 15.0,
                              itemBuilder: (BuildContext context, int index) {
                                return FadeInUp(
                                  delay: Duration(milliseconds: 200 * index),
                                  child: SizedBox(
                                    height: index % 2 == 0 ? 250 : 200,
                                    child: DiscoveryCard(
                                      homePageStyle: false,
                                      productModel: snapshot.data![index],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(child: Text('No data')); // Use Center instead of SliverToBoxAdapter
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  SizedBox imagePart() {
    return SizedBox(
      height: Get.size.height * 0.80,
      child: Hero(
        tag: widget.categoryModel.name,
        child: ClipRRect(
          borderRadius: BorderRadii.borderRadius30,
          child: CachedNetworkImage(
            imageUrl: '${authController.ipAddress}${widget.categoryModel.logo}',
            fit: BoxFit.cover,
            placeholder: (context, url) => EmptyStates().loadingData(),
            errorWidget: (context, url, error) => EmptyStates().noMiniCategoryImage(),
          ),
        ),
      ),
    );
  }
}
