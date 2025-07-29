
import Foundation
import AppMetricaCore
import OneSignalFramework

struct CheckURLService {
    
    static let link = URL(string: "https://smileymaze181dash.win/STThkV")
//    static let link = URL(string: "https://google.com")
    
    static let longLink = URL(string: "https://smileymaze181dash.win/STThkV?push=\(AppMetrica.deviceIDHash!)")
//    static let longLink = URL(string: "https://google.com?push=\(AppMetrica.deviceIDHash!)")
    
    static  func checkURLStatus( completion: @escaping (Bool) -> Void) {
        guard let url = link  else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { _, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 404 {
                    completion(true)
                    
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
}
