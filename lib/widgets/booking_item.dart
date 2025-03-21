import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:golf_uiv2/model/block.dart';
import 'package:golf_uiv2/model/shop_model.dart';
import 'package:golf_uiv2/model/shops.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/widgets/pressable.dart';
import 'package:golf_uiv2/widgets/pressable_icon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';

Widget shopItemView(ThemeData themeData, ShopItemModel shops,
    {Color? backgroundColor,
    void Function()? onItemPressed,
    bool enabled = true,
    Function(bool)? onFavoriteChanged}) {
  return Stack(
    children: [
      Padding(
        padding: EdgeInsets.only(bottom: 2.0.w),
        child: Pressable(
          padding: EdgeInsets.all(2.0.h),
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(2.0.h),
          backgroundColor: themeData.colorScheme.onBackground,
          onPress: onItemPressed,
          enabled: enabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: themeData.textTheme.headlineSmall!.copyWith(
                    color: themeData.colorScheme.surface,
                  ),
                  children: <InlineSpan>[
                    (shops.isMember ?? false)
                        ? _buildMemberText(themeData)
                        : TextSpan(),
                    (shops.countMemberLimit ?? 0) > 0
                        ? _buildVipLimitText(themeData, shops.countMemberLimit)
                        : TextSpan(),
                    (shops.isShopManager ?? false)
                        ? WidgetSpan(
                            child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Image.asset("assets/icons/person_vip.png",
                                width: 24),
                          ))
                        : TextSpan(),
                    TextSpan(text: "${shops.nameShop}"),
                  ],
                ),
              ),
              SizedBox(height: 1.0.h),
              Text(
                shops.addressShop!,
                style: themeData.textTheme.headlineLarge,
              ),
              SizedBox(height: 1.0.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 0,
                      child: Icon(
                        Icons.phone,
                        color: themeData.colorScheme.iconColor,
                        size: 5.0.w,
                      )),
                  SizedBox(width: 2.0.h),
                  Text(
                    shops.phoneShop!,
                    style: themeData.textTheme.headlineSmall,
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_city,
                    color: themeData.colorScheme.iconColor,
                    size: 5.0.w,
                  ),
                  SizedBox(width: 2.0.h),
                  Text(
                    shops.distance.toString() + " km",
                    style: themeData.textTheme.headlineSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      shops.discount != 0
          ? Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                    color: shops.discount! < 100
                        ? Colors.red[400]
                        : Colors.green[400],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(2.0.h),
                      bottomLeft: Radius.circular(8),
                    ) // green shaped
                    ),
                child: Text(shops.discount! < 100
                    ? "-" + (100 - shops.discount!.toInt()).toString() + "%"
                    : "+" + (shops.discount!.toInt() - 100).toString() + "%"),
              ),
            )
          : Container(),
      Positioned(
        bottom: 2.0.w,
        right: 0,
        child: _buildFavoriteButton(
          themeData,
          isFavorite: shops.isFavorite!,
          onFavoriteChanged: onFavoriteChanged,
        ),
      )
    ],
  );
  // .onTap(() {
  //   if (onItemPressed != null) {
  //     onItemPressed.call();
  //   } else {
  //     Get.toNamed(AppRoutes.BOOKING_CREATE, arguments: shops);
  //   }
  // });
}

_buildVipLimitText(ThemeData appTheme, int? countTurns) => WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: Container(
      margin: EdgeInsets.only(
        right: 5.0.sp,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 4.0.sp,
        vertical: 1.0.sp,
      ),
      decoration: BoxDecoration(
        color: appTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(5.0.sp),
      ),
      child: Text(
        "$countTurns",
        style: appTheme.textTheme.titleSmall!.copyWith(
          fontSize: 9.0.sp,
          color: appTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    )

    // Container(
    //   margin: EdgeInsets.only(right: 5.0.sp),
    //   decoration: BoxDecoration(
    //     color: appTheme.colorScheme.primary,
    //     borderRadius: BorderRadius.circular(3.0.sp),
    //   ),
    //   padding: EdgeInsets.symmetric(
    //     horizontal: 3.0.sp,
    //     vertical: 3.0.sp,
    //   ),
    //   child: Text(
    //     "$countTurns".tr.toUpperCase(),
    //     style: appTheme.textTheme.titleSmall
    //         .copyWith(color: appTheme.colorScheme.onPrimary),
    //   ),
    // ),
    );

_buildMemberText(ThemeData appTheme) => WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
        padding: EdgeInsets.only(right: 5.0.sp),
        child: Icon(
          Icons.card_membership,
          size: 15.0.sp,
          color: appTheme.colorScheme.secondary,
        ),
      ),
    );

_buildFavoriteButton(ThemeData appTheme,
        {bool isFavorite = false, Function(bool)? onFavoriteChanged}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PressableIcon(
          isFavorite ? Icons.favorite : Icons.favorite_outline,
          color: isFavorite ? Colors.red[400] : appTheme.colorScheme.onSurface,
          size: 6.0.w,
          padding: EdgeInsets.all(13),
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(23),
          onPress: () => onFavoriteChanged!(!isFavorite),
        )
      ],
    );

Widget shopItemViewNoEvent(ThemeData themeData, Shops shop) {
  return Container(
    margin: EdgeInsets.only(bottom: 2.0.h),
    padding: EdgeInsets.all(2.0.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2.0.h)),
        color: Get.context!.theme.colorScheme.backgroundCardColor),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          shop.name,
          style: themeData.textTheme.headlineSmall,
        ),
        SizedBox(height: 1.0.h),
        Text(
          shop.address,
          style: themeData.textTheme.headlineLarge,
        ),
        SizedBox(height: 1.0.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 0,
                child: Icon(
                  Icons.phone,
                  color: themeData.colorScheme.iconColor,
                )),
            SizedBox(width: 2.0.h),
            Text(
              shop.phone,
              style: themeData.textTheme.headlineSmall,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 0,
                child:
                    Icon(Icons.money, color: themeData.colorScheme.iconColor)),
            SizedBox(width: 2.0.h),
            Text(
              shop.price.toString(),
              style: themeData.textTheme.headlineSmall,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 0,
                child: Icon(Icons.location_city,
                    color: themeData.colorScheme.iconColor)),
            SizedBox(width: 2.0.h),
            Text(
              shop.range.toString() + " km",
              style: themeData.textTheme.headlineSmall,
            )
          ],
        ),
      ],
    ),
  );
}

Widget bookingDetailItemView(
    ThemeData themeData, String? title, String content) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title != null
          ? Text(
              title,
              style: themeData.textTheme.titleSmall,
            )
          : Container(),
      SizedBox(height: 1.0.h),
      Text(
        content,
        style: themeData.textTheme.headlineLarge,
      )
    ],
  );
}

Widget bookingDetailSimpleItemView(
    ThemeData themeData, String title, String content) {
  return Container(
    alignment: Alignment.centerLeft,
    child: AutoSizeText(title + ": " + content,
        style: GoogleFonts.openSans(
            // headerLine 6
            fontSize: 8.0.sp,
            color: GolfColor.TextFielHintdLightColor,
            fontWeight: FontWeight.w700)),
  );
}

Widget bookingDetailListBlockView(ThemeData themeData, List<Blocks> lstBlock,
    {Blocks? nearestAvailableBlock}) {
  var _lstWidget = <Widget>[];
  for (int i = 0; i < lstBlock.length; i++) {
    _lstWidget.add(bookingDetailItemView(
        themeData,
        i == 0
            ? 'time_booking'.tr + ' (' + lstBlock.length.toString() + ')'
            : null,
        lstBlock[i].rangeStart!.toStringFormatHoursUTC() +
            ' - ' +
            lstBlock[i].rangeEnd!.toStringFormatHoursUTC()));
  }
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: _lstWidget);
}

Widget bookingDetailListBlockSimpleView(
    ThemeData themeData, List<Blocks> lstBlock,
    {Blocks? nearestAvailableBlock}) {
  String _lstWidget = "";
  for (int i = 0; i < lstBlock.length; i++) {
    _lstWidget += lstBlock[i].rangeStart!.toStringFormatHoursUTC() +
        ' - ' +
        lstBlock[i].rangeEnd!.toStringFormatHoursUTC() +
        (i == lstBlock.length - 1 ? " " : ", ");
  }
  return Container(
    alignment: Alignment.centerLeft,
    child: AutoSizeText('time_booking'.tr + ": " + _lstWidget,
        style: GoogleFonts.openSans(
            // headerLine 6
            fontSize: 8.0.sp,
            color: GolfColor.TextFielHintdLightColor,
            fontWeight: FontWeight.w700)),
  );
}
