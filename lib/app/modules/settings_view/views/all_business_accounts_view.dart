import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/agree_button.dart';
import 'package:atelyam/app/core/custom_widgets/back_button.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/business_user_service.dart';
import 'package:atelyam/app/data/service/product_service.dart';
import 'package:atelyam/app/modules/settings_view/components/business_acc_card.dart';
import 'package:atelyam/app/modules/settings_view/components/product_card_mine.dart';
import 'package:atelyam/app/modules/settings_view/views/business_acc_components_view/create_business_account_view.dart';
import 'package:atelyam/app/modules/settings_view/views/business_acc_components_view/edit_business_account_view.dart';
import 'package:atelyam/app/modules/settings_view/views/product_components/create_product.view.dart';
import 'package:atelyam/app/modules/settings_view/views/product_components/edit_product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AllBusinessAccountsView extends StatefulWidget {
  AllBusinessAccountsView({super.key});

  @override
  State<AllBusinessAccountsView> createState() => _AllBusinessAccountsViewState();
}

class _AllBusinessAccountsViewState extends State<AllBusinessAccountsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.whiteMainColor,
        appBar: _appBar(),
        body: TabBarView(
          children: [
            getMyProducts(),
            getBusinessAccounts(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: AppColors.kSecondaryColor,
      title: Text(
        'all_business_accounts'.tr, // Başlık metni
        style: TextStyle(
          color: AppColors.whiteMainColor,
          fontSize: AppFontSizes.getFontSize(5),
          fontWeight: FontWeight.bold,
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: AppColors.kSecondaryColor),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BackButtonMine(
          miniButton: true,
        ),
      ),
      bottom: TabBar(
        labelColor: AppColors.whiteMainColor,
        indicatorColor: AppColors.whiteMainColor,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.plusJakartaSans,
          color: AppColors.whiteMainColor,
          fontSize: AppFontSizes.getFontSize(4),
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.plusJakartaSans,
          fontSize: AppFontSizes.getFontSize(4),
        ),
        dividerColor: Colors.white,
        isScrollable: false,
        unselectedLabelColor: Colors.grey,
        tabs: [
          FadeInDown(duration: const Duration(milliseconds: 900), child: Tab(text: 'tab2Settings'.tr)),
          FadeInDown(duration: const Duration(milliseconds: 900), child: Tab(text: 'business_accounts'.tr)),
        ],
      ),
    );
  }

  FutureBuilder<List<ProductModel>?> getMyProducts() {
    return FutureBuilder<List<ProductModel>?>(
      future: ProductService().getMyProducts(), // İşletme hesaplarını getir
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return EmptyStates().loadingData(); // Yükleme animasyonu göster
        } else if (snapshot.hasError) {
          return EmptyStates().errorData(snapshot.error.toString()); // Hata mesajı göster
        } else if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Column(
              children: [
                Expanded(child: EmptyStates().noDataAvailablePage(textColor: AppColors.kPrimaryColor)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AgreeButton(
                    onTap: () async {
                      final result = await Get.to(() => CreateProductView());
                      if (result == true) {
                        setState(() {});
                      }
                    },
                    text: 'add_product', // Buton metni
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length, // İşletme hesabı sayısı
                  itemExtent: 120,
// Her bir öğenin yüksekliği
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(), // Kaydırma fizikleri
                  scrollDirection: Axis.vertical, // Dikey kaydırma
                  itemBuilder: (BuildContext context, int index) {
                    return MyProductCard(
                      productModel: snapshot.data![index],
                      onTap: () async {
                        final result = await Get.to(() => UpdateProductView(product: snapshot.data![index]));
                        if (result == true) {
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AgreeButton(
                  onTap: () async {
                    final result = await Get.to(() => CreateProductView());
                    if (result == true) {
                      setState(() {});
                    }
                  },
                  text: 'add_product', // Buton metni
                ),
              ),
            ],
          );
        }
        return EmptyStates().noDataAvailable(); // Veri yok mesajı göster
      },
    );
  }

  Widget getBusinessAccounts() {
    return FutureBuilder<List<GetMyStatusModel>?>(
      future: BusinessUserService().getMyStatus(), // İşletme hesaplarını getir
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return EmptyStates().loadingData(); // Yükleme animasyonu göster
        } else if (snapshot.hasError) {
          return EmptyStates().errorData(snapshot.error.toString()); // Hata mesajı göster
        } else if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Column(
              children: [
                Expanded(child: EmptyStates().noDataAvailablePage(textColor: AppColors.kPrimaryColor)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AgreeButton(
                    onTap: () async {
                      final result = await Get.to(() => CreateBusinessAccountView()); // Örnek olarak CreateBusinessAccountView'a yönlendirir.
                      if (result == true) {
                        setState(() {});
                      }
                    },
                    text: 'add_account', // Buton metni
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length, // İşletme hesabı sayısı
            itemExtent: 120,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(), // Kaydırma fizikleri
            scrollDirection: Axis.vertical, // Dikey kaydırma
            itemBuilder: (BuildContext context, int index) {
              return BusinessAccCard(
                businessUser: snapshot.data![index],
                onTap: () async {
                  final result = await Get.to(() => EditBusinessAccountView(businessUser: snapshot.data![index]));
                  if (result == true) {
                    setState(() {});
                  }
                  ;
                },
              );
            },
          );
        }
        return EmptyStates().noDataAvailable(); // Veri yok mesajı göster
      },
    );
  }
}
