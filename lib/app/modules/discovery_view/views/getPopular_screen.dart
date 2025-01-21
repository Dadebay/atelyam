import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/get_popular_model.dart';
import 'package:atelyam/app/data/service/get_popular_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetPopularScreen extends StatefulWidget {
  const GetPopularScreen({super.key});

  @override
  State<GetPopularScreen> createState() => _GetPopularScreenState();
}

class _GetPopularScreenState extends State<GetPopularScreen> {
  late Future<List<GetPopularModel>?> _getPopularFuture;
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    _getPopularFuture = GetPopularService().fetchGetPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Populars'),
      ),
      body: FutureBuilder<List<GetPopularModel>?>(
        future: _getPopularFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return EmptyStates().loadingData();
          } else if (snapshot.hasError) {
            return EmptyStates().errorData(snapshot.hasError.toString());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(color: AppColors.warmWhiteColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            '${authController.ipAddress}${snapshot.data?[index].images?[0].image}',
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data?[index].businessName ?? ''),
                          Text(
                            snapshot.data?[index].phone ?? '',
                          ),
                          Text(
                            snapshot.data?[index].productCount.toString() ?? '',
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Text('no data');
          }
        },
      ),
    );
  }
}
