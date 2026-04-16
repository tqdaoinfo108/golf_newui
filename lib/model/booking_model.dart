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
  int? userCodeMemberID;
  BookingInsertItemModel(
    this.userCodeMemberID, {
    this.datePlay,
    this.slotID,
    this.shopID,
    this.blocks,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DatePlay'] = this.datePlay;
    data['SlotID'] = this.slotID;
    data['ShopID'] = this.shopID;
    data['Blocks'] = this.blocks;
    data['TimeZoneName'] = this.timeZoneName;
    data['UserCodeMemberID'] = userCodeMemberID;
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

class BookingCheckInsertResponseModel extends BaseResponseError {
  int? status;
  int? data;
  String? message;

  BookingCheckInsertResponseModel({this.status, this.data, this.message});

  BookingCheckInsertResponseModel.fromJson(Map<String, dynamic> json) {
    status = _asInt(json['status']);
    data = _asInt(json['data']);
    message = json['message']?.toString();
  }

  int get decisionStatus => status ?? data ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data1 = <String, dynamic>{};
    data1['status'] = status;
    data1['data'] = data;
    data1['message'] = message;
    return data1;
  }

  static int? _asInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    return int.tryParse(value.toString());
  }
}
