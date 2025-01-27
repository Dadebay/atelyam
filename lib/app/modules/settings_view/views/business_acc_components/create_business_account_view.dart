import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/custom_text_field.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/data/service/business_category_service.dart';
import 'package:atelyam/app/data/service/business_user_service.dart';
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

  bool _isLoading = false; // Yükleme durumu için bir flag

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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategory == null) {
      showSnackBar('Hata', 'Lütfen bir kategori seçin', AppColors.redColor);
      return;
    }

    if (_selectedImage == null) {
      showSnackBar('Hata', 'Lütfen bir LOGO seçin', AppColors.redColor);
      return;
    }

    setState(() => _isLoading = true); // Yükleme başladı

    // Loading dialog göster
    await showDialog(
      context: context,
      barrierDismissible: false, // Kullanıcı dialog'u kapatamasın
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Bilgileriniz sunucuya gönderiliyor, lütfen bekleyiniz...'),
          ],
        ),
      ),
    );

    final token = await Auth().getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://216.250.12.49:8000/mobile/createUser/'),
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

    request.files.add(
      await http.MultipartFile.fromPath('file', _selectedImage!.path),
    );

    request.headers.addAll(headers);

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Dialog'u kapat
      Navigator.of(context).pop();

      if (response.statusCode == 201) {
        await BusinessUserService().getMyBusinessAccounts().then((value) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Başarılı'),
              content: const Text('İşletme hesabı başarıyla oluşturuldu.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.back(); // Önceki sayfaya dön
                  },
                  child: const Text('Tamam'),
                ),
              ],
            ),
          );
        });
      } else if (response.statusCode == 400) {
        // Hata durumu
        showSnackBar('Hata', 'Bu kategoride zaten bir işletme hesabınız var.', AppColors.redColor);
      } else {
        // Diğer hatalar
        showSnackBar(
          'Hata',
          'İşlem başarısız: ${response.reasonPhrase}\nDetay: $responseBody',
          AppColors.redColor,
        );
      }
    } catch (e) {
      // Dialog'u kapat
      Navigator.of(context).pop();
      showSnackBar('Hata', 'Bir hata oluştu: $e', AppColors.redColor);
    } finally {
      setState(() => _isLoading = false); // Yükleme durumunu sıfırla
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
                requestfocusNode: _descriptionFocusNode,
              ),

              CustomTextField(
                labelName: 'Açıklama',
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                requestfocusNode: _tiktokFocusNode,
              ),

              CustomTextField(
                labelName: 'TikTok',
                controller: _tiktokController,
                focusNode: _tiktokFocusNode,
                requestfocusNode: _instagramFocusNode,
              ),

              CustomTextField(
                labelName: 'Instagram',
                controller: _instagramController,
                focusNode: _instagramFocusNode,
                requestfocusNode: _youtubeFocusNode,
              ),

              CustomTextField(
                labelName: 'YouTube',
                controller: _youtubeController,
                focusNode: _youtubeFocusNode,
                requestfocusNode: _websiteFocusNode,
              ),

              CustomTextField(
                labelName: 'Web Sitesi',
                controller: _websiteController,
                focusNode: _websiteFocusNode,
                requestfocusNode: _websiteFocusNode,
              ),

              const SizedBox(height: 30),

              // Gönder Butonu
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm, // Yükleme sırasında buton devre dışı
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSecondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadii.borderRadius20,
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white) // Yükleme animasyonu
                    : const Text('Hesabı Oluştur', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
