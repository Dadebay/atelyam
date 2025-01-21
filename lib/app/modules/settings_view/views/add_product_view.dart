import 'package:atelyam/app/core/custom_widgets/custom_text_field.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/models/hashtag_model.dart';
import 'package:atelyam/app/data/service/add_product_service.dart';
import 'package:atelyam/app/data/service/business_category_service.dart';
import 'package:atelyam/app/data/service/hashtag_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:atelyam/app/modules/home_view/views/bottom_nav_bar_view.dart';
import 'package:atelyam/app/modules/settings_view/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  late Future<List<BusinessCategoryModel>?> getBusinessCatFuture;
  late Future<List<HashtagModel>?> getHashTagFuture;

  final AuthController authController = Get.find();
  final NewSettingsPageController settingsPageController =
      Get.put(NewSettingsPageController());

  final HashtagService hashtagService = HashtagService();
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController priceController;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getBusinessCatFuture = BusinessCategoryService().fetchCategories();
    getHashTagFuture = HashtagService().fetchHashtags();
    nameController = TextEditingController();
    descController = TextEditingController();
    priceController = TextEditingController();
    settingsPageController.selectedImage.value = null;
    settingsPageController.selectedBusinessCategory.value = null;
    settingsPageController.selectedHasTag.value = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteMainColor,
      appBar: AppBar(
        title: Text('Adding products'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: getBusinessCatFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return EmptyStates().loadingData();
                } else if (snapshot.hasError) {
                  return EmptyStates().errorData(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final categories = snapshot.data!
                      .map(
                        (category) =>
                            {'title': category.name, 'id': category.id},
                      )
                      .toList();
                  return Obx(() {
                    final selectedBusinessCategory =
                        settingsPageController.selectedBusinessCategory.value;
                    final isValidSelection = categories.any(
                      (category) =>
                          category['id'] == selectedBusinessCategory?['id'] &&
                          category['title'] ==
                              selectedBusinessCategory?['title'],
                    );

                    return DropdownButton<Map<String, dynamic>>(
                      value: isValidSelection
                          ? selectedBusinessCategory
                          : null, // Ensure valid selection
                      items: categories.map((category) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: category,
                          child: Text(
                            category['title'].toString(),
                          ), // Display category name
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          settingsPageController.selectingBusinessCategory(
                            value: value,
                          );
                        }
                      },
                      style: TextStyle(color: AppColors.green),
                    );
                  });
                } else {
                  return Text('no data');
                }
              },
            ),
            FutureBuilder(
              future: getHashTagFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return EmptyStates().loadingData();
                } else if (snapshot.hasError) {
                  return EmptyStates().errorData(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final hashtags = snapshot.data!
                      .map(
                        (hashtag) => {'title': hashtag.name, 'id': hashtag.id},
                      )
                      .toList();
                  return Obx(() {
                    final selectedHashTag =
                        settingsPageController.selectedHasTag.value;
                    final isValidSelection = hashtags.any(
                      (hashtag) =>
                          hashtag['id'] == selectedHashTag?['id'] &&
                          hashtag['title'] == selectedHashTag?['title'],
                    );

                    return DropdownButton<Map<String, dynamic>>(
                      value: isValidSelection
                          ? selectedHashTag
                          : null, // Ensure valid selection
                      items: hashtags.map((hashtag) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: hashtag,
                          child: Text(
                            hashtag['title'].toString(),
                          ), // Display category name
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          settingsPageController.selectingHashtag(
                            value: value,
                          );
                        }
                      },
                      style: TextStyle(color: AppColors.green),
                    );
                  });
                } else {
                  return Text('no data');
                }
              },
            ),
            CustomTextField(
              labelName: 'Name',
              controller: nameController,
              focusNode: nameFocusNode,
              requestfocusNode: nameFocusNode,
              borderRadius: true,
              customColor: AppColors.kPrimaryColor.withOpacity(.4),
              isNumber: false,
              prefixIcon: IconlyLight.profile,
              unFocus: false,
            ),
            CustomTextField(
              labelName: 'Desc',
              controller: descController,
              focusNode: descFocusNode,
              requestfocusNode: descFocusNode,
              borderRadius: true,
              customColor: AppColors.kPrimaryColor.withOpacity(.4),
              isNumber: false,
              prefixIcon: IconlyLight.profile,
              unFocus: false,
            ),
            CustomTextField(
              labelName: 'Price',
              controller: priceController,
              focusNode: priceFocusNode,
              requestfocusNode: priceFocusNode,
              borderRadius: true,
              customColor: AppColors.kPrimaryColor.withOpacity(.4),
              isNumber: false,
              prefixIcon: IconlyLight.profile,
              unFocus: false,
            ),
            Obx(() {
              return settingsPageController.selectedImage.value != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.file(
                            settingsPageController.selectedImage.value!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: settingsPageController.removeImage,
                            child: Text('Remove Image'),
                          ),
                        ],
                      ),
                    )
                  : Text('No image selected');
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: settingsPageController.pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: () {
                AddProductService()
                    .addProduct(
                  categoryId: settingsPageController
                      .selectedBusinessCategory.value!['id']
                      .toString(),
                  hashtagId: settingsPageController.selectedHasTag.value!['id']
                      .toString(),
                  name: nameController.text,
                  desc: descController.text,
                  price: priceController.text,
                  file: settingsPageController.selectedImage.value,
                )
                    .then(
                  (value) {
                    Get.off(() => BottomNavBar());
                  },
                );
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
