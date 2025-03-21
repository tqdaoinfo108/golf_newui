import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/widgets/pressable.dart';
// import 'package:photo_manager/photo_manager.dart';

class PickImageListItem extends StatelessWidget {
  const PickImageListItem({Key? key, this.photoItem, this.onItemPressed})
      : super(key: key);

  // final AssetEntity? photoItem;
  final dynamic? photoItem;
  final void Function()? onItemPressed;

  @override
  Widget build(BuildContext context) {
    final thumbnailPath = Rx<Uint8List?>(null);

    photoItem?.thumbnailData.then((value) => thumbnailPath.value = value);

    return Pressable(
        backgroundColor: Colors.transparent,
        borderSide: BorderSide.none,
        onPress: onItemPressed,
        child: Obx(
          () => thumbnailPath.value == null
              ? Center(child: CircularProgressIndicator())
              : Image.memory(
                  thumbnailPath.value!,
                  fit: BoxFit.fitWidth,
                ),
        ));
  }
}
