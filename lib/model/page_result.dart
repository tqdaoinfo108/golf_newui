import 'package:golf_uiv2/utils/constants.dart';

class PageResult<T> {
  PageResultCode resultCode;
  T? data;

  PageResult({required this.resultCode, this.data});
}
