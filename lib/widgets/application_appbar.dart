import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ApplicationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Future<bool> Function()? onBackPressed;

  const ApplicationAppBar(this.title,
      {Key? key, this.backgroundColor, this.onBackPressed})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight((kToolbarHeight - 10.0).sp);

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return Container(
      color: backgroundColor,
      alignment: Alignment.bottomLeft,
      child: InkWell(
        onTap: () {
          if (onBackPressed != null) {
            onBackPressed!.call().then((res) {
              if (res) {
                Get.back();
              }
            });
          } else {
            Get.back();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0.sp, horizontal: 15.0.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios, size: 3.0.h),
              SizedBox(width: 10.0.sp),
              Text(
                title,
                style: appTheme.textTheme.headlineSmall!
                    .copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
