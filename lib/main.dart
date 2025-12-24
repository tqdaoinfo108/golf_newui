import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_pages.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/themes/themes.dart';
import 'package:golf_uiv2/translations/localization_service.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
// import 'package:zalo_flutter/zalo_flutter.dart';
import 'firebase_options.dart';
import 'screens/login/login_controller.dart';
import 'utils/keys.dart';
import 'screens/home/home_binding.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Handling a background message: ${message.messageId}");
}

final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print(
    'notification(${notificationResponse.id}) action tapped: '
    '${notificationResponse.actionId} with'
    ' payload: ${notificationResponse.payload}',
  );
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
      'notification action tapped with input: ${notificationResponse.input}',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase trước
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Đăng ký background handler cho Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Tạo notification channel cho Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'golf_channel', // id
    'Golf Notifications', // title
    description: 'This channel is used for golf notifications.',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // Khởi tạo local notification
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        notificationCategories: [],
      );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: selectNotificationStream.add,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // Lấy token Firebase (in ra để kiểm tra)
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    print('Firebase Messaging Token: $token');
  } catch (e) {}

  // Set up Line Sdk
  LineSDK.instance.setup("2007478079").then((_) {
    print("LineSDK Prepared");
  });

  SharedPreferences.getInstance().then((value) {
    SupportUtils.prefs = value;
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isLogined =
      SupportUtils.prefs.containsKey(HAS_LOGINED) &&
      SupportUtils.prefs.getBool(HAS_LOGINED)!;

  ThemeMode appThemeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();

    _requestPermissions();

    _isLogined =
        SupportUtils.prefs.containsKey(HAS_LOGINED) &&
        SupportUtils.prefs.getBool(HAS_LOGINED)! &&
        SupportUtils.prefs.containsKey(AUTH) &&
        SupportUtils.prefs.getString(AUTH)!.isNotEmpty;

    // switch theme
    switch (SupportUtils.prefs.getString(APP_THEME_MODE) ??
        ThemeModeCode.SYSTEM_MODE) {
      case ThemeModeCode.SYSTEM_MODE:
        appThemeMode = ThemeMode.system;
        break;
      case ThemeModeCode.LIGHT_MODE:
        appThemeMode = ThemeMode.light;
        break;
      case ThemeModeCode.DARK_MODE:
        appThemeMode = ThemeMode.dark;
        break;
    }

    // Lắng nghe thông báo khi app đang foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotificationWithDefaultSound(
          message.notification?.title ?? "",
          message.notification?.body ?? "",
          message.data['bookingID'] != null 
            ? int.tryParse(message.data['bookingID'].toString()) ?? 0 
            : 0,
        );
      }
    });

    // Lắng nghe khi user nhấn vào notification (kể cả khi app đã tắt)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.data}');
      // Điều hướng đến trang thông báo
      _handleNotificationClick(message.data);
    });

    // Xử lý khi click vào local notification
    selectNotificationStream.stream.listen((NotificationResponse response) {
      if (response.payload != null && response.payload!.isNotEmpty) {
        try {
          int bookingID = int.parse(response.payload!);
          if (bookingID != 0) {
            Get.toNamed(AppRoutes.BOOKING_DETAIL, arguments: bookingID);
          } else {
            Get.toNamed(AppRoutes.NOTIFICATIONS);
          }
        } catch (e) {
          Get.toNamed(AppRoutes.NOTIFICATIONS);
        }
      } else {
        Get.toNamed(AppRoutes.NOTIFICATIONS);
      }
    });

    // Kiểm tra notification đã mở app khi app đang tắt hoàn toàn
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('App opened from terminated state via notification: ${message.data}');
        Future.delayed(Duration(seconds: 1), () {
          _handleNotificationClick(message.data);
        });
      }
    });
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      // Xin quyền thông báo cho Android 13+
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }
    }
  }

  Future _showNotificationWithDefaultSound(
    String title,
    String message,
    int bookingID,
  ) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'golf_channel', // id phải trùng với channel đã tạo
      'Golf Notifications',
      channelDescription: 'This channel is used for golf notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().microsecond,
      title,
      message,
      platformChannelSpecifics,
      payload: bookingID.toString(),
    );
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    // Kiểm tra nếu có bookingID trong data
    if (data.containsKey('bookingID') && data['bookingID'] != null) {
      try {
        int bookingID = int.parse(data['bookingID'].toString());
        if (bookingID != 0) {
          Get.toNamed(AppRoutes.BOOKING_DETAIL, arguments: bookingID);
          return;
        }
      } catch (e) {
        print('Error parsing bookingID: $e');
      }
    }
    // Mặc định điều hướng đến trang thông báo
    Get.toNamed(AppRoutes.NOTIFICATIONS);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil.setScreenSize(constraints, orientation);
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              translations: LocalizationService(),
              locale: LocalizationService.locale,
              defaultTransition: Transition.noTransition,
              initialRoute: _isLogined ? AppRoutes.HOME : AppRoutes.LOGIN,
              initialBinding: _isLogined ? HomeBinding() : LoginBinding(),
              getPages: AppScreens.list,
              theme: Themes.light,
              // darkTheme: Themes.dark,
              themeMode: appThemeMode,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: LocalizationService.locales,
            );
          },
        );
      },
    );
  }
}
