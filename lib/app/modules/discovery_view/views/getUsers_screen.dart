import 'dart:developer';

import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/service/get_users_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetUsersScreen extends StatefulWidget {
  const GetUsersScreen({super.key});

  @override
  State<GetUsersScreen> createState() => _GetUsersScreenState();
}

class _GetUsersScreenState extends State<GetUsersScreen> {
  final AuthController authController = Get.find();
  late Future<List<BusinessUserModel>?> _getUsersFuture;

  final GetUsersService _getUsersService = GetUsersService();
  @override
  void initState() {
    super.initState();
    _getUsersFuture = _getUsersService.getchGetUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Users '),
      ),
      body: FutureBuilder<List<BusinessUserModel>?>(
        future: _getUsersFuture,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              log((snapshot.data?[index].backPhoto).toString());
              return Container(
                decoration: BoxDecoration(color: AppColors.warmWhiteColor),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          '${authController.ipAddress}${snapshot.data?[index].backPhoto}',
                    ),
                    Text(snapshot.data?[index].businessName ?? ''),
                    Text(snapshot.data?[index].description ?? ''),
                    Row(
                      children: [
                        Text('Tel nom:'),
                        Text(snapshot.data?[index].businessPhone ?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Tik tok:'),
                        Text(snapshot.data?[index].tiktok ?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Instagram:'),
                        Text(snapshot.data?[index].instagram ?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Websites:'),
                        Text(snapshot.data?[index].website ?? ''),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
