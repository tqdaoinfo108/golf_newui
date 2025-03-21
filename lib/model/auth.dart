import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';

class Auth {
  int? userID = SupportUtils.prefs.getInt(USER_ID);
  String? uUSerID = SupportUtils.prefs.getString(USERNAME);
  Auth();
  Auth.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    uUSerID = json['UUSerID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['UUSerID'] = this.uUSerID;
    return data;
  }
}
