import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/transparent_app_bar.dart';
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
          topImage(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: imagePart(),
          ),
          TransparentAppBar(
            title: widget.categoryModel.name,
            removeLeading: false,
            color: Colors.white,
          ),
          // Position the grid container below the hero image
          Positioned(
            top: Get.size.height * 0.2, // Adjust this value for overlap
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: FutureBuilder<List<ProductModel>>(
                future: HashtagService().fetchProductsByHashtagId(hashtagId: widget.categoryModel.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return EmptyStates().loadingData();
                  } else if (snapshot.hasError) {
                    return EmptyStates().errorData(snapshot.error.toString());
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return EmptyStates().noDataAvailable();
                  } else if (snapshot.hasData) {
                    return MasonryGridView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 30, bottom: 100),
                      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: snapshot.data!.length,
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 15.0,
                      itemBuilder: (BuildContext context, int index) {
                        if (index > 10) {
                          return SizedBox(
                            height: index % 2 == 0 ? 250 : 220,
                            child: DiscoveryCard(
                              productModel: snapshot.data![index],
                              homePageStyle: false,
                            ),
                          );
                        }

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
                    return const Center(child: Text('No data'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Positioned topImage() {
    return Positioned(
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
    );
  }

  SizedBox imagePart() {
    return SizedBox(
      height: Get.size.height * 0.60, // Reduced height for better layout
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
