class ShopVipMember {
  ShopVipMember(
    this.bookingConsecutiveLimit, {
    this.codeMemberId,
    this.shopId,
    this.typeCodeMember,
    this.code,
    this.nameCodeMember,
    this.numberPlayInMonth,
    this.amount,
    this.status,
    this.description,
    this.createdDate,
    this.updatedDate,
    this.userCreated,
    this.userUpdated,
    this.isAllowReccuring
  });

  int? codeMemberId;
  int? shopId;
  int? typeCodeMember;
  String? code;
  String? nameCodeMember;
  int? numberPlayInMonth;
  double? amount;
  int? status;
  String? description;
  int? createdDate;
  int? updatedDate;
  String? userCreated;
  String? userUpdated;
  int bookingConsecutiveLimit = 2;
  bool? isAllowReccuring;

  ShopVipMember copyWith({
    int? codeMemberId,
    int? shopId,
    int? typeCodeMember,
    String? code,
    String? nameCodeMember,
    int? numberPlayInMonth,
    double? amount,
    int? status,
    String? description,
    int? createdDate,
    int? updatedDate,
    String? userCreated,
    String? userUpdated,
    bool? isAllowReccuring,
  }) => ShopVipMember( bookingConsecutiveLimit,
    codeMemberId: codeMemberId ?? this.codeMemberId,
    shopId: shopId ?? this.shopId,
    typeCodeMember: typeCodeMember ?? this.typeCodeMember,
    code: code ?? this.code,
    nameCodeMember: nameCodeMember ?? this.nameCodeMember,
    numberPlayInMonth: numberPlayInMonth ?? this.numberPlayInMonth,
    amount: amount ?? this.amount,
    status: status ?? this.status,
    isAllowReccuring: isAllowReccuring ?? this.isAllowReccuring,
    description: description ?? this.description,
    createdDate: createdDate ?? this.createdDate,
    updatedDate: updatedDate ?? this.updatedDate,
    userCreated: userCreated ?? this.userCreated,
    userUpdated: userUpdated ?? this.userUpdated,
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
    amount: json["Amount"],
    status: json["Status"],
    description: json["Description"],
    createdDate:
        json["CreatedDate"] == null ? null : json["CreatedDate"] * 1000,
    updatedDate:
        json["UpdatedDate"] == null ? null : json["UpdatedDate"] * 1000,
    userCreated: json["UserCreated"],
    userUpdated: json["UserUpdated"],
    isAllowReccuring: json["IsAllowReccuring"]
  );

  Map<String, dynamic> toJson() => {
    "CodeMemberID": codeMemberId == null ? null : codeMemberId,
    "ShopID": shopId == null ? null : shopId,
    "TypeCodeMember": typeCodeMember == null ? null : typeCodeMember,
    "Code": code == null ? null : code,
    "NameCodeMember": nameCodeMember == null ? null : nameCodeMember,
    "NumberPlayInMonth": numberPlayInMonth == null ? null : numberPlayInMonth,
    "Amount": amount == null ? null : amount,
    "Status": status == null ? null : status,
    "Description": description == null ? null : description,
    "CreatedDate": createdDate == null ? null : createdDate,
    "UpdatedDate": updatedDate == null ? null : updatedDate,
    "UserCreated": userCreated == null ? null : userCreated,
    "UserUpdated": userUpdated == null ? null : userUpdated,
  };
}
