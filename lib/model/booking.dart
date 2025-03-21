import 'package:golf_uiv2/model/base_respose_error.dart';
import 'package:golf_uiv2/model/booking_payment.dart';
import 'package:golf_uiv2/utils/constants.dart';

import 'block.dart';

class Booking extends BaseResponseError {
  int? bookID;
  String? bookCode;
  int? dateBook;
  int? datePlay;
  int? userID;
  int? statusID;
  String? desription;
  int? createdDate;
  int? updatedDate;
  String? userCreated;
  String? userUpdated;
  int? shopID;
  int? slotID;
  String? codeShop;
  String? nameShop;
  String? codeSlot;
  String? addressShop;
  String? phoneShop;
  int? timeCancelMinute;
  String? nameSlot;
  List<Blocks>? blocks;
  BookingPayment? payment;

  // update v4
  bool? isShopManager;

  Blocks? getBookingCurrent() {
    if (blocks != null && blocks!.isNotEmpty) {
      var dateNow = DateTime.now();
      var timeCurrent = DateTime.utc(dateNow.year, dateNow.month, dateNow.day,
              dateNow.hour, dateNow.minute)
          .millisecondsSinceEpoch;
      var block = blocks!.firstWhere(
          (element) =>
              element.rangeStart! <= timeCurrent &&
              timeCurrent <= element.rangeEnd!,
          orElse: () => new Blocks()..blockID = -1);
      if (block.blockID == -1) {
        block = blocks!.firstWhere(
            (element) => element.rangeStart! > timeCurrent,
            orElse: () => blocks!.last);
        return block;
      }
      return block;
    }
    return blocks!.first;
  }

  Booking(
      {this.bookID,
      this.bookCode,
      this.dateBook,
      this.datePlay,
      this.userID,
      this.statusID,
      this.desription,
      this.createdDate,
      this.updatedDate,
      this.userCreated,
      this.userUpdated,
      this.shopID,
      this.slotID,
      this.codeShop,
      this.nameShop,
      this.codeSlot,
      this.addressShop,
      this.phoneShop,
      this.timeCancelMinute,
      this.blocks,
      this.payment,
      this.isShopManager,
      this.nameSlot});

  Booking.fromJson(Map<String, dynamic> json) {
    var _booksJson = json['Books'];
    timeCancelMinute = json['TimeCancelMinute'];
    bookID = _booksJson['BookID'];
    bookCode = _booksJson['BookCode'];
    dateBook = _booksJson['DateBook'] * 1000;
    datePlay = _booksJson['DatePlay'] * 1000;
    userID = _booksJson['UserID'];
    statusID = _booksJson['StatusID'];
    desription = _booksJson['Desription'];
    createdDate = _booksJson['CreatedDate'] * 1000;
    updatedDate = _booksJson['UpdatedDate'] * 1000;
    userCreated = _booksJson['UserCreated'];
    userUpdated = _booksJson['UserUpdated'];
    shopID = _booksJson['ShopID'];
    slotID = _booksJson['SlotID'];
    codeShop = _booksJson['CodeShop'];
    nameShop = _booksJson['NameShop'];
    codeSlot = _booksJson['CodeSlot'];
    addressShop = _booksJson['AddressShop'];
    phoneShop = _booksJson['PhoneShop'];
    nameSlot = _booksJson['NameSlot'];
    isShopManager = json['IsShopManager'];
    if (json['Blocks'] != null) {
      List<Blocks> _rawLstBlocks = [];
      blocks = [];

      json['Blocks'].forEach((v) {
        v['bookingDate'] = datePlay;
        _rawLstBlocks.add(new Blocks.fromJson(v));
      });

      blocks = _getSortBookingAvailablePlayTime(_rawLstBlocks);
    }

    payment = json["payment"] == null
        ? null
        : BookingPayment.fromJson(json['payment']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BookID'] = this.bookID;
    data['BookCode'] = this.bookCode;
    data['DateBook'] = this.dateBook;
    data['DatePlay'] = this.datePlay;
    data['UserID'] = this.userID;
    data['StatusID'] = this.statusID;
    data['Desription'] = this.desription;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedDate'] = this.updatedDate;
    data['UserCreated'] = this.userCreated;
    data['UserUpdated'] = this.userUpdated;
    data['ShopID'] = this.shopID;
    data['SlotID'] = this.slotID;
    data['CodeShop'] = this.codeShop;
    data['NameShop'] = this.nameShop;
    data['CodeSlot'] = this.codeSlot;
    data['AddressShop'] = this.addressShop;
    data['PhoneShop'] = this.phoneShop;
    data['TimeCancelMinute'] = this.timeCancelMinute;
    data['NameSlot'] = this.nameSlot;
    data['payment'] = this.payment;

    if (this.blocks != null) {
      data['Blocks'] = this.blocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<Blocks> _getSortBookingAvailablePlayTime(List<Blocks> rawLstBlocks) {
    var _newListBlock = List<Blocks>.from(rawLstBlocks);
    _newListBlock.sort((a, b) {
      var _currMilis = DateTime.now().millisecondsSinceEpoch;
      var _aStrartRange = _currMilis - a.rangeStart!;
      var _bStrartRange = _currMilis - b.rangeStart!;

      if (_aStrartRange == 0) return -1;
      if (_bStrartRange == 0) return 1;
      if (_aStrartRange < 0 && _bStrartRange > 0) {
        return -1;
      }
      if (_bStrartRange < 0 && _aStrartRange > 0) {
        return 1;
      }
      if (_aStrartRange > 0 && _bStrartRange > 0) {
        return _aStrartRange.compareTo(_bStrartRange);
      }
      if (_aStrartRange < 0 && _bStrartRange < 0) {
        return _bStrartRange.compareTo(_aStrartRange);
      }
      return 0;
    });

    return _newListBlock;
  }

  bool isAvailablePayment() =>
      this.statusID == BookingStatus.WAITING_PAYMENT &&
      (this.blocks![0].rangeEnd! -
              DateTime.utc(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                DateTime.now().hour,
                DateTime.now().minute,
              ).millisecondsSinceEpoch) >
          0;

  bool isAvailableCancel() {
    return this.isShopManager ??
        false ||
            this.statusID == BookingStatus.WAITING_PAYMENT ||
            (this.statusID == BookingStatus.PAID &&
                (this.blocks![0].rangeStart! -
                        (60 * timeCancelMinute! * 1000) -
                        DateTime.utc(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          DateTime.now().hour,
                          DateTime.now().minute,
                        ).millisecondsSinceEpoch) >
                    0);
  }
}
