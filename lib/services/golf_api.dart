import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' hide Headers;
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/auth.dart';
import 'package:golf_uiv2/model/auth_body.dart';
import 'package:golf_uiv2/model/base_respose.dart';
import 'package:golf_uiv2/model/block_model.dart';
import 'package:golf_uiv2/model/booking.dart';
import 'package:golf_uiv2/model/booking_model.dart';
import 'package:golf_uiv2/model/group_model.dart';
import 'package:golf_uiv2/model/notification.dart';
import 'package:golf_uiv2/model/payment_key_response.dart';
import 'package:golf_uiv2/model/shop_model.dart';
import 'package:golf_uiv2/model/shop_vip_memeber.dart';
import 'package:golf_uiv2/model/slot_model.dart';
import 'package:golf_uiv2/model/transaction.dart';
import 'package:golf_uiv2/model/user.dart';
import 'package:golf_uiv2/model/user_vip_member.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'base_service_core.dart';

class GolfApi {
  late Dio dio;
  late ApiClient apiClient;
  // String defaultAuthentication =
  //     "Basic ${base64Url.encode(utf8.encode("${SupportUtils.prefs.getString(USERNAME)}:${1633842000000}"))}";
  String defaultAuthentication = "Basic ${SupportUtils.prefs.getString(AUTH)}";
  String basicAuthentication = "Basic $GOLF_CORE_API_AUTHORIZE";

  GolfApi() {
    dio = new Dio();
    apiClient = new ApiClient(dio);
  }

  Future<BaseResponse<User?>> login(
    String username,
    String password,
    String lastTimeLogin,
  ) async {
    String? response;

    try {
      response = await apiClient.login(basicAuthentication, {
        'UUserID': username,
        'PassWord': password,
        'LastLogin': lastTimeLogin,
      });

      return BaseResponse<User?>.fromJson(
        jsonDecode(response!),
        (json) => User.fromJson(json),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<User?>> signUp(
    User userInfo,
    String lastTimeLogin,
    String languageCode,
  ) async {
    String? response;
    try {
      response = await apiClient.signUp(basicAuthentication, {
        'UUserID': userInfo.uUserID,
        'Email': userInfo.email,
        'FullName': userInfo.fullName,
        'PassWord': userInfo.password,
        'Provider': userInfo.provider,
        'ProviderUserID': userInfo.providerUserID,
        'LastLogin': lastTimeLogin,
        'LanguageCode': languageCode,
      });

      return BaseResponse<User>.fromJson(
        jsonDecode(response!),
        (json) => User.fromJson(json),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<ShopModel?> getShop(
    double? log,
    double? lat,
    int countList,
    String keySearch,
    int? uerId,
  ) async {
    try {
      var response = await apiClient.getShop(
        defaultAuthentication,
        log,
        lat,
        keySearch,
        0,
        100,
        uerId,
      );
      print(response);
      return ShopModel.fromJson(jsonDecode(response ?? ""));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ShopModel()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<ShopItemModel?> getShopDetail(int? shopId, int? uerId) async {
    try {
      var response = await apiClient.getShopDetail(
        defaultAuthentication,
        shopId,
        0,
        0,
        uerId,
      );

      print(response);
      return ShopItemModel.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ShopItemModel()
        ..setException(ApplicationError.withDioError(error));
    }
  }

  Future<SlotModel?> getSlot(int? shopID) async {
    try {
      var response = await apiClient.getSlot(defaultAuthentication, shopID);
      return SlotModel.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return SlotModel()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BlockModel?> getBlock(
    int? slotID,
    int? time,
    String dateTimeClient,
    int userID,
    int userCodeMemberID 
  ) async {
    try {
      var response = await apiClient.getBlock(
        defaultAuthentication,
        slotID,
        time,
        dateTimeClient,
        userID,
        userCodeMemberID 
      );
      return BlockModel.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BlockModel()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BookingResponeModel?> createBooking(
    Map<String, dynamic> jsonBody,
  ) async {
    try {
      var response = await apiClient.createBooking(
        defaultAuthentication,
        jsonBody,
      );
      return BookingResponeModel.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BookingResponeModel()
        ..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<List<Booking>?>> getLstHistoryBooking(
    int? userID,
    int status,
    int page,
    int limit,
  ) async {
    String? response;
    try {
      response = await apiClient.getLstHistoryBooking(
        defaultAuthentication,
        userID,
        status,
        page,
        limit,
      );

      return BaseResponse<List<Booking>>.fromJson(
        jsonDecode(response!),
        (json) =>
            (json as List<dynamic>)
                .map<Booking>(
                  (i) => Booking.fromJson(i as Map<String, dynamic>),
                )
                .toList(),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<Booking?> getHistoryBookingDetail(int? userID, int? bookID) async {
    String? response;
    try {
      response = await apiClient.getHistoryBookingDetail(
        defaultAuthentication,
        userID,
        bookID,
      );

      return Booking.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return Booking()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<String?>> getBookingQRCodeString(
    int? userID,
    int? bookID,
  ) async {
    String? response;
    try {
      response = await apiClient.getBookingQRCodeString(
        defaultAuthentication,
        userID,
        bookID,
        SupportUtils.getTimeZoneNameID(),
      );

      return BaseResponse<String>()..data = response;
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<String>?> uploadAvartar(File file) async {
    String? response;
    try {
      response = await apiClient.uploadAvatar(defaultAuthentication, file);

      return BaseResponse<String>()..data = jsonDecode(response!)['data'];
    } on DioError catch (error, stacktrace) {
      print(
        "Exception occured: ${error.response!.statusMessage} stackTrace: $stacktrace",
      );
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<User> updateImagePath(String? imagePath) async {
    String? response;
    try {
      var boody =
          UserUpdatePathModel(
            new Auth(),
            new UserUpdatePath(imagesPaths: imagePath),
          ).toJson();
      response = await apiClient.updateImagePath(defaultAuthentication, boody);
      return User.fromJson(jsonDecode(response!)['data']);
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return User()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<User?>> updateProfile(
    String fullName,
    String phone,
    String email,
  ) async {
    String? response;
    try {
      var boody =
          UserUpdateProfileModel(
            new Auth(),
            new UserUpdateProfile(
              fullName: fullName,
              phone: phone,
              email: email,
            ),
          ).toJson();
      response = await apiClient.updateProfile(defaultAuthentication, boody);

      return BaseResponse<User>.fromJson(
        jsonDecode(response!),
        (json) => User.fromJson(json),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<String?>> updateBookingStatus(
    int? bookId,
    int status,
  ) async {
    String? response;
    try {
      response = await apiClient.updateBookingStatus(
        defaultAuthentication,
        bookId,
        {'status': status},
      );

      return BaseResponse<String?>()..setData(response);
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<int?>> addPayment(AuthBody body) async {
    String? response;
    try {
      response = await apiClient.addPayment(
        defaultAuthentication,
        body.toJson(),
      );

      return BaseResponse<int>.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<NotificationModel?> getNotification(
    int? user,
    int page,
    int limit,
  ) async {
    String? response;
    try {
      response = await apiClient.getNotification(
        defaultAuthentication,
        user,
        page,
        limit,
      );

      return NotificationModel.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return NotificationModel()
        ..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<User?>> getUserInfo() async {
    String? response;

    var _userId = SupportUtils.prefs.getInt(USER_ID);
    var _userName = SupportUtils.prefs.getString(USERNAME);
    try {
      response = await apiClient.getProfile(
        defaultAuthentication,
        _userId,
        _userName,
      );

      return BaseResponse.fromJson(
        jsonDecode(response!),
        (json) => User.fromJson(json),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<bool>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    String? response;
    var _body =
        AuthBody<Map<String, dynamic>>()
          ..setAuth(Auth())
          ..setData({
            'PassWordOld': oldPassword,
            'PassWordNew': newPassword,
          }, dataToJson: (data) => data);
    try {
      response = await apiClient.changePass(
        defaultAuthentication,
        _body.toJson(),
      );

      return BaseResponse<bool>.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<User?>> resetPassword(
    String email,
    String languageCode,
    int groupShopID,
  ) async {
    String? response;
    try {
      response = await apiClient.resetPassword(basicAuthentication, {
        'email': email,
        'languageCode': languageCode,
        'GroupShopID': groupShopID,
      });

      return BaseResponse<User>.fromJson(
        jsonDecode(response!),
        (json) => User.fromJson(json),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<User?>> verifyAccount(
    String? email,
    String languageCode,
  ) async {
    String? response;
    try {
      response = await apiClient.veryfiveAccount(defaultAuthentication, {
        'email': email,
        'languageCode': languageCode,
      });

      return BaseResponse<User>.fromJson(
        jsonDecode(response!),
        (json) => User.fromJson(json),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<String?>> getUUserID() async {
    String? response;
    try {
      response = await apiClient.getUUserID(basicAuthentication);

      return BaseResponse<String>.fromJson(
        jsonDecode(response!),
        (json) => json,
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<String?>> clearNotification(int? userID) async {
    String? response;
    try {
      response = await apiClient.clearNotification(
        defaultAuthentication,
        userID,
      );

      return BaseResponse()..setData(response);
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<List<ShopVipMember>>?> getAllShopVipMember(
    int? shopId,
    int? page,
    int? limit,
  ) async {
    String? response;
    try {
      response = await apiClient.getAllShopVipMember(
        defaultAuthentication,
        shopId,
        1,
        page,
        limit,
      );

      return BaseResponse.fromJson(
        jsonDecode(response!),
        (json) => List<ShopVipMember>.from(
          json.map((item) => ShopVipMember.fromJson(item)),
        ),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<List<UserVipMember>>?> getUserVipMember(
    int? userId,
  ) async {
    String? response;
    try {
      response = await apiClient.getUserCards(defaultAuthentication, userId);
      final _data = userVipMemberFromJson(response!);
      return BaseResponse()
        ..setData(_data)
        ..setTotal(_data.length);
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<UserVipMember?>> registerVipMember(AuthBody body) async {
    String? response;
    try {
      response = await apiClient.registerVipMember(
        defaultAuthentication,
        body.toJson(),
      );

      return BaseResponse<UserVipMember>.fromJson(
        jsonDecode(response!),
        (json) => UserVipMember.fromJson(json),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<bool>> updateVipMemberAutoRenew(AuthBody body) async {
    String? response;
    try {
      response = await apiClient.updateVipMemberAutoRenew(
        defaultAuthentication,
        body.toJson(),
      );

      return BaseResponse<bool>.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<bool>> cancelVipMember(AuthBody body) async {
    String? response;
    try {
      response = await apiClient.cancelVipMember(
        defaultAuthentication,
        body.toJson(),
      );

      return BaseResponse<bool>.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<PaymentKeyResponse?>> getPaymentKey(AuthBody body) async {
    String? response;
    try {
      response = await apiClient.getPaymentKey(
        defaultAuthentication,
        body.toJson(),
      );

      return BaseResponse<PaymentKeyResponse>.fromJson(
        jsonDecode(response!),
        (json) => PaymentKeyResponse.fromJson(json),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<UserVipMember?>> addPaymentVipMember(
    AuthBody body,
  ) async {
    String? response;
    try {
      response = await apiClient.addPaymentVipMember(
        defaultAuthentication,
        body.toJson(),
      );

      return BaseResponse<UserVipMember>.fromJson(
        jsonDecode(response!),
        (json) => UserVipMember.fromJson(json),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<List<Transaction>>?> getTransactionHistory(
    int? userId,
    int? page,
    int? limit,
    int dateFrom,
    int dateEnd,
  ) async {
    String? response;
    try {
      response = await apiClient.getTransactionHistory(
        defaultAuthentication,
        userId,
        dateFrom,
        dateEnd,
        page,
        limit,
      );

      return BaseResponse.fromJson(
        jsonDecode(response!),
        (json) => List<Transaction>.from(
          json.map((item) => Transaction.fromJson(item)),
        ),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<bool>> updateLanguage(String lang) async {
    String? response;
    try {
      var boody = UserUpdateLanguageModel(new Auth(), lang).toJson();
      response = await apiClient.updateLanguage(defaultAuthentication, boody);

      return BaseResponse<bool>.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<ShopModel> getListShopFavorite(
    int? page,
    int? limit,
    int? uerId,
  ) async {
    try {
      var response = await apiClient.getListShopFavorite(
        defaultAuthentication,
        page,
        limit,
        uerId,
      );

      return ShopModel.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ShopModel()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<bool>> changeFavorite(int? shopId, int? uerId) async {
    String? response;
    try {
      response = await apiClient.changeFavorite(
        defaultAuthentication,
        shopId,
        uerId,
      );

      return BaseResponse<bool>()..data = jsonDecode(response!)['data'];
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<String>> getKeyConfigByKey(String keyConfig) async {
    try {
      var response = await apiClient.getConfigByKey(
        basicAuthentication,
        keyConfig,
      );

      return BaseResponse.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<bool>> removeUser(int userID) async {
    try {
      var response = await apiClient.removeUser(basicAuthentication, userID);

      return BaseResponse.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<bool>> cardMpiCheckResult(String orderID, int shopID) async {
    try {
      var response = await apiClient.cardMpiCheckResult(
        basicAuthentication,
        orderID,shopID
      );

      return BaseResponse.fromJson(jsonDecode(response!));
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<List<GroupModel>>> getGroupUserByEmail(
    String email,
  ) async {
    try {
      var response = await apiClient.getGroupUserByEmail(
        email,
        basicAuthentication,
      );

      return BaseResponse<List<GroupModel>>.fromJson(
        jsonDecode(response!),
        (json) =>
            (json as List<dynamic>)
                .map<GroupModel>(
                  (i) => GroupModel.fromJson(i as Map<String, dynamic>),
                )
                .toList(),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }

  Future<BaseResponse<List<UserVipMember>>> getListMemberPayment(
    int shopID,
    int userID,
    int datePlay
  ) async {
    try {
      var response = await apiClient.getListCodeMemberPayment(
        defaultAuthentication,
        shopID,
        userID,
        datePlay
      );

      return BaseResponse<List<UserVipMember>>.fromJson(
        jsonDecode(response!),
        (json) =>
            (json as List<dynamic>)
                .map<UserVipMember>(
                  (i) => UserVipMember.fromJson(i as Map<String, dynamic>),
                )
                .toList(),
      );
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseResponse()..setException(ApplicationError.withDioError(error));
    }
  }
}
