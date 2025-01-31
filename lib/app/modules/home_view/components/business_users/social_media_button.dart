import 'package:animate_do/animate_do.dart';
import 'package:atelyam/app/core/custom_widgets/widgets.dart';
import 'package:atelyam/app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    } else {
      urlToLaunch = userName;
    }

    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(urlToLaunch);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          showSnackBar('url_error', 'url_error_message', AppColors.darkMainColor);
        }
      },
      child: FadeInUp(
        duration: Duration(milliseconds: 500 * index),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        icon,
                        color: AppColors.darkMainColor.withOpacity(.6),
                        size: AppFontSizes.fontSize20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        name.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppFontSizes.fontSize16,
                          color: AppColors.darkMainColor.withOpacity(.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 3,
                child: Text(
                  displayedUserName,
                  maxLines: maxline,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSizes.fontSize16,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
