import UIKit
import Flutter
import GoogleSignIn
import LinkPresentation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    @available(iOS 9.0, *)
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        // if url.absoluteString.range(of: "zalo") != nil {
        //     return ZDKApplicationDelegate
        //                 .sharedInstance()
        //                 .application(app, open: url, options: options)
        // }
        return super.application(app, open: url, options: options)
    }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
