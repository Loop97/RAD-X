import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    //API_KEY
    GMSServices.provideAPIKey("AIzaSyC3ecGs3tTVUnP2iWL1wrsAwZ1N2lTE5Vs")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
