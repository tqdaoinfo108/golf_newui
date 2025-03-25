import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';

Widget settingItem(
  BuildContext context,
  String title,
  Function func,
  IconData icon, {
  Color color = GolfColor.GolfIconColor,
}) {
  final appTheme = Theme.of(context);

  return InkWell(
    onTap: () => func.call(),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.0.w, 2.0.w, 6.0.w, 2.0.w),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 6.0.w),
                    SizedBox(width: 20),
                    Text(title, style: appTheme.textTheme.headlineSmall),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 5.0.w,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget settingItemWithImage(
  BuildContext context,
  String title,
  Function func,
  String icon, {
  Color color = GolfColor.GolfIconColor,
}) {
  final appTheme = Theme.of(context);

  return InkWell(
    onTap: () => func.call(),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.0.w, 2.0.w, 6.0.w, 2.0.w),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Row(
                  children: [
                    Image.asset(
                      icon,
                      width: 5.0.w,
                      height: 5.0.w,
                      color: color,
                    ),
                    SizedBox(width: 20),
                    Text(title, style: appTheme.textTheme.headlineSmall),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 5.0.w,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

//
// Widget buttonSignOut(BuildContext context) {
//   final appTheme = Theme.of(context);
//
//   return InkWell(
//     onTap: () {
//       SupportUtils.letsLogout();
//       Get.offAllNamed(AppRoutes.LOGIN);
//     },
//     child: Container(
//       padding: EdgeInsets.all(4.0.w),
//       decoration: BoxDecoration(
//           border: Border.all(width: 1, color: Colors.white54),
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           color: Theme.of(context).colorScheme.onBackground),
//       child: Row(
//         children: [
//           Icon(
//             Icons.logout,
//             color: Colors.red[400],
//             size: 5.0.w,
//           ),
//           SizedBox(width: 4.0.w),
//           Text(
//             'sign_out'.tr,
//             style: appTheme.textTheme.headlineSmall,
//           ),
//         ],
//       ),
//     ),
//   );
// }
