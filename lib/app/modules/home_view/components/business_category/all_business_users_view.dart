// lib/app/modules/all_brend_view/views/all_brend_view.dart

import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/background_pattern.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/service/business_user_service.dart';
import 'package:atelyam/app/modules/home_view/components/business_category/business_user_card_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBusinessUsersView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final int categoryId;

  AllBusinessUsersView({required this.categoryId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                    automaticallyImplyLeading: true,
                    foregroundColor: AppColors.whiteMainColor,
                    title: Text(
                      'commecial_users'.tr,
                      style: TextStyle(
                        color: AppColors.whiteMainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.fontSize24,
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: FutureBuilder<List<BusinessUserModel>>(
                      future: BusinessUserService().fetchUsers(categoryId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return EmptyStates().loadingData();
                        } else if (snapshot.hasError) {
                          return EmptyStates().errorData(snapshot.hasError.toString());
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return EmptyStates().noDataAvailablePage();
                        } else {
                          final List<BusinessUserModel> categories = snapshot.data!;
                          return GridView.builder(
                            itemCount: categories.length,
                            padding: EdgeInsets.zero,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8),
                            itemBuilder: (BuildContext context, index) {
                              return FadeInUp(
                                duration: Duration(milliseconds: 500 * index),
                                child: BusinessUsersCardView(
                                  category: categories[index],
                                  categoryID: categoryId,
                                ),
                              );
                            },
                          );
                        }
                      },
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
}
