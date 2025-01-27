import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/agree_button.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/business_user_service.dart';
import 'package:atelyam/app/data/service/product_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:atelyam/app/modules/discovery_view/components/discovery_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class BrandsProfile extends StatefulWidget {
  final BusinessUserModel businessUserModelFromOutside;
  final int categoryID;
  const BrandsProfile({required this.businessUserModelFromOutside, required this.categoryID, super.key});

  @override
  State<BrandsProfile> createState() => _BrandsProfileState();
}

class _BrandsProfileState extends State<BrandsProfile> {
  final ProductService _productService = ProductService();
  late Future<List<ProductModel>?> productsFuture;
  late BusinessUserModel _businessUser;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _businessUser = widget.businessUserModelFromOutside;
    if (_businessUser.images!.isNotEmpty) {
      _fetchBusinessUserData();
    } else {
      productsFuture = _productService.fetchProducts(widget.categoryID, widget.businessUserModelFromOutside.id);
    }
  }

  Future<void> _fetchBusinessUserData() async {
    setState(() => _isLoading = true);
    try {
      final newData = await BusinessUserService().fetchBusinessAccountByID(_businessUser.id);
      setState(() => _businessUser = newData!);
      productsFuture = _productService.fetchProducts(widget.categoryID, _businessUser.user);
    } catch (e) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  final AuthController authController = Get.find<AuthController>();

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
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
                _makePhoneCall('+${_businessUser.businessPhone}');
              },
              text: 'call',
            ),
          ),
        ),
        backgroundColor: AppColors.whiteMainColor,
        body: _isLoading
            ? EmptyStates().loadingData()
            : NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    _buildSliverAppBar(),
                  ];
                },
                body: TabBarView(
                  children: [
                    _buildInfoTab(), // Bilgi tabı
                    _buildImagesTab(), // Resimler tabı
                    _buildVideosTab(), // Videolar tabı
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_businessUser.instagram?.isNotEmpty == true)
            _socialMediaIcons(onTap: () {}, name: 'Instagram', userName: _businessUser.instagram.toString(), icon: FontAwesomeIcons.instagram, maxline: 1, index: 3),
          _socialMediaIcons(onTap: () {}, name: 'Youtube', userName: _businessUser.youtube.toString(), icon: FontAwesomeIcons.youtube, index: 4, maxline: 1),
          _socialMediaIcons(onTap: () {}, name: 'TikTok', userName: _businessUser.tiktok.toString(), icon: FontAwesomeIcons.tiktok, index: 5, maxline: 1),
          _socialMediaIcons(onTap: () {}, name: 'phone_number', userName: _businessUser.businessPhone.toString(), icon: IconlyBold.call, index: 6, maxline: 1),
          _socialMediaIcons(onTap: () {}, name: 'location', userName: _businessUser.address.toString(), icon: IconlyBold.location, index: 6, maxline: 4),
        ],
      ),
    );
  }

  // Sosyal medya ikonlarını oluşturan reusable widget
  GestureDetector _socialMediaIcons({
    required VoidCallback onTap,
    required IconData icon,
    required int index,
    required String name,
    required String userName,
    required int maxline,
  }) {
    String displayedUserName = userName;
    String urlToLaunch;

    if (userName.startsWith('@')) {
      String platformUrl = '';
      switch (name) {
        case 'Instagram':
          platformUrl = 'https://www.instagram.com/${userName.substring(1)}';
          break;
        case 'TikTok':
          platformUrl = 'https://www.tiktok.com/@${userName.substring(1)}';
          break;
        case 'Youtube':
          platformUrl = 'https://youtube.com/${userName.substring(1)}';
          break;
        default:
          platformUrl = userName;
      }
      urlToLaunch = platformUrl;
    } else if (userName.startsWith('http://') || userName.startsWith('https://')) {
      urlToLaunch = userName;
      displayedUserName = Uri.parse(userName).host;
    } else {
      urlToLaunch = userName;
    }

    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(urlToLaunch);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          showSnackBar('URL açylmady', 'Gownunize gormek url acyp bilmedim', AppColors.darkMainColor);
        }
      },
      child: FadeInUp(
        duration: Duration(milliseconds: 500 * index),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(icon, color: AppColors.darkMainColor.withOpacity(.6), size: AppFontSizes.fontSize20),
                    ),
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSizes.fontSize16, color: AppColors.darkMainColor.withOpacity(.6)),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 3,
                child: Text(
                  displayedUserName,
                  maxLines: maxline,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFontSizes.fontSize16, color: AppColors.kPrimaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagesTab() {
    return FutureBuilder<List<ProductModel>?>(
      future: productsFuture,
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

              // Apply animation only to the first 10 items
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
          Text('comingTitle'.tr, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFontSizes.fontSize20 + 2, color: AppColors.kPrimaryColor)),
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
      scrolledUnderElevation: 0.0,
      expandedHeight: 360.0,
      foregroundColor: AppColors.darkMainColor,
      actionsIconTheme: const IconThemeData(color: AppColors.darkMainColor),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      bottom: TabBar(
        labelColor: AppColors.kPrimaryColor,
        indicatorColor: AppColors.kPrimaryColor,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.plusJakartaSans,
          fontSize: AppFontSizes.fontSize20 - 2,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: AppFontSizes.fontSize20 - 2,
        ),
        dividerColor: Colors.transparent,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 25),
        indicator: const UnderlineTabIndicator(
          borderRadius: BorderRadii.borderRadius40,
          borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 5.0),
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

  // FlexibleSpaceBar arka planını oluşturma
  Widget _buildFlexibleSpaceBackground() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset('assets/image/patterns/pattern.jpg', height: 250, fit: BoxFit.cover),
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
          child: Column(
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
                      imageUrl: authController.ipAddress + _businessUser.backPhoto,
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
                    _businessUser.businessName.toString(),
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
                    _businessUser.description,
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
      ],
    );
  }
}
