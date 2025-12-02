// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_service_core.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _ApiClient implements ApiClient {
  _ApiClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'http://api.mujin24.com/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<String?> login(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/authorization/login',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> signUp(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/user/register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getShop(
    auth,
    longitude,
    latitude,
    keySearch,
    start,
    limit,
    userID,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'Longitude': longitude,
      r'Latitude': latitude,
      r'keySearch': keySearch,
      r'start': start,
      r'limit': limit,
      r'userID': userID,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/shop/get',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getShopDetail(
    auth,
    shopID,
    longitude,
    latitude,
    userID,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'shopID': shopID,
      r'Longitude': longitude,
      r'Latitude': latitude,
      r'userID': userID,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/shop/getshopdetailbyid',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getSlot(auth, shopID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'ShopID': shopID};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/slot/get',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getBlock(auth, slotID, timeBooking, dateTimeClient, userID, isVisa) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'SlotID': slotID,
      r'TimeBooking': timeBooking,
      r'DateTimeClient': dateTimeClient,
      r'UserID': userID,
      r'IsVisa': isVisa,

    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/block/get',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> createBooking(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/booking/insert',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getLstHistoryBooking(
    auth,
    userID,
    status,
    page,
    limit,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/booking/gethistorybooking/${userID}/${page}/${limit}/${status}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getHistoryBookingDetail(auth, userID, bookID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/booking/getbookingdetail/${userID}/${bookID}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getBookingQRCodeString(auth, userID, bookID, timeZone) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/booking/getstringqrcode/${userID}/${bookID}/${timeZone}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> uploadAvatar(auth, file) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': auth};
    _headers.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.files.add(
      MapEntry(
        'file',
        MultipartFile.fromFileSync(
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
        ),
      ),
    );
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(
              _dio.options,
              'api/avatar/upload',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> changePass(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/user/changepass',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> updateImagePath(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': auth};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(
              _dio.options,
              'api/user/imagepath/update',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getProfile(auth, userID, uUSerID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'UserID': userID,
      r'UUSerID': uUSerID,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/user/profile',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> updateProfile(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/user/update',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> updateBookingStatus(auth, bookId, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/booking/updatestatus/${bookId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> addPayment(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/booking/updatepayment',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getNotification(auth, userID, page, limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'userID': userID,
      r'page': page,
      r'limit': limit,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/notification/get',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> resetPassword(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/user/forgotpassword',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> veryfiveAccount(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/user/veryfiveaccount',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getUUserID(auth) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/user/getcodepop',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> clearNotification(auth, userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'userID': userID};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/notification/clearall',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getAllShopVipMember(auth, shopID, status, page, limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'shopID': shopID,
      r'status': status,
      r'page': page,
      r'limit': limit,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/codemember/getbyshopid',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getUserVipMember(auth, userID, status, page, limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'userID': userID,
      r'status': status,
      r'page': page,
      r'limit': limit,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/usercodemember/getbyuserid',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> registerVipMember(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/usercodemember/create',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> updateVipMemberAutoRenew(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/usercodemember/update/renew',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getPaymentKey(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/payment/create/paymentkey',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> addPaymentVipMember(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/paymentcodemember/create',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getTransactionHistory(
    auth,
    userID,
    dateFrom,
    dateEnd,
    page,
    limit,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'userID': userID,
      r'dateFrom': dateFrom,
      r'dateEnd': dateEnd,
      r'page': page,
      r'limit': limit,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/payment/gethistorybyuser',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getUserCards(auth, userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'userID': userID};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/usercodemember/getmycard',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> updateLanguage(auth, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/user/updatelanguage',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getListShopFavorite(auth, page, limit, userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'limit': limit,
      r'userID': userID,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/shopuser/get',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getConfigByKey(auth, keyConfig) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'keyConfig': keyConfig};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/config/getbykey',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> removeUser(auth, userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'userID': userID};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/user/disable',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> cardMpiCheckResult(auth, orderID,shopID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'orderID': orderID, r'shopID': shopID};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/payment/mpiResult',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> getGroupUserByEmail(email, auth) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'email': email};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/user/get-group-shop-by-email',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> changeFavorite(auth, shopID, userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'shopID': shopID,
      r'userID': userID,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'POST',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/shopuser/change',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
  
  @override
  Future<String?> getListCodeMemberPayment(String auth, int shopID, int userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'shopID': shopID,
      r'userID': userID,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json',
      r'Authorization': auth,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(
      _setStreamType<String>(
        Options(
              method: 'GET',
              headers: _headers,
              extra: _extra,
              contentType: 'application/json',
            )
            .compose(
              _dio.options,
              'api/usercodemember/get-list-code-member-payment',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    final value = _result.data;
    return value;
  }
}
