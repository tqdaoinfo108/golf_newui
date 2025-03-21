import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:golf_uiv2/model/transaction.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';

class TransactionHistoryListItem extends StatelessWidget {
  const TransactionHistoryListItem(this.transactionItem, {Key? key})
      : super(key: key);

  final Transaction transactionItem;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 5.0.sp),
      child: Stack(children: [
        /// Content
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: appTheme.colorScheme.onBackground,
            borderRadius: BorderRadius.circular(10.0.sp),
          ),
          padding: EdgeInsets.all(10.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${"date".tr}:",
                style: appTheme.textTheme.titleSmall!.copyWith(
                  color: appTheme.colorScheme.onSurface,
                  fontSize: 9.0.sp,
                ),
              ),
              Text(transactionItem.datePayment!.toStringFormatDateTime(),
                  style: appTheme.textTheme.headlineSmall!.copyWith(
                    color: appTheme.colorScheme.surface,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 5.0.sp),
              Text(
                "${"amount".tr}:",
                style: appTheme.textTheme.titleSmall!.copyWith(
                  color: appTheme.colorScheme.onSurface,
                  fontSize: 9.0.sp,
                ),
              ),
              Text(_getAmountStr(),
                  style: appTheme.textTheme.headlineSmall!.copyWith(
                    color: appTheme.colorScheme.error,
                  )),
              SizedBox(height: 5.0.sp),
              Text(
                "${"content".tr}:",
                style: appTheme.textTheme.titleSmall!.copyWith(
                  color: appTheme.colorScheme.onSurface,
                  fontSize: 9.0.sp,
                ),
              ),
              Text(_getContentStr(),
                  style: appTheme.textTheme.headlineSmall!.copyWith(
                    color: appTheme.colorScheme.surface,
                  )),
            ],
          ),
        ),

        /// Status
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            decoration: BoxDecoration(
              color: transactionItem.status == 1
                  ? appTheme.colorScheme.primary
                  : appTheme.colorScheme.error,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0.sp),
                bottomLeft: Radius.circular(10.0.sp),
              ),
            ),
            padding:
                EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 5.0.sp),
            child: Text(
              transactionItem.status == 1 ? "success".tr : "fail".tr,
              style: appTheme.textTheme.headlineLarge!.copyWith(
                color: appTheme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  _getContentStr() {
    switch (transactionItem.typePayment) {
      case PaymentType.REGISTER_VIP_MEMBER:
        return (transactionItem.typeCodeMember == VipMemberType.LIMIT
                ? "${"registered_limited_turn_vip_member_at".tr.replaceFirst('...', transactionItem.nameShop!)} "
                : "${"registered_vip_member_at".tr.replaceFirst('...', transactionItem.nameShop!)} ") +
            (transactionItem.typeCodeMember == VipMemberType.UNLIMIT
                ? "(${"from_date".tr.replaceFirst('...', transactionItem.timeStart!.toStringFormatSimpleDate())} " +
                    "${"to_date".tr.toLowerCase().replaceFirst('...', transactionItem.timeEnd!.toStringFormatSimpleDate())})"
                : "");
      case PaymentType.AUTO_RENEW_VIP_MEMBER:
        return "automatically_renewed_vip_member_at"
            .tr
            .replaceFirst('{shop_name}', transactionItem.nameShop!)
            .replaceFirst('{from_date}',
                transactionItem.timeStart!.toStringFormatSimpleDate())
            .replaceFirst('{to_date}',
                transactionItem.timeEnd!.toStringFormatSimpleDate());
      case PaymentType.CREATE_BOOKING_WITH_ONLINE_PAYMENT:
      case PaymentType.CREATE_BOOKING_WITH_VIP_MEMBER:
        var _paymentType = '';

        if (transactionItem.listPaymentDetail!.length > 1) {
          _paymentType = "${"use_vip_member".tr} + ${"online_payment".tr}";
        } else {
          if (transactionItem.listPaymentDetail![0].typePayment ==
              BookingDetailPaymentType.ONLINE) {
            _paymentType = "online_payment".tr;
          } else {
            _paymentType = "use_vip_member".tr;
          }
        }
        return "${"booking_payment_at".tr.replaceFirst('...', transactionItem.nameShop!).replaceFirst('&&&', _paymentType)} " +
            "(${transactionItem.datePlay!.toStringFormatSimpleDate()}) ";
      default:
        return "";
    }
  }

  _getAmountStr() {
    switch (transactionItem.typePayment) {
      case PaymentType.REGISTER_VIP_MEMBER:
      case PaymentType.AUTO_RENEW_VIP_MEMBER:
        return "- ${transactionItem.amount!.round().toStringFormatCurrency()}";
      case PaymentType.CREATE_BOOKING_WITH_ONLINE_PAYMENT:
        return "${'online'.tr} (- ${transactionItem.amount!.round().toStringFormatCurrency()})";
      case PaymentType.CREATE_BOOKING_WITH_VIP_MEMBER:
        if (transactionItem.listPaymentDetail!.length > 1) {
          final _amount = transactionItem.listPaymentDetail!
              .firstWhere((payment) =>
                  payment.typePayment == BookingDetailPaymentType.ONLINE)
              .amount!;
          return "${'online'.tr} (- ${_amount.round().toStringFormatCurrency()})";
        } else {
          final _transactionPaymentDetail =
              transactionItem.listPaymentDetail![0];

          switch (_transactionPaymentDetail.typePayment) {
            case BookingDetailPaymentType.ONLINE:
              return "${'online'.tr} (- ${_transactionPaymentDetail.amount!.round().toStringFormatCurrency()})";
            case BookingDetailPaymentType.MEMBER_LIMITED:
              return "${'member_limited'.tr} (${transactionItem.remainPlay})";
            case BookingDetailPaymentType.MEMBER_UNLIMITED:
              return "member_unlimited".tr;
            default:
              return "";
          }
        }
      default:
        return "";
    }
  }
}
