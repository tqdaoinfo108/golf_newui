class GroupModel {
  int? groupShopID;
  String? codeInvite;
  String? nameGroupShop;
  String? nameUUserIDJP;

  GroupModel({
    this.groupShopID,
    this.codeInvite,
    this.nameGroupShop,
    this.nameUUserIDJP,
  });

  GroupModel.fromJson(Map<String, dynamic> json) {
    groupShopID = json['GroupShopID'];
    codeInvite = json['CodeInvite'];
    nameGroupShop = json['NameGroupShop'];
    nameUUserIDJP = json['NameUUserIDJP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GroupShopID'] = this.groupShopID;
    data['CodeInvite'] = this.codeInvite;
    data['NameGroupShop'] = this.nameGroupShop;
    data['NameUUserIDJP'] = this.nameUUserIDJP;
    return data;
  }
}
