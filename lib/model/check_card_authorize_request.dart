class CheckCardAuthorizeRequest {
  CheckCardAuthorizeRequest({
    this.cardNumber,
    this.cardExpire,
    this.securityCode,
    this.cardholderName,
    this.codeMemberID,
  });

  String? cardNumber;
  String? cardExpire;
  String? securityCode;
  String? cardholderName;
  int? codeMemberID;

  Map<String, dynamic> toJson() => {
    "cardNumber": cardNumber,
    "cardExpire": cardExpire,
    "securityCode": securityCode,
    "cardholderName": cardholderName,
    "codeMemberID": codeMemberID,
  };

  factory CheckCardAuthorizeRequest.fromJson(Map<String, dynamic> json) =>
      CheckCardAuthorizeRequest(
        cardNumber: json["cardNumber"],
        cardExpire: json["cardExpire"],
        securityCode: json["securityCode"],
        cardholderName: json["cardholderName"],
        codeMemberID: json["codeMemberID"],
      );
}
