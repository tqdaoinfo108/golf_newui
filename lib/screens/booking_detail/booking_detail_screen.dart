import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/booking.dart';
import 'package:golf_uiv2/model/decision_option.dart';
import 'package:golf_uiv2/screens/booking_detail/widgets/button_paid.dart';
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

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return GetX<BookingDetailController>(
      initState: (_state) async {
        await Get.find<BookingDetailController>().getBookingHistoryDetail();
        if (Get.find<BookingDetailController>().curBooking.statusID ==
            BookingStatus.PAID) {
          await Get.find<BookingDetailController>().getQRCodeString();
        }
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: GolfColor.GolfSubColor,
          appBar: ApplicationAppBar(context, 'back'.tr),
          body:
              controller.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 40,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.curBooking.datePlay!
                                  .toStringFormatDate(),
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${controller.curBooking.blocks![0].rangeStart!.toStringFormatHoursUTC()}" " - ${controller.curBooking.blocks![0].rangeEnd!.toStringFormatHoursUTC()}",
                              style: GoogleFonts.openSans(
                                // headerLine 6
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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
                            color: themeData.colorScheme.background,
                          ),
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 200,
                                    top: 2.0.w,
                                    right: 40,
                                    left: 40,
                                  ),
                                  child: Column(
                                    spacing: 10,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
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
                                        'slot'.tr,
                                        controller.curBooking.nameSlot!,
                                      ),
                                      bookingDetailListBlockView(
                                        themeData,
                                        controller.curBooking.blocks!,
                                        nearestAvailableBlock:
                                            controller.curBooking.blocks![0],
                                      ),
                                      bookingDetailItemView(
                                        themeData,
                                        'date_created'.tr,
                                        controller.curBooking.createdDate!
                                            .toStringFormatDate(),
                                      ),
                                      if ((controller
                                                  .curBooking
                                                  .payment
                                                  ?.totalFeeVisa ??
                                              0) >
                                          0)
                                        bookingDetailItemView(
                                          themeData,
                                          'price'.tr,
                                          controller
                                              .curBooking
                                              .payment!
                                              .totalFeeVisa!
                                              .round()
                                              .toStringFormatCurrency(),
                                        ),
                                      // /// QR Code
                                      // controller.curBooking.statusID ==
                                      //         BookingStatus.PAID
                                      //     ? QRCodeInfo(
                                      //       qrCodeStr: controller.qrCodeString,
                                      //       bookingDetail:
                                      //           controller.curBooking,
                                      //     )
                                      //     : Container(),
                                      // SizedBox(height: 8.0.h),
                                    ],
                                  ),
                                ),
                              ),
                              // button
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (controller.curBooking.statusID ==
                                          BookingStatus.PAID ||
                                      controller.curBooking.statusID ==
                                          BookingStatus.USED)
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
                                            isScrollControlled:
                                                true, // Cho phép modal cao hơn mặc định
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
                                  SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    margin: const EdgeInsets.only(bottom: 40),
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
                                                controller
                                                    .letsPaymentWithVipMember,
                                          ),
                                      onCancelPressed: controller.cancelBooking,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
    if (thisBooking.statusID == BookingStatus.PAID &&
        thisBooking.isAvailableCancel()) {
      return ButtonPaid(onCancelPressed: onCancelPressed);
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
  }) {
    final typePayment = controller.curBooking.payment!.typePayment;
    final totalBlockToPay = controller.curBooking.payment!.turnToPlay;
    final remainTurnVipCard = controller.curBooking.payment!.remainingTurn;
    final shopHasConfigLimit =
        controller.curBooking.payment!.shopFinshAndContinue;

    if (typePayment == BookingDetailPaymentType.MEMBER_UNLIMITED ||
        typePayment == BookingDetailPaymentType.MEMBER_LIMITED) {
      onPayByVipMember?.call();
    } else if (typePayment == BookingDetailPaymentType.ONLINE) {
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
