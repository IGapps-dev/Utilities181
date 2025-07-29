
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
        OneSignal.initialize("7c1ade0e-717a-4889-ac42-2b39fdd5ca38", withLaunchOptions: nil)
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
        let configuration = AppMetricaConfiguration(apiKey: "0b9fba70-777b-4575-848c-63b8d4946fe6")
         AppMetrica.activate(with: configuration!)
        print(AppMetrica.deviceIDHash)
    }
}
