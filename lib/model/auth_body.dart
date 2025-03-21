import 'package:golf_uiv2/model/auth.dart';

class AuthBody<T> {
  T? _data;
  Auth? _auth;
  Map<String, dynamic>? Function(T? data)? _dataToJson;

  // AuthBody(this._auth, this._data,
  //     {@required Map<String, dynamic> Function(dynamic json) dataToJson}) {
  //   this._dataToJson = _dataToJson;
  // }

  setData(T data,
      {required Map<String, dynamic>? Function(T? data) dataToJson}) {
    this._data = data;
    this._dataToJson = dataToJson;
  }

  setAuth(Auth auth) {
    this._auth = auth;
  }

  Auth? get getAuth {
    return _auth;
  }

  T? get getData {
    return _data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> res = new Map<String, dynamic>();
    res['auth'] = this._auth?.toJson() ?? '';
    if (this._data != null && _dataToJson != null) {
      res['data'] = this._dataToJson!(this._data);
    }
    return res;
  }
}
