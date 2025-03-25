import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DefaultAvatar extends StatelessWidget {
  const DefaultAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/images/user.png',
        width: 60.0.sp,
        height: 60.0.sp,
        fit: BoxFit.cover,
      ),
    );
  }
}
