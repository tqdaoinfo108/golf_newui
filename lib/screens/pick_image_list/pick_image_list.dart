import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/screens/pick_image_list/widgets/pick_image_list_item.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';

class PickImageListScreen extends StatelessWidget {
  const PickImageListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic>? lstPhotos = Get.arguments;
    final appTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colorScheme.primary,
      appBar: ApplicationAppBar("back".tr),
      body: Container(
        decoration: BoxDecoration(
          color: appTheme.colorScheme.onBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0.sp),
            topRight: Radius.circular(30.0.sp),
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
              child: Text(
                "${'pick_a_photo'.tr}",
                style: appTheme.textTheme.headlineSmall,
              ),
            ),
            Flexible(
              child: (lstPhotos?.isEmpty ?? true)
                  ? _buildEmptyList(appTheme)
                  : GridView.builder(
                      padding: EdgeInsets.all(15.0.sp),
                      itemCount: lstPhotos!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 3.0.sp,
                        crossAxisSpacing: 3.0.sp,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return PickImageListItem(
                          photoItem: lstPhotos[index],
                          onItemPressed: () => Get.back(
                            result: PageResult(
                              resultCode: PageResultCode.OK,
                              data: lstPhotos[index],
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyList(ThemeData appTheme) => Container(
        child: Center(
          child: Text(
            "not_have_any_photos".tr,
            style: appTheme.textTheme.titleSmall
                ?.copyWith(color: appTheme.colorScheme.surface),
          ),
        ),
      );
}
