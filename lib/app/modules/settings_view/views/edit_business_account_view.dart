import 'dart:io';

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
  final String businessId;
  const EditBusinessAccountView({required this.businessId, super.key});

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
    if (result != null) {
      setState(() => categories = result);
    }
  }

  Future<void> _loadBusinessUser() async {
    final user = await _businessUserService.fetchBusinessAccountByID(int.parse(widget.businessId.toString()));
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
      Get.snackbar('Hata', 'Lütfen bir kategori seçin');
      return;
    }

    final token = await Auth().getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('http://216.250.12.49:8000/mobile/businessUsers/${widget.businessId}/'),
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

    request.headers.addAll(headers);

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        Get.back(result: true); // Refresh list
        Get.snackbar('Başarılı', 'Hesap başarıyla güncellendi');
      } else {
        Get.snackbar('Hata', 'Güncelleme başarısız: ${response.reasonPhrase}');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Bir hata oluştu: $e');
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
      final response = await http.delete(
        Uri.parse('http://216.250.12.49:8000/mobile/businessUsers/${widget.businessId}/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 204) {
        Get.back();
        Get.snackbar('Başarılı', 'Hesap başarıyla silindi');
      } else {
        Get.snackbar('Hata', 'Silme işlemi başarısız');
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

                    // Diğer form alanları (CreateBusinessAccountView'den aynen alınabilir)
                    // ... (Create sayfasındaki CustomTextField'lar buraya eklenecek)

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
