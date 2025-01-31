import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/data/service/business_user_service.dart';
import 'package:atelyam/app/data/service/product_service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BrandsController extends GetxController {
  final ProductService _productService = ProductService();
  final BusinessUserService _businessUserService = BusinessUserService();
  RxBool isLoadingBrandsProfile = false.obs;
  late Rx<BusinessUserModel?> businessUser = Rx<BusinessUserModel?>(null);
  late Rx<Future<List<ProductModel>?>> productsFuture = Rx<Future<List<ProductModel>?>>(Future.value(null));

  Future<void> fetchBusinessUserData(
    BusinessUserModel businessUserModelFromOutside,
    int categoryID,
  ) async {
    isLoadingBrandsProfile.value = true;
    try {
      businessUser.value = await _businessUserService.fetchBusinessAccountByID(businessUserModelFromOutside.id);
      if (businessUser.value != null) {
        productsFuture.value = _productService.fetchProducts(categoryID, businessUser.value!.user);
      }
      isLoadingBrandsProfile.value = false;
    } catch (e) {
      isLoadingBrandsProfile.value = false;
      showSnackBar('error', 'anErrorOccurred' + '$e', AppColors.redColor);
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      showSnackBar('error', 'phone_call_error' + '$launchUri', AppColors.redColor);
    }
  }
}
