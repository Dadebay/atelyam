// lib/app/modules/all_brend_view/views/all_brend_view.dart

import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/background_pattern.dart';
import 'package:atelyam/app/core/custom_widgets/transparent_app_bar.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/service/business_user_service.dart';
import 'package:atelyam/app/modules/home_view/components/business_category_view/business_user_card_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBusinessUsersView extends StatelessWidget {
  final int categoryId;

  AllBusinessUsersView({required this.categoryId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundPattern(),
          TransparentAppBar(title: 'commecial_users'.tr, removeLeading: false, color: AppColors.whiteMainColor),
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 40),
            child: FutureBuilder<List<BusinessUserModel>>(
              future: BusinessUserService().getBusinessAccountsByCategory(categoryID: categoryId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return EmptyStates().loadingData();
                } else if (snapshot.hasError) {
                  return EmptyStates().errorData(snapshot.hasError.toString());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return EmptyStates().noDataAvailablePage(textColor: AppColors.whiteMainColor);
                } else {
                  final List<BusinessUserModel> categories = snapshot.data!;
                  return GridView.builder(
                    itemCount: categories.length,
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8),
                    itemBuilder: (BuildContext context, index) {
                      return FadeInUp(
                        duration: Duration(milliseconds: 200 * index),
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
      ),
    );
  }
}
