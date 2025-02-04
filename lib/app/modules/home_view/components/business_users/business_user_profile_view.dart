import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/agree_button.dart';
import 'package:atelyam/app/core/custom_widgets/back_button.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:atelyam/app/modules/discovery_view/components/discovery_card.dart';
import 'package:atelyam/app/modules/home_view/components/business_users/social_media_button.dart';
import 'package:atelyam/app/modules/home_view/controllers/brands_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class BusinessUserProfileView extends StatefulWidget {
  final BusinessUserModel businessUserModelFromOutside;
  final int categoryID;
  final String whichPage;
  const BusinessUserProfileView({required this.businessUserModelFromOutside, required this.categoryID, required this.whichPage, super.key});
  State<BusinessUserProfileView> createState() => _BusinessUserProfileViewState();
}

class _BusinessUserProfileViewState extends State<BusinessUserProfileView> {
  final BrandsController _homeController = Get.put<BrandsController>(BrandsController());
  final AuthController authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    // _homeController.fetchBusinessUserData(widget.businessUserModelFromOutside, widget.categoryID);
    _homeController.fetchBusinessUserData(
      businessUserModelFromOutside: widget.businessUserModelFromOutside,
      categoryID: widget.categoryID,
      whichPage: widget.whichPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomSheet: FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: AgreeButton(
              onTap: () {
                _homeController.makePhoneCall('+${widget.businessUserModelFromOutside.businessPhone}');
              },
              text: 'call'.tr,
            ),
          ),
        ),
        backgroundColor: AppColors.whiteMainColor,
        body: Obx(
          () => _homeController.isLoadingBrandsProfile.value
              ? EmptyStates().loadingData()
              : NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      _buildSliverAppBar(),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      _buildInfoTab(),
                      _buildImagesTab(),
                      _buildVideosTab(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            if (_homeController.businessUser.value!.instagram?.isNotEmpty == true)
              SocialMediaIcon(name: 'instagram', userName: _homeController.businessUser.value!.instagram.toString(), icon: FontAwesomeIcons.instagram, maxline: 1, index: 3),
            SocialMediaIcon(name: 'youtube', userName: _homeController.businessUser.value!.youtube.toString(), icon: FontAwesomeIcons.youtube, index: 4, maxline: 1),
            SocialMediaIcon(name: 'tiktok', userName: _homeController.businessUser.value!.tiktok.toString(), icon: FontAwesomeIcons.tiktok, index: 5, maxline: 1),
            SocialMediaIcon(name: 'phone_number', userName: _homeController.businessUser.value!.businessPhone.toString(), icon: IconlyBold.call, index: 6, maxline: 1),
            SocialMediaIcon(name: 'location', userName: _homeController.businessUser.value!.address.toString(), icon: IconlyBold.location, index: 6, maxline: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesTab() {
    return Obx(
      () => FutureBuilder<List<ProductModel>?>(
        future: _homeController.productsFuture.value,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return EmptyStates().loadingData();
          } else if (snapshot.hasError) {
            return EmptyStates().errorData(snapshot.error.toString());
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return EmptyStates().noDataAvailable();
          } else {
            final products = snapshot.data!;
            return MasonryGridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: products.length,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                if (index > 10) {
                  return SizedBox(
                    height: index % 2 == 0 ? 250 : 220,
                    child: DiscoveryCard(
                      productModel: product,
                      homePageStyle: false,
                    ),
                  );
                }
                return FadeInUp(
                  duration: Duration(milliseconds: 100 * index),
                  child: SizedBox(
                    height: index % 2 == 0 ? 250 : 220,
                    child: DiscoveryCard(
                      productModel: product,
                      homePageStyle: false,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildVideosTab() {
    return Container(
      color: AppColors.whiteMainColor,
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'comingTitle'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFontSizes.fontSize20 + 2, color: AppColors.kPrimaryColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              'comingSubtitle'.tr,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppFontSizes.fontSize16, color: AppColors.kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      leading: BackButtonMine(miniButton: true),
      scrolledUnderElevation: 0.0,
      expandedHeight: 360.0,
      foregroundColor: AppColors.kSecondaryColor,
      actionsIconTheme: const IconThemeData(color: AppColors.kSecondaryColor),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      bottom: TabBar(
        labelColor: AppColors.kSecondaryColor,
        indicatorColor: AppColors.kSecondaryColor,
        splashBorderRadius: BorderRadii.borderRadius20,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.plusJakartaSans,
          fontSize: AppFontSizes.fontSize20 - 2,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.plusJakartaSans,
          fontSize: AppFontSizes.fontSize20 - 2,
        ),
        dividerColor: Colors.transparent,
        indicator: const UnderlineTabIndicator(
          borderRadius: BorderRadii.borderRadius40,
          borderSide: BorderSide(color: AppColors.kSecondaryColor, width: 5.0),
        ),
        unselectedLabelColor: Colors.grey,
        tabs: [
          FadeInDown(duration: const Duration(milliseconds: 900), child: Tab(text: 'tab1'.tr)),
          FadeInDown(duration: const Duration(milliseconds: 900), child: Tab(text: 'tab2'.tr)),
          FadeInDown(duration: const Duration(milliseconds: 900), child: Tab(text: 'tab3'.tr)),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _buildFlexibleSpaceBackground(),
      ),
    );
  }

  Widget _buildFlexibleSpaceBackground() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(Assets.backgorundPattern3, height: 250, fit: BoxFit.cover),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadii.borderRadius30,
                      boxShadow: [BoxShadow(color: AppColors.kPrimaryColor.withOpacity(.4), spreadRadius: 4, blurRadius: 4)],
                      border: Border.all(color: AppColors.kPrimaryColor.withOpacity(.4)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadii.borderRadius30,
                      child: CachedNetworkImage(
                        fadeInCurve: Curves.ease,
                        imageUrl: authController.ipAddress + _homeController.businessUser.value!.backPhoto,
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
                FadeInDown(
                  duration: const Duration(milliseconds: 700),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      _homeController.businessUser.value!.businessName.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.fontSize20,
                      ),
                    ),
                  ),
                ),
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 70),
                    child: Text(
                      _homeController.businessUser.value!.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.darkMainColor.withOpacity(.6),
                        fontSize: AppFontSizes.fontSize14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
