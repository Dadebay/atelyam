import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/custom_text_field.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/models/hashtag_model.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/data/service/business_category_service.dart';
import 'package:atelyam/app/data/service/hashtag_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadProductView extends StatefulWidget {
  const UploadProductView({super.key});

  @override
  State<UploadProductView> createState() => _UploadProductViewState();
}

class _UploadProductViewState extends State<UploadProductView> {
  final _formKey = GlobalKey<FormState>();
  final BusinessCategoryService _categoryService = BusinessCategoryService();
  final HashtagService _hashtagService = HashtagService();
  final ImagePicker _picker = ImagePicker();

  List<BusinessCategoryModel>? categories;
  List<HashtagModel>? hashtags;
  BusinessCategoryModel? selectedCategory;
  HashtagModel? selectedHashtag;
  File? _selectedImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadHashtags();
  }

  Future<void> _loadCategories() async {
    final result = await _categoryService.fetchCategories();
    if (result != null) {
      setState(() => categories = result);
    }
  }

  Future<void> _loadHashtags() async {
    final result = await _hashtagService.fetchHashtags();
    setState(() => hashtags = result);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  Future<void> _submitProduct() async {
    if (selectedCategory == null || selectedHashtag == null || _selectedImage == null) {
      Get.snackbar('Hata', 'Lütfen tüm alanları doldurun');
      return;
    }

    final token = await Auth().getToken();
    print(token);
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };
    final AuthController authController = Get.find();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${authController.ipAddress}/mobile/uploadProducts/'),
    );

    request.fields.addAll({
      'category_id': selectedCategory!.id.toString(),
      'hashtag_id': selectedHashtag!.id.toString(),
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
    });

    request.files.add(
      await http.MultipartFile.fromPath('file', _selectedImage!.path),
    );

    request.headers.addAll(headers);

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 201) {
        Get.back();
        Get.snackbar('Başarılı', 'Ürün başarıyla yüklendi');
      } else {
        Get.snackbar('Hata', 'Ürün yüklenemedi: ${response.reasonPhrase}');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Bir hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Ürün Yükle'),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kategori Seçimi
              DropdownButtonFormField<BusinessCategoryModel>(
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadii.borderRadius20,
                  ),
                ),
                value: selectedCategory,
                items: categories?.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedCategory = value),
                validator: (value) => value == null ? 'Lütfen kategori seçin' : null,
              ),

              const SizedBox(height: 20),

              // Hashtag Seçimi
              DropdownButtonFormField<HashtagModel>(
                decoration: InputDecoration(
                  labelText: 'Hashtag',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadii.borderRadius20,
                  ),
                ),
                value: selectedHashtag,
                items: hashtags?.map((hashtag) {
                  return DropdownMenuItem(
                    value: hashtag,
                    child: Text(hashtag.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedHashtag = value),
                validator: (value) => value == null ? 'Lütfen hashtag seçin' : null,
              ),

              const SizedBox(height: 20),

              // Ürün Resmi Yükleme
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadii.borderRadius20,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo, size: 40),
                            Text('Resim Yükle'),
                          ],
                        )
                      : Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 20),

              // Ürün Bilgileri
              CustomTextField(
                labelName: 'Ürün Adı',
                controller: _nameController,
                maxline: 1,
                focusNode: FocusNode(),
                requestfocusNode: FocusNode(),
                isNumber: false,
                unFocus: false,
              ),

              CustomTextField(
                labelName: 'Açıklama',
                focusNode: FocusNode(),
                requestfocusNode: FocusNode(),
                isNumber: false,
                unFocus: false,
                controller: _descriptionController,
                maxline: 3,
              ),

              CustomTextField(
                labelName: 'Fiyat',
                controller: _priceController,
                focusNode: FocusNode(),
                requestfocusNode: FocusNode(),
                isNumber: false,
                unFocus: false,
              ),

              const SizedBox(height: 30),

              // Gönder Butonu
              ElevatedButton(
                onPressed: _submitProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSecondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadii.borderRadius20,
                  ),
                ),
                child: const Text('Ürünü Yükle', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
