class ShopVipMember {
  ShopVipMember(
    this.bookingConsecutiveLimit, {
    this.codeMemberId,
    this.shopId,
    this.typeCodeMember,
    this.code,
    this.nameCodeMember,
    this.numberPlayInMonth,
    this.numberPlayInDay,
    this.amount,
    this.status,
    this.isHideBlock,
    this.rangeStart,
    this.rangeEnd,
    this.lstWeekday,
    this.description,
    this.createdDate,
    this.updatedDate,
    this.userCreated,
    this.userUpdated,
    this.isAllowReccuring,
    this.numberPlayInMonthText,
    this.numberPlayInDayText,
    this.numberConsecutiveText,
    this.timeSlotText,
    this.dayText,
  });

  int? codeMemberId;
  int? shopId;
  int? typeCodeMember;
  String? code;
  String? nameCodeMember;
  double? amount;
  int? status;
  bool? isHideBlock;
  int bookingConsecutiveLimit = 2;
  int? rangeStart;
  int? rangeEnd;
  List<int>? lstWeekday;
  String? description;
  int? createdDate;
  int? updatedDate;
  String? userCreated;
  String? userUpdated;
  bool? isAllowReccuring;
  int? numberPlayInMonth;
  int? numberPlayInDay;
  String? numberPlayInMonthText;
  String? numberPlayInDayText;
  String? numberConsecutiveText;
  String? timeSlotText;
  String? dayText;

  ShopVipMember copyWith({
    int? codeMemberId,
    int? shopId,
    int? typeCodeMember,
    String? code,
    String? nameCodeMember,
    int? numberPlayInMonth,
    int? numberPlayInDay,
    double? amount,
    int? status,
    bool? isHideBlock,
    int? rangeStart,
    int? rangeEnd,
    List<int>? lstWeekday,
    String? description,
    int? createdDate,
    int? updatedDate,
    String? userCreated,
    String? userUpdated,
    bool? isAllowReccuring,
    String? numberPlayInMonthText,
    String? numberPlayInDayText,
    String? numberConsecutiveText,
    String? timeSlotText,
    String? dayText,
  }) => ShopVipMember( bookingConsecutiveLimit,
    codeMemberId: codeMemberId ?? this.codeMemberId,
    shopId: shopId ?? this.shopId,
    typeCodeMember: typeCodeMember ?? this.typeCodeMember,
    code: code ?? this.code,
    nameCodeMember: nameCodeMember ?? this.nameCodeMember,
    numberPlayInMonth: numberPlayInMonth ?? this.numberPlayInMonth,
    numberPlayInDay: numberPlayInDay ?? this.numberPlayInDay,
    amount: amount ?? this.amount,
    status: status ?? this.status,
    isHideBlock: isHideBlock ?? this.isHideBlock,
    rangeStart: rangeStart ?? this.rangeStart,
    rangeEnd: rangeEnd ?? this.rangeEnd,
    lstWeekday: lstWeekday ?? this.lstWeekday,
    isAllowReccuring: isAllowReccuring ?? this.isAllowReccuring,
    description: description ?? this.description,
    createdDate: createdDate ?? this.createdDate,
    updatedDate: updatedDate ?? this.updatedDate,
    userCreated: userCreated ?? this.userCreated,
    userUpdated: userUpdated ?? this.userUpdated,
    numberPlayInMonthText: numberPlayInMonthText ?? this.numberPlayInMonthText,
    numberPlayInDayText: numberPlayInDayText ?? this.numberPlayInDayText,
    numberConsecutiveText: numberConsecutiveText ?? this.numberConsecutiveText,
    timeSlotText: timeSlotText ?? this.timeSlotText,
    dayText: dayText ?? this.dayText,
  );

  factory ShopVipMember.fromJson(Map<String, dynamic> json) => ShopVipMember(  json["BookConsecutiveLimit"] == null ? 2 : json["BookConsecutiveLimit"],
    codeMemberId: json["CodeMemberID"] == null ? null : json["CodeMemberID"],
    shopId: json["ShopID"],
    typeCodeMember:
        json["TypeCodeMember"],
    code: json["Code"],
    nameCodeMember:
        json["NameCodeMember"],
    numberPlayInMonth:
        json["NumberPlayInMonth"],
    numberPlayInDay:
        json["NumberPlayInDay"],
    amount: json["Amount"],
    status: json["Status"],
    isHideBlock: json["IsHideBlock"],
    rangeStart: json["RangeStart"],
    rangeEnd: json["RangeEnd"],
    lstWeekday: json["lstWeekday"] == null ? null : List<int>.from(json["lstWeekday"]),
    description: json["Description"],
    createdDate:
        json["CreatedDate"] == null ? null : json["CreatedDate"] * 1000,
    updatedDate:
        json["UpdatedDate"] == null ? null : json["UpdatedDate"] * 1000,
    userCreated: json["UserCreated"],
    userUpdated: json["UserUpdated"],
    isAllowReccuring: json["IsAllowReccuring"],
    numberPlayInMonthText: json["NumberPlayInMonthText"],
    numberPlayInDayText: json["NumberPlayInDayText"],
    numberConsecutiveText: json["NumberConsecutiveText"],
    timeSlotText: json["TimeSlotText"],
    dayText: json["DayText"],
  );

  Map<String, dynamic> toJson() => {
    "CodeMemberID": codeMemberId == null ? null : codeMemberId,
    "ShopID": shopId == null ? null : shopId,
    "TypeCodeMember": typeCodeMember == null ? null : typeCodeMember,
    "Code": code == null ? null : code,
    "NameCodeMember": nameCodeMember == null ? null : nameCodeMember,
    "NumberPlayInMonth": numberPlayInMonth == null ? null : numberPlayInMonth,
    "NumberPlayInDay": numberPlayInDay == null ? null : numberPlayInDay,
    "Amount": amount == null ? null : amount,
    "Status": status == null ? null : status,
    "IsHideBlock": isHideBlock == null ? null : isHideBlock,
    "BookConsecutiveLimit": bookingConsecutiveLimit,
    "RangeStart": rangeStart == null ? null : rangeStart,
    "RangeEnd": rangeEnd == null ? null : rangeEnd,
    "lstWeekday": lstWeekday == null ? null : lstWeekday,
    "Description": description == null ? null : description,
    "CreatedDate": createdDate == null ? null : createdDate,
    "UpdatedDate": updatedDate == null ? null : updatedDate,
    "UserCreated": userCreated == null ? null : userCreated,
    "UserUpdated": userUpdated == null ? null : userUpdated,
    "IsAllowReccuring": isAllowReccuring == null ? null : isAllowReccuring,
    "NumberPlayInMonthText": numberPlayInMonthText == null ? null : numberPlayInMonthText,
    "NumberPlayInDayText": numberPlayInDayText == null ? null : numberPlayInDayText,
    "NumberConsecutiveText": numberConsecutiveText == null ? null : numberConsecutiveText,
    "TimeSlotText": timeSlotText == null ? null : timeSlotText,
    "DayText": dayText == null ? null : dayText,
  };
}
