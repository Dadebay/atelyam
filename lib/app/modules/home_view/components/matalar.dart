import 'package:atelyam/app/core/custom_widgets/listview_top_name_icon_part.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class Matalar extends StatelessWidget {
  const Matalar({required this.screenWidth, super.key});
  final double screenWidth;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListviewTopNameIconPart(
          text: 'Matalar',
          icon: false,
          onTap: () {},
        ),
        SizedBox(
          height: screenWidth * 0.45,
          child: ListView.builder(
            itemCount: 10,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: screenWidth * 0.55,
                margin: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadii.borderRadius30,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kPrimaryColor.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadii.borderRadius30,
                        child: Image.asset(
                          'assets/image/matalar/${index + 1}.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadii.borderRadius30,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Matalaryn atlary',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            height: 1.0,
                            fontWeight: FontWeight.w600,
                            fontSize: AppFontSizes.fontSize20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
