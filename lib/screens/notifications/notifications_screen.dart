import 'package:flutter/material.dart';
import 'package:golf_uiv2/model/decision_option.dart';
import 'package:golf_uiv2/screens/notifications/notifications_controller.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/notification_widget.dart';
import 'package:loadmore/loadmore.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return GetBuilder<NotificationController>(
      initState: (_) {
        Get.find<NotificationController>().getListNotication();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: GolfColor.GolfPrimaryColor,
          body: SafeArea(
            child: Container(
              child: Column(
                children: [
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
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'notification'.tr,
                                  style:
                                      Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              SupportUtils.showDecisionDialog(
                                'are_you_sure_clear_notification'.tr,
                                lstOptions: [
                                  DecisionOption(
                                    'yes'.tr,
                                    type: DecisionOptionType.EXPECTATION,
                                    onDecisionPressed: () {
                                      controller.clearAllNotification();
                                    },
                                  ),
                                  DecisionOption(
                                    'no'.tr,
                                    onDecisionPressed: null,
                                  ),
                                ],
                              );
                            },
                            icon: Icon(
                              Icons.clear_all_rounded,
                              color: themeData.colorScheme.onPrimary,
                              size: 6.0.w,
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.0.w),
                          topRight: Radius.circular(6.0.w),
                        ),
                        color: Colors.white,
                      ),
                      child:
                          controller.isLoading &&
                                  controller.lstNotification.isEmpty
                              ? Center(child: CircularProgressIndicator())
                              : controller.lstNotification.isEmpty
                              ? Center(
                                child: Text(
                                  'not_fount_data'.tr,
                                  style: themeData.textTheme.headlineLarge,
                                ),
                              )
                              : LoadMore(
                                textBuilder: controller.buildStringLoadMore,
                                isFinish:
                                    controller.lstNotification.length >=
                                    (controller.total ?? 0),
                                onLoadMore: controller.getListNotication,
                                child: ListView.builder(
                                  padding: EdgeInsets.only(top: 2.0.h),
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return notificationItemView(
                                      themeData,
                                      controller.lstNotification[index],
                                    );
                                  },
                                  itemCount: controller.lstNotification.length,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
