import 'package:flutter/material.dart';
import 'package:golf_uiv2/widgets/pressable.dart';

class PressableText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? splashColor;
  final Color? backgroundColor;
  final BorderSide? borderSide;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Function()? onPress;
  final double? pressRadius;
  final bool enabled;

  const PressableText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.splashColor,
    this.backgroundColor,
    this.borderSide,
    this.borderRadius,
    this.padding,
    this.onPress,
    this.pressRadius,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      splashColor: splashColor,
      backgroundColor: backgroundColor,
      borderSide: borderSide,
      borderRadius: borderRadius,
      padding: padding,
      onPress: onPress,
      pressRadius: pressRadius,
      enabled: enabled,
      child: Text(
        data,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
      ),
    );
  }
}
