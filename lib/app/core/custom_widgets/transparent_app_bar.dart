// ignore_for_file: deprecated_member_use

import 'package:atelyam/app/core/custom_widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TransparentAppBar({required this.title, required this.color, Key? key, this.actions}) : super(key: key);
  final String title;
  final Color color;
  final List<Widget>? actions; // İsteğe bağlı action listesi

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title.tr,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),

      centerTitle: true,
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.transparent,
      leadingWidth: 60,
      leading: const Padding(padding: EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 4), child: BackButtonMine()),
      actions: actions, // Actionları ekliyoruz
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
