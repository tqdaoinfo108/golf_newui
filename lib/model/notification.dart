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

  NotificationItemModel(
      {this.notificationID,
      this.typeID,
      this.iD,
      this.title,
      this.message,
      this.createdDate,
      this.userCreated});

  NotificationItemModel.fromJson(Map<String, dynamic> json) {
    notificationID = json['NotificationID'];
    typeID = json['TypeID'];
    iD = json['ID'];
    title = json['Title'];
    message = json['Message'];
    createdDate = json['CreatedDate'];
    userCreated = json['UserCreated'];
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
    return data;
  }
}
