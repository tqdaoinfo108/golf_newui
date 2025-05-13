import 'package:golf_uiv2/model/payment_item.dart';

class GetPaymentKeyRequest {
  GetPaymentKeyRequest({
    this.capture,
    this.additionalMessage,
    this.items,
    this.shopID,
  });

  bool? capture;
  String? additionalMessage;
  List<PaymentItem>? items;
  String? cardNumber;
  String? cardExpire;
  String? securityCode;
  String? holderName;
  int? shopID;

  GetPaymentKeyRequest copyWith({
    bool? capture,
    String? additionalMessage,
    List<PaymentItem>? items,
  }) => GetPaymentKeyRequest(
    capture: capture ?? this.capture,
    additionalMessage: additionalMessage ?? this.additionalMessage,
    items: items ?? this.items,
  );

  factory GetPaymentKeyRequest.fromJson(Map<String, dynamic> json) =>
      GetPaymentKeyRequest(
        capture: json["Capture"] == null ? null : json["Capture"],
        additionalMessage:
            json["AdditionalMessage"] == null
                ? null
                : json["AdditionalMessage"],
        items:
            json["items"] == null
                ? null
                : List<PaymentItem>.from(
                  json["items"].map((x) => PaymentItem.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "cardNumber": cardNumber,
    "cardExpire": cardExpire,
    "securityCode": securityCode,
    "holderName": holderName,
    "ShopID": shopID,
    "Capture": capture == null ? null : capture,
    "AdditionalMessage": additionalMessage == null ? null : additionalMessage,
    "items":
        items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}
