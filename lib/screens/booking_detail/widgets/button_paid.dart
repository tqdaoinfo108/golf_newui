import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:golf_uiv2/widgets/button_default.dart';

class ButtonPaid extends StatelessWidget {
  const ButtonPaid({Key? key, this.onCancelPressed}) : super(key: key);

  final void Function()? onCancelPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: DefaultButton(
            text: 'cancel_booking'.tr,
            textColor: Colors.white,
            backgroundColor: Colors.black87,
            press: onCancelPressed,
          ),
        ),
      ],
    );
  }
}
