import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:sizer/sizer.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
    this.textColor,
    this.backgroundColor,
  }) : super(key: key);
  final String? text;
  final Function? press;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 14.0.w,
      child: GestureDetector(
        onTap: press as void Function()?,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [backgroundColor!, backgroundColor!.withOpacity(.86)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: AutoSizeText(
            text!,
            style: TextStyle(fontSize: 14.0.sp, color: textColor),
          ),
        ),
      ),
    );
  }
}
