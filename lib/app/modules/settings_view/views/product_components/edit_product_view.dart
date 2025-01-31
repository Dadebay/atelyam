import 'package:atelyam/app/core/custom_widgets/agree_button.dart';
import 'package:atelyam/app/core/custom_widgets/back_button.dart';
import 'package:atelyam/app/core/custom_widgets/custom_text_field.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/models/hashtag_model.dart';
import 'package:atelyam/app/data/models/product_model.dart';
import 'package:atelyam/app/modules/settings_view/controllers/product_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class UpdateProductView extends StatefulWidget {
  final ProductModel product;

  const UpdateProductView({required this.product, super.key});

  @override
  State<UpdateProductView> createState() => _UpdateProductViewState();
}

class _UpdateProductViewState extends State<UpdateProductView> {
  final ProductController controller = Get.put(ProductController());

  final List<FocusNode> focusNodes = List.generate(3, (_) => FocusNode());

  final List<TextEditingController> textControllers = List.generate(3, (_) => TextEditingController());
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    textControllers[0].text = widget.product.name;
    textControllers[1].text = widget.product.price.toString();
    textControllers[2].text = widget.product.description;

    await controller.loadCategories().then((a) {
      // Find the new category object and update the selectedCategory
      controller.selectedCategory.value = controller.categories.firstWhereOrNull((e) => e.id == widget.product.category);
    });
    await controller.loadHashtags().then((a) {
      // Find the new hashtag object and update the selectedHashtag
      controller.selectedHashtag.value = controller.hashtags.firstWhereOrNull((e) => e.id == widget.product.hashtag);
    });
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kSecondaryColor,
      title: Text(
        'update_product'.tr,
        style: TextStyle(
          color: AppColors.whiteMainColor,
          fontSize: AppFontSizes.fontSize16 + 2,
          fontWeight: FontWeight.bold,
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: AppColors.kSecondaryColor),
      leading: BackButtonMine(miniButton: true),
      actions: [
        IconButton(
          icon: Icon(IconlyLight.delete, color: Colors.white),
          onPressed: () => controller.deleteProduct(widget.product.id, context),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Obx(() {
        if (controller.selectedImage.value != null) {
          return ClipRRect(
            borderRadius: BorderRadii.borderRadius20,
            child: Image.file(
              controller.selectedImage.value!,
              fit: BoxFit.cover,
              height: 250,
              width: 200,
            ),
          );
        }
        if (widget.product.img.toString() != 'null') {
          return Center(
            child: Container(
              height: 250,
              width: 200,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadii.borderRadius20,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadii.borderRadius20,
                child: CachedNetworkImage(
                  imageUrl: '${controller.authController.ipAddress}${widget.product.img}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconlyLight.image, color: AppColors.kPrimaryColor, size: 40),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'update_image'.tr,
                  style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadii.borderRadius15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadii.borderRadius20,
        borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadii.borderRadius20,
        borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteMainColor,
      appBar: _appBar(context),
      body: Obx(() {
        print(controller.categories.length);
        return controller.categories.isEmpty
            ? EmptyStates().loadingData()
            : ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: Obx(
                      () => DropdownButtonFormField<BusinessCategoryModel>(
                        decoration: _dropdownDecoration('category'.tr),
                        value: controller.selectedCategory.value,
                        items: controller.categories
                            .map(
                              (e) => DropdownMenuItem<BusinessCategoryModel>(
                                value: e,
                                child: Text(
                                  e.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppFontSizes.getFontSize(4),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => controller.selectedCategory.value = value,
                      ),
                    ),
                  ),

                  // Hashtag Dropdown
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: Obx(() {
                      return DropdownButtonFormField<HashtagModel>(
                        decoration: _dropdownDecoration('hashtag'.tr),
                        value: controller.selectedHashtag.value,
                        items: controller.selectedHashtag.value == null
                            ? [] // Show an empty list if selectedHashtag is null
                            : controller.hashtags
                                .map(
                                  (e) => DropdownMenuItem<HashtagModel>(
                                    value: e,
                                    child: Text(
                                      e.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppFontSizes.getFontSize(4),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) => controller.selectedHashtag.value = value,
                      );
                    }),
                  ),

                  // Form Fields
                  CustomTextField(
                    labelName: 'product_name'.tr,
                    controller: textControllers[0],
                    prefixIcon: IconlyBroken.edit,
                    customColor: AppColors.kPrimaryColor.withOpacity(.2),
                    borderRadius: true,
                    showLabel: true,
                    focusNode: focusNodes[0],
                    requestfocusNode: focusNodes[1],
                  ),
                  CustomTextField(
                    labelName: 'price'.tr,
                    customColor: AppColors.kPrimaryColor.withOpacity(.2),
                    borderRadius: true,
                    controller: textControllers[1],
                    prefixIcon: IconlyBroken.wallet,
                    focusNode: focusNodes[1],
                    showLabel: true,
                    requestfocusNode: focusNodes[2],
                  ),
                  CustomTextField(
                    labelName: 'description'.tr,
                    controller: textControllers[2],
                    maxLine: 6,
                    showLabel: true,
                    customColor: AppColors.kPrimaryColor.withOpacity(.2),
                    borderRadius: true,
                    focusNode: focusNodes[2],
                    requestfocusNode: focusNodes[0],
                  ),

                  // Image Section
                  _buildImageSection(),

                  // Update Button
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: AgreeButton(
                      onTap: () => controller.updateProduct(
                        productId: widget.product.id,
                        nameController: textControllers[0].text,
                        descriptionController: textControllers[2].text,
                        priceController: textControllers[1].text,
                      ),
                      text: 'update_product'.tr,
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
