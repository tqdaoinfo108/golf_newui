import 'package:golf_uiv2/model/application_error.dart';

class BaseResponse<T> {
  ApplicationError? _error;
  T? data;
  int? status;
  int? total;
  int? shopID;

  setException(ApplicationError error) {
    _error = error;
  }

  setData(T data) {
    this.data = data;
  }

  setTotal(int total) {
    this.total = total;
  }

  ApplicationError? get getException {
    return _error;
  }

  BaseResponse.fromJson(Map<String, dynamic> json,
      [T Function(dynamic json)? dataFromJson]) {
    if (dataFromJson == null) {
      data = json['data'];
    } else {
      var _tmp = json['data'];
      data = _tmp == null ? null : dataFromJson(_tmp);
    }
    status = json.containsKey('status') ? json['status'] : -100;
    shopID = json.containsKey('shopID') ? json['shopID'] : 0;
    total = json.containsKey('total')
        ? json['total']
        : json.containsKey('totals')
            ? json['totals']
            : -100;
  }
  BaseResponse();
}
