import 'package:atelyam/app/core/custom_widgets/background_pattern.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/category_model.dart';
import 'package:atelyam/app/data/service/category_service.dart';
import 'package:atelyam/app/modules/category_view/components/category_card.dart';
import 'package:atelyam/app/modules/category_view/views/category_products_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});
  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<CategoryModel>> _categoriesFuture;
  @override
  void initState() {
    super.initState();
    _categoriesFuture = CategoryService().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundPattern(),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  floating: false,
                  pinned: false,
                  expandedHeight: constraints.maxHeight * 0.06,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    'category'.tr,
                    style: TextStyle(
                      color: AppColors.whiteMainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.fontSize24,
                    ),
                  ),
                ),
                FutureBuilder<List<CategoryModel>>(
                  future: _categoriesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SliverToBoxAdapter(child: EmptyStates().loadingData());
                    } else if (snapshot.hasError) {
                      return SliverToBoxAdapter(child: EmptyStates().errorData(snapshot.hasError.toString()));
                    } else if (snapshot.hasData) {
                      final categories = snapshot.data!;
                      final int length = categories.length;
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: index == length - 1 ? 100 : 1),
                              child: CategoryCard(
                                categoryModel: categories[index],
                                onTap: () {
                                  Get.to(
                                    () => CategoryProductView(
                                      categoryModel: categories[index],
                                    ),
                                  );
                                },
                                scrollableState: Scrollable.of(context),
                              ),
                            );
                          },
                          childCount: categories.length,
                        ),
                      );
                    } else {
                      return SliverToBoxAdapter(child: EmptyStates().noCategoriesAvailable());
                    }
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
