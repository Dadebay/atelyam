import 'package:atelyam/app/core/custom_widgets/agree_button_view.dart';
import 'package:atelyam/app/core/custom_widgets/background_pattern.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/hashtag_service.dart';
import 'package:atelyam/app/modules/discovery_view/components/discovery_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class AllProductsView extends StatelessWidget {
  const AllProductsView({required this.title, required this.id, super.key});
  final String title;
  final int id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15.0),
        child: AgreeButton(
          text: 'filter'.tr,
          onTap: () {},
        ),
      ),
      body: Stack(
        children: [
          BackgroundPattern(),
          CustomScrollView(
            slivers: <Widget>[
              _buildAppBar(),
              _buildGridView(),
            ],
          ),
        ],
      ),
    );
  }

  SliverLayoutBuilder _buildAppBar() {
    return SliverLayoutBuilder(
      builder: (BuildContext context, constraints) {
        return SliverAppBar(
          expandedHeight: 60,
          floating: false,
          foregroundColor: AppColors.whiteMainColor,
          pinned: false,
          titleTextStyle: TextStyle(color: AppColors.whiteMainColor, fontSize: AppFontSizes.fontSize30, fontWeight: FontWeight.bold),
          backgroundColor: Colors.transparent,
          title: Text(
            title.tr,
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return FutureBuilder<List<ProductModel>>(
      future: HashtagService().fetchProductsByHashtagId(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(child: EmptyStates().loadingData());
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(child: EmptyStates().errorData(snapshot.hasError.toString()));
        } else if (snapshot.hasData) {
          return SliverToBoxAdapter(
            child: MasonryGridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: index % 2 == 0 ? 300 : 250,
                  child: DiscoveryCard(
                    homePageStyle: false,
                    productModel: snapshot.data![index],
                  ),
                );
              },
            ),
          );
        }
        return SliverToBoxAdapter(child: EmptyStates().noDataAvailable());
      },
    );
  }
}
