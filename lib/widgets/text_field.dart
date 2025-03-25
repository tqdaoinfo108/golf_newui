import 'package:flutter/material.dart';
import 'package:golf_uiv2/screens/booking/booking_controller.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

Widget textFieldInput() {
  return SizedBox(height: 14.0.w, child: TextField());
}

class TexFieldValidate extends StatefulWidget {
  final ThemeData? themeData;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? icon;
  final Color? accentColor;
  final FormFieldValidator<String>? validate;
  final isPassword;
  final FormFieldSetter<String>? onChanged;
  final Function? onEditingComplete;
  final FocusNode focusNode;
  final bool enable;
  final String? initialValue;
  final TextInputType textInputType;
  TexFieldValidate(
    this.focusNode, {
    this.hintText,
    this.controller,
    this.icon,
    this.accentColor,
    this.validate,
    this.themeData,
    this.onChanged,
    this.onEditingComplete,
    this.enable = true,
    this.initialValue,
    this.isPassword = false,
    this.textInputType = TextInputType.text,
    Key? key,
  }) : super(key: key);

  @override
  TexFieldValidateState createState() => TexFieldValidateState();
}

class TexFieldValidateState extends State<TexFieldValidate> {
  var _isShowPassword = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.enable ? 1.0 : 0.6,
      child: Container(
        child: TextFormField(
          keyboardType: widget.textInputType,
          initialValue: widget.initialValue,
          enabled: widget.enable,
          // focusNode: widget.focusNode,
          controller: widget.controller,
          cursorColor: widget.accentColor,
          // validator: widget.validate,
          obscureText: widget.isPassword && !_isShowPassword,
          style: widget.themeData!.primaryTextTheme.titleSmall!.copyWith(
            color: widget.themeData!.colorScheme.surface,
          ),

          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffF3F3F3),
            // fillColor: widget.themeData!.colorScheme.backgroundCardColor,
            errorText: _errorMessage,
            errorStyle: widget.themeData!.textTheme.titleSmall!.copyWith(
              color: widget.themeData!.colorScheme.error,
            ),
            contentPadding: EdgeInsets.fromLTRB(2.0.w, 4.0.w, 1.0.w, 4.0.w),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(40),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(40),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(40),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(40),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(40),
            ),
            prefixIcon: Icon(
              widget.icon,
              color: widget.accentColor,
              size: 5.0.w,
            ),
            hintText: widget.hintText,
            hintStyle: widget.themeData!.primaryTextTheme.titleSmall!.copyWith(
              color: Color(0xff949494),
            ),
            border: InputBorder.none,
            suffixIcon:
                !widget.isPassword
                    ? null
                    : Padding(
                      padding: EdgeInsets.only(right: 2.0.w),
                      child: IconButton(
                        icon: Icon(
                          _isShowPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color:
                              GolfColor.GolfPrimaryColor,
                          size: 6.0.w,
                        ),
                        onPressed:
                            () => setState(
                              () => _isShowPassword = !_isShowPassword,
                            ),
                      ),
                    ),
          ),
          onChanged: (value) {
            if (widget.onChanged != null) widget.onChanged!(value);

            setState(() {
              if (widget.validate != null)
                _errorMessage = widget.validate!(value);
              else
                _errorMessage = null;
            });
          },
          onEditingComplete: widget.onEditingComplete as void Function()?,
        ),
      ),
    );
  }
}

Widget searchTextFieldView(
  ThemeData themeData,
  BookingController bookingController,
) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 5.0.sp, vertical: 1.0.sp),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: themeData.colorScheme.backgroundCardColor,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            onChanged: bookingController.getShopByKeySearch,
            keyboardType: TextInputType.text,
            cursorColor: GolfColor.GolfPrimaryColor,
            style: themeData.textTheme.headlineSmall,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal:
              20),
              hintText: "search".tr,
              hintStyle: themeData.textTheme.headlineSmall,
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.search,
            color: themeData.colorScheme.iconColor,
            size: 5.0.w,
          ),
          onPressed: () {},
        ),
      ],
    ),
  );
}
