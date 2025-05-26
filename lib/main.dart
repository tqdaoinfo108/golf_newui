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

 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

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
  /// Set up Line Sdk
  WidgetsFlutterBinding.ensureInitialized();
  // dev@gpn.com.vn
  LineSDK.instance.setup("2007478079").then((_) {
    print("LineSDK Prepared");
  });

  // android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('assets/ic_launcher.png');

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

  // init firebase message
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences.getInstance().then((value) {
    SupportUtils.prefs = value;

    /// Run Application
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

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
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

    super.initState();
    _requestPermissions();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotificationWithDefaultSound(
          message.notification?.title ?? "",
          message.notification?.body ?? "",
          0
        );
      }
    });
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
    }
  }

  Future _showNotificationWithDefaultSound(
    String title,
    String message,
    int bookingID,
  ) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'Golf system',
      'Calendar reminder',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().microsecond,
      title,
      message,
      platformChannelSpecifics,
      payload: "",
    );
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

  Future onSelectNotification(int bookingID) async {
    if (bookingID != 0) {
      Get.toNamed(AppRoutes.BOOKING_DETAIL, arguments: bookingID);
    }
  }
}