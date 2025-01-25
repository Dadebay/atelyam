import 'package:atelyam/app/core/custom_widgets/agree_button_view.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/models/business_user_model.dart';
import 'package:atelyam/app/data/service/business_user_service.dart';
import 'package:atelyam/app/modules/settings_view/views/create_business_account_view.dart';
import 'package:atelyam/app/modules/settings_view/views/edit_business_account_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBusinessAccountsView extends StatelessWidget {
  const AllBusinessAccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'allBusinessAccounts'.tr,
          style: TextStyle(color: AppColors.whiteMainColor, fontSize: AppFontSizes.fontSize20, fontWeight: FontWeight.bold),
        ),
      ),
      bottomSheet: AgreeButton(
        onTap: () {
          print('Asd');
          Get.to(() => CreateBusinessAccountView());
        },
        text: 'add account',
      ),
      body: FutureBuilder<List<BusinessUserModel>?>(
        future: BusinessUserService().getMyBusinessAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return EmptyStates().loadingData();
          } else if (snapshot.hasError) {
            return EmptyStates().errorData(snapshot.hasError.toString());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemExtent: Get.size.height * 0.20,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => EditBusinessAccountView(businessId: snapshot.data![index].id.toString()));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    decoration: BoxDecoration(
                      color: snapshot.data![index].status.toString() == 'active' ? AppColors.warmWhiteColor : AppColors.red1Color,
                      borderRadius: BorderRadii.borderRadius20,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadii.borderRadius40,
                            child: WidgetsMine().customCachedImage(
                              snapshot.data![index].backPhoto,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              snapshot.data![index].businessName,
                            ),
                            Text(
                              snapshot.data![index].businessPhone,
                            ),
                          ],
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return EmptyStates().noDataAvailable();
        },
      ),
    );
  }
}
