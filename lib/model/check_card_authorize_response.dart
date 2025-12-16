class CheckCardAuthorizeResponse {
  CheckCardAuthorizeResponse({
    this.serviceType,
    this.mstatus,
    this.merrMsg,
    this.orderId,
    this.authStartUrl,
    this.cardNumber,
    this.cardExpire,
    this.securityCode,
    this.cardholderName,
  });

  String? serviceType;
  String? mstatus;
  String? merrMsg;
  String? orderId;
  String? authStartUrl;
  String? cardNumber;
  String? cardExpire;
  String? securityCode;
  String? cardholderName;

  factory CheckCardAuthorizeResponse.fromJson(Map<String, dynamic> json) =>
      CheckCardAuthorizeResponse(
        serviceType: json["serviceType"],
        mstatus: json["mstatus"],
        merrMsg: json["merrMsg"],
        orderId: json["orderId"],
        authStartUrl: json["authStartUrl"],
        cardNumber: json["cardNumber"],
        cardExpire: json["cardExpire"],
        securityCode: json["securityCode"],
        cardholderName: json["cardholderName"],
      );

  Map<String, dynamic> toJson() => {
    "serviceType": serviceType,
    "mstatus": mstatus,
    "merrMsg": merrMsg,
    "orderId": orderId,
    "authStartUrl": authStartUrl,
    "cardNumber": cardNumber,
    "cardExpire": cardExpire,
    "securityCode": securityCode,
    "cardholderName": cardholderName,
  };

  CheckCardAuthorizeResponse copyWith({
    String? serviceType,
    String? mstatus,
    String? merrMsg,
    String? orderId,
    String? authStartUrl,
    String? cardNumber,
    String? cardExpire,
    String? securityCode,
    String? cardholderName,
  }) => CheckCardAuthorizeResponse(
    serviceType: serviceType ?? this.serviceType,
    mstatus: mstatus ?? this.mstatus,
    merrMsg: merrMsg ?? this.merrMsg,
    orderId: orderId ?? this.orderId,
    authStartUrl: authStartUrl ?? this.authStartUrl,
    cardNumber: cardNumber ?? this.cardNumber,
    cardExpire: cardExpire ?? this.cardExpire,
    securityCode: securityCode ?? this.securityCode,
    cardholderName: cardholderName ?? this.cardholderName,
  );
}
