// import 'package:atelyam/app/core/empty_states/empty_states.dart';
// import 'package:atelyam/app/core/theme/theme.dart';
// import 'package:atelyam/app/data/service/about_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart'; // flutter_html paketini ekleyin
// import 'package:get/get.dart';
// import 'package:iconly/iconly.dart';

// class AboutUsView extends StatelessWidget {
//   AboutUsView({super.key});

//   // final SettingsPageController settingsController = Get.find<SettingsPageController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteMainColor,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         scrolledUnderElevation: 0,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: const Icon(
//             IconlyLight.arrow_left_circle,
//             color: AppColors.whiteMainColor,
//           ),
//         ),
//         backgroundColor: AppColors.kPrimaryColor,
//         title: Text(
//           'aboutUs'.tr,
//           style: TextStyle(
//             color: AppColors.whiteMainColor,
//             fontSize: AppFontSizes.fontSize20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: FutureBuilder(
//           future: AboutService().fetchAboutData(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return EmptyStates().loadingData();
//             } else if (snapshot.hasError) {
//               return EmptyStates().errorData(snapshot.hasError.toString());
//             } else if (snapshot.hasData) {
//               return Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Html(
//                   data: snapshot.data!.description, // HTML içeriğini render et
//                   style: {
//                     'body': Style(
//                       fontSize: FontSize(AppFontSizes.fontSize16),
//                       color: AppColors.darkMainColor,
//                     ),
//                     'h3': Style(
//                       fontSize: FontSize(AppFontSizes.fontSize20),
//                       fontWeight: FontWeight.bold,
//                       padding: EdgeInsets.only(bottom: 10),
//                     ),
//                     'p': Style(
//                       padding: EdgeInsets.only(bottom: 10),
//                     ),
//                     'a': Style(
//                       color: AppColors.kPrimaryColor,
//                       textDecoration: TextDecoration.none,
//                     ),
//                   },
//                 ),
//               );
//             } else {
//               return const Center(child: Text('No data available'));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
