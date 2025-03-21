class TransactionPaymentDetail {
    TransactionPaymentDetail({
        this.paymentDetailId,
        this.payId,
        this.paymentCodeMemberId,
        this.typePayment,
        this.amount,
        this.createdDate,
        this.numberBlock,
        this.paymentCode,
        this.orderId,
    });

    int? paymentDetailId;
    int? payId;
    int? paymentCodeMemberId;
    int? typePayment;
    double? amount;
    int? createdDate;
    int? numberBlock;
    String? paymentCode;
    int? orderId;

    TransactionPaymentDetail copyWith({
        int? paymentDetailId,
        int? payId,
        int? paymentCodeMemberId,
        int? typePayment,
        double? amount,
        int? createdDate,
        int? numberBlock,
        String? paymentCode,
        int? orderId,
    }) => 
        TransactionPaymentDetail(
            paymentDetailId: paymentDetailId ?? this.paymentDetailId,
            payId: payId ?? this.payId,
            paymentCodeMemberId: paymentCodeMemberId ?? this.paymentCodeMemberId,
            typePayment: typePayment ?? this.typePayment,
            amount: amount ?? this.amount,
            createdDate: createdDate ?? this.createdDate,
            numberBlock: numberBlock ?? this.numberBlock,
            paymentCode: paymentCode ?? this.paymentCode,
            orderId: orderId ?? this.orderId,
        );

    factory TransactionPaymentDetail.fromJson(Map<String, dynamic> json) => TransactionPaymentDetail(
        paymentDetailId: json["PaymentDetailID"] == null ? null : json["PaymentDetailID"],
        payId: json["PayID"] == null ? null : json["PayID"],
        paymentCodeMemberId: json["PaymentCodeMemberID"],
        typePayment: json["TypePayment"] == null ? null : json["TypePayment"],
        amount: json["Amount"] == null ? null : json["Amount"],
        createdDate: json["CreatedDate"] == null ? null : json["CreatedDate"],
        numberBlock: json["NumberBlock"] == null ? null : json["NumberBlock"],
        paymentCode: json["PaymentCode"] == null ? null : json["PaymentCode"],
        orderId: json["Order_ID"],
    );

    Map<String, dynamic> toJson() => {
        "PaymentDetailID": paymentDetailId == null ? null : paymentDetailId,
        "PayID": payId == null ? null : payId,
        "PaymentCodeMemberID": paymentCodeMemberId,
        "TypePayment": typePayment == null ? null : typePayment,
        "Amount": amount == null ? null : amount,
        "CreatedDate": createdDate == null ? null : createdDate,
        "NumberBlock": numberBlock == null ? null : numberBlock,
        "PaymentCode": paymentCode == null ? null : paymentCode,
        "Order_ID": orderId,
    };
}
