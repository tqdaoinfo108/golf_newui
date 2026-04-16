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

import '../../model/decision_option.dart';
import '../../model/user_vip_member.dart';
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

  final RxList<BlockItemModel> lstBlock2 = <BlockItemModel>[].obs;
  List<BlockItemModel> get lstBlock =>
      this.lstBlock2.where((item) => item.isShow != false).toList();
  set lstBlock(List<BlockItemModel> value) => this.lstBlock2.value = value;

  // Payment method list
  final RxList<UserVipMember> _lstPaymentMethod = <UserVipMember>[].obs;
  List<UserVipMember> get lstPaymentMethod => this._lstPaymentMethod;
  set lstPaymentMethod(List<UserVipMember> value) =>
      this._lstPaymentMethod.value = value;

  // Selected payment method
  final Rx<UserVipMember?> _selectedPaymentMethod = Rx<UserVipMember?>(null);
  UserVipMember? get selectedPaymentMethod => this._selectedPaymentMethod.value;
  set selectedPaymentMethod(UserVipMember? value) =>
      this._selectedPaymentMethod.value = value;

  // Flag to check if payment method is selected
  bool get isPaymentMethodSelected => selectedPaymentMethod != null;

  RxString machineValue = 'choose_slot'.tr.obs;
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

    // shopSelected = Get.arguments;
    lstSlot = <SlotItemModel>[];
    lstBlock = <BlockItemModel>[];
    lstPaymentMethod = <UserVipMember>[];
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
    lstPaymentMethod = <UserVipMember>[];
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
    _resetSelectionsAfterPaymentChange(clearSlotList: true);
    update();
  }

  void getSlotFirst() async {
    await getPaymentMethods();
    await getSlot();
    _resetSelectionsAfterPaymentChange();
    update();
  }

  void _resetSelectionsAfterPaymentChange({bool clearSlotList = false}) {
    idSlot = 0;
    machineValue.value = 'choose_slot'.tr;
    slotValue = 'choose_block'.tr;
    if (clearSlotList) {
      lstSlot = [];
    } else {
      for (final slot in lstSlot) {
        slot.isSelect = false;
      }
    }
    lstBlock = [];
    lstBlock2.refresh();
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

  void onSelectPaymentMethod(UserVipMember? paymentMethod) {
    final oldPaymentId = selectedPaymentMethod?.userCodeMemberId;
    final newPaymentId = paymentMethod?.userCodeMemberId;
    selectedPaymentMethod = paymentMethod;
    // Collapse payment method and expand machine selection after payment method is selected
    if (paymentMethod != null) {
      isPaymentMethodExpanded = false;
      isMachineExpanded = true;
      isBlockExpanded = false;
      if (oldPaymentId != newPaymentId) {
        _resetSelectionsAfterPaymentChange();
      }
    }
    getSlot();
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
    if (shopSelected?.shopID == null) {
      return;
    }

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
    var listValue = await GolfApi().getBlock(
      selectedSlots.first.slotID,
      dateIntCurrent,
      _strDatTimeCurrent,
      SupportUtils.prefs.getInt(USER_ID) ?? 0,
      selectedPaymentMethod?.userCodeMemberId ?? 0,
    );

    lstBlock.clear();
    lstBlock = listValue?.data ?? [];
    update();
  }

  void onChangeSlotExpanded({SlotItemModel? item}) async {
    if (!isPaymentMethodSelected) {
      SupportUtils.showToast(
        'please_choose_payment_method'.tr,
        type: ToastType.ERROR,
      );
      return;
    }

    if (item != null) {
      machineValue.value = item.nameSlot ?? "";
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
    } else if (idSlot != 0) {
      isBlockExpanded = true;
    }
    getBlock();

    update();
  }

  void onChangeBlockExpanded({BlockItemModel? item}) {
    if (!isPaymentMethodSelected || idSlot == null || idSlot == 0) {
      return;
    }
    if (item != null) {
      // Select/deselect block item
      var bookings = lstBlock.where((_v) => _v.blockID == item.blockID);

      if (bookings.length > 0) {
        final bookingItem = bookings.first;
        bookingItem.isSelect = !bookingItem.isSelect;
      }
      lstBlock2.refresh();
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
    isMachineExpanded = false;
    isPaymentMethodExpanded = true;
    isBlockExpanded = false;
    update();
  }

  bool onValidateCreateBooking() {
    if (lstPaymentMethod.isNotEmpty && !isPaymentMethodSelected) {
      SupportUtils.showToast(
        'please_choose_payment_method'.tr,
        type: ToastType.ERROR,
      );
      return false;
    }

    // Validator
    var lstBlockSelected = lstBlock.where((_v) => _v.isSelect).toList();
    if (lstBlockSelected.isEmpty || idSlot == 0) {
      SupportUtils.showToast(
        'no_time_frame_selected'.tr,
        type: ToastType.ERROR,
      );
      return false;
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
      return false;
    }

    return true;
  }

  Map<String, dynamic> _buildCreateBookingJsonBody() {
    var lstBlockSelected = lstBlock.where((_v) => _v.isSelect).toList();
    var createBookingModel = BookingInsertItemModel(
      selectedPaymentMethod?.userCodeMemberId,
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
    return (AuthBody<BookingInsertItemModel>()
          ..setAuth(Auth())
          ..setData(createBookingModel, dataToJson: (_data) => _data!.toJson()))
        .toJson();
  }

  String _sanitizeBookingMessage(String? message) {
    if (message == null || message.trim().isEmpty) {
      return '';
    }

    return message
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('\u200b', '')
        .trim();
  }

  Future<void> _submitCreateBooking(Map<String, dynamic> jsonBody) async {
    var result = await GolfApi().createBooking(jsonBody);
    await Get.toNamed(AppRoutes.BOOKING_DETAIL, arguments: result?.data);
    onReset();
    final controller = Get.find<HomeController>();
    controller.changePageIndex(0);
  }

  void _showAreYouSureCreateBookingDialog(Map<String, dynamic> jsonBody) {
    SupportUtils.showDecisionDialog(
      'are_you_sure_create_booking'.tr,
      lstOptions: [
        DecisionOption('cancel'.tr, onDecisionPressed: null),
        DecisionOption(
          'yes'.tr,
          type: DecisionOptionType.EXPECTATION,
          onDecisionPressed: () async {
            await _submitCreateBooking(jsonBody);
          },
        ),
      ],
    );
  }

  void _showCheckInsertDialog(String message, Map<String, dynamic> jsonBody) {
    SupportUtils.showDecisionDialog(
      message,
      lstOptions: [
        DecisionOption(
          'back'.tr,
          type: DecisionOptionType.DENIED,
          onDecisionPressed: null,
        ),
        DecisionOption(
          'yes_can_it'.tr,
          type: DecisionOptionType.EXPECTATION,
          onDecisionPressed: () async {
            await _submitCreateBooking(jsonBody);
          },
        ),
      ],
    );
  }

  void _showCheckInsertInfoDialog(String message) {
    SupportUtils.showDecisionDialog(
      message,
      lstOptions: [
        DecisionOption(
          'back'.tr,
          type: DecisionOptionType.DENIED,
          onDecisionPressed: null,
        ),
      ],
    );
  }

  /// Returns true when member payment is selected and selected blocks include
  /// outside-member-time blocks that will require extra online payment.
  bool hasOutsideMemberTimeSelection() {
    final selectedMemberId = selectedPaymentMethod?.userCodeMemberId ?? 0;
    if (selectedMemberId <= 0) {
      return false;
    }

    final selectedBlocks = lstBlock.where((block) => block.isSelect).toList();
    if (selectedBlocks.isEmpty) {
      return false;
    }

    return selectedBlocks.any((block) => block.isBlockCodeMember == false);
  }

  void onCreateBooking() async {
    final jsonBody = _buildCreateBookingJsonBody();
    final checkResult = await GolfApi().checkBookingInsert(jsonBody);

    if (checkResult?.getException != null) {
      SupportUtils.showToast(
        checkResult!.getException!.getErrorMessage(),
        type: ToastType.ERROR,
      );
      return;
    }

    final status = checkResult?.decisionStatus ?? 0;
    final message = _sanitizeBookingMessage(checkResult?.message);

    if (status == 1) {
      _showAreYouSureCreateBookingDialog(jsonBody);
      return;
    }

    if (status == -1) {
      _showCheckInsertDialog(
        message.isNotEmpty ? message : 'application_error'.tr,
        jsonBody,
      );
      return;
    }

    if (status == 0) {
      SupportUtils.showToast(
        message.isNotEmpty ? message : 'server_error'.tr,
        type: ToastType.ERROR,
      );
      return;
    }

    _showCheckInsertInfoDialog(
      message.isNotEmpty ? message : 'application_error'.tr,
    );
  }

  void onCancelBooking() {
    Get.toNamed("/test", id: 1);
    Get.delete<BookingCreateController>();

    // Get.back();
  }

  void updateUserVipMember() {
    _shopSelected.value = shopSelected!.copyWith(isUserMemberCode: 1);
  }

  /// Check if there are N consecutive blocks selected based on stt
  bool _hasConsecutiveBlocks(List<BlockItemModel> selectedBlocks, int count) {
    count = count + 1;
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
