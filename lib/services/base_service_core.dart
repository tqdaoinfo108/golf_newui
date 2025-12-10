import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:golf_uiv2/utils/constants.dart';

import '../utils/keys.dart';
import '../utils/support.dart';

class ApiClient {
  final Dio _dio;
  static const String _baseUrl = GOLF_CORE_API_URL;

  ApiClient(Dio dio) : _dio = dio {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      receiveTimeout: Duration(seconds: API_RECEIVE_RESPONSE_TIMEOUT),
      connectTimeout: Duration(seconds: API_CONNECT_TIMEOUT),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // Helper to convert response to JSON string
  String? _toJsonString(dynamic data) {
    if (data == null) return null;
    if (data is String) return data;
    if (data is Response) return _toJsonString(data.data);
    return jsonEncode(data);
  }

  // Base methods
  Future<String?> _get(
    String endpoint, {
    required Map<String, dynamic> queryParameters,
    required String auth,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: {'Authorization': auth}),
      );
      log(
        "$endpoint \n${jsonEncode(auth)} \n${jsonEncode(queryParameters)} \n${jsonEncode(response.data)}",
      );
      return _toJsonString(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _post(
    String endpoint, {
    required Map<String, dynamic> body,
    required String auth,
  }) async {
    try {
       log(
        "$endpoint \n${jsonEncode(auth)} \n${jsonEncode(body)}}",
      );
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(headers: {'Authorization': auth}),
      );

      log(
        "\n${jsonEncode(response.data)}",
      );

      return _toJsonString(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Auth
  Future<String?> login(String auth, Map<String, dynamic> body) =>
      _post('api/authorization/login', body: body, auth: auth);

  Future<String?> signUp(String auth, Map<String, dynamic> body) =>
      _post('api/user/register', body: body, auth: auth);

  // Shop
  Future<String?> getShop(
    String auth,
    double? longitude,
    double? latitude,
    String keySearch,
    int start,
    int limit,
    int? userID,
  ) => _get(
    'api/shop/get',
    queryParameters: {
      'Longitude': longitude,
      'Latitude': latitude,
      'keySearch': keySearch,
      'start': start,
      'limit': limit,
      'userID': userID,
    },
    auth: auth,
  );

  Future<String?> getShopDetail(
    String auth,
    int? shopID,
    double longitude,
    double latitude,
    int? userID,
  ) => _get(
    'api/shop/getshopdetailbyid',
    queryParameters: {
      'shopID': shopID,
      'Longitude': longitude,
      'Latitude': latitude,
      'userID': userID,
    },
    auth: auth,
  );

  // Slot & Block
  Future<String?> getSlot(String auth, int? shopID) =>
      _get('api/slot/get', queryParameters: {'ShopID': shopID}, auth: auth);

  Future<String?> getBlock(
    String auth,
    int? slotID,
    int? timeBooking,
    String dateTimeClient,
    int userID,
    int userCodeMemberID,
  ) => _get(
    'api/block/get',
    queryParameters: {
      'SlotID': slotID,
      'TimeBooking': timeBooking,
      'DateTimeClient': dateTimeClient,
      'UserID': userID,
      'userCodeMemberID': userCodeMemberID,
    },
    auth: auth,
  );

  // Booking
  Future<String?> createBooking(String auth, Map<String, dynamic> body) =>
      _post('api/booking/insert', body: body, auth: auth);

  Future<String?> getLstHistoryBooking(
    String auth,
    int? userID,
    int status,
    int page,
    int limit,
  ) => _get(
    'api/booking/gethistorybooking/$userID/$page/$limit/$status',
    queryParameters: {},
    auth: auth,
  );

  Future<String?> getHistoryBookingDetail(
    String auth,
    int? userID,
    int? bookID,
  ) => _get(
    'api/booking/getbookingdetail/$userID/$bookID',
    queryParameters: {},
    auth: auth,
  );

  Future<String?> getBookingQRCodeString(
    String auth,
    int? userID,
    int? bookID,
    String timeZone,
  ) => _get(
    'api/booking/getstringqrcode/$userID/$bookID/$timeZone',
    queryParameters: {},
    auth: auth,
  );

  Future<String?> updateBookingStatus(
    String auth,
    int? bookId,
    Map<String, dynamic> body,
  ) => _post('api/booking/updatestatus/$bookId', body: body, auth: auth);

  // Payment
  Future<String?> addPayment(String auth, Map<String, dynamic> body) =>
      _post('api/booking/updatepayment', body: body, auth: auth);

  Future<String?> getTransactionHistory(
    String auth,
    int? userID,
    int dateFrom,
    int dateEnd,
    int? page,
    int? limit,
  ) => _get(
    'api/payment/gethistorybyuser',
    queryParameters: {
      'userID': userID,
      'dateFrom': dateFrom,
      'dateEnd': dateEnd,
      'page': page,
      'limit': limit,
    },
    auth: auth,
  );

  Future<String?> getPaymentKey(String auth, Map<String, dynamic> body) =>
      _post('api/payment/create/paymentkey', body: body, auth: auth);

  Future<String?> addPaymentVipMember(String auth, Map<String, dynamic> body) =>
      _post('api/paymentcodemember/create', body: body, auth: auth);

  Future<String?> cardMpiCheckResult(String auth, String orderID, int shopID) =>
      _get(
        'api/payment/mpiResult',
        queryParameters: {'orderID': orderID, 'shopID': shopID},
        auth: auth,
      );

  // Notification
  Future<String?> getNotification(
    String auth,
    int? userID,
    int page,
    int limit,
  ) => _get(
    'api/notification/get',
    queryParameters: {'userID': userID, 'page': page, 'limit': limit},
    auth: auth,
  );

  Future<String?> clearNotification(String auth, int? userID) => _get(
    'api/notification/clearall',
    queryParameters: {'userID': userID},
    auth: auth,
  );

  // User Profile
  Future<String?> getProfile(String auth, int? userID, String? uUSerID) => _get(
    'api/user/profile',
    queryParameters: {'UserID': userID, 'UUSerID': uUSerID},
    auth: auth,
  );

  Future<String?> updateProfile(String auth, Map<String, dynamic> body) =>
      _post('api/user/update', body: body, auth: auth);

  Future<String?> changePass(String auth, Map<String, dynamic> body) =>
      _post('api/user/changepass', body: body, auth: auth);

  Future<String?> updateImagePath(String auth, Map<String, dynamic> body) =>
      _post('api/user/imagepath/update', body: body, auth: auth);

  Future<String?> resetPassword(String auth, Map<String, dynamic> body) =>
      _post('api/user/forgotpassword', body: body, auth: auth);

  Future<String?> veryfiveAccount(String auth, Map<String, dynamic> body) =>
      _post('api/user/veryfiveaccount', body: body, auth: auth);

  Future<String?> updateLanguage(String auth, Map<String, dynamic> body) =>
      _post('api/user/updatelanguage', body: body, auth: auth);

  Future<String?> removeUser(String auth, int userID) =>
      _get('api/user/disable', queryParameters: {'userID': userID}, auth: auth);

  Future<String?> getUUserID(String auth) =>
      _get('api/user/getcodepop', queryParameters: {}, auth: auth);

  Future<String?> getGroupUserByEmail(String auth, String email) => _get(
    'api/user/get-group-shop-by-email',
    queryParameters: {'email': email},
    auth: auth,
  );

  // VIP Member
  Future<String?> getAllShopVipMember(
    String auth,
    int? shopID,
    int status,
    int? page,
    int? limit,
  ) => _get(
    'api/codemember/getbyshopid',
    queryParameters: {
      'shopID': shopID,
      'status': status,
      'page': page,
      'limit': limit,
      'userID': SupportUtils.prefs.getInt(USER_ID),
    },
    auth: auth,
  );

  Future<String?> getUserVipMember(
    String auth,
    int userID,
    int status,
    int page,
    int limit,
  ) => _get(
    'api/usercodemember/getbyuserid',
    queryParameters: {
      'userID': userID,
      'status': status,
      'page': page,
      'limit': limit,
    },
    auth: auth,
  );

  Future<String?> registerVipMember(String auth, Map<String, dynamic> body) =>
      _post('api/usercodemember/create', body: body, auth: auth);

  Future<String?> updateVipMemberAutoRenew(
    String auth,
    Map<String, dynamic> body,
  ) => _post('api/usercodemember/update/renew', body: body, auth: auth);

  Future<String?> cancelVipMember(String auth, Map<String, dynamic> body) =>
      _post('api/usercodemember/cancel', body: body, auth: auth);

  Future<String?> getUserCards(String auth, int? userID) => _get(
    'api/usercodemember/getmycard',
    queryParameters: {'userID': userID},
    auth: auth,
  );

  Future<String?> getListCodeMemberPayment(
    String auth,
    int shopID,
    int userID,
    int datePlay,
  ) => _get(
    'api/usercodemember/get-list-code-member-payment',
    queryParameters: {'shopID': shopID, 'userID': userID, 'datePlay': datePlay},
    auth: auth,
  );

  // Shop Favorite
  Future<String?> getListShopFavorite(
    String auth,
    int? page,
    int? limit,
    int? userID,
  ) => _get(
    'api/shopuser/get',
    queryParameters: {'page': page, 'limit': limit, 'userID': userID},
    auth: auth,
  );

  Future<String?> changeFavorite(String auth, int? shopID, int? userID) =>
      _post(
        'api/shopuser/change',
        body: {'shopID': shopID, 'userID': userID},
        auth: auth,
      );

  // Config
  Future<String?> getConfigByKey(String auth, String key) => _get(
    'api/config/getbykey',
    queryParameters: {'keyConfig': key},
    auth: auth,
  );

  // Avatar
  Future<String?> uploadAvatar(String auth, File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
        ),
      });
      final response = await _dio.post(
        'api/avatar/upload',
        data: formData,
        options: Options(headers: {'Authorization': auth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
