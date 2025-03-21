import 'package:golf_uiv2/model/base_respose_error.dart';

class SlotModel extends BaseResponseError {
  int? totals;
  List<SlotItemModel>? data;

  SlotModel({this.totals, this.data});

  SlotModel.fromJson(Map<String, dynamic> json) {
    totals = json['totals'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new SlotItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totals'] = this.totals;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotItemModel {
  int? slotID;
  String? codeSlot;
  String? nameSlot;
  String? descriptionSlot;
  bool isSelect = false;

  SlotItemModel(
      {this.slotID, this.codeSlot, this.nameSlot, this.descriptionSlot});

  SlotItemModel.fromJson(Map<String, dynamic> json) {
    slotID = json['SlotID'];
    codeSlot = json['CodeSlot'];
    nameSlot = json['NameSlot'];
    descriptionSlot = json['DescriptionSlot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SlotID'] = this.slotID;
    data['CodeSlot'] = this.codeSlot;
    data['NameSlot'] = this.nameSlot;
    data['DescriptionSlot'] = this.descriptionSlot;
    return data;
  }
}
