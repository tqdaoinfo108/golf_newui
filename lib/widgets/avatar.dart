import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Avatar extends StatelessWidget {
  final String? avatarPath;
  const Avatar({Key? key, this.avatarPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        '$avatarPath',
        width: 60.0.sp,
        height: 60.0.sp,
        fit: BoxFit.cover,
      ),
    );
  }
}
