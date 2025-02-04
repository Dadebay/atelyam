// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use
// SignInService().checkConnection();
import 'dart:async';
import 'dart:math';

import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/service/auth_service.dart';
import 'package:atelyam/app/modules/auth_view/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ConnectionCheckView extends StatefulWidget {
  @override
  State<ConnectionCheckView> createState() => _ConnectionCheckViewState();
}

class _ConnectionCheckViewState extends State<ConnectionCheckView> {
  final ScrollController _scrollController = ScrollController();

  late Timer _scrollTimer;

  final int itemCount = 29;

  late List<int> extendedItemList;

  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();

    final random = Random();
    final startIndex = random.nextInt(itemCount);
    extendedItemList = List.generate(itemCount * 2, (index) => (index + startIndex) % itemCount + 1);
    startAutoScroll();
    SignInService().checkConnection();
    authController.fetchIpAddress();
  }

  List<String> loadingMessages = [
    'brandingTitle1',
    'brandingTitle2',
    'brandingTitle3',
    'brandingTitle4',
    'brandingTitle5',
    'brandingTitle6',
    'brandingTitle7',
    'brandingTitle8',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer.cancel();
    super.dispose();
  }

  void startAutoScroll() {
    const scrollSpeed = 6.0;
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 100) {
          _scrollController.jumpTo(_scrollController.offset - (_scrollController.position.maxScrollExtent / 2));
        } else {
          _scrollController.animateTo(
            _scrollController.offset + scrollSpeed,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  Widget buildGridView() {
    return MasonryGridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: extendedItemList.length,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                spreadRadius: 2,
                blurRadius: 12,
              ),
            ],
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image(
              image: AssetImage('assets/image/fasonlar/${extendedItemList[index]}.webp'),
              fit: BoxFit.cover,
              frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(child: buildGridView()),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 60, bottom: 60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.005),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    Assets.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 70, bottom: 25, left: 10, right: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.005),
                  ],
                ),
              ),
              child: Text(
                loadingMessages[random.nextInt(loadingMessages.length)].tr.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: AppFontSizes.getFontSize(5),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
