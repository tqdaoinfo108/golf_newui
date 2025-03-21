import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:golf_uiv2/router/app_routers.dart';
// import 'package:golf_uiv2/screens/pick_image_album_list/widgets/pick_image_album_item.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
// import 'package:golf_uiv2/widgets/app_listview.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';
//
class PickImageAlbumListScreen extends StatelessWidget {
  const PickImageAlbumListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//     _checkPermission();
//     final List<AssetPathEntity>? lstAlbums = Get.arguments;
    final appTheme = Theme.of(context);
//
    return Scaffold(
      backgroundColor: appTheme.colorScheme.primary,
      appBar: ApplicationAppBar("back".tr),
      body: Container(
//         decoration: BoxDecoration(
//           color: appTheme.colorScheme.background,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30.0.sp),
//             topRight: Radius.circular(30.0.sp),
//           ),
//         ),
//         constraints: BoxConstraints.expand(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 vertical: 10.0.sp,
//                 horizontal: 15.0.sp,
//               ),
//               child: Text(
//                 "${'choose_an_album'.tr}",
//                 style: appTheme.textTheme.headlineSmall,
//               ),
//             ),
//             Flexible(
//               child: (lstAlbums?.isEmpty ?? true)
//                   ? _buildEmptyList(appTheme)
//                   : AppListView(
//                       itemCount: lstAlbums!.length,
//                       itemBuilder: (context, index) =>
//                           // Text("${lstAlbums[index].files?.length}")
//                           PickImageAlbumItem(
//                         albumItem: lstAlbums[index],
//                         onItemPressed: () async => Get.toNamed(
//                                 AppRoutes.PICK_IMAGE_LIST,
//                                 arguments: await lstAlbums[index]
//                                     .getAssetListRange(
//                                         start: 0,
//                                         end: lstAlbums[index].assetCount))!
//                             .then((result) {
//                           if (result != null) {
//                             Get.back(result: result);
//                           }
//                         }),
//                       ),
//                     ),
//             ),
//           ],
//         ),
      ),
    );
  }
//
//   Widget _buildEmptyList(ThemeData appTheme) => Container(
//         child: Center(
//           child: Text(
//             "not_have_any_album_in_your_gallery".tr,
//             style: appTheme.textTheme.titleSmall
//                 ?.copyWith(color: appTheme.colorScheme.surface),
//           ),
//         ),
//       );
//
//   Future<bool> _checkPermission() async {
//     final PermissionState res = await PhotoManager.requestPermissionExtend();
//     if (res == PermissionState.limited) {
//       SupportUtils.showToast('choosing_limited_photos'.tr,
//           type: ToastType.WARNING);
//     }
//     return res == PermissionState.authorized || res == PermissionState.limited;
//   }
}
