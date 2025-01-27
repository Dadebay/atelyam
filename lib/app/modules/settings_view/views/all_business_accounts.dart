import 'package:atelyam/app/core/custom_widgets/agree_button.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/business_user_service.dart';
import 'package:atelyam/app/data/service/product_service.dart';
import 'package:atelyam/app/modules/settings_view/views/business_acc_components/create_business_account_view.dart';
import 'package:atelyam/app/modules/settings_view/views/business_acc_components/edit_business_account_view.dart';
import 'package:atelyam/app/modules/settings_view/views/product_components/create_product.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBusinessAccountsView extends StatelessWidget {
  const AllBusinessAccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController, iki sekme (Products ve Business Accounts) için kullanılır.
    return DefaultTabController(
      length: 2, // İki sekme: Products ve Business Accounts
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'allBusinessAccounts'.tr, // Başlık metni
            style: TextStyle(
              color: AppColors.whiteMainColor,
              fontSize: AppFontSizes.fontSize20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // TabBar, AppBar'ın altına eklenir.
          bottom: TabBar(
            tabs: [
              Tab(text: 'Products'), // Sol sekme: Products
              Tab(text: 'Business Accounts'), // Sağ sekme: Business Accounts
            ],
            indicatorColor: AppColors.whiteMainColor, // Sekme göstergesi rengi
            labelColor: AppColors.whiteMainColor, // Seçili sekme metin rengi
            unselectedLabelColor: Colors.grey, // Seçili olmayan sekme metin rengi
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: getMyProducts(),
                ),
                AgreeButton(
                  onTap: () {
                    Get.to(() => UploadProductView()); // Örnek olarak CreateBusinessAccountView'a yönlendirir.
                  },
                  text: 'Add Product', // Buton metni
                ),
              ],
            ),

            // Business Accounts Page (Sağ Sekme)
            Column(
              children: [
                Expanded(child: getBusinessAccounts()),
                AgreeButton(
                  onTap: () {
                    Get.to(() => CreateBusinessAccountView()); // Örnek olarak CreateBusinessAccountView'a yönlendirir.
                  },
                  text: 'Add Account', // Buton metni
                ),
              ],
            ),
          ],
        ),
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
        } else if (snapshot.data!.isEmpty) {
          return EmptyStates().noDataAvailable();
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length, // İşletme hesabı sayısı
            itemExtent: Get.size.height * 0.20, // Her bir öğenin yüksekliği
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(), // Kaydırma fizikleri
            scrollDirection: Axis.vertical, // Dikey kaydırma
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10), // Kenar boşlukları
                  decoration: BoxDecoration(
                    color: snapshot.data![index].status.toString() == 'active'
                        ? AppColors.warmWhiteColor // Aktif hesap rengi
                        : AppColors.redColor, // Pasif hesap rengi
                    borderRadius: BorderRadii.borderRadius20, // Köşe yuvarlaklığı
                  ),
                  child: Row(
                    children: [
                      // İşletme logosu
                      Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadii.borderRadius40, // Logo köşe yuvarlaklığı
                          child: WidgetsMine().customCachedImage(
                            snapshot.data![index].img, // Logo URL'si
                          ),
                        ),
                      ),
                      // İşletme bilgileri
                      Column(
                        children: [
                          Text(
                            snapshot.data![index].name, // İşletme adı
                          ),
                          Text(
                            snapshot.data![index].price, // İşletme telefonu
                          ),
                        ],
                      ),
                      // Düzenleme butonu
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit), // Düzenleme ikonu
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        // Veri yoksa
        return EmptyStates().noDataAvailable(); // Veri yok mesajı göster
      },
    );
  }

  FutureBuilder<List<BusinessUserModel>?> getBusinessAccounts() {
    return FutureBuilder<List<BusinessUserModel>?>(
      future: BusinessUserService().getMyBusinessAccounts(), // İşletme hesaplarını getir
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return EmptyStates().loadingData(); // Yükleme animasyonu göster
        } else if (snapshot.hasError) {
          return EmptyStates().errorData(snapshot.error.toString()); // Hata mesajı göster
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length, // İşletme hesabı sayısı
            itemExtent: Get.size.height * 0.20, // Her bir öğenin yüksekliği
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(), // Kaydırma fizikleri
            scrollDirection: Axis.vertical, // Dikey kaydırma
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // İşletme hesabına tıklandığında yapılacak işlem
                  print(snapshot.data![index].title); // Konsola başlık yazdır
                  Get.to(() => EditBusinessAccountView(businessUser: snapshot.data![index])); // Düzenleme sayfasına yönlendir
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10), // Kenar boşlukları
                  decoration: BoxDecoration(
                    color: snapshot.data![index].status.toString() == 'active'
                        ? AppColors.warmWhiteColor // Aktif hesap rengi
                        : AppColors.redColor, // Pasif hesap rengi
                    borderRadius: BorderRadii.borderRadius20, // Köşe yuvarlaklığı
                  ),
                  child: Row(
                    children: [
                      // İşletme logosu
                      Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadii.borderRadius40, // Logo köşe yuvarlaklığı
                          child: WidgetsMine().customCachedImage(
                            snapshot.data![index].backPhoto, // Logo URL'si
                          ),
                        ),
                      ),
                      // İşletme bilgileri
                      Column(
                        children: [
                          Text(
                            snapshot.data![index].businessName, // İşletme adı
                          ),
                          Text(
                            snapshot.data![index].businessPhone, // İşletme telefonu
                          ),
                        ],
                      ),
                      // Düzenleme butonu
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit), // Düzenleme ikonu
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        // Veri yoksa
        return EmptyStates().noDataAvailable(); // Veri yok mesajı göster
      },
    );
  }
}
