import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/screens/transaction_history/transaction_history_controller.dart';
import 'package:golf_uiv2/screens/transaction_history/widgets/time_filter.dart';
import 'package:golf_uiv2/screens/transaction_history/widgets/transaction_history_list_item.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/app_listview.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:sizer/sizer.dart';

import '../../utils/color.dart';

class TransactionHistoryScreen extends GetView<TransactionHistoryController> {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: GolfColor.GolfPrimaryColor,
      appBar: ApplicationAppBar(context,"back".tr),
      body: Container(
        decoration: BoxDecoration(
          color: appTheme.colorScheme.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0.sp,
                horizontal: 15.0.sp,
              ),
              child: Obx(
                () => TimeFilter(
                  controller.fromDateFilter,
                  controller.toDateFilter,
                  onFromDateChanged: (date) {
                    controller.fromDateFilter = date;
                    if (date
                            .startOfDay()
                            .compareTo(controller.toDateFilter.startOfDay()) >
                        0) {
                      controller.toDateFilter = date;
                    }
                  },
                  onToDateChanged: (date) {
                    controller.toDateFilter = date;
                    if (date
                            .startOfDay()
                            .compareTo(controller.fromDateFilter.startOfDay()) <
                        0) {
                      controller.fromDateFilter = date;
                    }
                  },
                  onRequestSearch: () => controller.requestRefresh(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0.sp,
                horizontal: 15.0.sp,
              ),
              child: Obx(
                () => Text(
                  "${'result'.tr} (${controller.total})",
                  style: appTheme.textTheme.headlineSmall,
                ),
              ),
            ),
            Flexible(
              child: controller.obx(
                (lstTransactions) => (lstTransactions?.isEmpty ?? true)
                    ? _buildEmptyList(appTheme)
                    : AppListView(
                        itemCount: lstTransactions!.length,
                        itemBuilder: (context, index) =>
                            TransactionHistoryListItem(lstTransactions[index]),
                        onLoadMore: () => controller.requestLoadMore(),
                      ),
                onLoading: _buildLoadingIndicator(appTheme),
                onError: (error) {
                  SupportUtils.showToast(error, type: ToastType.ERROR);
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildEmptyList(ThemeData appTheme) => Container(
        child: Center(
          child: Text(
            "result_is_empty".tr,
            style: appTheme.textTheme.titleSmall
                ?.copyWith(color: appTheme.colorScheme.surface),
          ),
        ),
      );

  _buildLoadingIndicator(ThemeData appTheme) => Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
}
