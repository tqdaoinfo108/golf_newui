import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/booking.dart';
import 'package:golf_uiv2/model/decision_option.dart';
import 'package:golf_uiv2/screens/booking_detail/widgets/button_unavailable_payment.dart';
import 'package:golf_uiv2/screens/booking_detail/widgets/button_waiting_payment.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:golf_uiv2/widgets/booking_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/button_default.dart';
import 'booking_detail_controller.dart';
import 'widgets/qr_code_info.dart';

class BookingDetailScreen extends GetView<BookingDetailController> {
  BookingDetailScreen({Key? key}) : super(key: key);

  bool _isWaitingPaymentAndCanPay(Booking booking) {
    return booking.statusID == BookingStatus.WAITING_PAYMENT &&
        booking.isAvailablePayment();
  }

  Future<bool> _handleBackPressed(BookingDetailController controller) async {
    if (!_isWaitingPaymentAndCanPay(controller.curBooking)) {
      return true;
    }

    final shouldLeave = await Get.dialog<bool>(
      AlertDialog(backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          'leave_waiting_payment_warning'.tr,
          style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('back'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('continue_booking'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return shouldLeave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return GetX<BookingDetailController>(
      initState: (_state) async {
        await Get.find<BookingDetailController>().getBookingHistoryDetail();
        // if (Get.find<BookingDetailController>().curBooking.statusID ==
        //     BookingStatus.PAID) {
        await Get.find<BookingDetailController>().getQRCodeString();
        // }
      },
      builder: (controller) {
        final isPaidOrUsed =
          controller.curBooking.statusID == BookingStatus.PAID ||
          controller.curBooking.statusID == BookingStatus.USED;
        final canShowQrButton =
          isPaidOrUsed && controller.curBooking.isAvailableShowQRCode();
        final showQrExpiredNote =
          isPaidOrUsed && !controller.curBooking.isAvailableShowQRCode();

        return WillPopScope(
          onWillPop: () => _handleBackPressed(controller),
          child: Scaffold(
            backgroundColor: GolfColor.GolfSubColor,
            appBar: ApplicationAppBar(
              context,
              'back'.tr,
              onBackPressed: () => _handleBackPressed(controller),
            ),
            body:
                controller.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'booking_detail_header_title'.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.openSans(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'booking_detail_header_subtitle'.tr,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.openSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            color: themeData.brightness == Brightness.dark
                                ? Colors.black
                                : Color(0xFFF5F6FF), // Màu nền tổng thể sáng hơn
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 16,
                                    left: 20,
                                    right: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: themeData.colorScheme.onBackground,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.only(
                                    bottom: 24,
                                    right: 20,
                                    left: 20,
                                  ),
                                  child: Column(
                                    spacing: 14,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 16),
                                      bookingDetailItemView(
                                        themeData,
                                        'shop'.tr,
                                        controller.curBooking.nameShop!,
                                      ),
                                      bookingDetailItemView(
                                        themeData,
                                        'address'.tr,
                                        controller.curBooking.addressShop!,
                                      ),
                                      bookingDetailItemView(
                                        themeData,
                                        'date_play'.tr,
                                        controller.curBooking.datePlay!
                                            .toStringFormatDate(),
                                      ),
                                      bookingDetailItemView(
                                        themeData,
                                        'select_machine'.tr,
                                        controller.curBooking.nameSlot!,
                                      ),
                                      bookingDetailListBlockView(
                                        themeData,
                                        controller.curBooking.blocks!,
                                        nearestAvailableBlock:
                                            controller.curBooking.blocks![0],
                                      ),
                                      if ((controller
                                                  .curBooking
                                                  .payment
                                                  ?.totalFeeVisa ??
                                              0) >
                                          0)
                                        bookingDetailTotalAmountView(
                                          themeData,
                                          controller
                                              .curBooking
                                              .payment!
                                              .totalFeeVisa!,
                                        ),
                                      bookingDetailItemView(
                                        themeData,
                                        'date_created'.tr,
                                        controller.curBooking.createdDate!
                                            .toStringFormatDate(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size: 14,
                                      color: Color(0xff8B90B9),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'booking_confirm_notice'.tr,
                                      style: GoogleFonts.openSans(
                                        fontSize: 12,
                                        color: Color(0xff8B90B9),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                if (canShowQrButton)
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.0.h,
                                    ),
                                    child: DefaultButton(
                                      radius: 12,
                                      text: 'show_qr'.tr,
                                      textColor: Colors.white,
                                      backgroundColor: GolfColor.GolfSubColor,
                                      press: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          builder: (c) {
                                            return Scaffold(
                                              backgroundColor:
                                                  GolfColor.GolfSubColor,
                                              appBar: ApplicationAppBar(
                                                context,
                                                'ticket_information'.tr,
                                              ),
                                              body: QRCodeInfo(
                                                context,
                                                controller.qrCodeString,
                                                controller.curBooking,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                if (showQrExpiredNote)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.0.h,
                                    ),
                                    child: Text(
                                      'qr_expired_note'.tr,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                        fontSize: 11,
                                        color: Color(0xff8B90B9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: const EdgeInsets.only(
                                    bottom: kToolbarHeight,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.0.h,
                                  ),
                                  child: _buildButton(
                                    themeData,
                                    controller.curBooking,
                                    onPaymentPressed:
                                        () => _letsPayment(
                                          context,
                                          onPayByOnLinePayment:
                                              controller
                                                  .letsPaymentWithOnlinePayment,
                                          onPayByVipMember:
                                              controller.letsPaymentWithVipMember,
                                          onOrtherPayment5And6:
                                              controller.letsPaymentOrther5and6,
                                        ),
                                    onCancelPressed: controller.cancelBooking,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  _buildButton(
    ThemeData appTheme,
    Booking thisBooking, {
    void Function()? onCancelPressed,
    void Function()? onPaymentPressed,
  }) {
    if (thisBooking.statusID == BookingStatus.WAITING_PAYMENT) {
      if (!thisBooking.isAvailablePayment()) {
        return ButtonUnavailablePayment(onCancelPressed: onCancelPressed);
      }
      return ButtonWatingPayment(
        onPaymentPressed: onPaymentPressed,
        onCancelPressed: onCancelPressed,
      );
    }
    return Container();
  }

  _alertNotEnoughVipCardTurn(Function()? onContinuePayment) {
    SupportUtils.showDecisionDialog(
      "${'your_vip_card_is_not_enough_turn'.tr}" +
          " ${'all_block_left_will_pay_by_online'.tr}" +
          " ${'whould_you_like_to_continue'.tr}",
      lstOptions: [
        DecisionOption(
          'no'.tr,
          type: DecisionOptionType.DENIED,
          onDecisionPressed: null,
        ),
        DecisionOption(
          'continue_payment'.tr,
          onDecisionPressed: onContinuePayment,
          isImportant: true,
        ),
      ],
    );
  }

  _alertPlayedOtherBookingToUseVipCard(Function()? onContinuePayment) {
    SupportUtils.showDecisionDialog(
      "${'play_other_booking_to_use_vip_card'.tr}" +
          " ${'please_play_booking_before'.tr}",
      lstOptions: [
        DecisionOption(
          'cancel'.tr,
          type: DecisionOptionType.DENIED,
          onDecisionPressed: null,
        ),
        DecisionOption(
          'continue_payment'.tr,
          onDecisionPressed: onContinuePayment,
          isImportant: true,
        ),
      ],
    );
  }

  _alertNotAllowUseVipCard(Function()? onContinuePayment) {
    SupportUtils.showDecisionDialog(
      "${'your_vip_card_not_allow_to_use'.tr}" +
          " ${'you_must_pay_by_online'.tr}" +
          " ${'whould_you_like_to_continue'.tr}",
      lstOptions: [
        DecisionOption(
          'no'.tr,
          type: DecisionOptionType.DENIED,
          onDecisionPressed: null,
        ),
        DecisionOption(
          'continue_payment'.tr,
          onDecisionPressed: onContinuePayment,
          isImportant: true,
        ),
      ],
    );
  }

  _letsPayment(
    BuildContext context, {
    void Function()? onPayByVipMember,
    void Function()? onPayByOnLinePayment,
    void Function()? onOrtherPayment5And6,
  }) {
    final typePayment = controller.curBooking.payment!.typePayment;
    final totalBlockToPay = controller.curBooking.payment!.turnToPlay;
    final remainTurnVipCard = controller.curBooking.payment!.remainingTurn;
    final shopHasConfigLimit =
        controller.curBooking.payment!.shopFinshAndContinue;

    if (typePayment == BookingDetailPaymentType.MEMBER_UNLIMITED ||
        typePayment == BookingDetailPaymentType.MEMBER_LIMITED ||
        typePayment == 5) {
      onPayByVipMember?.call();
    } else if (typePayment == BookingDetailPaymentType.ONLINE ||
        typePayment == 6) {
      if (shopHasConfigLimit! && totalBlockToPay! > 1) {
        _alertNotAllowUseVipCard(onPayByOnLinePayment);
      } else if (shopHasConfigLimit && remainTurnVipCard! > 0) {
        _alertPlayedOtherBookingToUseVipCard(onPayByOnLinePayment);
      } else {
        onPayByOnLinePayment?.call();
      }
    } else if (typePayment ==
        BookingDetailPaymentType.MEMBER_LIMITED_AND_ONLINE) {
      _alertNotEnoughVipCardTurn(onPayByOnLinePayment);
    }
  }
}
