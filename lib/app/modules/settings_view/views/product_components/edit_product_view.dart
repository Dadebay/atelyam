import 'dart:io';

import 'package:atelyam/app/core/custom_widgets/custom_text_field.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_category_model.dart';
import 'package:atelyam/app/data/models/hashtag_model.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/data/service/business_category_service.dart';
import 'package:atelyam/app/data/service/hashtag_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UpdateProductView extends StatefulWidget {
  final int productId; // Güncellenecek ürünün ID'si

  const UpdateProductView({required this.productId, super.key});

  @override
  State<UpdateProductView> createState() => _UpdateProductViewState();
}

class _UpdateProductViewState extends State<UpdateProductView> {
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

  bool _isLoading = false; // Yükleme durumu için bir flag

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

  Future<void> _updateProduct() async {
    if (selectedCategory == null || selectedHashtag == null) {
      showSnackBar('Hata', 'Lütfen tüm alanları doldurun', AppColors.redColor);
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
            Text('Ürün güncelleniyor, lütfen bekleyiniz...'),
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
      Uri.parse('http://216.250.12.49:8000/mobile/productUpdate/${widget.productId}'),
    );

    request.fields.addAll({
      'category_id': selectedCategory!.id.toString(),
      'hashtag_id': selectedHashtag!.id.toString(),
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
    });

    if (_selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', _selectedImage!.path),
      );
    }

    request.headers.addAll(headers);

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Dialog'u kapat
      Navigator.of(context).pop();

      // Response status code ve body'yi konsola yazdır
      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 200) {
        // Başarılı durum
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Başarılı'),
            content: const Text('Ürün başarıyla güncellendi.'),
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
      } else {
        // Hata durumu
        showSnackBar('Hata', 'Ürün güncellenemedi: ${response.reasonPhrase}', AppColors.redColor);
      }
    } catch (e) {
      // Dialog'u kapat
      Navigator.of(context).pop();
      showSnackBar('Hata', 'Bir hata oluştu: $e', AppColors.redColor);
    } finally {
      setState(() => _isLoading = false); // Yükleme durumunu sıfırla
    }
  }

  Future<void> _deleteProduct() async {
    // Kullanıcıya silme işlemi için onay iste
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ürünü Sil'),
        content: const Text('Bu ürünü silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // İptal
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Onay
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm == true) {
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
              Text('Ürün siliniyor, lütfen bekleyiniz...'),
            ],
          ),
        ),
      );

      final token = await Auth().getToken();
      final headers = {
        'Authorization': 'Bearer $token',
      };

      try {
        final response = await http.delete(
          Uri.parse('http://216.250.12.49:8000/mobile/productDelete/${widget.productId}'),
          headers: headers,
        );

        // Dialog'u kapat
        Navigator.of(context).pop();

        // Response status code ve body'yi konsola yazdır
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          // Başarılı durum
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Başarılı'),
              content: const Text('Ürün başarıyla silindi.'),
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
        } else {
          // Hata durumu
          showSnackBar('Hata', 'Ürün silinemedi: ${response.reasonPhrase}', AppColors.redColor);
        }
      } catch (e) {
        // Dialog'u kapat
        Navigator.of(context).pop();
        showSnackBar('Hata', 'Bir hata oluştu: $e', AppColors.redColor);
      } finally {
        setState(() => _isLoading = false); // Yükleme durumunu sıfırla
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünü Güncelle'),
        backgroundColor: AppColors.kSecondaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteProduct, // Silme butonu
          ),
        ],
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
                focusNode: FocusNode(),
                requestfocusNode: FocusNode(),
              ),

              CustomTextField(
                labelName: 'Açıklama',
                focusNode: FocusNode(),
                requestfocusNode: FocusNode(),
                controller: _descriptionController,
              ),

              CustomTextField(
                labelName: 'Fiyat',
                controller: _priceController,
                focusNode: FocusNode(),
                requestfocusNode: FocusNode(),
              ),

              const SizedBox(height: 30),

              // Gönder Butonu
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProduct, // Yükleme sırasında buton devre dışı
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSecondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadii.borderRadius20,
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white) // Yükleme animasyonu
                    : const Text('Ürünü Güncelle', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
