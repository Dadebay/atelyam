import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/agree_button.dart';
import 'package:atelyam/app/core/custom_widgets/back_button.dart';
import 'package:atelyam/app/core/custom_widgets/custom_text_field.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/models/hashtag_model.dart';
import 'package:atelyam/app/modules/settings_view/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class CreateProductView extends StatelessWidget {
  CreateProductView({super.key});
  final ProductController controller = Get.put(ProductController());

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kSecondaryColor,
      title: Text(
        'create_product'.tr, // Başlık metni
        style: TextStyle(
          color: AppColors.whiteMainColor,
          fontSize: AppFontSizes.fontSize16 + 2,
          fontWeight: FontWeight.bold,
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: AppColors.kSecondaryColor),
      leading: BackButtonMine(
        miniButton: true,
      ),
    );
  }

  List<FocusNode> focusNodes = List.generate(3, (_) => FocusNode());
  List<TextEditingController> textEditingControllers = List.generate(3, (_) => TextEditingController());

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: controller.pickImages,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconlyLight.image, size: 40, color: Colors.grey.shade400),
            SizedBox(height: 8),
            Text(
              'add_image'.tr,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(File image, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: GestureDetector(
            onTap: () => controller.removeImage(index),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteMainColor,
      appBar: _appBar(context),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Obx(
              () => DropdownButtonFormField<BusinessCategoryModel>(
                decoration: InputDecoration(
                  labelText: 'category'.tr,
                  labelStyle: TextStyle(fontSize: AppFontSizes.getFontSize(4), fontWeight: FontWeight.w600, color: Colors.grey.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadii.borderRadius15,
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadii.borderRadius15,
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadii.borderRadius15,
                    borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 2),
                  ),
                ),
                value: controller.selectedCategory.value,
                items: controller.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(category.name),
                    ),
                  );
                }).toList(),
                icon: Icon(IconlyLight.arrow_down_circle, color: Colors.grey.shade300, size: 30), // Ok ikonunun boyutunu artır
                iconSize: 30, // Ok ikonunun boyutunu artır
                isExpanded: true, // Dropdown'u genişlet
                itemHeight: 60, // D
                onChanged: (value) => controller.selectedCategory.value = value,
                validator: (value) => value == null ? 'fill_all_fields'.tr : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Obx(
              () => DropdownButtonFormField<HashtagModel>(
                decoration: InputDecoration(
                  labelText: 'hashtag'.tr,
                  labelStyle: TextStyle(fontSize: AppFontSizes.getFontSize(4), fontWeight: FontWeight.w600, color: Colors.grey.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadii.borderRadius15,
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadii.borderRadius15,
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadii.borderRadius15,
                    borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 2),
                  ),
                ),
                value: controller.selectedHashtag.value,
                items: controller.hashtags.map((hashtag) {
                  return DropdownMenuItem(
                    value: hashtag,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(hashtag.name),
                    ),
                  );
                }).toList(),
                icon: Icon(IconlyLight.arrow_down_circle, color: Colors.grey.shade300, size: 30), // Ok ikonunun boyutunu artır
                iconSize: 30, // Ok ikonunun boyutunu artır
                isExpanded: true, // Dropdown'u genişlet
                itemHeight: 60, // D
                onChanged: (value) => controller.selectedHashtag.value = value,
                validator: (value) => value == null ? 'fill_all_fields'.tr : null,
              ),
            ),
          ),
          CustomTextField(
            labelName: 'product_name'.tr,
            borderRadius: true,
            customColor: Colors.grey.shade300,
            controller: textEditingControllers[0],
            prefixIcon: IconlyBroken.edit,
            showLabel: true,
            focusNode: focusNodes[0],
            requestfocusNode: focusNodes[1],
          ),
          CustomTextField(
            labelName: 'price'.tr,
            controller: textEditingControllers[1],
            borderRadius: true,
            showLabel: true,
            prefixIcon: IconlyBroken.wallet,
            customColor: Colors.grey.shade300,
            focusNode: focusNodes[1],
            requestfocusNode: focusNodes[2],
          ),
          CustomTextField(
            labelName: 'description'.tr,
            borderRadius: true,
            maxLine: 6,
            showLabel: true,
            customColor: Colors.grey.shade300,
            focusNode: focusNodes[2],
            requestfocusNode: focusNodes[0],
            controller: textEditingControllers[2],
          ),
          GestureDetector(
            onTap: controller.pickImage,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 250,
                width: 200,
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadii.borderRadius20,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: Obx(
                  () => controller.selectedImage.value == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconlyLight.image, color: AppColors.kPrimaryColor, size: 40),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'main_image_upload'.tr,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadii.borderRadius20,
                          child: Image.file(
                            controller.selectedImage.value!,
                            width: Get.size.width,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'upload_images'.tr + ' (Max 4)',
                  style: TextStyle(
                    color: AppColors.kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Obx(
                  () => GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: controller.selectedImages.length + 1,
                    itemBuilder: (context, index) {
                      if (index < controller.selectedImages.length) {
                        return _buildImageItem(controller.selectedImages[index]!, index);
                      } else {
                        return controller.selectedImages.length < controller.maxImageCount ? _buildUploadButton() : SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: AgreeButton(
              onTap: () {
                controller.submitProduct(nameController: textEditingControllers[0].text, descriptionController: textEditingControllers[2].text, priceController: textEditingControllers[1].text);
              },
              text: 'upload_product'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
