// lib/app/modules/home_view/components/categories_mini.dart
// ignore_for_file: deprecated_member_use

import 'package:atelyam/app/core/custom_widgets/listview_top_name_and_icon.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/modules/home_view/components/business_category_view/all_business_users_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessCategoryView extends StatelessWidget {
  final double screenWidth;
  final Future<List<BusinessCategoryModel>?> categoriesFuture;
  BusinessCategoryView({required this.screenWidth, required this.categoriesFuture, super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListviewTopNameAndIcon(
          text: 'types_of_business',
          icon: false,
          onTap: () {},
        ),
        SizedBox(
          height: screenWidth * 0.40,
          child: FutureBuilder<List<BusinessCategoryModel>?>(
            future: categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return EmptyStates().loadingData();
              } else if (snapshot.hasError || snapshot.data == null) {
                return EmptyStates().errorData(snapshot.hasError.toString());
              } else {
                final List<BusinessCategoryModel> categories = snapshot.data!;
                return ListView.builder(
                  itemCount: categories.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final category = categories[index];
                    return _businessCard(category);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  GestureDetector _businessCard(BusinessCategoryModel category) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AllBusinessUsersView(categoryId: category.id));
      },
      child: Hero(
        tag: category.name,
        child: Container(
          margin: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: screenWidth * 0.24,
                height: screenWidth * 0.24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kThirdColor.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadii.borderRadius99,
                  child: WidgetsMine().customCachedImage(category.img),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  category.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.darkMainColor,
                    height: 1.0,
                    fontWeight: FontWeight.w600,
                    fontSize: AppFontSizes.fontSize16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
