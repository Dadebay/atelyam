import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:atelyam/app/modules/home_view/components/business_users/business_user_profile_view.dart';
import 'package:atelyam/app/product/custom_widgets/widgets.dart';
import 'package:atelyam/app/product/empty_states/empty_states.dart';
import 'package:atelyam/app/product/theme/color_constants.dart';
import 'package:atelyam/app/product/theme/theme.dart';
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
          () => BusinessUserProfileView(
            businessUserModelFromOutside: businessUserModel,
            categoryID: businessUserModel.userID!,
            whichPage: 'popular',
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadii.borderRadius50,
          boxShadow: [
            BoxShadow(
              color: showAllBrends ? ColorConstants.whiteMainColor.withOpacity(.4) : ColorConstants.kThirdColor.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 4,
            ),
          ],
          color: ColorConstants.kSecondaryColor,
          border: Border.all(color: ColorConstants.kPrimaryColor.withOpacity(.2)),
        ),
        child: Column(
          children: [
            topPart(),
            masonGridView(),
          ],
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
                decoration: BoxDecoration(borderRadius: BorderRadii.borderRadius40, border: Border.all(color: ColorConstants.whiteMainColor.withOpacity(.9))),
                height: Get.size.height,
                width: Get.size.width,
                child: businessUserModel.images!.isEmpty
                    ? Icon(
                        IconlyLight.image_2,
                        color: ColorConstants.whiteMainColor.withOpacity(.6),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadii.borderRadius40,
                        child: WidgetsMine().customCachedImage(
                          businessUserModel.images!.first,
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
                        decoration: BoxDecoration(borderRadius: BorderRadii.borderRadius25, border: Border.all(color: ColorConstants.whiteMainColor.withOpacity(.9))),
                        height: Get.size.height,
                        width: Get.size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadii.borderRadius25,
                          child: businessUserModel.images!.length < 2
                              ? Icon(
                                  IconlyLight.image_2,
                                  color: ColorConstants.whiteMainColor.withOpacity(.6),
                                )
                              : WidgetsMine().customCachedImage(businessUserModel.images![1]),
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
                        decoration: BoxDecoration(borderRadius: BorderRadii.borderRadius25, border: Border.all(color: ColorConstants.whiteMainColor.withOpacity(.9))),
                        child: ClipRRect(
                          borderRadius: BorderRadii.borderRadius25,
                          child: businessUserModel.images!.length < 3
                              ? Icon(
                                  IconlyLight.image_2,
                                  color: ColorConstants.whiteMainColor.withOpacity(.6),
                                )
                              : WidgetsMine().customCachedImage(businessUserModel.images![2]),
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
              decoration: BoxDecoration(borderRadius: BorderRadii.borderRadius30, border: Border.all(color: ColorConstants.whiteMainColor.withOpacity(.9))),
              child: ClipRRect(
                borderRadius: BorderRadii.borderRadius30,
                child: CachedNetworkImage(
                  fadeInCurve: Curves.ease,
                  imageUrl: authController.ipAddress.value + businessUserModel.backPhoto,
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
                    style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.whiteMainColor, fontSize: AppFontSizes.fontSize20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(
                            IconlyLight.image_2,
                            color: ColorConstants.whiteMainColor,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            businessUserModel.productCount.toString() + '  ' + 'productCount'.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w600, color: ColorConstants.whiteMainColor, fontSize: AppFontSizes.fontSize14),
                          ),
                        ),
                      ],
                    ),
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
