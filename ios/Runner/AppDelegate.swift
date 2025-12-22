import Flutter
import UIKit
import FirebaseCore
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      GeneratedPluginRegistrant.register(with: self)

      // This is required to make any communication available in the action isolate.
      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)
      }

      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      }

      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    @available(iOS 12.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        openSettingsFor notification: UNNotification?
    ) {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "com.example.flutter_local_notifications_example/settings",
            binaryMessenger: controller.binaryMessenger)

        channel.invokeMethod("showNotificationSettings", arguments: nil)
    }
}
