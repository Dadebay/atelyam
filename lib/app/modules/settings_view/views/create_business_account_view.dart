import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/custom_text_field.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/data/service/business_category_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CreateBusinessAccountView extends StatefulWidget {
  const CreateBusinessAccountView({super.key});

  @override
  State<CreateBusinessAccountView> createState() => _CreateBusinessAccountViewState();
}

class _CreateBusinessAccountViewState extends State<CreateBusinessAccountView> {
  final _formKey = GlobalKey<FormState>();
  final BusinessCategoryService _categoryService = BusinessCategoryService();
  final ImagePicker _picker = ImagePicker();

  // Focus Nodes
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _tiktokFocusNode = FocusNode();
  final FocusNode _instagramFocusNode = FocusNode();
  final FocusNode _youtubeFocusNode = FocusNode();
  final FocusNode _websiteFocusNode = FocusNode();

  List<BusinessCategoryModel>? categories;
  BusinessCategoryModel? selectedCategory;
  File? _selectedImage;

  // Controllers
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    // Focus node'ları temizle
    _descriptionFocusNode.dispose();
    _tiktokFocusNode.dispose();
    _instagramFocusNode.dispose();
    _youtubeFocusNode.dispose();
    _websiteFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final result = await _categoryService.fetchCategories();
    if (result != null) {
      setState(() => categories = result);
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  Future<void> _submitForm() async {
    if (selectedCategory == null) {
      Get.snackbar('Hata', 'Lütfen bir kategori seçin');
      return;
    }
    final token = await Auth().getToken();
    if (_selectedImage == null) {
      Get.snackbar('Hata', 'Lütfen bir logo seçin');
      return;
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://216.250.12.49:8000/mobile/createUser/'),
    );
// 201 done diymek 200 diyen yaly
//400 so kategoriyada on business user ber
//
    request.fields.addAll({
      'title_id': selectedCategory!.id.toString(),
      'businessName': _businessNameController.text,
      'businessPhone': _phoneController.text,
      'description': _descriptionController.text,
      'address': _addressController.text,
      'tiktok': _tiktokController.text,
      'instagram': _instagramController.text,
      'youtube': _youtubeController.text,
      'website': _websiteController.text,
    });

    request.files.add(
      await http.MultipartFile.fromPath('file', _selectedImage!.path),
    );

    request.headers.addAll(headers);

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString(); // Body'yi oku

      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 201) {
        Get.back();
      } else if (response.statusCode == 400) {
        showSnackBar('Yalnys', 'Bu kategoriyada onem akk bar sizde', Colors.red);
      } else {
        Get.snackbar(
          'Hata',
          'İşlem başarısız: ${response.reasonPhrase}\nDetay: $responseBody',
        );
      }
    } catch (e) {
      Get.snackbar('Hata', 'Bir hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni İşletme Hesabı Oluştur'),
        elevation: 0,
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

              // Logo Yükleme
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
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
                            Text('Logo Yükle'),
                          ],
                        )
                      : Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 20),

              // Form Alanları
              CustomTextField(
                labelName: 'İşletme Adı',
                controller: _businessNameController,
                focusNode: FocusNode(),
                requestfocusNode: _descriptionFocusNode,
                isNumber: false,
                unFocus: false,
              ),

              CustomTextField(
                labelName: 'Telefon',
                controller: _phoneController,
                focusNode: FocusNode(),
                requestfocusNode: FocusNode(),
                isNumber: true,
                unFocus: false,
              ),

              CustomTextField(
                labelName: 'Adres',
                controller: _addressController,
                focusNode: FocusNode(),
                requestfocusNode: _descriptionFocusNode,
                isNumber: false,
                unFocus: false,
                maxline: 3,
              ),

              CustomTextField(
                labelName: 'Açıklama',
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                requestfocusNode: _tiktokFocusNode,
                isNumber: false,
                unFocus: false,
                maxline: 3,
              ),

              CustomTextField(
                labelName: 'TikTok',
                controller: _tiktokController,
                focusNode: _tiktokFocusNode,
                requestfocusNode: _instagramFocusNode,
                isNumber: false,
                unFocus: false,
              ),

              CustomTextField(
                labelName: 'Instagram',
                controller: _instagramController,
                focusNode: _instagramFocusNode,
                requestfocusNode: _youtubeFocusNode,
                isNumber: false,
                unFocus: false,
              ),

              CustomTextField(
                labelName: 'YouTube',
                controller: _youtubeController,
                focusNode: _youtubeFocusNode,
                requestfocusNode: _websiteFocusNode,
                isNumber: false,
                unFocus: false,
              ),

              CustomTextField(
                labelName: 'Web Sitesi',
                controller: _websiteController,
                focusNode: _websiteFocusNode,
                requestfocusNode: _websiteFocusNode,
                isNumber: false,
                unFocus: true,
              ),

              const SizedBox(height: 30),

              // Gönder Butonu
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSecondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadii.borderRadius20,
                  ),
                ),
                child: const Text('Hesabı Oluştur', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
