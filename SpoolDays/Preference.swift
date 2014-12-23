import Foundation

class Preference {
    var mintAPIKey: String {
        get {
            let bundle = NSBundle.mainBundle()
            if let path = bundle.pathForResource("preference", ofType: "plist") {
                if let dictionary = NSDictionary(contentsOfFile: path) {
                    return dictionary.objectForKey("MintAPIKey") as? String ?? ""
                }
            }
            return ""
        }
    }
}