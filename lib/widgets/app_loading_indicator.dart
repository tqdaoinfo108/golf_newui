import 'package:flutter/material.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:sizer/sizer.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      height: 10.0.w,
      width: 10.0.w,
      margin: EdgeInsets.all(5),
      child: CircularProgressIndicator(color: GolfColor.GolfPrimaryColor,));
}
