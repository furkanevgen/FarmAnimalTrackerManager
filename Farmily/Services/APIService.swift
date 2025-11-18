import Foundation
import UIKit
import AppsFlyerLib

class APIService {
    static let shared = APIService()
    
    private let baseLink = "https://gtappinfo.site/ios-farmanimal-trackermanager/server.php"
    private let parameter = "Bs2675kDjkb5Ga"
    
    private init() {}
    
    private var paramOS: String {
        return UIDevice.current.systemVersion
    }
    
    private var paramLng: String {
        if let language = Locale.preferredLanguages.first {
            let languageCode = language.components(separatedBy: "-").first ?? language
            return languageCode
        }
        return Locale.current.language.languageCode?.identifier ?? "11"
    }
    
    private var paramDevice: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    private var paramCountry: String {
        if let regionCode = Locale.current.region?.identifier {
            return regionCode
        }
        if let language = Locale.preferredLanguages.first {
            let components = Locale.Components(identifier: language)
            if let regionCode = components.region {
                return regionCode.identifier
            }
        }
        return "00"
    }
    
    private var appsFlayerId: String {
        let appsFlyerUID = AppsFlyerLib.shared().getAppsFlyerUID()
        return appsFlyerUID
    }
    
    func fetchServerData() async throws -> (token: String, link: String) {
        var components = URLComponents(string: baseLink)
        components?.queryItems = [
            URLQueryItem(name: "p", value: parameter),
            URLQueryItem(name: "os", value: paramOS),
            URLQueryItem(name: "lng", value: paramLng),
            URLQueryItem(name: "devicemodel", value: paramDevice),
            URLQueryItem(name: "country", value: paramCountry),
            URLQueryItem(name: "appsflyerid", value: appsFlayerId)
        ]
        
        guard let link = components?.url else {
            throw APIError.invalidLink
        }
        
        var request = URLRequest(url: link)
        request.timeoutInterval = 15
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw APIError.invalidResponse
        }
        
        guard responseString.contains("#") else {
            throw APIError.invalidResponseFormat
        }
        
        let parts = responseString.components(separatedBy: "#")
        guard parts.count >= 2 else {
            throw APIError.invalidResponseFormat
        }
        
        let token = parts[0]
        let linkString = parts[1]
        
        return (token: token, link: linkString)
    }
}

enum APIError: Error {
    case invalidLink
    case invalidResponse
    case invalidResponseFormat
}

