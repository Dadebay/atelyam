import 'package:atelyam/app/core/custom_widgets/custom_text_field.dart';
import 'package:atelyam/app/data/service/create_business_acc_service.dart';
import 'package:atelyam/app/modules/home_view/views/bottom_nav_bar_view.dart';
import 'package:atelyam/app/modules/home_view/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/service/business_category_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:atelyam/app/modules/settings_view/controllers/settings_controller.dart';
import 'package:iconly/iconly.dart';

class CreateBusinessAccauntView extends StatefulWidget {
  const CreateBusinessAccauntView({super.key});

  @override
  State<CreateBusinessAccauntView> createState() =>
      _CreateBusinessAccauntViewState();
}

class _CreateBusinessAccauntViewState extends State<CreateBusinessAccauntView> {
  late Future<List<BusinessCategoryModel>?> _getBusinessCatFuture;
  final AuthController authController = Get.find();
  final NewSettingsPageController settingsPageController =
      Get.put(NewSettingsPageController());
  late TextEditingController businessNameController;
  late TextEditingController phoneController;
  late TextEditingController descController;
  late TextEditingController addressController;
  late TextEditingController tiktokController;
  late TextEditingController instagramController;
  late TextEditingController youtubeController;
  late TextEditingController websiteController;

  final FocusNode businessNameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode descFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode tiktokFocusNode = FocusNode();
  final FocusNode instagramFocusNode = FocusNode();
  final FocusNode youtubeFocusNode = FocusNode();
  final FocusNode websiteFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _getBusinessCatFuture = BusinessCategoryService().fetchCategories();

    businessNameController = TextEditingController();
    phoneController = TextEditingController();
    descController = TextEditingController();
    addressController = TextEditingController();
    tiktokController = TextEditingController();
    instagramController = TextEditingController();
    youtubeController = TextEditingController();
    websiteController = TextEditingController();
    settingsPageController.selectedCategory.value = null;
    settingsPageController.selectedImage.value = null;
  }

  @override
  void dispose() {
    businessNameController.dispose();
    phoneController.dispose();
    descController.dispose();
    addressController.dispose();
    tiktokController.dispose();
    instagramController.dispose();
    youtubeController.dispose();
    websiteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteMainColor,
      appBar: AppBar(
        title: Text('Create Business Acc'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _getBusinessCatFuture,
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
                    final selectedCategory =
                        settingsPageController.selectedCategory.value;
                    final isValidSelection = categories.any(
                      (category) =>
                          category['id'] == selectedCategory?['id'] &&
                          category['title'] == selectedCategory?['title'],
                    );

                    return DropdownButton<Map<String, dynamic>>(
                      value: isValidSelection
                          ? selectedCategory
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
                          settingsPageController.selectingCategory(
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

            // Business fields
            CustomTextField(
              labelName: 'Business Name',
              controller: businessNameController,
              focusNode: businessNameFocusNode,
              requestfocusNode: businessNameFocusNode,
              borderRadius: true,
              customColor: AppColors.kPrimaryColor.withOpacity(.4),
              isNumber: false,
              prefixIcon: IconlyLight.profile,
              unFocus: false,
            ),
            CustomTextField(
              labelName: 'phone_number',
              controller: phoneController,
              borderRadius: true,
              prefixIcon: IconlyLight.call,
              focusNode: phoneFocusNode,
              customColor: AppColors.kPrimaryColor.withOpacity(.4),
              requestfocusNode: phoneFocusNode,
              isNumber: true,
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
              labelName: 'Adress',
              controller: addressController,
              focusNode: addressFocusNode,
              requestfocusNode: addressFocusNode,
              borderRadius: true,
              customColor: AppColors.kPrimaryColor.withOpacity(.4),
              isNumber: false,
              prefixIcon: IconlyLight.profile,
              unFocus: false,
            ),
            CustomTextField(
              labelName: 'Tik tok',
              controller: tiktokController,
              focusNode: tiktokFocusNode,
              requestfocusNode: tiktokFocusNode,
              borderRadius: true,
              customColor: AppColors.kPrimaryColor.withOpacity(.4),
              isNumber: false,
              prefixIcon: IconlyLight.profile,
              unFocus: false,
            ),
            CustomTextField(
              labelName: 'Instagram',
              controller: instagramController,
              focusNode: instagramFocusNode,
              requestfocusNode: instagramFocusNode,
              borderRadius: true,
              customColor: AppColors.kPrimaryColor.withOpacity(.4),
              isNumber: false,
              prefixIcon: IconlyLight.profile,
              unFocus: false,
            ),
            CustomTextField(
              labelName: 'Youtube',
              controller: youtubeController,
              focusNode: youtubeFocusNode,
              requestfocusNode: youtubeFocusNode,
              borderRadius: true,
              customColor: AppColors.kPrimaryColor.withOpacity(.4),
              isNumber: false,
              prefixIcon: IconlyLight.profile,
              unFocus: false,
            ),
            CustomTextField(
              labelName: 'Website',
              controller: websiteController,
              focusNode: websiteFocusNode,
              requestfocusNode: websiteFocusNode,
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
                CreateBusinessAccService()
                    .createAccaunt(
                  businessName: businessNameController.text,
                  phone: phoneController.text,
                  address: addressController.text,
                  desc: descController.text,
                  instagram: instagramController.text,
                  tiktok: tiktokController.text,
                  titleId: settingsPageController.selectedCategory.value!['id']
                      .toString(),
                  website: websiteController.text,
                  youtube: youtubeController.text,
                  file: settingsPageController.selectedImage.value,
                )
                    .then(
                  (value) {
                    Get.off(() => BottomNavBar());
                  },
                );
              },
              child: Text('Done button'),
            ),
          ],
        ),
      ),
    );
  }
}
