import 'package:atelyam/app/modules/settings_view/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectImageView extends StatelessWidget {
  final NewSettingsPageController controller =
      Get.put(NewSettingsPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Single Image Picker')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            return controller.selectedImage.value != null
                ? Column(
                    children: [
                      Image.file(
                        controller.selectedImage.value!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: controller.removeImage,
                        child: Text('Remove Image'),
                      ),
                    ],
                  )
                : Text('No image selected');
          }),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: controller.pickImage,
            child: Text('Pick Image'),
          ),
        ],
      ),
    );
  }
}
