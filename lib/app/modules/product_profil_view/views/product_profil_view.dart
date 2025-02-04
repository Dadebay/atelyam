import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/agree_button.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/business_user_service.dart';
import 'package:atelyam/app/modules/home_view/components/business_users/business_user_profile_view.dart';
import 'package:atelyam/app/modules/product_profil_view/controllers/product_profil_controller.dart';
import 'package:atelyam/app/modules/product_profil_view/views/photo_view_page.dart';
import 'package:atelyam/app/modules/settings_view/components/fav_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductProfilView extends StatefulWidget {
  const ProductProfilView({required this.productModel, super.key});
  final ProductModel productModel;
  @override
  State<ProductProfilView> createState() => _ProductProfilViewState();
}

class _ProductProfilViewState extends State<ProductProfilView> {
  final ProductProfilController controller = Get.put(ProductProfilController());
  BusinessUserModel? businessUserModel;

  @override
  void initState() {
    super.initState();
    controller.fetchImages(widget.productModel.id, widget.productModel.img);
    controller.fetchViewCount(widget.productModel.id);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      showSnackBar('error', 'phone_call_error' + launchUri.toString(), AppColors.redColor);
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteMainColor,
      bottomSheet: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: AgreeButton(
            onTap: () {
              if (businessUserModel != null) {
                _makePhoneCall('+${businessUserModel!.businessPhone}');
              }
            },
            text: 'call'.tr,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          appBar(),
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: FutureBuilder<BusinessUserModel?>(
              future: BusinessUserService().fetchBusinessAccountKICI(widget.productModel.user.toInt()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(child: EmptyStates().loadingData());
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(child: EmptyStates().errorData(snapshot.hasError.toString()));
                } else if (snapshot.hasData) {
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.kSecondaryColor,
                          borderRadius: BorderRadii.borderRadius15,
                        ),
                        child: Text(
                          '${'sold'.tr} - ${widget.productModel.price.substring(0, widget.productModel.price.length - 3)} TMT',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.whiteMainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.fontSize20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, top: 15),
                        child: Text(
                          widget.productModel.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.darkMainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: AppFontSizes.fontSize20,
                          ),
                        ),
                      ),
                      brendData(snapshot.data!),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'info_product'.tr,
                          style: TextStyle(color: Colors.black, fontSize: AppFontSizes.fontSize20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        widget.productModel.description,
                        style: TextStyle(color: Colors.grey, fontSize: AppFontSizes.fontSize16 - 2, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                    ]),
                  );
                }
                return SliverToBoxAdapter(child: EmptyStates().noDataAvailable());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget brendData(BusinessUserModel businessUserModel) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => BusinessUserProfileView(
            categoryID: businessUserModel.userID!,
            businessUserModelFromOutside: businessUserModel,
            whichPage: 'popular',
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.whiteMainColor,
          borderRadius: BorderRadii.borderRadius25,
          boxShadow: [
            BoxShadow(
              color: AppColors.kThirdColor.withOpacity(0.4),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(color: AppColors.kPrimaryColor.withOpacity(.2)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              margin: const EdgeInsets.only(right: 15),
              child: ClipRRect(
                borderRadius: BorderRadii.borderRadius99,
                child: WidgetsMine().customCachedImage(businessUserModel.backPhoto),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    businessUserModel.businessName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.darkMainColor, fontWeight: FontWeight.bold, fontSize: AppFontSizes.fontSize20 - 2),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    businessUserModel.address.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.darkMainColor.withOpacity(.6), fontWeight: FontWeight.w600, fontSize: AppFontSizes.fontSize14 - 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar appBar() {
    return SliverAppBar(
      expandedHeight: 500.0,
      pinned: true,
      scrolledUnderElevation: 0.0,
      backgroundColor: AppColors.whiteMainColor,
      leading: FadeInLeft(
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 6, top: 6),
          child: IconButton(
            style: IconButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadii.borderRadius18), backgroundColor: AppColors.whiteMainColor),
            icon: Icon(
              IconlyLight.arrow_left_circle,
              color: AppColors.darkMainColor,
              size: AppFontSizes.fontSize24,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ),
      actions: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(color: AppColors.whiteMainColor, borderRadius: BorderRadii.borderRadius15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(IconlyLight.show, color: AppColors.darkMainColor, size: AppFontSizes.fontSize20 - 2),
              ),
              Obx(
                () => Text(
                  controller.viewCount.toString(),
                  style: TextStyle(color: AppColors.darkMainColor, fontWeight: FontWeight.bold, fontSize: AppFontSizes.fontSize20 - 2),
                ),
              ),
            ],
          ),
        ),
        FadeInRight(
          duration: const Duration(milliseconds: 500),
          child: FavButton(
            productProfilStyle: true,
            product: widget.productModel,
          ),
        ),
        FadeInRight(
          duration: const Duration(milliseconds: 600),
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              style: IconButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadii.borderRadius15), backgroundColor: AppColors.whiteMainColor),
              icon: Icon(
                IconlyLight.download,
                color: AppColors.darkMainColor,
                size: AppFontSizes.fontSize24,
              ),
              onPressed: () {
                controller.checkPermissionAndDownloadImage(controller.productImages[controller.selectedImageIndex.value]);
              },
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: controller.isLoading.value
                        ? EmptyStates().loadingData()
                        : GestureDetector(
                            onTap: () {
                              Get.to(() => PhotoViewPage(images: controller.productImages));
                            },
                            child: CachedNetworkImage(
                              imageUrl: controller.productImages.isNotEmpty ? controller.productImages[controller.selectedImageIndex.value] : '',
                              key: ValueKey<int>(controller.selectedImageIndex.value),
                              fit: BoxFit.cover,
                              height: Get.size.height,
                              width: Get.size.width,
                              placeholder: (context, url) => EmptyStates().loadingData(),
                              errorWidget: (context, url, error) => EmptyStates().noMiniCategoryImage(),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                width: Get.size.width,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                decoration: BoxDecoration(color: AppColors.whiteMainColor.withOpacity(0), borderRadius: BorderRadii.borderRadius20),
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.productImages.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return FadeInUp(
                        duration: Duration(milliseconds: 500 * index),
                        child: GestureDetector(
                          onTap: () {
                            controller.updateSelectedImageIndex(index);
                          },
                          child: Obx(() {
                            return Container(
                              margin: const EdgeInsets.all(8),
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadii.borderRadius18,
                                boxShadow: [
                                  BoxShadow(
                                    color: index == controller.selectedImageIndex.value ? AppColors.whiteMainColor.withOpacity(.6) : Colors.transparent,
                                    blurRadius: 5,
                                    spreadRadius: 3,
                                  ),
                                ],
                                border: index == controller.selectedImageIndex.value
                                    ? Border.all(
                                        color: AppColors.whiteMainColor,
                                        width: 2.0,
                                      )
                                    : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadii.borderRadius18,
                                child: CachedNetworkImage(
                                  imageUrl: controller.productImages[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => EmptyStates().loadingData(),
                                  errorWidget: (context, url, error) => EmptyStates().noMiniCategoryImage(),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
