
import Foundation

struct AppConfig {
    static var baseURL: String { getValue(for: "API_BASE_URL") }
    static var apiToken: String { getValue(for: "API_TOKEN") }
    
    private static func getValue(for key: String) -> String {
        guard let path = Bundle.main.path(forResource: "config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict[key] as? String else { return "" }
        return value
    }
}
