import 'base_respose_error.dart';

class ShopModel extends BaseResponseError {
  List<ShopItemModel>? data;
  int? total;

  ShopModel({this.data, this.total});

  ShopModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new ShopItemModel.fromJson(v));
      });
    }
    total = json['total'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    return data;
  }
}

class ShopItemModel extends BaseResponseError {
  double? distance;
  String? unit;
  int? shopID;
  String? codeShop;
  String? nameShop;
  String? phoneShop;
  String? addressShop;
  int? status;
  String? imagesPaths;
  String? descriptionShop;
  double? discount;
  int? countMemberCode;
  bool? isFavorite;
  bool? isMember;
  int? countMemberLimit;
  bool? isShopManager;
  int? dayLimitBooking;

  ShopItemModel(
      {this.distance,
      this.unit,
      this.shopID,
      this.codeShop,
      this.nameShop,
      this.phoneShop,
      this.addressShop,
      this.status,
      this.imagesPaths,
      this.descriptionShop,
      this.countMemberCode,
      this.discount,
      this.isFavorite,
      this.isMember,
      this.countMemberLimit});

  copyWith({
    double? distance,
    String? unit,
    int? shopID,
    String? codeShop,
    String? nameShop,
    String? phoneShop,
    String? addressShop,
    int? status,
    String? imagesPaths,
    String? descriptionShop,
    double? discount,
    int? isUserMemberCode,
    int? countMemberCode,
    bool? isFavorite,
    bool? isMember,
    int? countMemberLimit,
  }) {
    return ShopItemModel(
      distance: distance ?? this.distance,
      unit: unit ?? this.unit,
      shopID: shopID ?? this.shopID,
      codeShop: codeShop ?? this.codeShop,
      nameShop: nameShop ?? this.nameShop,
      phoneShop: phoneShop ?? this.phoneShop,
      addressShop: addressShop ?? this.addressShop,
      status: status ?? this.status,
      imagesPaths: imagesPaths ?? this.imagesPaths,
      descriptionShop: descriptionShop ?? this.descriptionShop,
      discount: discount ?? this.discount,
      countMemberCode: countMemberCode ?? this.countMemberCode,
      isFavorite: isFavorite ?? this.isFavorite,
      isMember: isMember ?? this.isMember,
      countMemberLimit: countMemberLimit ?? this.countMemberLimit,
    );
  }

  ShopItemModel.fromJson(Map<String, dynamic> json) {
    distance = json['Distance'];
    unit = json['Unit'];
    shopID = json['ShopID'];
    codeShop = json['CodeShop'];
    nameShop = json['NameShop'];
    phoneShop = json['PhoneShop'];
    addressShop = json['AddressShop'];
    status = json['Status'];
    imagesPaths = json['ImagesPaths'];
    descriptionShop = json['DescriptionShop'];
    discount = json["Discount"];
    countMemberCode = json["CountMemberCode"];
    isFavorite = json["IsFavorite"];
    isMember = json["IsMember"];
    countMemberLimit = json["CountMemberLimit"];
    this.isShopManager = json["IsShopManager"];
    this.dayLimitBooking = json["DayLimitBooking"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Distance'] = this.distance;
    data['Unit'] = this.unit;
    data['ShopID'] = this.shopID;
    data['CodeShop'] = this.codeShop;
    data['NameShop'] = this.nameShop;
    data['PhoneShop'] = this.phoneShop;
    data['AddressShop'] = this.addressShop;
    data['Status'] = this.status;
    data['ImagesPaths'] = this.imagesPaths;
    data['DescriptionShop'] = this.descriptionShop;
    data['Discount'] = this.discount;
    data['CountMemberCode'] = this.countMemberCode;
    data['IsFavorite'] = this.isFavorite;
    data['IsMember'] = this.isMember;
    data['CountMemberLimit'] = this.countMemberLimit;
    return data;
  }
}
