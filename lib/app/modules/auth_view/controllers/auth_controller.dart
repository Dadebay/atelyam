import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final ipAddress = ''.obs;

  final db = FirebaseFirestore.instance;

  Future<void> fetchIpAddress() async {
    try {
      final DocumentSnapshot snapshot = await db.collection('server').doc('server_ip').get();
      log(snapshot.data.toString());
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        ipAddress.value = data['ip'] ?? 'http://216.250.12.49:8000/'; // Get IP address from "ip" field
      } else {
        ipAddress.value = 'IP adresi bulunamadı.';
      }
    } catch (e) {
      ipAddress.value = 'Veritabanından IP adresi çekilemedi.';
    }
  }

  // IP adresini Firebase'e kaydetme fonksiyonu (Gerçek bir IP adres alma mantığı yok)
  Future<void> saveIpAddress(String newIp) async {
    try {
      await db.collection('server').doc('server_ip').set({'ip': newIp}); //Firestore için
      ipAddress.value = newIp;
    } catch (e) {}
  }
}
