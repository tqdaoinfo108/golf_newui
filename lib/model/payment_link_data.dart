class PaymentLinkData {
  String? paymentKey;
  String? resultCode;
  String? status;
  String? message;
  String? paymentKeyExpiryTime;
  String? payLinkUrl;

  PaymentLinkData(
      {this.paymentKey,
      this.resultCode,
      this.status,
      this.message,
      this.paymentKeyExpiryTime,
      this.payLinkUrl});

  PaymentLinkData.fromJson(Map<String, dynamic> json) {
    paymentKey = json['payment_key'];
    resultCode = json['result_code'];
    status = json['status'];
    message = json['message'];
    paymentKeyExpiryTime = json['payment_key_expiry_time'];
    payLinkUrl = json['pay_link_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_key'] = this.paymentKey;
    data['result_code'] = this.resultCode;
    data['status'] = this.status;
    data['message'] = this.message;
    data['payment_key_expiry_time'] = this.paymentKeyExpiryTime;
    data['pay_link_url'] = this.payLinkUrl;
    return data;
  }
}
