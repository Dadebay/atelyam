import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class MyProductCard extends StatelessWidget {
  final ProductModel productModel;
  final Function() onTap;

  const MyProductCard({required this.productModel, required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteMainColor, // Pasif hesap rengi
        borderRadius: BorderRadii.borderRadius20, // Köşe yuvarlaklığı
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 3,
            blurRadius: 3,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: productModel.status.toString().toLowerCase() == 'true' ? Colors.grey.shade500 : AppColors.whiteMainColor, // Pasif hesap rengi
                borderRadius: BorderRadii.borderRadius20, // Köşe yuvarlaklığı
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadii.borderRadius18,
                    border: Border.all(color: AppColors.kSecondaryColor, width: 1),
                  ),
                  margin: EdgeInsets.only(right: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadii.borderRadius18, // Logo köşe yuvarlaklığı
                    child: productModel.img.toString() == 'null'
                        ? Icon(
                            IconlyLight.image_2,
                            color: Colors.grey,
                          )
                        : WidgetsMine().customCachedImage(
                            productModel.img, // Logo URL'si
                          ),
                  ),
                ),
                productModel.status.toString().toLowerCase() == 'true'
                    ? waitingDesign()
                    : Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              productModel.name.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSizes.getFontSize(4.5),
                              ),
                            ),
                            Text(
                              productModel.price.toString() + ' TMT ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.kPrimaryColor,
                                fontWeight: FontWeight.w400,
                                fontSize: AppFontSizes.getFontSize(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                // Düzenleme butonu
                IconButton(
                  onPressed: onTap,
                  icon: Icon(IconlyLight.edit_square), // Düzenleme ikonusssss
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded waitingDesign() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'wait'.tr,
            style: TextStyle(
              color: AppColors.kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.getFontSize(4.5),
            ),
          ),
          Text(
            'wait_desc'.tr,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.kPrimaryColor,
              fontWeight: FontWeight.w400,
              fontSize: AppFontSizes.getFontSize(3.5),
            ),
          ),
        ],
      ),
    );
  }

  Expanded inactiveDesign() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'inactive'.tr,
            style: TextStyle(
              color: AppColors.kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.getFontSize(4.5),
            ),
          ),
          Text(
            'inactive_desc'.tr,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.kPrimaryColor,
              fontWeight: FontWeight.w400,
              fontSize: AppFontSizes.getFontSize(3.5),
            ),
          ),
        ],
      ),
    );
  }
}
