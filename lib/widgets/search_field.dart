import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sizer/sizer.dart';

class SearchField extends StatefulWidget {
  final String? placeHolder;
  final Function(String? query)? onSearchPressed;
  final ValueChanged<String>? onChangedText;
  final String? initValue;

  const SearchField(
      {Key? key,
      this.placeHolder,
      this.onSearchPressed,
      this.onChangedText,
      this.initValue})
      : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  String? text;

  @override
  void initState() {
    super.initState();
    text = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: appTheme.colorScheme.onBackground,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
                onChanged: (val) {
                  widget.onChangedText?.call(val);
                  setState(() {
                    text = val;
                  });
                },
                keyboardType: TextInputType.text,
                cursorColor: appTheme.colorScheme.primary,
                style: appTheme.textTheme.headlineSmall,
                decoration: InputDecoration(
                    hintText: widget.placeHolder ?? "search".tr,
                    hintStyle: appTheme.textTheme.headlineSmall,
                    border: InputBorder.none)),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: appTheme.colorScheme.surface,
              size: 5.0.w,
            ),
            onPressed: () {
              widget.onSearchPressed?.call(text);
            },
          ),
        ],
      ),
    );
  }
}
