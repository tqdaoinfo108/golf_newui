import 'package:flutter/material.dart';
import 'package:golf_uiv2/model/block.dart';
import 'package:golf_uiv2/model/shop_model.dart';
import 'package:golf_uiv2/model/shops.dart';
import 'package:golf_uiv2/model/booking_payment.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/widgets/pressable.dart';
import 'package:golf_uiv2/widgets/pressable_icon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';

/// Format giá tiền theo loại payment
String formatPaymentPrice(BookingPayment? payment) {
  if (payment == null) return '¥0';

  final typePayment = payment.typePayment;

  // Member Unlimited hoặc Member Limited
  if (typePayment == BookingDetailPaymentType.MEMBER_UNLIMITED ||
      typePayment == BookingDetailPaymentType.MEMBER_LIMITED) {
    // Hiển thị tên plan + lượt
    final remainingTurn = payment.remainingTurn ?? 0;
    return '$remainingTurn ${'turn'.tr}'; // "5 lượt"
  }

  // Online Payment (Credit Card)
  if (typePayment == BookingDetailPaymentType.ONLINE) {
    final totalFee = payment.totalFeeVisa ?? 0;
    return totalFee > 0 ? '¥${totalFee.round()} (税込)' : '¥0';
  }

  // Member Limited + Online
  if (typePayment == BookingDetailPaymentType.MEMBER_LIMITED_AND_ONLINE) {
    final totalFee = payment.totalFeeVisa ?? 0;
    return totalFee > 0 ? '¥${totalFee.round()} (税込)' : '¥0';
  }

  // Default (Admin, Staff, Owner hoặc các trường hợp khác)
  return '¥0';
}

Widget shopItemView(
  ThemeData themeData,
  ShopItemModel shops, {
  Color? backgroundColor,
  void Function()? onItemPressed,
  bool enabled = true,
  Function(bool)? onFavoriteChanged,
  Widget? buyVipMemberButton,
}) {
  var textBody = themeData.textTheme.headlineMedium?.copyWith(
    color: GolfColor.GolfSubColor,
    fontSize: 14,
  );
  var textTitle = themeData.textTheme.headlineMedium?.copyWith(
    color: GolfColor.GolfSubColor,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  return shops.codeShop == null
      ? SizedBox()
      : Stack(
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
                            ? _buildVipLimitText(
                              themeData,
                              shops.countMemberLimit,
                            )
                            : TextSpan(),
                        (shops.isShopManager ?? false)
                            ? WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Image.asset(
                                  "assets/icons/person_vip.png",
                                  width: 24,
                                ),
                              ),
                            )
                            : TextSpan(),
                        TextSpan(text: "${shops.nameShop}", style: textTitle),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.0.h),
                  Text(shops.addressShop ?? "N/A", style: textBody),
                  SizedBox(height: 1.0.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/phone.png",
                        color: GolfColor.GolfSubColor,
                        width: 18,
                        height: 18,
                      ),
                      SizedBox(width: 2.0.h),
                      Text(shops.phoneShop ?? "N/A", style: textBody),
                    ],
                  ),
                  SizedBox(height: 1.0.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/office.png",
                        color: GolfColor.GolfSubColor,
                        width: 18,
                        height: 18,
                      ),
                      SizedBox(width: 2.0.h),
                      Text("${shops.distance} km", style: textBody),
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
                    color:
                        shops.discount! < 100
                            ? Colors.red[400]
                            : Colors.green[400],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(2.0.h),
                      bottomLeft: Radius.circular(8),
                    ), // green shaped
                  ),
                  child: Text(
                    shops.discount! < 100
                        ? "-${100 - shops.discount!.toInt()}%"
                        : "+${shops.discount!.toInt() - 100}%",
                  ),
                ),
              )
              : Container(),
          Positioned(
            bottom: 2.0.w,
            right: 0,
            child: Row(
              children: [
                if (buyVipMemberButton != null) ...[buyVipMemberButton],
                _buildFavoriteButton(
                  themeData,
                  isFavorite: shops.isFavorite!,
                  onFavoriteChanged: onFavoriteChanged,
                ),
              ],
            ),
          ),
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
    margin: EdgeInsets.only(right: 5.0.sp),
    padding: EdgeInsets.symmetric(horizontal: 4.0.sp, vertical: 1.0.sp),
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
  ),

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

_buildFavoriteButton(
  ThemeData appTheme, {
  bool isFavorite = false,
  Function(bool)? onFavoriteChanged,
}) => Column(
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
    ),
  ],
);

Widget shopItemViewNoEvent(ThemeData themeData, Shops shop) {
  return Container(
    margin: EdgeInsets.only(bottom: 2.0.h),
    padding: EdgeInsets.all(2.0.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(2.0.h)),
      color: Get.context!.theme.colorScheme.backgroundCardColor,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(shop.name, style: themeData.textTheme.headlineSmall),
        SizedBox(height: 1.0.h),
        Text(shop.address, style: themeData.textTheme.headlineLarge),
        SizedBox(height: 1.0.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 0,
              child: Icon(Icons.phone, color: themeData.colorScheme.iconColor),
            ),
            SizedBox(width: 2.0.h),
            Text(shop.phone, style: themeData.textTheme.headlineSmall),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 0,
              child: Icon(Icons.money, color: themeData.colorScheme.iconColor),
            ),
            SizedBox(width: 2.0.h),
            Text(
              shop.price.toString(),
              style: themeData.textTheme.headlineSmall,
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 0,
              child: Icon(
                Icons.location_city,
                color: themeData.colorScheme.iconColor,
              ),
            ),
            SizedBox(width: 2.0.h),
            Text("${shop.range} km", style: themeData.textTheme.headlineSmall),
          ],
        ),
      ],
    ),
  );
}

Widget bookingDetailItemView(
  ThemeData themeData,
  String? title,
  String content, {
  Widget? trailing,
  VoidCallback? onTap,
}) {
  if (title == null) {
    return Text(
      content,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1a1a4d),
      ),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget child = Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 3,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Color(0xff8B90B9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Expanded(
        flex: 7,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                content,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1a1a4d),
                ),
                textAlign: TextAlign.start,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null) ...[SizedBox(width: 4), trailing],
          ],
        ),
      ),
    ],
  );

  if (onTap != null) {
    return InkWell(onTap: onTap, child: child);
  }

  return child;
}

Widget bookingDetailSimpleItemView(
  ThemeData themeData,
  String title,
  String content,
) {
  final TextStyle titleStyle = GoogleFonts.inter(
    fontSize: 11.5.sp,
    color: const Color(0xFF70779A),
    fontWeight: FontWeight.w600,
    height: 1.35,
  );
  final TextStyle contentStyle = GoogleFonts.inter(
    fontSize: 11.5.sp,
    color: const Color(0xFF1A1A4D),
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  return Container(
    alignment: Alignment.centerLeft,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 25.0.w, child: Text('$title:', style: titleStyle)),
        Expanded(child: Text(content, style: contentStyle)),
      ],
    ),
  );
}

Widget bookingDetailListBlockView(
  ThemeData themeData,
  List<Blocks> lstBlock, {
  Blocks? nearestAvailableBlock,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '${'time_booking'.tr} (${lstBlock.length})',
        style: GoogleFonts.inter(
          fontSize: 12,
          color: Color(0xff8B90B9),
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      ...List.generate(
        lstBlock.length,
        (i) {
          final rightText = _buildBlockRightText(lstBlock[i]);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${lstBlock[i].rangeStart!.toStringFormatHoursUTC()} - ${lstBlock[i].rangeEnd!.toStringFormatHoursUTC()}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a1a4d),
                    ),
                  ),
                  if (rightText != null) ...[
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rightText,
                        textAlign: TextAlign.right,
                        softWrap: true,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a1a4d),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 12),
              Divider(color: Color(0xFFE0E0E0), thickness: 0.5, height: 1),
              SizedBox(height: 12),
            ],
          );
        },
      ),
    ],
  );
}

String? _buildBlockRightText(Blocks block) {
  final memberName = (block.nameCodeMember ?? '').trim();

  // Case 1: Membership block has plan name -> show NameCodeMember.
  if (memberName.isNotEmpty) {
    return memberName;
  }

  // Case 2 & 3: No membership -> always show amount (0 or >0).
  final amount = block.amountAfterDiscount?.toInt() ?? 0;
  return '¥$amount';
}

Widget bookingDetailTotalAmountView(ThemeData themeData, double totalAmount) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Color(0xffebeafa),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'total_amount'.tr,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Color(0xff8B90B9),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '¥${totalAmount.round()}',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1a1a4d),
                ),
              ),
              TextSpan(
                text: ' (税込)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Color(0xff8B90B9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget bookingDetailListBlockSimpleView(
  ThemeData themeData,
  List<Blocks> lstBlock, {
  Blocks? nearestAvailableBlock,
}) {
  String _lstWidget = '';
  for (int i = 0; i < lstBlock.length; i++) {
    _lstWidget +=
        '${lstBlock[i].rangeStart!.toStringFormatHoursUTC()} - ${lstBlock[i].rangeEnd!.toStringFormatHoursUTC()}${i == lstBlock.length - 1 ? '' : ', '}';
  }
  return bookingDetailSimpleItemView(themeData, 'time_booking'.tr, _lstWidget);
}
