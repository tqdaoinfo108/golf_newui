enum PageResultCode { OK, FAIL }

enum ApplicationErrorCode {
  CONNECTION_ERROR,
  REQUEST_CANCEL,
  RESPONSE_TIMEOUT,
  UNKNOW_APPLICATION_ERROR,
  UNKNOW_SERVER_ERROR
}

enum SocialNetwork { FACEBOOK, GOOGLE, LINE, ZALO, APPLE }

enum ToastType { INFO, SUCCESSFUL, ERROR, WARNING }

enum DecisionOptionType { NORMAL, EXPECTATION, WARNING, DENIED }

const int API_CONNECT_TIMEOUT = 30000; // milisenconds
const int API_RECEIVE_RESPONSE_TIMEOUT = 30000; // milisenconds
const int DEFAUTL_LIMIT = 20; // milisenconds

// const String GOLF_CORE_API_URL = 'http://apigolfschedule.eappviet.com/';
const String GOLF_CORE_API_URL = 'http://api.mujin24.com:8085/'; // http://login.xn--24-zh4arfne.com:8080/
const String GOLF_CORE_API_AUTHORIZE =
    'VXNlckdvbGZTY2hlZHVsZTpVc2VyR29sZlNjaGVkdWxl';
const String USER_AVATAR_PATH = 'api/avatar/view?fileName=';

// const String PAYMENT_API_URL = 'https://pay.veritrans.co.jp/';
// const String PAYMENT_POP_SCRIPT_URL =
//     'https://pay.veritrans.co.jp/pop/v1/javascripts/pop.js';
// const String PAYMENT_API_AUTHORIZE =
//     'NjEzNmYzMjMtYWE0My00ODQwLWJkMTktYWRjOTFmMzBlMjA3Og==';
// const String PAYMENT_POP_SERVER_KEY = '6136f323-aa43-4840-bd19-adc91f30e207';
// const String PAYMENT_POP_PASSWORD = '';
// const String PAYMENT_POP_CLIENT_KEY = 'e84c118c-2faa-4eef-a69c-5bc2121f0ada';
const bool PAYMENT_DEBUG = true;
const String PAYMENT_SUCCESS_URL = 'https://golf.payment.com/success';
const String PAYMENT_FAILURE_URL = 'https://golf.payment.com/fail';

class BookingStatus {
  static const int WAITING_PAYMENT = 0;
  static const int PAID = 1;
  static const int CANCELED = -1;
  static const int EXPIRED = -2;
  static const int USED = 2;
}

class ConfirmEmailStatus {
  static const int UNCONFIRMED = 0;
  static const int CONFIRMED = 1;
}

class ThemeModeCode {
  static const String SYSTEM_MODE = 'system';
  static const String LIGHT_MODE = 'light';
  static const String DARK_MODE = 'dark';
}

class NotificationType {
  static const int BOOKING_CREATE = 1;
  static const int BOOKING_CANCEL = 21;
  static const int BOOKING_CANCEL_BY_PAYMENT = 22;
  static const int BOOKING_SCCUESS = 3;

  static const int PAYMENT_SUCCESS = 11;
  static const int PAYMENT_FAIL = 12;

  static const int SURCHARGE = 21;
}

class VipMemberType {
  static const int UNLIMIT = 1;
  static const int LIMIT = 2;
}

class PaymentType {
  static const int REGISTER_VIP_MEMBER = 1;
  static const int AUTO_RENEW_VIP_MEMBER = 2;
  static const int CREATE_BOOKING_WITH_ONLINE_PAYMENT = 3;
  static const int CREATE_BOOKING_WITH_VIP_MEMBER = 4;
}

class BookingPaymentType {
  static const int ONLINE = 1;
  static const int MEMBER_UNLIMITED = 2;
  static const int MEMBER_LIMITED = 3;
}

class BookingDetailPaymentType {
  static const int EXPIRED = -1;
  static const int PAID = 0;
  static const int MEMBER_UNLIMITED = 1;
  static const int MEMBER_LIMITED = 2;
  static const int ONLINE = 3;
  static const int MEMBER_LIMITED_AND_ONLINE = 4;
}
