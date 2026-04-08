import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:golf_uiv2/widgets/button_default.dart';

import '../../../utils/color.dart';

class ButtonWatingPayment extends StatelessWidget {
  const ButtonWatingPayment(
      {Key? key, this.onCancelPressed, this.onPaymentPressed})
      : super(key: key);

  final void Function()? onCancelPressed;
  final void Function()? onPaymentPressed;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return DefaultButton(
      text: 'payment'.tr,
      textColor: appTheme.colorScheme.onSecondary,
      backgroundColor: GolfColor.GolfPrimaryColor,
      radius: 12,
      press: onPaymentPressed,
    );
  }
}
