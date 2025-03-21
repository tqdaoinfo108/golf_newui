import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/widgets/pressable.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';

class PickImageAlbumItem extends StatelessWidget {
  const PickImageAlbumItem({Key? key, this.albumItem, this.onItemPressed})
      : super(key: key);

  // final AssetPathEntity? albumItem;
  final dynamic? albumItem;
  final void Function()? onItemPressed;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final albumThumbnailPath = Rx<Uint8List?>(null);

    if ((albumItem?.assetCount ?? 0) > 0) {
      albumItem!.getAssetListRange(start: 0, end: 1).then((photos) => photos[0]
          .thumbnailData
          .then((thumnail) => albumThumbnailPath.value = thumnail));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 5.0.sp),
      child: Pressable(
        backgroundColor: appTheme.colorScheme.onBackground,
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0.sp),
        padding: EdgeInsets.all(10.0.sp),
        onPress: onItemPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(
              () => albumThumbnailPath.value == null
                  ? Container(width: 60.0.sp)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(5.0.sp),
                      child: Image.memory(
                        albumThumbnailPath.value!,
                        width: 60.0.sp,
                        height: 60.0.sp,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
            ),
            SizedBox(width: 10.0.sp),
            Text(
              "${albumItem!.name}\n(${albumItem!.assetCount})",
              style: appTheme.textTheme.headlineSmall!
                  .copyWith(color: appTheme.colorScheme.surface),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
