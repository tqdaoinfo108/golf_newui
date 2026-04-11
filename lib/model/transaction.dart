import 'package:golf_uiv2/model/transaction_payment_detail.dart';

class Transaction {
  Transaction({
    this.code,
    this.datePlay,
    this.userId,
    this.statusId,
    this.shopId,
    this.slotId,
    this.codeShop,
    this.nameShop,
    this.addressShop,
    this.phoneShop,
    this.payId,
    this.userCodeMemberId,
    this.paymentCode,
    this.orderId,
    this.datePayment,
    this.amount,
    this.status,
    this.typePayment,
    this.typeCodeMember,
    this.timeStart,
    this.timeEnd,
    this.remainPlay,
    this.typePaymentBooking,
        this.dateJP,
        this.dateAndStatusJP,
        this.moneyJP,
        this.shopJP,
        this.typeCodeMemberMJP,
    this.listPaymentDetail,
  });

  String? code;
  int? datePlay;
  int? userId;
  int? statusId;
  int? shopId;
  int? slotId;
  String? codeShop;
  String? nameShop;
  String? addressShop;
  String? phoneShop;
  int? payId;
  int? userCodeMemberId;
  String? paymentCode;
  String? orderId;
  int? datePayment;
  double? amount;
  int? status;
  int? typePayment;
  int? typeCodeMember;
  int? timeStart;
  int? timeEnd;
  int? remainPlay;
  int? typePaymentBooking;
    String? dateJP;
    String? dateAndStatusJP;
    String? moneyJP;
    String? shopJP;
    String? typeCodeMemberMJP;
  List<TransactionPaymentDetail>? listPaymentDetail;

  Transaction copyWith({
    String? code,
    int? datePlay,
    int? userId,
    int? statusId,
    int? shopId,
    int? slotId,
    String? codeShop,
    String? nameShop,
    String? addressShop,
    String? phoneShop,
    int? payId,
    int? userCodeMemberId,
    String? paymentCode,
    String? orderId,
    int? datePayment,
    double? amount,
    int? status,
    int? typePayment,
    int? typeCodeMember,
    int? timeStart,
    int? timeEnd,
    int? remainPlay,
    int? typePaymentBooking,
        String? dateJP,
        String? dateAndStatusJP,
        String? moneyJP,
        String? shopJP,
        String? typeCodeMemberMJP,
    List<TransactionPaymentDetail>? listPaymentDetail,
  }) =>
      Transaction(
        code: code ?? this.code,
        datePlay: datePlay ?? this.datePlay,
        userId: userId ?? this.userId,
        statusId: statusId ?? this.statusId,
        shopId: shopId ?? this.shopId,
        slotId: slotId ?? this.slotId,
        codeShop: codeShop ?? this.codeShop,
        nameShop: nameShop ?? this.nameShop,
        addressShop: addressShop ?? this.addressShop,
        phoneShop: phoneShop ?? this.phoneShop,
        payId: payId ?? this.payId,
        userCodeMemberId: userCodeMemberId ?? this.userCodeMemberId,
        paymentCode: paymentCode ?? this.paymentCode,
        orderId: orderId ?? this.orderId,
        datePayment: datePayment ?? this.datePayment,
        amount: amount ?? this.amount,
        status: status ?? this.status,
        typePayment: typePayment ?? this.typePayment,
        typeCodeMember: typeCodeMember ?? this.typeCodeMember,
        timeStart: timeStart ?? this.timeStart,
        timeEnd: timeEnd ?? this.timeEnd,
        remainPlay: remainPlay ?? this.remainPlay,
        typePaymentBooking: typePaymentBooking ?? this.typePaymentBooking,
                dateJP: dateJP ?? this.dateJP,
                dateAndStatusJP: dateAndStatusJP ?? this.dateAndStatusJP,
                moneyJP: moneyJP ?? this.moneyJP,
                shopJP: shopJP ?? this.shopJP,
                typeCodeMemberMJP: typeCodeMemberMJP ?? this.typeCodeMemberMJP,
        listPaymentDetail: listPaymentDetail ?? this.listPaymentDetail,
      );

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        code: json["Code"] == null ? null : json["Code"],
        datePlay: json["DatePlay"] == null ? null : json["DatePlay"] * 1000,
        userId: json["UserID"] == null ? null : json["UserID"],
        statusId: json["StatusID"] == null ? null : json["StatusID"],
        shopId: json["ShopID"] == null ? null : json["ShopID"],
        slotId: json["SlotID"] == null ? null : json["SlotID"],
        codeShop: json["CodeShop"] == null ? null : json["CodeShop"],
        nameShop: json["NameShop"] == null ? null : json["NameShop"],
        addressShop: json["AddressShop"] == null ? null : json["AddressShop"],
        phoneShop: json["PhoneShop"] == null ? null : json["PhoneShop"],
        payId: json["PayID"] == null ? null : json["PayID"],
        userCodeMemberId:
            json["UserCodeMemberID"] == null ? null : json["UserCodeMemberID"],
        paymentCode: json["PaymentCode"] == null ? null : json["PaymentCode"],
        orderId: json["Order_ID"] == null ? null : json["Order_ID"],
        datePayment:
            json["DatePayment"] == null ? null : json["DatePayment"] * 1000,
        amount: json["Amount"] == null ? null : json["Amount"],
        status: json["Status"] == null ? null : json["Status"],
        typePayment: json["TypePayment"] == null ? null : json["TypePayment"],
        typeCodeMember:
            json["TypeCodeMember"] == null ? null : json["TypeCodeMember"],
        timeStart: json["TimeStart"] == null ? null : json["TimeStart"] * 1000,
        timeEnd: json["TimeEnd"] == null ? null : json["TimeEnd"] * 1000,
        remainPlay: json["RemainPlay"] == null ? null : json["RemainPlay"],
        typePaymentBooking: json["TypePaymentBooking"] == null
            ? null
            : json["TypePaymentBooking"],
        dateJP: json["DateJP"] == null ? null : json["DateJP"],
        dateAndStatusJP: json["DateAndStatusJP"] == null
            ? null
            : json["DateAndStatusJP"],
        moneyJP: json["MoneyJP"] == null ? null : json["MoneyJP"],
        shopJP: json["ShopJP"] == null ? null : json["ShopJP"],
        typeCodeMemberMJP: json["TypeCodeMemberMJP"] == null
            ? null
            : json["TypeCodeMemberMJP"],
        listPaymentDetail: json["listPaymentDetail"] == null
            ? null
            : List<TransactionPaymentDetail>.from(json["listPaymentDetail"]
                .map((val) => TransactionPaymentDetail.fromJson(val))),
      );

  Map<String, dynamic> toJson() => {
        "Code": code == null ? null : code,
        "DatePlay": datePlay == null ? null : datePlay,
        "UserID": userId == null ? null : userId,
        "StatusID": statusId == null ? null : statusId,
        "ShopID": shopId == null ? null : shopId,
        "SlotID": slotId == null ? null : slotId,
        "CodeShop": codeShop == null ? null : codeShop,
        "NameShop": nameShop == null ? null : nameShop,
        "AddressShop": addressShop == null ? null : addressShop,
        "PhoneShop": phoneShop == null ? null : phoneShop,
        "PayID": payId == null ? null : payId,
        "UserCodeMemberID": userCodeMemberId == null ? null : userCodeMemberId,
        "PaymentCode": paymentCode == null ? null : paymentCode,
        "Order_ID": orderId == null ? null : orderId,
        "DatePayment": datePayment == null ? null : datePayment,
        "Amount": amount == null ? null : amount,
        "Status": status == null ? null : status,
        "TypePayment": typePayment == null ? null : typePayment,
        "TypeCodeMember": typeCodeMember == null ? null : typeCodeMember,
        "TimeStart": timeStart == null ? null : timeStart,
        "TimeEnd": timeEnd == null ? null : timeEnd,
        "RemainPlay": remainPlay == null ? null : remainPlay,
        "TypePaymentBooking":
            typePaymentBooking == null ? null : typePaymentBooking,
        "DateJP": dateJP == null ? null : dateJP,
        "DateAndStatusJP": dateAndStatusJP == null ? null : dateAndStatusJP,
        "MoneyJP": moneyJP == null ? null : moneyJP,
        "ShopJP": shopJP == null ? null : shopJP,
        "TypeCodeMemberMJP":
            typeCodeMemberMJP == null ? null : typeCodeMemberMJP,
        "listPaymentDetail":
            listPaymentDetail == null ? null : listPaymentDetail,
      };
}
