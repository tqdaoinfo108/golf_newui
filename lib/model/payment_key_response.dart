class PaymentKeyResponse {
    PaymentKeyResponse({
        this.paymentKey,
        this.status,
        this.clientKey,
        this.oderId,
        this.grossAmount,
        this.resResponseContents,
        this.reqRedirectionUri,
        this.mstatus,
        this.cardNumber
    });

    String? paymentKey;
    String? status;
    String? clientKey;
    String? oderId;
    int? grossAmount;
    // update
    String? resResponseContents;
    String? reqRedirectionUri;
    String? mstatus;
    String? cardNumber;

    PaymentKeyResponse copyWith({
        String? paymentKey,
        String? status,
        String? clientKey,
        String? oderId,
        int? grossAmount,
    }) => 
        PaymentKeyResponse(
            paymentKey: paymentKey ?? this.paymentKey,
            status: status ?? this.status,
            clientKey: clientKey ?? this.clientKey,
            oderId: oderId ?? this.oderId,
            grossAmount: grossAmount ?? this.grossAmount,
        );

    factory PaymentKeyResponse.fromJson(Map<String, dynamic> json) => PaymentKeyResponse(
        paymentKey: json["PaymentKey"] == null ? null : json["PaymentKey"],
        status: json["Status"] == null ? null : json["Status"],
        clientKey: json["ClientKey"] == null ? null : json["ClientKey"],
        oderId: json["orderId"] == null ? null : json["orderId"],
        grossAmount:int.tryParse( json["reqAmount"]),
        resResponseContents: json["resResponseContents"] == null ? null : json["resResponseContents"],
        reqRedirectionUri: json["reqRedirectionUri"] == null ? null : json["reqRedirectionUri"],
        mstatus: json["mstatus"] == null ? null : json["mstatus"],
        cardNumber: json["reqCardNumber"]
    );

    Map<String, dynamic> toJson() => {
        "PaymentKey": paymentKey == null ? null : paymentKey,
        "Status": status == null ? null : status,
        "ClientKey": clientKey == null ? null : clientKey,
        "OderID": oderId == null ? null : oderId,
        "GrossAmount": grossAmount == null ? null : grossAmount,
    };
}
