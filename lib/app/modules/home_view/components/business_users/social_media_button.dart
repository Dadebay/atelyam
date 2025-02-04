import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final String name;
  final String userName;
  final int maxline;

  const SocialMediaIcon({
    required this.icon,
    required this.index,
    required this.name,
    required this.userName,
    required this.maxline,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String displayedUserName = userName;
    String urlToLaunch;

    if (userName.startsWith('@')) {
      String platformUrl = '';
      switch (name) {
        case 'Instagram':
          platformUrl = 'https://www.instagram.com/${userName.substring(1)}';
          break;
        case 'TikTok':
          platformUrl = 'https://www.tiktok.com/@${userName.substring(1)}';
          break;
        case 'Youtube':
          platformUrl = 'https://youtube.com/${userName.substring(1)}';
          break;
        default:
          platformUrl = userName;
      }
      urlToLaunch = platformUrl;
    } else if (userName.startsWith('http://') || userName.startsWith('https://')) {
      urlToLaunch = userName;
      displayedUserName = Uri.parse(userName).host;
    } else if (userName.startsWith('+') || RegExp(r'^[0-9]+$').hasMatch(userName)) {
      // Eğer userName bir telefon numarası ise
      urlToLaunch = 'tel:$userName';
      displayedUserName = userName;
    } else {
      urlToLaunch = userName;
    }

    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(urlToLaunch);
        print(url);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          showSnackBar('url_error', 'url_error_message', AppColors.darkMainColor);
        }
      },
      child: FadeInUp(
        duration: Duration(milliseconds: 300 * index),
        child: Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 50),
          child: Row(
            children: [
              Container(
                width: AppFontSizes.getFontSize(12),
                height: AppFontSizes.getFontSize(12),
                margin: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadii.borderRadius18,
                  color: AppColors.kSecondaryColor,
                ),
                child: Icon(
                  icon,
                  color: AppColors.whiteMainColor,
                  size: AppFontSizes.getFontSize(6),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.getFontSize(3.5),
                        color: AppColors.darkMainColor.withOpacity(.6),
                      ),
                    ),
                    Text(
                      displayedUserName,
                      maxLines: maxline,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppFontSizes.getFontSize(4.5),
                        color: AppColors.kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Icon(
                  IconlyLight.arrow_right_circle,
                  color: AppColors.kPrimaryColor,
                  size: AppFontSizes.getFontSize(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
