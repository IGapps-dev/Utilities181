
import UIKit
import SwiftUI
import OneSignalFramework
import AppMetricaCore

class LoadingSplash: UIViewController {
    
    let loadingLabel = UILabel()
    let loadingImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFlow()
    }
    
    private func setupUI() {
        view.addSubview(loadingImage)
        loadingImage.image = UIImage(named: "Launch")
        
        loadingImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingImage.topAnchor.constraint(equalTo: view.topAnchor),
            loadingImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupFlow() {
        CheckURLService.checkURLStatus { is200 in
            DispatchQueue.main.async {
                if is200 {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.restrictRotation = .all
                    }
                    
                    let link = "?push=\(AppMetrica.deviceIDHash!)&oneid=\(OneSignal.User.onesignalId ?? "NIHUYA")" //и тут
                    
                    print("Before: \(String(describing: URL(string: link)))")
                    let vc = WebviewVC(url: URL(string: link)!)
                    print("After: \(String(describing: URL(string: link)))")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                } else {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.restrictRotation = .portrait
                    }
                    let swiftUIView = ContentView()
                    let hostingController = UIHostingController(rootView: swiftUIView)
                    hostingController.modalPresentationStyle = .fullScreen
                    self.present(hostingController, animated: true)
                }
            }
        }
    }
}
