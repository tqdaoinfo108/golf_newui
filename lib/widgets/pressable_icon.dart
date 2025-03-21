import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:golf_uiv2/widgets/pressable.dart';

class PressableIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final Color? splashColor;
  final Color? backgroundColor;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final BorderSide? borderSide;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Function()? onPress;
  final double? pressRadius;
  final bool enabled;

  const PressableIcon(
    this.icon, {
    Key? key,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.onPress,
    this.splashColor,
    this.backgroundColor,
    this.padding,
    this.borderSide,
    this.borderRadius,
    this.pressRadius,
    this.enabled = true,
  }) : super(key: key);

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
      child: Icon(
        icon,
        size: size,
        color: color,
        semanticLabel: semanticLabel,
        textDirection: textDirection,
      ),
    );
  }
}
