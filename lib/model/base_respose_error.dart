import 'package:golf_uiv2/model/application_error.dart';

class BaseResponseError {
  ApplicationError? _error;

  setException(ApplicationError error) {
    _error = error;
  }

  ApplicationError? get getException {
    return _error;
  }

  BaseResponseError();
}
