import 'package:golf_uiv2/model/base_respose_error.dart';

class NotificationModel extends BaseResponseError {
  int? total;
  List<NotificationItemModel>? data;

  NotificationModel({this.total, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new NotificationItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationItemModel {
  int? notificationID;
  int? typeID;
  int? iD;
  String? title;
  String? message;
  int? createdDate;
  String? userCreated;
  bool? isRead;
  int? readDate;

  NotificationItemModel(
      {this.notificationID,
      this.typeID,
      this.iD,
      this.title,
      this.message,
      this.createdDate,
      this.userCreated,
      this.isRead,
      this.readDate});

  NotificationItemModel.fromJson(Map<String, dynamic> json) {
    notificationID = json['NotificationID'];
    typeID = json['TypeID'];
    iD = json['ID'];
    title = json['Title'];
    message = json['Message'];
    createdDate = _toInt(json['CreatedDate']);
    userCreated = json['UserCreated'];
    isRead = _toBool(json['IsRead']);
    readDate = _toInt(json['ReadDate']);
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }

  bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    final raw = value.toString().toLowerCase();
    return raw == '1' || raw == 'true';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NotificationID'] = this.notificationID;
    data['TypeID'] = this.typeID;
    data['ID'] = this.iD;
    data['Title'] = this.title;
    data['Message'] = this.message;
    data['CreatedDate'] = this.createdDate;
    data['UserCreated'] = this.userCreated;
    data['IsRead'] = this.isRead;
    data['ReadDate'] = this.readDate;
    return data;
  }
}
