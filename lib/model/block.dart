import 'package:golf_uiv2/utils/support.dart';

class Blocks {
  int? blockID;
  String? codeBlock;
  String? nameBlock;
  int? rangeStart;
  int? rangeEnd;
  int? status;
  String? descriptionBlock;
  int? createdDate;
  int? updatedDate;
  String? userCreated;
  String? userUpdated;
  int? bookingDate;
  double? price;
  double? discount;
  double? amountAfterDiscount;
  bool? isActive;

  String getNameBlock() {
    return rangeStart!.toStringFormatHoursUTC() +
        " - " +
        rangeEnd!.toStringFormatHoursUTC();
  }

  Blocks(
      {this.blockID,
      this.codeBlock,
      this.nameBlock,
      this.rangeStart,
      this.rangeEnd,
      this.status,
      this.descriptionBlock,
      this.createdDate,
      this.updatedDate,
      this.userCreated,
      this.bookingDate,
      this.userUpdated,
      this.price,
      this.discount,
      this.amountAfterDiscount,
      this.isActive});

  Blocks.fromJson(Map<String, dynamic> json) {
    blockID = json['BlockID'];
    codeBlock = json['CodeBlock'];
    nameBlock = json['NameBlock'];
    status = json['Status'];
    descriptionBlock = json['DescriptionBlock'];
    createdDate = (json['CreatedDate'] ?? 0) * 1000;
    updatedDate = (json['UpdatedDate'] ?? 0) * 1000;
    userCreated = json['UserCreated'];
    userUpdated = json['UserUpdated'];
    bookingDate = json['bookingDate'];
    price = json['Price'];
    discount = json['Discount'];
    amountAfterDiscount = json['AmountAfterDiscount'];
    isActive = json['IsActive'];

    var _tmpRangeStartDate = DateTime.fromMillisecondsSinceEpoch(
      (json['RangeStart']) * 1000,
      isUtc: true,
    );
    var _tmpRangeEndDate = DateTime.fromMillisecondsSinceEpoch(
      (json['RangeEnd']) * 1000,
      isUtc: true,
    );
    var _tmpBookingDate = DateTime.fromMillisecondsSinceEpoch(bookingDate!);

    rangeStart = DateTime.utc(
      _tmpBookingDate.year,
      _tmpBookingDate.month,
      _tmpBookingDate.day,
      _tmpRangeStartDate.hour,
      _tmpRangeStartDate.minute,
    ).millisecondsSinceEpoch;

    rangeEnd = DateTime.utc(
      _tmpBookingDate.year,
      _tmpBookingDate.month,
      _tmpBookingDate.day,
      _tmpRangeEndDate.hour,
      _tmpRangeEndDate.minute,
    ).millisecondsSinceEpoch;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BlockID'] = this.blockID;
    data['CodeBlock'] = this.codeBlock;
    data['NameBlock'] = this.nameBlock;
    data['RangeStart'] = this.rangeStart;
    data['RangeEnd'] = this.rangeEnd;
    data['Status'] = this.status;
    data['DescriptionBlock'] = this.descriptionBlock;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedDate'] = this.updatedDate;
    data['UserCreated'] = this.userCreated;
    data['UserUpdated'] = this.userUpdated;
    data['bookingDate'] = this.bookingDate;
    data['Price'] = this.price;
    data['Discount'] = this.discount;
    data['AmountAfterDiscount'] = this.amountAfterDiscount;
    data['IsActive'] = this.isActive;
    return data;
  }
}
