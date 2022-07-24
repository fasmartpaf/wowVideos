import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

//for deeplinking
  private var methodChannel: FlutterMethodChannel?
  private var eventChannel: FlutterEventChannel?

  private let linkStreamHandler = LinkStreamHandler()


//deeplinking over

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {



//for deeplinking
   let controller = window.rootViewController as! FlutterViewController
      methodChannel = FlutterMethodChannel(name: "poc.deeplink.flutter.dev/channel", binaryMessenger: controller.binaryMessenger)
      eventChannel = FlutterEventChannel(name: "poc.deeplink.flutter.dev/events", binaryMessenger: controller.binaryMessenger)


      methodChannel?.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) in
        guard call.method == "initialLink" else {
          result(FlutterMethodNotImplemented)
          return
        }
      })

//deeplinking over

    GeneratedPluginRegistrant.register(with: self)

    //for deeplinking
    eventChannel?.setStreamHandler(linkStreamHandler)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


//for deeplinking
class LinkStreamHandler:NSObject, FlutterStreamHandler {

  var eventSink: FlutterEventSink?

  // links will be added to this queue until the sink is ready to process them
  var queuedLinks = [String]()

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    queuedLinks.forEach({ events($0) })
    queuedLinks.removeAll()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }

  func handleLink(_ link: String) -> Bool {
    guard let eventSink = eventSink else {
      queuedLinks.append(link)
      return false
    }
    eventSink(link)
    return true
  }
}
//deeplinking over