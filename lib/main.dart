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
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  /// Set up Line Sdk
  WidgetsFlutterBinding.ensureInitialized();
  LineSDK.instance.setup("2007243633").then((_) {
    print("LineSDK Prepared");
  });

  // init firebase message
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Set up Zalo Sdk
  // if (Platform.isAndroid) {
  //   await ZaloFlutter.getHashKeyAndroid();
  // }

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
  var _isLogined = SupportUtils.prefs.containsKey(HAS_LOGINED) &&
      SupportUtils.prefs.getBool(HAS_LOGINED)!;

  ThemeMode appThemeMode = ThemeMode.system;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  @override
  void initState() {
    _isLogined = SupportUtils.prefs.containsKey(HAS_LOGINED) &&
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
    // requestPermisstion(_firebaseMessaging, flutterLocalNotificationsPlugin);

    // android
    // var initializationSettingsAndroid =
    //     new AndroidInitializationSettings('@mipmap/ic_launcher');
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //   requestSoundPermission: true,
    //   requestBadgePermission: true,
    //   requestAlertPermission: true,
    // );
    //
    // var initializationSettings = new InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // flutterLocalNotificationsPlugin!.initialize(initializationSettings,
    //     onSelectNotification: (payload) async {
    //   var id = int.parse(payload!);
    //   onSelectNotification(id);
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // _showNotificationWithDefaultSound({'data': message.data});
      }
    });

    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     _showNotificationWithDefaultSound(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     _showNotificationWithDefaultSound(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     _showNotificationWithDefaultSound(message);
    //   },
    // );
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
              defaultTransition: Transition.native,
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