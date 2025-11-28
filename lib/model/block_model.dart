import 'package:golf_uiv2/model/base_respose_error.dart';
import 'package:golf_uiv2/utils/support.dart';

class BlockModel extends BaseResponseError {
  int? totals;
  List<BlockItemModel>? data;

  BlockModel({this.totals, this.data});

  BlockModel.fromJson(Map<String, dynamic> json) {
    totals = json['totals'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new BlockItemModel.fromJson(v));
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

class BlockItemModel {
  int? blockID;
  String? codeBlock;
  String? nameBlock;
  String? descriptionBlock;
  double? rangeStart;
  double? rangeEnd;
  bool? isActive;
  bool isSelect = false;
  bool isBooking = false;

  String getNameBlock() {
    return rangeStart!.toInt().toStringFormatHoursUTC() +
        " - " +
        rangeEnd!.toInt().toStringFormatHoursUTC();
  }

  BlockItemModel(
      {this.blockID,
      this.codeBlock,
      this.nameBlock,
      this.descriptionBlock,
      this.isActive});

  BlockItemModel.fromJson(Map<String, dynamic> json) {
    blockID = json['BlockID'];
    codeBlock = json['CodeBlock'];
    nameBlock = json['NameBlock'];
    descriptionBlock = json['DescriptionBlock'];
    isActive = json['IsActive'];
    rangeStart = (json['RangeStart']) * 1000;
    rangeEnd = (json['RangeEnd']) * 1000;
    isBooking = json["IsBooking"] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BlockID'] = this.blockID;
    data['CodeBlock'] = this.codeBlock;
    data['NameBlock'] = this.nameBlock;
    data['DescriptionBlock'] = this.descriptionBlock;
    data['IsActive'] = this.isActive;
    return data;
  }
}
