import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:atelyam/app/modules/home_view/components/business_users/business_user_profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class BrendCard extends StatelessWidget {
  BrendCard({required this.showAllBrends, required this.businessUserModel, super.key});
  final bool showAllBrends;
  final BusinessUserModel businessUserModel;
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => BrandsProfile(
            businessUserModel: businessUserModel,
            categoryID: 2,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadii.borderRadius50,
          boxShadow: [
            BoxShadow(
              color: showAllBrends ? AppColors.whiteMainColor.withOpacity(.4) : AppColors.kThirdColor.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 4,
            ),
          ],
          color: AppColors.kSecondaryColor,
          border: Border.all(color: AppColors.kPrimaryColor.withOpacity(.2)),
        ),
        child: Column(
          children: [topPart(), masonGridView()],
        ),
      ),
    );
  }

  Expanded masonGridView() {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 12, bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadii.borderRadius40, border: Border.all(color: AppColors.whiteMainColor.withOpacity(.9))),
                height: Get.size.height,
                width: Get.size.width,
                child: ClipRRect(
                  borderRadius: BorderRadii.borderRadius40,
                  child: CachedNetworkImage(
                    fadeInCurve: Curves.ease,
                    imageUrl: authController.ipAddress + businessUserModel.images!.first,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadii.borderRadius10,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => EmptyStates().loadingData(),
                    errorWidget: (context, url, error) => EmptyStates().noMiniCategoryImage(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadii.borderRadius25, border: Border.all(color: AppColors.whiteMainColor.withOpacity(.9))),
                        height: Get.size.height,
                        width: Get.size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadii.borderRadius25,
                          child: businessUserModel.images!.length < 2
                              ? EmptyStates().noMiniCategoryImage()
                              : CachedNetworkImage(
                                  fadeInCurve: Curves.ease,
                                  imageUrl: authController.ipAddress + businessUserModel.images![1],
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadii.borderRadius10,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => EmptyStates().loadingData(),
                                  errorWidget: (context, url, error) => EmptyStates().noMiniCategoryImage(),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Container(
                        height: Get.size.height,
                        width: Get.size.width,
                        decoration: BoxDecoration(borderRadius: BorderRadii.borderRadius25, border: Border.all(color: AppColors.whiteMainColor.withOpacity(.9))),
                        child: ClipRRect(
                          borderRadius: BorderRadii.borderRadius25,
                          child: businessUserModel.images!.length < 2
                              ? EmptyStates().noMiniCategoryImage()
                              : CachedNetworkImage(
                                  fadeInCurve: Curves.ease,
                                  imageUrl: authController.ipAddress + businessUserModel.images![2],
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadii.borderRadius10,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => EmptyStates().loadingData(),
                                  errorWidget: (context, url, error) => EmptyStates().noMiniCategoryImage(),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded topPart() {
    return Expanded(
      flex: 3,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
              height: Get.size.height,
              width: Get.size.width,
              decoration: BoxDecoration(borderRadius: BorderRadii.borderRadius30, border: Border.all(color: AppColors.whiteMainColor.withOpacity(.9))),
              child: ClipRRect(
                borderRadius: BorderRadii.borderRadius30,
                child: CachedNetworkImage(
                  fadeInCurve: Curves.ease,
                  imageUrl: authController.ipAddress + businessUserModel.backPhoto,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadii.borderRadius10,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => EmptyStates().loadingData(),
                  errorWidget: (context, url, error) => EmptyStates().noMiniCategoryImage(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: showAllBrends ? 5 : 4,
            child: Container(
              padding: EdgeInsets.only(top: showAllBrends ? 20 : 25, bottom: showAllBrends ? 10 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    businessUserModel.businessName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.whiteMainColor, fontSize: AppFontSizes.fontSize20),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(
                            Icons.call_outlined,
                            color: AppColors.whiteMainColor,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            businessUserModel.businessPhone.isEmpty ? 'phone_number'.tr : businessUserModel.businessPhone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.whiteMainColor, fontSize: AppFontSizes.fontSize14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(
                          IconlyLight.image_2,
                          color: AppColors.whiteMainColor,
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '352 Fason',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.whiteMainColor, fontSize: AppFontSizes.fontSize14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
