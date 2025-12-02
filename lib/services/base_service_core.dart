import 'dart:io';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:golf_uiv2/utils/constants.dart';
part 'base_service_core.g.dart';

@RestApi(baseUrl: GOLF_CORE_API_URL)
abstract class ApiClient {
  factory ApiClient(Dio dio) {
    dio.options = BaseOptions(
      receiveTimeout: Duration(seconds: API_RECEIVE_RESPONSE_TIMEOUT),
      connectTimeout: Duration(seconds: API_CONNECT_TIMEOUT),
    );
    return _ApiClient(dio, baseUrl: GOLF_CORE_API_URL);
  }

  static const Map<String, String> headerDefault = {
    "Content-Type": "application/json",
  };

  @POST("api/authorization/login")
  @Headers(headerDefault)
  Future<String?> login(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @POST("api/user/register")
  @Headers(headerDefault)
  Future<String?> signUp(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @GET("api/shop/get")
  @Headers(headerDefault)
  Future<String?> getShop(
    @Header("Authorization") String auth,
    @Query("Longitude") double? longitude,
    @Query("Latitude") double? latitude,
    @Query("keySearch") String keySearch,
    @Query("start") int start,
    @Query("limit") int limit,
    @Query("userID") int? userID,
  );

  @GET("api/shop/getshopdetailbyid")
  @Headers(headerDefault)
  Future<String?> getShopDetail(
    @Header("Authorization") String auth,
    @Query("shopID") int? shopID,
    @Query("Longitude") double longitude,
    @Query("Latitude") double latitude,
    @Query("userID") int? userID,
  );

  @GET("api/slot/get")
  @Headers(headerDefault)
  Future<String?> getSlot(
    @Header("Authorization") String auth,
    @Query("ShopID") int? shopID,
  );

  @GET("api/block/get")
  @Headers(headerDefault)
  Future<String?> getBlock(
    @Header("Authorization") String auth,
    @Query("SlotID") int? slotID,
    @Query("TimeBooking") int? timeBooking,
    @Query("DateTimeClient") String dateTimeClient,
    @Query("UserID") int UserID,
    @Query("IsVisa") bool isVisa,
  );

  @POST("api/booking/insert")
  @Headers(headerDefault)
  Future<String?> createBooking(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @GET("api/booking/gethistorybooking/{userID}/{page}/{limit}/{status}")
  @Headers(headerDefault)
  Future<String?> getLstHistoryBooking(
    @Header("Authorization") String auth,
    @Path("userID") int? userID,
    @Path("status") int status,
    @Path("page") int page,
    @Path("limit") int limit,
  );

  @GET("api/booking/getbookingdetail/{userID}/{bookID}")
  @Headers(headerDefault)
  Future<String?> getHistoryBookingDetail(
    @Header("Authorization") String auth,
    @Path("userID") int? userID,
    @Path("bookID") int? bookID,
  );

  @GET("api/booking/getstringqrcode/{userID}/{bookID}/{timeZoneInfoClient}")
  @Headers(headerDefault)
  Future<String?> getBookingQRCodeString(
    @Header("Authorization") String auth,
    @Path("userID") int? userID,
    @Path("bookID") int? bookID,
    @Path("timeZoneInfoClient") String timeZone,
  );

  @POST("api/avatar/upload")
  Future<String?> uploadAvatar(
    @Header("Authorization") String auth,
    @Part() File file,
  );

  @POST("api/user/changepass")
  @Headers(headerDefault)
  Future<String?> changePass(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @POST("api/user/imagepath/update")
  Future<String?> updateImagePath(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @GET("api/user/profile")
  @Headers(headerDefault)
  Future<String?> getProfile(
    @Header("Authorization") String auth,
    @Query('UserID') int? userID,
    @Query('UUSerID') String? uUSerID,
  );

  @POST("api/user/update")
  @Headers(headerDefault)
  Future<String?> updateProfile(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @POST("api/booking/updatestatus/{bookID}")
  @Headers(headerDefault)
  Future<String?> updateBookingStatus(
    @Header("Authorization") String auth,
    @Path("bookID") int? bookId,
    @Body() Map<String, dynamic> body,
  );

  @POST("api/booking/updatepayment")
  @Headers(headerDefault)
  Future<String?> addPayment(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @GET("api/notification/get")
  @Headers(headerDefault)
  Future<String?> getNotification(
    @Header("Authorization") String auth,
    @Query("userID") int? userID,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @POST("api/user/forgotpassword")
  @Headers(headerDefault)
  Future<String?> resetPassword(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @POST("api/user/veryfiveaccount")
  @Headers(headerDefault)
  Future<String?> veryfiveAccount(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @GET("api/user/getcodepop")
  @Headers(headerDefault)
  Future<String?> getUUserID(@Header("Authorization") String auth);

  @GET("api/notification/clearall")
  @Headers(headerDefault)
  Future<String?> clearNotification(
    @Header("Authorization") String auth,
    @Query("userID") int? userID,
  );

  @GET("api/codemember/getbyshopid")
  @Headers(headerDefault)
  Future<String?> getAllShopVipMember(
    @Header("Authorization") String auth,
    @Query("shopID") int? shopID,
    @Query("status") int status,
    @Query("page") int? page,
    @Query("limit") int? limit,
  );

  @GET("api/usercodemember/getbyuserid")
  @Headers(headerDefault)
  Future<String?> getUserVipMember(
    @Header("Authorization") String auth,
    @Query("userID") int userID,
    @Query("status") int status,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @POST("api/usercodemember/create")
  @Headers(headerDefault)
  Future<String?> registerVipMember(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @POST("api/usercodemember/update/renew")
  @Headers(headerDefault)
  Future<String?> updateVipMemberAutoRenew(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @POST("api/payment/create/paymentkey")
  @Headers(headerDefault)
  Future<String?> getPaymentKey(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @POST("api/paymentcodemember/create")
  @Headers(headerDefault)
  Future<String?> addPaymentVipMember(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @GET("api/payment/gethistorybyuser")
  @Headers(headerDefault)
  Future<String?> getTransactionHistory(
    @Header("Authorization") String auth,
    @Query("userID") int? userID,
    @Query("dateFrom") int dateFrom,
    @Query("dateEnd") int dateEnd,
    @Query("page") int? page,
    @Query("limit") int? limit,
  );

  @GET("api/usercodemember/getmycard")
  @Headers(headerDefault)
  Future<String?> getUserCards(
    @Header("Authorization") String auth,
    @Query("userID") int? userID,
  );

  @POST("api/user/updatelanguage")
  @Headers(headerDefault)
  Future<String?> updateLanguage(
    @Header("Authorization") String auth,
    @Body() Map<String, dynamic> body,
  );

  @GET("api/shopuser/get")
  @Headers(headerDefault)
  Future<String?> getListShopFavorite(
    @Header("Authorization") String auth,
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("userID") int? userID,
  );

  @POST("api/shopuser/change")
  @Headers(headerDefault)
  Future<String?> changeFavorite(
    @Header("Authorization") String auth,
    @Query("shopID") int? shopID,
    @Query("userID") int? userID,
  );

  @GET("api/config/getbykey")
  @Headers(headerDefault)
  Future<String?> getConfigByKey(
    @Header("Authorization") String auth,
    @Query("keyConfig") String key,
  );

  @GET("api/user/disable")
  @Headers(headerDefault)
  Future<String?> removeUser(
    @Header("Authorization") String auth,
    @Query("userID") int userID,
  );

  @GET("api/payment/mpiResult")
  @Headers(headerDefault)
  Future<String?> cardMpiCheckResult(
    @Header("Authorization") String auth,
    @Query("orderID") String orderID,
    @Query("shopID") int shopID,
  );

  @GET("api/user/get-group-shop-by-email")
  @Headers(headerDefault)
  Future<String?> getGroupUserByEmail(
    @Header("Authorization") String auth,
    @Query("email") String email,
  );

  @GET("api/usercodemember/get-list-code-member-payment")
  @Headers(headerDefault)
  Future<String?> getListCodeMemberPayment(
    @Header("Authorization") String auth,
    @Query("shopID") int shopID,
    @Query("userID") int userID,
  );
}
