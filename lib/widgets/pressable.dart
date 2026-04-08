import 'package:flutter/material.dart';

class Pressable extends StatelessWidget {
  final Color? splashColor;
  final Color? backgroundColor;
  final BorderSide? borderSide;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final double? pressRadius;
  final bool enabled;
  final Function()? onPress;

  const Pressable(
      {super.key,
      required this.child,
      this.splashColor,
      this.backgroundColor,
      this.borderSide,
      this.borderRadius,
      this.padding,
      this.onPress,
      this.pressRadius,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final roundedShape = RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.zero,
      side: borderSide ?? BorderSide.none,
    );

    return Opacity(
      opacity: enabled ? 1 : .4,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        shape: (borderRadius != null || borderSide != null)
            ? roundedShape
            : null,
        clipBehavior:
            (borderRadius != null || borderSide != null)
                ? Clip.antiAlias
                : Clip.none,
        child: InkWell(
          splashColor: splashColor,
          borderRadius: borderRadius,
          onTap: enabled ? onPress : null,
          radius: pressRadius,
          child: Padding(
            padding: padding ?? EdgeInsets.all(0),
            child: child,
          ),
        ),
      ),
    );
  }
}
