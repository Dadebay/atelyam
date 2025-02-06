import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/empty_states/empty_states.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:atelyam/app/data/service/about_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'; // flutter_widget_from_html paketini import et

class AboutUsView extends StatelessWidget {
  AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteMainColor,
      appBar: WidgetsMine().appBar(appBarName: 'aboutUs', actions: []),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FutureBuilder(
          future: AboutService().fetchAboutData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return EmptyStates().loadingData();
            } else if (snapshot.hasError) {
              return EmptyStates().errorData(snapshot.hasError.toString());
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: HtmlWidget(
                  snapshot.data!.description,
                  textStyle: TextStyle(
                    fontSize: AppFontSizes.fontSize16,
                    color: AppColors.darkMainColor,
                  ),
                ),
              );
            } else {
              return EmptyStates().noDataAvailablePage(textColor: AppColors.kPrimaryColor);
            }
          },
        ),
      ),
    );
  }
}
