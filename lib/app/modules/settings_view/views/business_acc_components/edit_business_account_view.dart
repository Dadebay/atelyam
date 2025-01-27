import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/custom_text_field.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/data/service/business_category_service.dart';
import 'package:atelyam/app/data/service/business_user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditBusinessAccountView extends StatefulWidget {
  final BusinessUserModel businessUser;
  const EditBusinessAccountView({required this.businessUser, super.key});

  @override
  State<EditBusinessAccountView> createState() => _EditBusinessAccountViewState();
}

class _EditBusinessAccountViewState extends State<EditBusinessAccountView> {
  final _formKey = GlobalKey<FormState>();
  final BusinessCategoryService _categoryService = BusinessCategoryService();
  final BusinessUserService _businessUserService = BusinessUserService();
  final ImagePicker _picker = ImagePicker();

  List<BusinessCategoryModel>? categories;
  BusinessCategoryModel? selectedCategory;
  File? _selectedImage;
  BusinessUserModel? _businessUser;

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
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadCategories();
    await _loadBusinessUser();
  }

  Future<void> _loadCategories() async {
    final result = await _categoryService.fetchCategories();
    selectedCategory = result?.firstWhere((category) => category.id == widget.businessUser.title);
    if (result != null) {
      setState(() => categories = result);
    }
  }

  Future<void> _loadBusinessUser() async {
    final user = await _businessUserService.fetchBusinessAccountByID(int.parse(widget.businessUser.id.toString()));
    _businessUser = user;
    _populateFormFields();
    setState(() {});
  }

  void _populateFormFields() {
    _businessNameController.text = _businessUser?.businessName ?? '';
    _phoneController.text = _businessUser?.businessPhone ?? '';
    _descriptionController.text = _businessUser?.description ?? '';
    _addressController.text = _businessUser?.address ?? '';
    _tiktokController.text = _businessUser?.tiktok ?? '';
    _instagramController.text = _businessUser?.instagram ?? '';
    _youtubeController.text = _businessUser?.youtube ?? '';
    _websiteController.text = _businessUser?.website ?? '';
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  Future<void> _submitForm() async {
    if (selectedCategory == null) {
      showSnackBar('Hata', 'Lütfen bir kategori seçin', AppColors.redColor);
      return;
    }

    final token = await Auth().getToken(); // Token'ı al
    final headers = {
      'Authorization': 'Bearer $token', // Bearer Token ekle
      'Content-Type': 'multipart/form-data',
    };

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://216.250.12.49:8000/mobile/updateBusiness/${widget.businessUser.id}/'),
    );

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

    if (_selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', _selectedImage!.path),
      );
    }

    request.headers.addAll(headers); // Headers'ı ekle

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString(); // Response body'yi oku
      print(selectedCategory!.id.toString());
      // Response durumunu ve body'sini yazdır
      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 200) {
        Get.back(result: true); // Refresh list
        showSnackBar('Başarılı', 'Hesap başarıyla güncellendi', AppColors.greenColor);
      } else {
        showSnackBar('Hata', 'Güncelleme başarısız: ${response.reasonPhrase}', AppColors.redColor);
      }
    } catch (e) {
      showSnackBar('Hata', 'Bir hata oluştu: $e', AppColors.redColor);
    }
  }

  Future<void> _deleteBusiness() async {
    final confirm = await Get.dialog(
      AlertDialog(
        title: const Text('Hesabı Sil'),
        content: const Text('Bu işletme hesabını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final token = await Auth().getToken();
      print(token);
      final response = await http.delete(
        Uri.parse('http://216.250.12.49:8000/mobile/deleteBusiness/${widget.businessUser.id}/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 204) {
        Get.back();
        showSnackBar('Başarılı', 'Hesap başarıyla silindi', AppColors.greenColor);
      } else {
        showSnackBar('Hata', 'Güncelleme başarısız: ${response.reasonPhrase}', AppColors.redColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İşletme Hesabını Düzenle'),
        backgroundColor: AppColors.kSecondaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteBusiness,
          ),
        ],
      ),
      body: _businessUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                        child: _selectedImage != null ? Image.file(_selectedImage!, fit: BoxFit.cover) : WidgetsMine().customCachedImage(_businessUser!.backPhoto),
                      ),
                    ),
                    // Form Alanları
                    CustomTextField(
                      labelName: 'İşletme Adı',
                      controller: _businessNameController,
                      focusNode: FocusNode(),
                      requestfocusNode: FocusNode(),
                    ),

                    CustomTextField(
                      labelName: 'Telefon',
                      controller: _phoneController,
                      focusNode: FocusNode(),
                      requestfocusNode: FocusNode(),
                    ),

                    CustomTextField(
                      labelName: 'Adres',
                      controller: _addressController,
                      focusNode: FocusNode(),
                      requestfocusNode: FocusNode(),
                    ),

                    CustomTextField(
                      labelName: 'Açıklama',
                      controller: _descriptionController,
                      focusNode: FocusNode(),
                      requestfocusNode: FocusNode(),
                    ),

                    CustomTextField(
                      labelName: 'TikTok',
                      controller: _tiktokController,
                      focusNode: FocusNode(),
                      requestfocusNode: FocusNode(),
                    ),

                    CustomTextField(
                      labelName: 'Instagram',
                      controller: _instagramController,
                      focusNode: FocusNode(),
                      requestfocusNode: FocusNode(),
                    ),

                    CustomTextField(
                      labelName: 'YouTube',
                      controller: _youtubeController,
                      focusNode: FocusNode(),
                      requestfocusNode: FocusNode(),
                    ),

                    CustomTextField(
                      labelName: 'Web Sitesi',
                      controller: _websiteController,
                      focusNode: FocusNode(),
                      requestfocusNode: FocusNode(),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSecondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadii.borderRadius20,
                        ),
                      ),
                      child: const Text('Güncelle', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
