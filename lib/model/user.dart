import 'package:golf_uiv2/model/base_respose_error.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import '../utils/keys.dart';
import 'auth.dart';

class User extends BaseResponseError {
  int? userID;
  String? imagesPaths;
  int? typeUserID;
  String? uUserID;
  String? fullName;
  String? email;
  String? phone;
  String? password;
  String? provider;
  String? providerUserID;
  int? confirmEmail;
  SocialNetwork? socialNetwork;
  String? languageCode;
  List<String>? lstShopID;
  // update v4
  List<ListShopManager>? listShopManager;

  get isUserManager => SupportUtils.prefs.getBool(IS_SHOP_MANAGER);

  User({
    this.userID,
    this.imagesPaths,
    this.typeUserID,
    this.uUserID,
    this.fullName,
    this.email,
    this.phone,
    this.password,
    this.provider,
    this.providerUserID,
    this.socialNetwork,
    this.confirmEmail,
    this.languageCode,
    this.lstShopID,
  });

  User.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    imagesPaths = json['ImagesPaths'];
    typeUserID = json['TypeUserID'];
    uUserID = json['UUserID'];
    fullName = json['FullName'];
    email = json['Email'];
    phone = json['Phone'];
    provider = json['Provider'];
    providerUserID = json['ProviderUserID'];
    confirmEmail = json['ConfirmEmail'];
    languageCode = json['LanguageCode'];

    // Parse lstShopID safely
    if (json['lstShopID'] != null) {
      try {
        if (json['lstShopID'] is List) {
          lstShopID =
              (json['lstShopID'] as List)
                  .map((e) => e?.toString() ?? '')
                  .where((s) => s.isNotEmpty)
                  .toList();
        } else if (json['lstShopID'] is String) {
          lstShopID = [json['lstShopID'] as String];
        }
      } catch (e) {
        print('Error parsing lstShopID: $e');
        lstShopID = null;
      }
    } else {
      lstShopID = null;
    }

    this.listShopManager =
        json["listShopManager"] == null
            ? null
            : (json["listShopManager"] as List)
                .map((e) => ListShopManager.fromJson(e))
                .toList();

    SupportUtils.prefs.setBool(
      IS_SHOP_MANAGER,
      (listShopManager ?? []).isNotEmpty,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['ImagesPaths'] = this.imagesPaths;
    data['TypeUserID'] = this.typeUserID;
    data['UUserID'] = this.uUserID;
    data['FullName'] = this.fullName;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Provider'] = this.provider;
    data['ProviderUserID'] = this.providerUserID;
    data['ConfirmEmail'] = this.confirmEmail;
    data['LanguageCode'] = this.languageCode;
    return data;
  }
}

class UserUpdatePathModel {
  Auth auth;
  UserUpdatePath data;

  UserUpdatePathModel(this.auth, this.data);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth'] = this.auth.toJson();
    data['data'] = this.data.toJson();
    return data;
  }
}

class UserUpdatePath {
  String? imagesPaths;

  UserUpdatePath({this.imagesPaths});

  UserUpdatePath.fromJson(Map<String, dynamic> json) {
    imagesPaths = json['ImagesPaths'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ImagesPaths'] = this.imagesPaths;
    return data;
  }
}

class UserUpdateProfileModel {
  Auth auth;
  UserUpdateProfile data;

  UserUpdateProfileModel(this.auth, this.data);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth'] = this.auth.toJson();
    data['data'] = this.data.toJson();
    return data;
  }
}

class UserUpdateProfile {
  String? fullName;
  String? email;
  String? phone;

  UserUpdateProfile({this.fullName, this.email, this.phone});

  UserUpdateProfile.fromJson(Map<String, dynamic> json) {
    fullName = json['FullName'];
    email = json['Email'];
    phone = json['Phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FullName'] = this.fullName;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    return data;
  }
}

class UserUpdateLanguageModel {
  Auth auth;
  String data;

  UserUpdateLanguageModel(this.auth, this.data);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth'] = this.auth.toJson();
    data['data'] = this.data;
    return data;
  }
}

class ListShopManager {
  int? shopId;
  String? codeShop;
  String? nameShop;

  ListShopManager({this.shopId, this.codeShop, this.nameShop});

  ListShopManager.fromJson(Map<String, dynamic> json) {
    this.shopId = json["ShopID"];
    this.codeShop = json["CodeShop"];
    this.nameShop = json["NameShop"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ShopID"] = this.shopId;
    data["CodeShop"] = this.codeShop;
    data["NameShop"] = this.nameShop;
    return data;
  }
}
// class UserModel {
//   int status;
//   User data;
//   ApplicationError _error;

//   setException(ApplicationError error) {
//     _error = error;
//   }

//   ApplicationError get getException {
//     return _error;
//   }

//   UserModel({this.status, this.data});

//   UserModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = json['data'] != null ? new User.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data.toJson();
//     }
//     return data;
//   }
// }
