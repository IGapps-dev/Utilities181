
import UIKit
import SwiftUI
import AppMetricaCore
import OneSignalFramework

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

 var window: UIWindow?
    
    var restrictRotation: UIInterfaceOrientationMask = .all
    
    private let oneSignalIDChecker = OneSignalIDChecker()
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return restrictRotation
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        OneSignal.initialize("", withLaunchOptions: nil) // OneSignal
        oneSignalIDChecker.startCheckingOneSignalID()
        setupAppmetrica()
        initViewController()
        return true
    }
    
    private func initViewController() {
        let controller: UIViewController
        if let lastUrl = SaveService.lastUrl {
            controller = WebviewVC(url: lastUrl)
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = controller
            window?.makeKeyAndVisible()
            print("Saved")
        } else {
            controller = LoadingSplash()
            let navigationController = UINavigationController(rootViewController: controller)
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            print("Not Saved")
        }
    }
    
    private func setupAppmetrica() {
        let configuration = AppMetricaConfiguration(apiKey: "") //Appmetrica
         AppMetrica.activate(with: configuration!)
        print(AppMetrica.deviceIDHash)
    }
}
