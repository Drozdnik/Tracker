import Foundation
import YandexMobileMetrica

struct AnalyticsServices{
    static func  activate(){
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "02c2b135-1b17-4ce8-a11c-f474b7c28636") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    static func report(event: String, screen: String, item: String? = nil) {
        var params: [String: Any] = ["event": event, "screen": screen]
        if let item = item {
            params["item"] = item
        }
        
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: \(error.localizedDescription)")
        })
    }
}

