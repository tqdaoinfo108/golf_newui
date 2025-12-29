import 'dart:convert';

import 'package:golf_uiv2/utils/constants.dart';

List<UserVipMember> userVipMemberFromJson(String str) =>
    List<UserVipMember>.from(
      json.decode(str).map((x) => UserVipMember.fromJson(x)),
    );

class UserVipMember {
  UserVipMember({
    this.bookingConsecutiveLimit,
    this.userId,
    this.userName,
    this.shopId,
    this.shopCode,
    this.shopName,
    this.shopAddress,
    this.typeLimit,
    this.sumBuyPlay,
    this.sumUsePlay,
    this.remainPlay,
    this.fromDate,
    this.toDate,
    this.isRenew,
    this.userCodeMemberId,
    this.listUserCodeMemberLimit,
    this.nameCodeMember,
    this.numberPlayInMonth,
    this.numberPlayInDay,
    this.numberPlayInMonthText,
    this.numberPlayInDayText,
    this.numberConsecutiveText,
    this.timeSlotText,
    this.dayText,
  });

  String? dayText;
  int? userId;
  String? userName;
  int? shopId;
  String? shopCode;
  String? shopName;
  String? shopAddress;
  int? typeLimit;
  int? sumBuyPlay;
  int? sumUsePlay;
  int? remainPlay;
  int? fromDate;
  int? toDate;
  int? isRenew;
  int? userCodeMemberId;
  List<UserVipMember>? listUserCodeMemberLimit;
  String? nameCodeMember;
  int? bookingConsecutiveLimit = 2;
  int? numberPlayInMonth;
  int? numberPlayInDay;
  String? numberPlayInMonthText;
  String? numberPlayInDayText;
  String? numberConsecutiveText;
  String? timeSlotText;

  factory UserVipMember.fromJson(Map<String, dynamic> json) => UserVipMember(
    userId: json["UserID"] == null ? null : json["UserID"],
    userName: json["UserName"] == null ? null : json["UserName"],
    shopId: json["ShopID"] == null ? null : json["ShopID"],
    shopCode: json["ShopCode"] == null ? null : json["ShopCode"],
    shopName: json["ShopName"] == null ? null : json["ShopName"],
    shopAddress: json["ShopAddress"] == null ? null : json["ShopAddress"],
    typeLimit: json["TypeLimit"] == null ? null : json["TypeLimit"],
    sumBuyPlay: json["SumBuyPlay"] == null ? null : json["SumBuyPlay"],
    sumUsePlay: json["SumUsePlay"] == null ? null : json["SumUsePlay"],
    remainPlay: json["RemainPlay"] == null ? null : json["RemainPlay"],
    fromDate: json["FromDate"] == null ? null : json["FromDate"] * 1000,
    toDate: json["ToDate"] == null ? null : json["ToDate"] * 1000,
    nameCodeMember:
        json["NameCodeMember"] == null ? null : json["NameCodeMember"],
    isRenew: json["IsRenew"] == null ? null : json["IsRenew"],
    userCodeMemberId:
        json["UserCodeMemberID"] == null ? null : json["UserCodeMemberID"],
    bookingConsecutiveLimit: json["BookConsecutiveLimit"],
    numberPlayInMonth: json["NumberPlayInMonth"],
    numberPlayInDay: json["NumberPlayInDay"],
    dayText: json["DayText"],
    numberPlayInMonthText: json["NumberPlayInMonthText"],
    numberPlayInDayText: json["NumberPlayInDayText"],
    numberConsecutiveText: json["NumberConsecutiveText"],
    timeSlotText: json["TimeSlotText"],
    listUserCodeMemberLimit:
        json["ListUserCodeMemberLimit"] == null
            ? null
            : List<UserVipMember>.from(
              json["ListUserCodeMemberLimit"].map(
                (val) => UserVipMember.fromJson(val),
              ),
            ),
  );

  bool isUseable() {
    return this.typeLimit != VipMemberType.UNLIMIT ||
        this.isRenew == 1 ||
        (this.toDate! -
                DateTime.utc(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  DateTime.now().hour,
                  DateTime.now().minute,
                ).millisecondsSinceEpoch) >
            0;
  }

  int? getLimitMemberFromDate() {
    return (List<UserVipMember>.from(listUserCodeMemberLimit!)
      ..sort((a, b) => a.fromDate!.compareTo(b.fromDate!)))[0].fromDate;
  }

  int? getLimitMemberToDate() {
    return (List<UserVipMember>.from(listUserCodeMemberLimit!)
      ..sort((a, b) => b.toDate!.compareTo(a.toDate!)))[0].toDate;
  }
}
