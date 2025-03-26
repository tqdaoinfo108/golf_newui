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

class BookingCreateController extends GetxController {
  ExpandableController? exMachineController;
  ExpandableController? exSlotController;
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
  List<BlockItemModel> get lstBlock => this._lstBlock;
  set lstBlock(List<BlockItemModel> value) => this._lstBlock.value = value;

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
    exMachineController = new ExpandableController(initialExpanded: true);
    exSlotController = new ExpandableController(initialExpanded: false);
    userId = SupportUtils.prefs.getInt(USER_ID);
    // init data
    lstSlot = <SlotItemModel>[];
    lstBlock = <BlockItemModel>[];
    var _dateTemp = DateTime.now();
    dateIntCurrent =
        DateTime.utc(
          _dateTemp.year,
          _dateTemp.month,
          _dateTemp.day,
        ).millisecondsSinceEpoch ~/
        1000;
    textDayOfWeek = DateTime.now().millisecondsSinceEpoch.toStringFormatDate();
    super.onInit();
  }

  void getSlotFirst() async {
    await getSlot();
    if (lstSlot.length > 0) {
      lstSlot[0].isSelect = true;
    }
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
      lstSlot.where((_v) => _v.isSelect).first.slotID,
      dateIntCurrent,
      _strDatTimeCurrent,
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
    exMachineController!.expanded = !exMachineController!.expanded;
    exSlotController!.expanded = !exSlotController!.expanded;
    getBlock();
    update();
  }

  void onChangeBlockExpanded({BlockItemModel? item}) {
    if (item != null) {
      var bookings = lstBlock.where((_v) => _v.blockID == item.blockID);

      if (bookings.length > 0) {
        final bookingItem = bookings.first;
        bookingItem.isSelect = !bookingItem.isSelect;
      }
    }

    _lstBlock.refresh();
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

    var createBookingModel = new BookingInsertItemModel();
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
    Get.offNamed(AppRoutes.BOOKING_DETAIL, arguments: result?.data);
  }

  void onCancelBooking() {
    Get.toNamed("/test", id: 1);
    Get.delete<BookingCreateController>();
  }

  void updateShopVipMember() {
    _shopSelected.value = shopSelected!.copyWith(isUserMemberCode: 1);
  }
}
