import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/auth.dart';
import 'package:golf_uiv2/model/auth_body.dart';
import 'package:golf_uiv2/model/block_model.dart';
import 'package:golf_uiv2/model/booking_model.dart';
import 'package:golf_uiv2/model/shop_model.dart';
import 'package:golf_uiv2/model/slot_model.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';

import '../../model/shop_vip_memeber.dart';
import '../home/home_controller.dart';

class BookingCreateController extends GetxController {
  ExpandableController? exMachineController;
  ExpandableController? exSlotController;
  ExpandableController? exPaymentMethodController;

  // Rx variables for expand state to trigger UI rebuild
  final RxBool _isPaymentMethodExpanded = true.obs;
  bool get isPaymentMethodExpanded => _isPaymentMethodExpanded.value;
  set isPaymentMethodExpanded(bool value) {
    _isPaymentMethodExpanded.value = value;
    exPaymentMethodController?.expanded = value;
  }

  final RxBool _isMachineExpanded = false.obs;
  bool get isMachineExpanded => _isMachineExpanded.value;
  set isMachineExpanded(bool value) {
    _isMachineExpanded.value = value;
    exMachineController?.expanded = value;
  }

  final RxBool _isBlockExpanded = true.obs;
  bool get isBlockExpanded => _isBlockExpanded.value;
  set isBlockExpanded(bool value) {
    _isBlockExpanded.value = value;
    exSlotController?.expanded = value;
  }
  // ShopItemModel shopSelected;
  // List<SlotItemModel> lstSlot;
  // List<BlockItemModel> lstBlock;

  final Rx<ShopItemModel?> _shopSelected = ShopItemModel().obs;
  ShopItemModel? get shopSelected => this._shopSelected.value;
  set shopSelected(value) => this._shopSelected.value = value;

  final RxList<SlotItemModel> _lstSlot = <SlotItemModel>[].obs;
  List<SlotItemModel> get lstSlot => this._lstSlot;
  set lstSlot(List<SlotItemModel> value) => this._lstSlot.value = value;

  final RxList<BlockItemModel> _lstBlock = <BlockItemModel>[].obs;
  List<BlockItemModel> get lstBlock =>
      this._lstBlock.where((item) => item.isShow != false).toList();
  set lstBlock(List<BlockItemModel> value) => this._lstBlock.value = value;

  // Payment method list
  final RxList<ShopVipMember> _lstPaymentMethod = <ShopVipMember>[].obs;
  List<ShopVipMember> get lstPaymentMethod => this._lstPaymentMethod;
  set lstPaymentMethod(List<ShopVipMember> value) =>
      this._lstPaymentMethod.value = value;

  // Selected payment method
  final Rx<ShopVipMember?> _selectedPaymentMethod = Rx<ShopVipMember?>(null);
  ShopVipMember? get selectedPaymentMethod => this._selectedPaymentMethod.value;
  set selectedPaymentMethod(ShopVipMember? value) =>
      this._selectedPaymentMethod.value = value;

  // Flag to check if payment method is selected
  bool get isPaymentMethodSelected => selectedPaymentMethod != null;

  String? machineValue = 'choose_slot'.tr;
  String slotValue = 'choose_block'.tr;
  String textDayOfWeek = "";

  // value sender
  int? dateIntCurrent;
  int? idSlot = 0;
  int idBlock = 0;

  int? userId;
  @override
  void onInit() {
    super.onInit();
    exMachineController = new ExpandableController(initialExpanded: false);
    exSlotController = new ExpandableController(initialExpanded: false);
    exPaymentMethodController = new ExpandableController(initialExpanded: true);
    userId = SupportUtils.prefs.getInt(USER_ID);
    // init data

    shopSelected = Get.arguments;
    lstSlot = <SlotItemModel>[];
    lstBlock = <BlockItemModel>[];
    lstPaymentMethod = <ShopVipMember>[];
    selectedPaymentMethod = null;
    var _dateTemp = DateTime.now();
    dateIntCurrent =
        DateTime.utc(
          _dateTemp.year,
          _dateTemp.month,
          _dateTemp.day,
        ).millisecondsSinceEpoch ~/
        1000;
    textDayOfWeek = DateTime.now().millisecondsSinceEpoch.toStringFormatDate();
  }

  void onReset() async {
    lstSlot = <SlotItemModel>[];
    lstBlock = <BlockItemModel>[];
    lstPaymentMethod = <ShopVipMember>[];
    selectedPaymentMethod = null;
    var _dateTemp = DateTime.now();
    dateIntCurrent =
        DateTime.utc(
          _dateTemp.year,
          _dateTemp.month,
          _dateTemp.day,
        ).millisecondsSinceEpoch ~/
        1000;
    textDayOfWeek = DateTime.now().millisecondsSinceEpoch.toStringFormatDate();
    getSlotFirst();
  }

  resetValue() async {
    await getPaymentMethods();
    isMachineExpanded = false;
    isBlockExpanded = false;
    isPaymentMethodExpanded = true;
    selectedPaymentMethod = null;
  }

  void getSlotFirst() async {
    await getPaymentMethods();
    await getSlot();
    if (lstSlot.length > 0) {
      lstSlot[0].isSelect = true;
    }
  }

  Future getPaymentMethods() async {
    try {
      var response = await GolfApi().getListMemberPayment(
        shopSelected!.shopID!,
        userId!,
        dateIntCurrent!,
      );
      if (response.data != null) {
        lstPaymentMethod = response.data!;
      }
    } on DioException catch (error, _) {
      print("Error getting payment methods: $error");
    }
    update();
  }

  void onSelectPaymentMethod(ShopVipMember? paymentMethod) {
    selectedPaymentMethod = paymentMethod;
    // Collapse payment method and expand machine selection after payment method is selected
    if (paymentMethod != null) {
      isPaymentMethodExpanded = false;
      isMachineExpanded = true;
    }
    update();
  }

  void onTogglePaymentMethodExpanded() {
    isPaymentMethodExpanded = !isPaymentMethodExpanded;
    if (isPaymentMethodExpanded) {
      isMachineExpanded = false;
      isBlockExpanded = false;
      lstSlot.forEach((e) => e.isSelect = false);
      lstBlock.forEach((e) => e.isSelect = false);
    }
    update();
  }

  Future getShopDetail() async {
    try {
      var res = await new GolfApi().getShopDetail(shopSelected!.shopID, userId);

      if (res != null) {
        shopSelected = shopSelected!.copyWith(
          isMember: res.isMember,
          countMemberLimit: res.countMemberLimit,
          countMemberCode: res.countMemberCode,
          discount: res.discount,
          isFavorite: res.isFavorite,
        );
      }
    } on DioException catch (error, _) {
      SupportUtils.showToast(
        ApplicationError.withDioError(error).getErrorMessage(),
        type: ToastType.ERROR,
      );
    }
  }

  void changeFavorite(int? shopId) {
    GolfApi()
        .changeFavorite(shopId, userId)
        .then(
          (value) => {
            if (value.data!) {getShopDetail()},
          },
        );
  }

  Future getSlot() async {
    var listValue = await new GolfApi().getSlot(shopSelected!.shopID);

    lstSlot.clear();
    lstSlot = listValue?.data ?? [];
    update();
  }

  Future getBlock() async {
    // Check if any slot is selected
    var selectedSlots = lstSlot.where((_v) => _v.isSelect);
    if (selectedSlots.isEmpty) {
      lstBlock.clear();
      update();
      return;
    }

    // dateTimeClient fomart 2021-11-02-03-30 ngày giờ hệ thống
    var dateTime = DateTime.now();
    String _strDatTimeCurrent = [
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    ].join('-');
    var listValue = await new GolfApi().getBlock(
      selectedSlots.first.slotID,
      dateIntCurrent,
      _strDatTimeCurrent,
      SupportUtils.prefs.getInt(USER_ID) ?? 0,
      selectedPaymentMethod?.codeMemberId ?? 0,
    );

    lstBlock.clear();
    lstBlock = listValue?.data ?? [];
    update();
  }

  void onChangeSlotExpanded({SlotItemModel? item}) async {
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
    // Close payment method when opening machine
    if (isMachineExpanded) {
      isPaymentMethodExpanded = false;
      isBlockExpanded = false;
      lstBlock.forEach((e) => e.isSelect = false);
    } else {
      isBlockExpanded = true;
    }
    getBlock();

    update();
  }

  void onChangeBlockExpanded({BlockItemModel? item}) {
    if (item != null) {
      // Select/deselect block item
      var bookings = lstBlock.where((_v) => _v.blockID == item.blockID);

      if (bookings.length > 0) {
        final bookingItem = bookings.first;
        bookingItem.isSelect = !bookingItem.isSelect;
      }
      _lstBlock.refresh();
    } else {
      // Toggle expand/collapse (header click)
      isBlockExpanded = !isBlockExpanded;
    }
    update();
  }

  void onToggleBlockExpanded() {
    isBlockExpanded = !isBlockExpanded;
    update();
  }

  void onSelectSlot(String value) {
    slotValue = value;
    exSlotController!.expanded = false;
    exMachineController!.expanded = false;
    update();
  }

  void onDateChange(DateTime dateTime) {
    dateIntCurrent =
        DateTime.utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
        ).millisecondsSinceEpoch ~/
        1000;
    // dateIntCurrent = dateTime.startOfDay().millisecondsSinceEpoch ~/ 1000;
    textDayOfWeek =
        DateTime.fromMillisecondsSinceEpoch(
          dateIntCurrent! * 1000,
          isUtc: true,
        ).endOfDay().millisecondsSinceEpoch.toStringFormatDate();
    resetValue();
    getBlock();
  }

  void onCreateBooking() async {
    // Validator
    var lstBlockSelected = lstBlock.where((_v) => _v.isSelect).toList();
    if (lstBlockSelected.length <= 0) {
      SupportUtils.showToast(
        'no_time_frame_selected'.tr,
        type: ToastType.ERROR,
      );
      return;
    }

    // Check for 4 consecutive blocks
    if (_hasConsecutiveBlocks(
      lstBlockSelected,
      selectedPaymentMethod?.bookingConsecutiveLimit ?? 2,
    )) {
      SupportUtils.showToast(
        'cannot_select_4_consecutive_blocks'.tr,
        type: ToastType.ERROR,
      );
      return;
    }

    var createBookingModel = BookingInsertItemModel(
      selectedPaymentMethod?.codeMemberId == 0,
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
    var jsonBody =
        (AuthBody<BookingInsertItemModel>()
              ..setAuth(Auth())
              ..setData(
                createBookingModel,
                dataToJson: (_data) => _data!.toJson(),
              ))
            .toJson();
    var result = await GolfApi().createBooking(jsonBody);
    await Get.offNamed(AppRoutes.BOOKING_DETAIL, arguments: result?.data);
    onReset();
    final controller = Get.find<HomeController>();
    controller.changePageIndex(0);
  }

  void onCancelBooking() {
    // Get.toNamed("/test", id: 1);
    // Get.delete<BookingCreateController>();

    Get.back();
  }

  void updateShopVipMember() {
    _shopSelected.value = shopSelected!.copyWith(isUserMemberCode: 1);
  }

  /// Check if there are N consecutive blocks selected based on stt
  bool _hasConsecutiveBlocks(List<BlockItemModel> selectedBlocks, int count) {
    if (selectedBlocks.length < count) return false;

    // Sort by stt
    var sortedBlocks = List<BlockItemModel>.from(selectedBlocks)
      ..sort((a, b) => (a.stt ?? 0).compareTo(b.stt ?? 0));

    int consecutiveCount = 1;
    for (int i = 1; i < sortedBlocks.length; i++) {
      if ((sortedBlocks[i].stt ?? 0) == (sortedBlocks[i - 1].stt ?? 0) + 1) {
        consecutiveCount++;
        if (consecutiveCount >= count) {
          return true;
        }
      } else {
        consecutiveCount = 1;
      }
    }
    return false;
  }

  /// Check if a block is bookable based on current time + 10 minutes
  /// Block is bookable if: dateIntCurrent + rangeStart > now + 10 minutes
  bool isBlockBookable(BlockItemModel block) {
    if (dateIntCurrent == null || block.rangeStart == null) return false;

    // Get the selected date (local)
    final now = DateTime.now();
    final selectedDate = DateTime.fromMillisecondsSinceEpoch(
      dateIntCurrent! * 1000,
      isUtc: true,
    );

    // rangeStart is time offset in milliseconds from 00:00 UTC
    // Convert to hours and minutes
    final blockTimeUtc = DateTime.fromMillisecondsSinceEpoch(
      block.rangeStart!.toInt(),
      isUtc: true,
    );
    final blockHour = blockTimeUtc.hour;
    final blockMinute = blockTimeUtc.minute;

    // Create block start time in local timezone using selected date + block time
    final blockStartTimeLocal = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      blockHour,
      blockMinute,
    );

    // Current local time + 10 minutes
    final minBookableTime = now.add(Duration(minutes: 10));

    // Block is bookable if its start time is after the minimum bookable time
    return blockStartTimeLocal.isAfter(minBookableTime);
  }
}
