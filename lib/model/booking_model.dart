import 'package:golf_uiv2/model/base_respose_error.dart';

import 'auth.dart';

class BookingInsertModel {
  Auth auth;
  BookingInsertItemModel data;

  BookingInsertModel(this.auth, this.data);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth'] = this.auth.toJson();
    data['data'] = this.data.toJson();
    return data;
  }
}

class BookingInsertItemModel {
  int? datePlay;
  int? slotID;
  int? shopID;
  String? timeZoneName;
  List<int?>? blocks;

  BookingInsertItemModel(
      {this.datePlay, this.slotID, this.shopID, this.blocks});

  BookingInsertItemModel.fromJson(Map<String, dynamic> json) {
    datePlay = json['DatePlay'];
    slotID = json['SlotID'];
    shopID = json['ShopID'];
    blocks = json['Blocks'].cast<int>();
    timeZoneName = json['TimeZoneName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DatePlay'] = this.datePlay;
    data['SlotID'] = this.slotID;
    data['ShopID'] = this.shopID;
    data['Blocks'] = this.blocks;
    data['TimeZoneName'] = this.timeZoneName;
    return data;
  }
}

class BookingResponeModel extends BaseResponseError {
  int? data;

  BookingResponeModel({this.data});

  BookingResponeModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data1 = new Map<String, dynamic>();
    data1['data'] = this.data;
    return data1;
  }
}
