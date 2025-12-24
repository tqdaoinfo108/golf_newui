import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/auth.dart';
import 'package:golf_uiv2/model/auth_body.dart';
import 'package:golf_uiv2/model/booking_model.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
import '../booking_create/booking_create_controller.dart';
import '../home/home_controller.dart';

class BookingCreateUserVipController extends BookingCreateController {
  // This controller uses UserVip APIs instead of regular booking APIs
  // Payment method selection is not needed for UserVip bookings
  
  @override
  void getSlotFirst() async {
    // Skip payment method loading for UserVip
    await getSlot();
    if (lstSlot.length > 0) {
      lstSlot[0].isSelect = true;
    }
  }

  @override
  resetValue() async {
    // Skip payment method loading for UserVip
    isMachineExpanded = false;
    isBlockExpanded = false;
    idSlot = 0;
    lstBlock = [];
  }

  @override
  Future getSlot() async {
    // Use UserVip API instead of regular slot API
    var listValue = await GolfApi().getSlotUserVip(
      shopSelected!.shopID,
      userId,
      dateIntCurrent,
    );

    lstSlot.clear();
    lstSlot = listValue?.data ?? [];
    update();
  }

  @override
  Future getBlock() async {
    // Check if any slot is selected
    var selectedSlots = lstSlot.where((_v) => _v.isSelect);
    if (selectedSlots.isEmpty) {
      lstBlock.clear();
      update();
      return;
    }

    // dateTimeClient format 2021-11-02-03-30 ngày giờ hệ thống
    var dateTime = DateTime.now();
    String _strDatTimeCurrent = [
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    ].join('-');
    
    // Use UserVip API instead of regular block API
    var listValue = await GolfApi().getBlockUserVip(
      selectedSlots.first.slotID,
      dateIntCurrent,
      _strDatTimeCurrent,
      SupportUtils.prefs.getInt(USER_ID) ?? 0,
    );

    lstBlock.clear();
    lstBlock = listValue?.data ?? [];
    update();
  }

  @override
  void onChangeSlotExpanded({item}) async {
    if (item != null) {
      machineValue = item.nameSlot;
      idSlot = item.slotID;
      for (var i in lstSlot) {
        if (i.slotID == item.slotID) {
          i.isSelect = true;
        } else {
          i.isSelect = false;
        }
      }
    }
    isMachineExpanded = !isMachineExpanded;
    exSlotController!.expanded = !exSlotController!.expanded;
    // No payment method for UserVip
    if (isMachineExpanded) {
      isBlockExpanded = false;
      lstBlock.forEach((e) => e.isSelect = false);
    } else if (idSlot != 0) {
      isBlockExpanded = true;
    }
    getBlock();

    update();
  }

  @override
  void onCreateBooking() async {
    var lstBlockSelected = lstBlock.where((_v) => _v.isSelect).toList();
    var createBookingModel = BookingInsertItemModel(
      null, // No userCodeMemberId for UserVip
    );
    createBookingModel.datePlay = dateIntCurrent;
    createBookingModel.slotID = idSlot;
    createBookingModel.shopID = shopSelected!.shopID;
    createBookingModel.timeZoneName = SupportUtils.getTimeZoneNameID();
    var lstBlockChoose = <int?>[];
    for (var item in lstBlockSelected) {
      lstBlockChoose.add(item.blockID);
    }
    createBookingModel.blocks = lstBlockChoose;
    var jsonBody = (AuthBody<BookingInsertItemModel>()
          ..setAuth(Auth())
          ..setData(
            createBookingModel,
            dataToJson: (_data) => _data!.toJson(),
          ))
        .toJson();
    
    // Use UserVip API instead of regular booking API
    var result = await GolfApi().createBookingUserVip(jsonBody);
    await Get.toNamed(AppRoutes.BOOKING_DETAIL, arguments: result?.data);
    onReset();
    final controller = Get.find<HomeController>();
    controller.changePageIndex(0);
  }

  @override
  bool onValidateCreateBooking() {
    // Validator - no payment method check for UserVip
    var lstBlockSelected = lstBlock.where((_v) => _v.isSelect).toList();
    if (lstBlockSelected.isEmpty || idSlot == 0) {
      SupportUtils.showToast(
        'no_time_frame_selected'.tr,
        type: ToastType.ERROR,
      );
      return false;
    }

    // No consecutive block limit check for UserVip bookings
    return true;
  }

  @override
  void onCancelBooking() {
    Get.toNamed("/test", id: 1);
    Get.delete<BookingCreateUserVipController>();
    // Get.back();
  }
}
