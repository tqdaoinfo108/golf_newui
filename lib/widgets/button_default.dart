import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
    this.textColor,
    this.backgroundColor,
    this.radius = 40
  }) : super(key: key);
  final String? text;
  final Function? press;
  final Color? textColor;
  final Color? backgroundColor;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: GestureDetector(
        onTap: press as void Function()?,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [backgroundColor!, backgroundColor!.withOpacity(.9)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(radius!),
          ),
          child: Text(
            text!,
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize:
            16, color: textColor),
          ),
        ),
      ),
    );
  }
}
