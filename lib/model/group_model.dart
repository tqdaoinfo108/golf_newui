class GroupModel {
  int? groupShopID;
  // String? codeInvite;
  String? nameGroupShop;

  GroupModel({this.groupShopID, this.nameGroupShop});

  GroupModel.fromJson(Map<String, dynamic> json) {
    groupShopID = json['GroupShopID'];
    // codeInvite = json['CodeInvite'];
    nameGroupShop = json['NameGroupShop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GroupShopID'] = this.groupShopID;
    // data['CodeInvite'] = this.codeInvite;
    data['NameGroupShop'] = this.nameGroupShop;
    return data;
  }
}
