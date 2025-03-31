import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/screens/my_vip_list/my_vip_list_controller.dart';
import 'package:golf_uiv2/screens/my_vip_list/widgets/my_vip_list_item.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/app_listview.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:sizer/sizer.dart';

class MyVipListScreen extends GetView<MyVipListController> {
  const MyVipListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colorScheme.onBackground,
      appBar: ApplicationAppBar(context,"back".tr),
      body: Container(
        decoration: BoxDecoration(
          color: appTheme.colorScheme.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0.sp),
            topRight: Radius.circular(30.0.sp),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0.sp),
            Flexible(
              child: controller.obx(
                (lstVipMembers) => (lstVipMembers?.isEmpty ?? true)
                    ? _buildEmptyList(appTheme)
                    : AppListView(
                        itemCount: lstVipMembers!.length,
                        itemBuilder: (context, index) => MyVipListItem(
                          vipMemberItem: lstVipMembers[index],
                          autoRenewChanged: (val) =>
                              controller.updateRenew(lstVipMembers[index], val),
                          enable: lstVipMembers[index].isUseable(),
                        ),
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

  Widget _buildEmptyList(ThemeData appTheme) => Container(
        child: Center(
          child: Text(
            "not_have_vip_member".tr,
            style: appTheme.textTheme.titleSmall
                ?.copyWith(color: appTheme.colorScheme.surface),
          ),
        ),
      );

  Widget _buildLoadingIndicator(ThemeData appTheme) => Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
}
