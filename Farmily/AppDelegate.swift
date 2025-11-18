import UIKit
import AppsFlyerLib

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppsFlyerLib.shared().appsFlyerDevKey = "daALJrxgwmr8HUY2dXMu3L"
        AppsFlyerLib.shared().appleAppID = "6755446208"
        
        AppsFlyerLib.shared().isDebug = false
        
        AppsFlyerLib.shared().minTimeBetweenSessions = 5
        
        AppsFlyerLib.shared().start()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

extension AppDelegate {
    static func setOrientation(_ orientation: UIInterfaceOrientationMask) {
        AppDelegate.orientationLock = orientation
        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: AppDelegate.orientationLock))
        }
        UIViewController.attemptRotationToDeviceOrientation()
    }
}

