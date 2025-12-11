import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/screens/notification_detail/notification_detail_controller.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';

class NotificationDetailScreen extends GetView<NotificationDetailController> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    
    return Scaffold(
      backgroundColor: GolfColor.GolfPrimaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: themeData.colorScheme.onPrimary,
                        size: 6.0.w,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  alignment: Alignment.center,
                  child: Text(
                    'notification_detail'.tr,
                    textAlign: TextAlign.center,
                    style: themeData.textTheme.titleLarge!.copyWith(
                      color: themeData.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 60),
              ],
            ),
            
            // Content
            Expanded(
              child: Container(
                  width: double.maxFinite,

                decoration: BoxDecoration(
                  color: GolfColor.GolfGrayBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Obx(() {
                  if (controller.notification == null) {
                    return Center(
                      child: Text(
                        'no_notification_data'.tr,
                        style: themeData.textTheme.bodyLarge,
                      ),
                    );
                  }
                  
                  final notification = controller.notification!;
                  
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          notification.title ?? '',
                          style: themeData.textTheme.titleLarge!.copyWith(
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        // Date
                        if (notification.createdDate != null)
                          Text(
                            (notification.createdDate!*1000)
                                            .toStringFormatDate(),
                            style: themeData.textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                              fontSize: 11.0.sp,
                            ),
                          ),
                        
                        SizedBox(height: 20),
                        
                        // Content
                        Text(
                          notification.message ?? '',
                          style: themeData.textTheme.bodyLarge!.copyWith(
                            fontSize: 13.0.sp,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
